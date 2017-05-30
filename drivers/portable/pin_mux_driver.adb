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

with Pin_Mux_Driver.MCU_Specific_Private;
with Memory_Protection;
with System.Address_To_Access_Conversions;

package body Pin_Mux_Driver is
   pragma SPARK_Mode (Off);
   use Pin_Mux_Driver.MCU_Specific_Private;
   use Memory_Protection;

   package Address_To_Port_Registers_Pointer is new
      System.Address_To_Access_Conversions (PORT.Registers_Type);

   use Address_To_Port_Registers_Pointer;

   --
   --  Matrix to keep track of what pins are currently in use. If a pin is not
   --  in use (Set_Pin_Function has not been called for it), its entry is
   --  null.
   --
   Pins_In_Use_Map : array (Pin_Port_Type, PORT.Pin_Index_Type) of Boolean :=
     (others => (others => False));

   -------------------
   -- Clear_Pin_Irq --
   -------------------

   procedure Clear_Pin_Irq (Pin_Info : Pin_Info_Type) is
      Port_Registers : access PORT.Registers_Type renames
        Ports (Pin_Info.Pin_Port);
      ISFR_Value : PORT.Pin_Array_Type := (others => 0);
      Old_IO_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Object_Data_Region (
         To_Address (Object_Pointer (Port_Registers)),
         PORT.Registers_Type'Object_Size,
         Read_Write,
         Old_IO_Region);

      ISFR_Value (Pin_Info.Pin_Index) := 1;
      Port_Registers.all.ISFR := ISFR_Value;
      Restore_Private_Object_Data_Region (Old_IO_Region);
   end Clear_Pin_Irq;

   --------------------
   -- Disable_Pin_Irq --
   --------------------

   procedure Disable_Pin_Irq (Pin_Info : Pin_Info_Type) is
      Port_Registers : access PORT.Registers_Type renames
        Ports (Pin_Info.Pin_Port);
      PCR_Value : PORT.PCR_Type;
      Old_IO_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Object_Data_Region (
         To_Address (Object_Pointer (Port_Registers)),
         PORT.Registers_Type'Object_Size,
         Read_Write,
         Old_IO_Region);

      PCR_Value := Port_Registers.all.PCR (Pin_Info.Pin_Index);
      PCR_Value.IRQC := Pin_Irq_None'Enum_Rep;
      Port_Registers.all.PCR (Pin_Info.Pin_Index) := PCR_Value;
      Restore_Private_Object_Data_Region (Old_IO_Region);
   end Disable_Pin_Irq;

   --------------------
   -- Enable_Pin_Irq --
   --------------------

   procedure Enable_Pin_Irq (Pin_Info : Pin_Info_Type;
                             Pin_Irq_Mode : Pin_Irq_Mode_Type) is
      Port_Registers : access PORT.Registers_Type renames
        Ports (Pin_Info.Pin_Port);
      PCR_Value : PORT.PCR_Type;
      Old_IO_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Object_Data_Region (
         To_Address (Object_Pointer (Port_Registers)),
         PORT.Registers_Type'Object_Size,
         Read_Write,
         Old_IO_Region);

      PCR_Value := Port_Registers.all.PCR (Pin_Info.Pin_Index);
      PCR_Value.IRQC := Pin_Irq_Mode'Enum_Rep;
      Port_Registers.all.PCR (Pin_Info.Pin_Index) := PCR_Value;
      Restore_Private_Object_Data_Region (Old_IO_Region);
   end Enable_Pin_Irq;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is separate;
   --  This procedure is MCU-specific

   ----------------------
   -- Set_Pin_function --
   ----------------------

   procedure Set_Pin_Function (Pin_Info : Pin_Info_Type;
                               Drive_Strength_Enable : Boolean := False;
                               Pullup_Resistor : Boolean := False;
                               Open_Drain_Enable : Boolean := False)
   is separate;

end Pin_Mux_Driver;
