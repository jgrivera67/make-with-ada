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

with Last_Chance_Handler;  pragma Unreferenced (Last_Chance_Handler);

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Kinetis_K64F; use Kinetis_K64F;
with Kinetis_K64F.PORT;
with Kinetis_K64F.GPIO;
with GNAT.Source_Info;

procedure Hexiwear_Gnat_Runtime_Test is
   procedure Led_Test;

   procedure Led_Test is
      PCR_Value : PORT.PCR_Type;
      Pin_Array_Value : GPIO.Pin_Array;
   begin
      PCR_Value := PORT.PortB_Registers.PCR (22);
      PCR_Value.MUX := 1;
      PORT.PortB_Registers.PCR (22) := PCR_Value;

      PCR_Value := PORT.PortE_Registers.PCR (26);
      PCR_Value.MUX := 1;
      PORT.PortE_Registers.PCR (26) := PCR_Value;

      Pin_Array_Value := GPIO.PortB_Registers.PDDR;
      Pin_Array_Value (22) := 1;
      GPIO.PortB_Registers.PDDR := Pin_Array_Value;

      Pin_Array_Value := GPIO.PortE_Registers.PDDR;
      Pin_Array_Value (26) := 1;
      GPIO.PortE_Registers.PDDR := Pin_Array_Value;

      Pin_Array_Value := (others => 1);
      GPIO.PortB_Registers.PSOR := Pin_Array_Value;
      GPIO.PortE_Registers.PSOR := Pin_Array_Value;

      --  turn on red:
      Pin_Array_Value := (22 => 1, others => 0);
      GPIO.PortB_Registers.PCOR := Pin_Array_Value;
      delay until Clock + Milliseconds(500);

      -- turn off red:
      Pin_Array_Value := (22 => 1, others => 0);
      GPIO.PortB_Registers.PSOR := Pin_Array_Value;
      delay until Clock + Milliseconds(500);

      -- turn on yellow:
      Pin_Array_Value := (22 => 1, others => 0);
      GPIO.PortB_Registers.PCOR := Pin_Array_Value;
      Pin_Array_Value := (26 => 1, others => 0);
      GPIO.PortE_Registers.PCOR := Pin_Array_Value;
      delay until Clock + Milliseconds(500);

      -- turn off yellow:
      Pin_Array_Value := (22 => 1, others => 0);
      GPIO.PortB_Registers.PSOR := Pin_Array_Value;
      Pin_Array_Value := (26 => 1, others => 0);
      GPIO.PortE_Registers.PSOR := Pin_Array_Value;
      delay until Clock + Milliseconds(500);

      --  turn on green:
      Pin_Array_Value := (26 => 1, others => 0);
      GPIO.PortE_Registers.PCOR := Pin_Array_Value;

   end Led_Test;

   -- ** --

   procedure Toggle_LED_Green (Toggle_State : in out Boolean) is
      Pin_Array_Value : GPIO.Pin_Array;
   begin
      Pin_Array_Value := (26 => 1, others => 0);
      if Toggle_State then
         GPIO.PortE_Registers.PCOR := Pin_Array_Value;
      else
         GPIO.PortE_Registers.PSOR := Pin_Array_Value;
      end if;

      Toggle_State := Toggle_State xor True;
   end Toggle_LED_Green;

   -- ** --

   Next_Time : Time;
   Counter : Natural := 0;
   LED_Toggle_State : Boolean := True;

begin --  Hexiwear_Gnat_Runtime_Test

   --  Test LED and "delay until"
   --Led_Test;

   --  Test UART output
   New_Line;
   Put_Line ("Hello World");
   Put_Line ("Built on " & GNAT.Source_Info.Compilation_Date & " at " &
             GNAT.Source_Info.Compilation_Time);

   --  Test assertion violation:
   --  (To test assert violations uncomment the line below)
   --  pragma Assert (False);

   --  Test LED, UART output and "delay until" repeatedly:
   Next_Time := Clock;
   loop
      Toggle_LED_Green (LED_Toggle_State);
      Put (Counter'Image);
      Put (ASCII.CR);
      Counter := Counter + 1;
      Next_Time := Next_Time + Milliseconds (1000);
      delay until Next_Time;
   end loop;

end Hexiwear_Gnat_Runtime_Test;
