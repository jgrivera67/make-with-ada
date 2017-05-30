--
--  Copyright (c) 2016, German Rivera
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  * Redistributions of source code must retain the above copyright notice,
--    this list of conditions and the following disclaimer.
--
--  * Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.
--

with Command_Line;
with Serial_Console;
with Command_Parser_Common;
with Microcontroller.Arm_Cortex_M;
with Interfaces.Bit_Types;
with Networking.Layer3_IPv4;
with CAN_To_UDP_Gateway;
with Number_Conversion_Utils;
with App_Configuration;
with Ada.Real_Time;
with Memory_Protection;
with MPU_Tests;

--
--  Application-specific command parser implementation
--
package body Command_Parser is
   pragma SPARK_Mode (Off);
   use Microcontroller.Arm_Cortex_M;
   use Interfaces.Bit_Types;
   use Networking;
   use Networking.Layer3_IPv4;
   use Interfaces;
   use Number_Conversion_Utils;
   use Ada.Real_Time;
   use Memory_Protection;

   procedure Cmd_Ping;

   procedure Cmd_Print_Config_Params;

   procedure Cmd_Print_Help with Pre => Serial_Console.Is_Lock_Mine;

   procedure Cmd_Save_Config_Params;

   procedure Cmd_Set;

   procedure Cmd_Set_IPv4_Unicast_Address;

   procedure Cmd_Set_IPv4_Multicast_Address;

   procedure Cmd_Set_IPv4_Parameter;

   procedure Cmd_Set_UDP_Port;

   procedure Cmd_Set_UDP_Parameter;

   procedure Cmd_Test;

   procedure Cmd_Test_Hang;

   procedure Cmd_Test_MPU;

   -- ** --

   --
   --  Help message string
   --
   Help_Msg : constant String :=
     "Available commands are:" & ASCII.LF &
     ASCII.HT & "stats (or st) - Prints stats" & ASCII.LF &
     ASCII.HT & "log <log name: info (or i), error (or e), debug (or d)> - " &
     "Dumps the given runtime log" & ASCII.LF &
     ASCII.HT & "log-tail <log name: info, error, debug> <tail lines> - " &
     "Dumps tail of the given runtime log" & ASCII.LF &
     ASCII.HT & "print-config (or pc) - Print configuration parameters" &
     ASCII.LF &
     ASCII.HT & "set ipv4 addr <IPv4 unicast address> - " &
     "Set local IPv4 unicast address" &
     ASCII.LF &
     ASCII.HT & "set ipv4 maddr <IPv4 multicast address> - " &
     "Set local IPv4 multicast address" &
     ASCII.LF &
     ASCII.HT & "set udp port <UDP port number> - " &
     "Set UDP port number for the UDP multicast receiver" &
     ASCII.LF &
     ASCII.HT & "save-config (or sc) - Save car controller configuration " &
     "parameters" & ASCII.LF &
     ASCII.HT & "reset - Reset microcontroller" & ASCII.LF &
     ASCII.HT & "test color <color: black, red, green, yellow, blue, " &
     "magenta, cyan, white)> - Test LED color" & ASCII.LF &
     ASCII.HT & "test assert - Test assert failure" & ASCII.LF &
     ASCII.HT & "test hang - Cause an artificial hang" & ASCII.LF &
     ASCII.HT & "test mpu write1 - Test forbidden write to global data" &
     ASCII.LF &
     ASCII.HT & "test mpu write2 - Test forbidden write to secret data" &
     ASCII.LF &
     ASCII.HT & "test mpu read - Test forbidden read to secret data" &
     ASCII.LF &
     ASCII.HT & "test mpu exe1 - Test forbidden execute to secret flash code" &
     ASCII.LF &
     ASCII.HT & "test mpu exe2 - Test forbidden execute to secret RAM code" &
     ASCII.LF &
     ASCII.HT & "test mpu stko - Test stack overrun" & ASCII.LF &
     ASCII.HT & "test mpu valid - Test valid accesses" & ASCII.LF &
     ASCII.HT & "help (or h) - Prints this message" & ASCII.LF;

   --
   --  Command-line prompt string
   --
   Prompt : aliased constant String := "gateway>";

   --
   --  State variables of the command parser
   --
   type Command_Parser_Type is limited record
      Initialized : Boolean := False;
   end record;

   Command_Parser_Var : Command_Parser_Type;

   --------------
   -- Cmd_Ping --
   --------------

   procedure Cmd_Ping is
      function Parse_Ping_Argument (Arg : String;
                                    IPv4_Address : out IPv4_Address_Type)
                                    return Boolean;

      Token : Command_Line.Token_Type;
      Token_Found : Boolean;
      Parsing_Ok : Boolean;
      Destination_IPv4_Address : IPv4_Address_Type;
      Destination_IPv4_Address_Str : IPv4_Address_String_Type;
      Subnet_Prefix : Unsigned_8;
      Ping_Request_Sent_Ok : Boolean;
      Ping_Reply_Received_Ok : Boolean;
      Request_Sequence_Number : Unsigned_16 := 0;
      Request_Identifier : constant Unsigned_16 := 88;
      Reply_Sequence_Number : Unsigned_16;
      Reply_Identifier : Unsigned_16;
      Remote_IPv4_Address : IPv4_Address_Type;
      Ping_Period_Ms : constant Time_Span := Milliseconds (500);

      -- ** --

      function Parse_Ping_Argument (Arg : String;
                                    IPv4_Address : out IPv4_Address_Type)
                                    return Boolean is
      begin
         return Parse_IPv4_Address (Arg,
                                    False,
                                    IPv4_Address,
                                    Subnet_Prefix);
      end Parse_Ping_Argument;

   begin --  Cmd_Ping
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Parsing_Error;
      end if;

      Parsing_Ok :=
        Parse_Ping_Argument (Token.String_Value (1 .. Token.Length),
                             Destination_IPv4_Address);
      if not Parsing_Ok then
         goto Parsing_Error;
      end if;

      IPv4_Address_To_String (Destination_IPv4_Address,
                              Destination_IPv4_Address_Str);

      for I in 1 .. 8 loop
         Ping_Request_Sent_Ok := Send_Ping_Request (Destination_IPv4_Address,
                                                    Request_Identifier,
                                                    Request_Sequence_Number);
         if not Ping_Request_Sent_Ok then
            Serial_Console.Print_String (
               "Sending ping request to " &
               Destination_IPv4_Address_Str & "failed" & ASCII.LF);

            return;
         end if;

         loop
            Ping_Reply_Received_Ok :=
               Receive_Ping_Reply (5000,
                                   Remote_IPv4_Address,
                                   Reply_Identifier,
                                   Reply_Sequence_Number);
            if not Ping_Reply_Received_Ok then
               Serial_Console.Print_String (
                  "Ping " & Request_Sequence_Number'Image & " for " &
                  Destination_IPv4_Address_Str & " timed-out" & ASCII.LF);
               return;
            end if;

            if Remote_IPv4_Address /= Destination_IPv4_Address or else
               Reply_Identifier /= Request_Identifier or else
               Reply_Sequence_Number /= Request_Sequence_Number
            then
               Serial_Console.Print_String (
                  "Received invalid or stale ping reply" & ASCII.LF);
            else
               Serial_Console.Print_String (
                  "Ping" & Reply_Sequence_Number'Image & " replied by " &
                  Destination_IPv4_Address_Str & ASCII.LF);
               exit;
            end if;
         end loop;

         Request_Sequence_Number := Request_Sequence_Number + 1;
         delay until Clock + Ping_Period_Ms;
      end loop;

      return;

   <<Parsing_Error>>
      Serial_Console.Print_String ("Error: Invalid syntax for command 'ping'" &
                                   ASCII.LF);
   end Cmd_Ping;

   -----------------------------
   -- Cmd_Print_Config_Params --
   -----------------------------

   procedure Cmd_Print_Config_Params is
      Config_Parameters : App_Configuration.Config_Parameters_Type;
      IPv4_Address_Str : IPv4_Address_String_Type;
      Subnet_Prefix_Str : String (1 .. 2);
      Str_Length : Positive;
   begin
      CAN_To_UDP_Gateway.Get_Configuration_Paramters (Config_Parameters);

      IPv4_Address_To_String (Config_Parameters.Local_IPv4_Address,
                              IPv4_Address_Str);

      Unsigned_To_Decimal_String (
         Unsigned_32 (Config_Parameters.IPv4_Subnet_Prefix),
         Subnet_Prefix_Str,
         Str_Length);

      Serial_Console.Print_String ("Local IPv4 unicast address: " &
                                   IPv4_Address_Str & "/" &
                                   Subnet_Prefix_Str (1 .. Str_Length) &
                                   ASCII.LF);

      IPv4_Address_To_String (Config_Parameters.IPv4_Multicast_Address,
                              IPv4_Address_Str);

      Serial_Console.Print_String ("Local IPv4 multicast address: " &
                                   IPv4_Address_Str &
                                   ASCII.LF);

      Serial_Console.Print_String ("UDP port for IPv4 multicast receiver:" &
                                   Config_Parameters.
                                      IPv4_Multicast_Receiver_UDP_Port'Image &
                                   ASCII.LF);

      Serial_Console.Print_String ("Networking Layer-2 tracing: " &
                                   (if Config_Parameters.Net_Tracing_Layer2_On
                                    then "On" else "Off") &
                                   ASCII.LF);

      Serial_Console.Print_String ("Networking Layer-3 tracing: " &
                                   (if Config_Parameters.Net_Tracing_Layer3_On
                                    then "On" else "Off") &
                                   ASCII.LF);
      Serial_Console.Print_String ("Networking Layer-4 tracing: " &
                                   (if Config_Parameters.Net_Tracing_Layer4_On
                                    then "On" else "Off") &
                                   ASCII.LF);
   end Cmd_Print_Config_Params;

   --------------------
   -- Cmd_Print_Help --
   --------------------

   procedure Cmd_Print_Help is
   begin
      Serial_Console.Print_String (Help_Msg);
   end Cmd_Print_Help;

   -- ** --

   procedure Cmd_Save_Config_Params is
   begin
      CAN_To_UDP_Gateway.Save_Configuration_Parameters;
   end Cmd_Save_Config_Params;

   -- ** --

   procedure Cmd_Set is
      function Parse_Set_Command (Set_Command : String) return Boolean;

      -- ** --

      function Parse_Set_Command (Set_Command : String) return Boolean is
      begin
         if Set_Command = "ipv4" then
            Cmd_Set_IPv4_Parameter;
         elsif Set_Command = "udp" then
            Cmd_Set_UDP_Parameter;
         else
            Serial_Console.Print_String
              ("Subcommand '" &
                 Set_Command &
                 "' is not recognized" &
                 ASCII.LF);
            return False;
         end if;

         return True;
      end Parse_Set_Command;

      -- ** --

      Token : Command_Line.Token_Type;
      Token_Found : Boolean;
      Parsing_Ok : Boolean;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Error;

      end if;

      Parsing_Ok := Parse_Set_Command (Token.String_Value (1 .. Token.Length));
      if not Parsing_Ok then
         goto Error;
      end if;

      return;

      <<Error>>
      Serial_Console.Print_String ("Error: Invalid syntax for command 'set'" &
                                     ASCII.LF);
   end Cmd_Set;

   ------------------------------------
   -- Cmd_Set_IPv4_Multicast_Address --
   ------------------------------------

   procedure Cmd_Set_IPv4_Multicast_Address is
      Token_Found   : Boolean;
      Conversion_Ok : Boolean;
      Token         : Command_Line.Token_Type;
      IPv4_Address : IPv4_Address_Type;
      Subnet_Prefix : Unsigned_8 with Unreferenced;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      Conversion_Ok :=
         Parse_IPv4_Address (Token.String_Value (1 .. Token.Length),
                             False,
                             IPv4_Address,
                             Subnet_Prefix);

      if not Conversion_Ok then
         Serial_Console.Print_String
           ("Error: Invalid argument " &
              Token.String_Value (1 .. Token.Length) &
              ASCII.LF);
         return;
      end if;

      CAN_To_UDP_Gateway.Set_IPv4_Multicast_Address (IPv4_Address);
   end Cmd_Set_IPv4_Multicast_Address;

   ----------------------------
   -- Cmd_Set_IPv4_Parameter --
   ----------------------------

   procedure Cmd_Set_IPv4_Parameter is
      Token_Found : Boolean;
      Token       : Command_Line.Token_Type;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      if Token.String_Value (1 .. Token.Length) = "address"
        or else Token.String_Value (1 .. Token.Length) = "addr"
      then
         Cmd_Set_IPv4_Unicast_Address;
      elsif Token.String_Value (1 .. Token.Length) = "multicast-address"
        or else Token.String_Value (1 .. Token.Length) = "maddr"
      then
         Cmd_Set_IPv4_Multicast_Address;
      else
         Serial_Console.Print_String
           ("Error: Subcommand '" &
              Token.String_Value (1 .. Token.Length) &
              "' is not recognized" &
              ASCII.LF);
      end if;
   end Cmd_Set_IPv4_Parameter;

   ----------------------------------
   -- Cmd_Set_IPv4_Unicast_Address --
   ----------------------------------

   procedure Cmd_Set_IPv4_Unicast_Address is
      Token_Found   : Boolean;
      Conversion_Ok : Boolean;
      Token         : Command_Line.Token_Type;
      IPv4_Address : IPv4_Address_Type;
      Subnet_Prefix : Unsigned_8;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      Conversion_Ok :=
         Parse_IPv4_Address (Token.String_Value (1 .. Token.Length),
                             True,
                             IPv4_Address,
                             Subnet_Prefix);

      if not Conversion_Ok then
         Serial_Console.Print_String
           ("Error: Invalid argument " &
              Token.String_Value (1 .. Token.Length) &
              ASCII.LF);
         return;
      end if;

      CAN_To_UDP_Gateway.Set_Local_IPv4_Unicast_Address (
         IPv4_Address,
         IPv4_Subnet_Prefix_Type (Subnet_Prefix));
   end Cmd_Set_IPv4_Unicast_Address;

   ---------------------------
   -- Cmd_Set_UDP_Parameter --
   ---------------------------

   procedure Cmd_Set_UDP_Parameter is
      Token_Found : Boolean;
      Token       : Command_Line.Token_Type;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      if Token.String_Value (1 .. Token.Length) = "port"
      then
         Cmd_Set_UDP_Port;
      else
         Serial_Console.Print_String
           ("Error: Subcommand '" &
              Token.String_Value (1 .. Token.Length) &
              "' is not recognized" &
              ASCII.LF);
      end if;
   end Cmd_Set_UDP_Parameter;

   ----------------------
   -- Cmd_Set_UDP_Port --
   ----------------------

   procedure Cmd_Set_UDP_Port is
      Token_Found   : Boolean;
      Conversion_Ok : Boolean;
      Token         : Command_Line.Token_Type;
      UDP_Port : Unsigned_16;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         Serial_Console.Print_String ("Error: Incomplete command" & ASCII.LF);
         return;
      end if;

      Decimal_String_To_Unsigned (Token.String_Value (1 .. Token.Length),
                                  UDP_Port,
                                  Conversion_Ok);

      if not Conversion_Ok then
         Serial_Console.Print_String
           ("Error: Invalid argument " &
              Token.String_Value (1 .. Token.Length) &
              ASCII.LF);
         return;
      end if;

      CAN_To_UDP_Gateway.Set_Multicast_UDP_Port (UDP_Port);
   end Cmd_Set_UDP_Port;

   -- ** --

   procedure Cmd_Test is
      function Parse_Test_Command (Command : String) return Boolean;

      -- ** --

      function Parse_Test_Command (Command : String) return Boolean is
      begin
         if Command = "color" then
            Command_Parser_Common.Cmd_Test_Color;
         elsif Command = "assert" then
            pragma Assert (False);
         elsif Command = "hang" then
            Cmd_Test_Hang;
         elsif Command = "mpu" then
            Cmd_Test_MPU;
         else
            return False;
         end if;

         return True;
      end Parse_Test_Command;

      -- ** --

      Token : Command_Line.Token_Type;
      Token_Found : Boolean;
      Parsing_Ok : Boolean;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Error;

      end if;

      Parsing_Ok :=
        Parse_Test_Command (Token.String_Value (1 .. Token.Length));
      if not Parsing_Ok then
         goto Error;
      end if;

      return;

   <<Error>>
      Serial_Console.Print_String ("Error: Invalid syntax for command 'test'" &
                                     ASCII.LF);
   end Cmd_Test;

   -- ** --

   procedure Cmd_Test_Hang is
      Old_Interrupts_Mask : Word with Unreferenced;
   begin
      Old_Interrupts_Mask := Disable_Cpu_Interrupts;
      loop
         null;
      end loop;
   end Cmd_Test_Hang;

   -- ** --

   procedure Cmd_Test_MPU is
      function Parse_Test_Command (Command : String) return Boolean;

      -- ** --

      function Parse_Test_Command (Command : String) return Boolean is
      begin
         if Command = "write1" then
            MPU_Tests.Test_Forbidden_Write_To_Global_Data;
         elsif Command = "write2" then
            MPU_Tests.Test_Forbidden_Write_To_Secret_Data;
         elsif Command = "read" then
            MPU_Tests.Test_Forbidden_Read_To_Secret_Data;
         elsif Command = "exe1" then
            MPU_Tests.Test_Forbidden_Execute_To_Secret_Flash_Code;
         elsif Command = "exe2" then
            MPU_Tests.Test_Forbidden_Execute_To_Secret_RAM_Code;
         elsif Command = "stko" then
            MPU_Tests.Test_Stack_Overrun;
         elsif Command = "valid" then
            MPU_Tests.Test_Valid_Accesses;
         else
            return False;
         end if;

         return True;
      end Parse_Test_Command;

      -- ** --

      Token : Command_Line.Token_Type;
      Token_Found : Boolean;
      Parsing_Ok : Boolean;
   begin
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         goto Error;

      end if;

      Parsing_Ok :=
        Parse_Test_Command (Token.String_Value (1 .. Token.Length));
      if not Parsing_Ok then
         goto Error;
      end if;

      return;

   <<Error>>
      Serial_Console.Print_String (
         "Error: Invalid syntax for command 'test mpu'" &  ASCII.LF);
   end Cmd_Test_MPU;

   -- ** --

   procedure Initialize is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Command_Line.Initialize (Prompt'Access);
      Set_Private_Object_Data_Region (Command_Parser_Var'Address,
                                      Command_Parser_Var'Size,
                                      Read_Write,
                                      Old_Region);

      Command_Parser_Var.Initialized := True;
      Restore_Private_Object_Data_Region (Old_Region);
   end Initialize;

   -- ** --

   function Initialized return Boolean is (Command_Parser_Var.Initialized);

   -- ** --

   procedure Parse_Command is
      procedure Command_Dispatcher (Command : String);

      -- ** --

      procedure Command_Dispatcher (Command : String) is
      begin
         if Command = "help" or else Command = "h" then
            Cmd_Print_Help;
         elsif Command = "stats" or else Command = "st" then
            Command_Parser_Common.Cmd_Print_Stats;
         elsif Command = "log" then
            Command_Parser_Common.Cmd_Dump_Log;
         elsif Command = "log-tail" then
            Command_Parser_Common.Cmd_Dump_Log_Tail;
         elsif Command = "set" then
            Cmd_Set;
         elsif Command = "ping" then
            Cmd_Ping;
         elsif Command = "print-config"  or else Command = "pc" then
            Cmd_Print_Config_Params;
         elsif Command = "save-config"  or else Command = "sc" then
            Cmd_Save_Config_Params;
         elsif Command = "reset" then
            Command_Parser_Common.Cmd_Reset;
         elsif Command = "test" then
            Cmd_Test;
         else
            Serial_Console.Print_String ("Command '" & Command &
                                         "' is not recognized" & ASCII.LF);
         end if;
      end Command_Dispatcher;

      -- ** --

      Token : Command_Line.Token_Type;
      Token_Found : Boolean;

   begin -- Parse_Command
      Token_Found := Command_Line.Get_Next_Token (Token);
      if not Token_Found then
         return;
      end if;

      Serial_Console.Lock;
      Serial_Console.Put_Char (ASCII.LF);
      Command_Dispatcher (Token.String_Value (1 .. Token.Length));
      Serial_Console.Unlock;
   end Parse_Command;

end Command_Parser;
