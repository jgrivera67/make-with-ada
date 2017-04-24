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

with Interfaces.Bit_Types;
with Microcontroller.Arm_Cortex_M;
with Gpio_Driver.MCU_Specific_Private;
with Memory_Protection;
with System.Address_To_Access_Conversions;

package body Gpio_Driver is
   use Interfaces.Bit_Types;
   use Microcontroller.Arm_Cortex_M;
   use Gpio_Driver.MCU_Specific_Private;
   use Devices.MCU_Specific;
   use Memory_Protection;

   package Address_To_Gpio_Registers_Pointer is new
      System.Address_To_Access_Conversions (GPIO.Registers_Type);

   use Address_To_Gpio_Registers_Pointer;

   -------------------------
   -- Activate_Output_Pin --
   -------------------------

   procedure Activate_Output_Pin (Gpio_Pin : Gpio_Pin_Type) is
      Gpio_Registers : GPIO_Registers_Access_Type renames
        Gpio_Ports (Gpio_Pin.Pin_Info.Pin_Port);
      PDDR_Value : Pin_Array_Type;
      Pin_Array_Value : Pin_Array_Type := (others => 0);
      Pin_Index : Pin_Index_Type renames Gpio_Pin.Pin_Info.Pin_Index;
      Old_IO_Region : Writable_Region_Type;
   begin
      PDDR_Value := Gpio_Registers.PDDR;
      pragma Assert (PDDR_Value (Pin_Index) /= 0);

      Set_CPU_Writable_Data_Region (
         To_Address (Object_Pointer (Gpio_Registers)),
         GPIO.Registers_Type'Object_Size,
         Old_IO_Region);

      Pin_Array_Value (Pin_Index) := 1;
      if Gpio_Pin.Is_Active_High then
         Gpio_Registers.PSOR := Pin_Array_Value;
      else
         Gpio_Registers.PCOR := Pin_Array_Value;
      end if;

      Set_CPU_Writable_Data_Region (Old_IO_Region);
   end Activate_Output_Pin;

   -------------------
   -- Clear_Pin_Irq --
   -------------------

   procedure Clear_Pin_Irq (Gpio_Pin : Gpio_Pin_Type) is
   begin
      Pin_Mux_Driver.Clear_Pin_Irq (Gpio_Pin.Pin_Info);
   end Clear_Pin_Irq;

   -------------------
   -- Configure_Pin --
   -------------------

   procedure Configure_Pin
     (Gpio_Pin : Gpio_Pin_Type;
      Drive_Strength_Enable : Boolean;
      Pullup_Resistor : Boolean;
      Is_Output_Pin : Boolean)
   is
      Old_Primask : Word;
      Gpio_Registers : GPIO_Registers_Access_Type renames
        Gpio_Ports (Gpio_Pin.Pin_Info.Pin_Port);
      PDDR_Value : Pin_Array_Type;
      Old_IO_Region : Writable_Region_Type;
   begin
      Old_Primask := Disable_Cpu_Interrupts;

      Pin_Mux_Driver.Set_Pin_Function (Gpio_Pin.Pin_Info,
                                       Drive_Strength_Enable, Pullup_Resistor);

      Set_CPU_Writable_Data_Region (
         To_Address (Object_Pointer (Gpio_Registers)),
         GPIO.Registers_Type'Object_Size,
         Old_IO_Region);

      PDDR_Value := Gpio_Registers.PDDR;
      PDDR_Value (Gpio_Pin.Pin_Info.Pin_Index) := Boolean'Pos (Is_Output_Pin);
      Gpio_Registers.PDDR := PDDR_Value;

      Set_CPU_Writable_Data_Region (Old_IO_Region);

      Restore_Cpu_Interrupts (Old_Primask);
   end Configure_Pin;

   ---------------------------
   -- Deactivate_Output_Pin --
   ---------------------------

   procedure Deactivate_Output_Pin (Gpio_Pin : Gpio_Pin_Type) is
      Gpio_Registers : GPIO_Registers_Access_Type renames
        Gpio_Ports (Gpio_Pin.Pin_Info.Pin_Port);
      PDDR_Value : Pin_Array_Type;
      Pin_Array_Value : Pin_Array_Type := (others => 0);
      Pin_Index : Pin_Index_Type renames Gpio_Pin.Pin_Info.Pin_Index;
      Old_IO_Region : Writable_Region_Type;
   begin
      PDDR_Value := Gpio_Registers.PDDR;
      pragma Assert (PDDR_Value (Pin_Index) /= 0);

      Set_CPU_Writable_Data_Region (
         To_Address (Object_Pointer (Gpio_Registers)),
         GPIO.Registers_Type'Object_Size,
         Old_IO_Region);

      Pin_Array_Value (Pin_Index) := 1;
      if Gpio_Pin.Is_Active_High then
         Gpio_Registers.PCOR := Pin_Array_Value;
      else
         Gpio_Registers.PSOR := Pin_Array_Value;
      end if;

      Set_CPU_Writable_Data_Region (Old_IO_Region);
   end Deactivate_Output_Pin;

   ---------------------
   -- Disable_Pin_Irq --
   ---------------------

   procedure Disable_Pin_Irq (Gpio_Pin : Gpio_Pin_Type) is
   begin
      Pin_Mux_Driver.Disable_Pin_Irq (Gpio_Pin.Pin_Info);
   end Disable_Pin_Irq;

   --------------------
   -- Enable_Pin_Irq --
   --------------------

   procedure Enable_Pin_Irq
     (Gpio_Pin : Gpio_Pin_Type;
      Pin_Irq_Mode : Pin_Irq_Mode_Type)
   is
   begin
      Pin_Mux_Driver.Enable_Pin_Irq (Gpio_Pin.Pin_Info, Pin_Irq_Mode);
   end Enable_Pin_Irq;

   --------------------
   -- Read_Input_Pin --
   --------------------

   function Read_Input_Pin (Gpio_Pin : Gpio_Pin_Type) return Boolean is
      Gpio_Registers : GPIO_Registers_Access_Type renames
        Gpio_Ports (Gpio_Pin.Pin_Info.Pin_Port);
      Pin_Index : Pin_Index_Type renames Gpio_Pin.Pin_Info.Pin_Index;
      PDIR_Value : Pin_Array_Type;
   begin
      PDIR_Value := Gpio_Registers.PDIR;
      return PDIR_Value (Pin_Index) /= 0;
   end Read_Input_Pin;

   -----------------------
   -- Toggle_Output_Pin --
   -----------------------

   procedure Toggle_Output_Pin (Gpio_Pin : Gpio_Pin_Type) is
      Gpio_Registers : GPIO_Registers_Access_Type renames
        Gpio_Ports (Gpio_Pin.Pin_Info.Pin_Port);
      PDDR_Value : Pin_Array_Type;
      Pin_Array_Value : Pin_Array_Type := (others => 0);
      Pin_Index : Pin_Index_Type renames Gpio_Pin.Pin_Info.Pin_Index;
      Old_IO_Region : Writable_Region_Type;
   begin
      PDDR_Value := Gpio_Registers.PDDR;
      pragma Assert (PDDR_Value (Pin_Index) /= 0);

      Set_CPU_Writable_Data_Region (
         To_Address (Object_Pointer (Gpio_Registers)),
         GPIO.Registers_Type'Object_Size,
         Old_IO_Region);

      Pin_Array_Value (Pin_Index) := 1;
      Gpio_Registers.PTOR := Pin_Array_Value;

      Set_CPU_Writable_Data_Region (Old_IO_Region);
   end Toggle_Output_Pin;

end Gpio_Driver;
