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

pragma SPARK_Mode (Off);

separate (Pin_Mux_Driver)
   procedure Set_Pin_Function (Pin_Info : Pin_Info_Type;
                               Drive_Strength_Enable : Boolean := False;
                               Pullup_Resistor : Boolean := False;
                               Open_Drain_Enable : Boolean := False)
   is
      procedure Enable_Port_Clock (Pin_Port : Pin_Port_Type);

      -----------------------
      -- Enable_Port_Clock --
      -----------------------

      procedure Enable_Port_Clock (Pin_Port : Pin_Port_Type)
      is
         SCGC5_Value : SIM.SCGC5_Type;
         Old_Region : MPU_Region_Descriptor_Type;
      begin
         Set_Private_Data_Region (
            SIM.Registers'Address,
            SIM.Registers'Size,
            Read_Write,
            Old_Region);

         SCGC5_Value := SIM.Registers.SCGC5;
         case Pin_Port is
            when PIN_PORT_A =>
               SCGC5_Value.PORTA := 1;
            when PIN_PORT_B =>
               SCGC5_Value.PORTB := 1;
            when PIN_PORT_C =>
               SCGC5_Value.PORTC := 1;
            when PIN_PORT_D =>
               SCGC5_Value.PORTD := 1;
            when PIN_PORT_E =>
               SCGC5_Value.PORTE := 1;
         end case;

         SIM.Registers.SCGC5 := SCGC5_Value;
         Restore_Private_Data_Region (Old_Region);
      end Enable_Port_Clock;

      Pins_In_Use_Entry : Boolean renames
        Pins_In_Use_Map (Pin_Info.Pin_Port, Pin_Info.Pin_Index);

      Port_Registers : access PORT.Registers_Type renames
        Ports (Pin_Info.Pin_Port);
      PCR_Value : PORT.PCR_Type;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      pragma Assert (not Pins_In_Use_Entry);
      Enable_Port_Clock (Pin_Info.Pin_Port);

      PCR_Value :=
        (MUX => Pin_Function_Type'Pos (Pin_Info.Pin_Function),
         DSE => Boolean'Pos (Drive_Strength_Enable),
         PS | PE => Boolean'Pos (Pullup_Resistor),
         ODE => Boolean'Pos (Open_Drain_Enable),
         IRQC => 0,
         others => 0);

      Set_Private_Data_Region (
         To_Address (Object_Pointer (Port_Registers)),
         PORT.Registers_Type'Object_Size,
         Read_Write,
         Old_Region);

      Port_Registers.all.PCR (Pin_Info.Pin_Index) := PCR_Value;

      Set_Private_Data_Region (
         Pins_In_Use_Map'Address,
         Pins_In_Use_Map'Size,
         Read_Write);

      Pins_In_Use_Entry := True;
      Restore_Private_Data_Region (Old_Region);
   end Set_Pin_Function;
