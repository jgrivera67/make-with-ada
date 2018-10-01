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

with Kinetis_K64F;
with Interfaces.Bit_Types;
with Microcontroller.Arch_Specific;
with Microcontroller.CPU_Specific;
with Gpio_Driver.MCU_Specific_Private;
with Memory_Protection;
with System.Address_To_Access_Conversions;

package body Gpio_Driver is
   pragma SPARK_Mode (Off);
   use Interfaces.Bit_Types;
   use Interfaces;
   use Microcontroller.Arch_Specific;
   use Microcontroller.CPU_Specific;
   use Gpio_Driver.MCU_Specific_Private;
   use Devices.MCU_Specific;
   use Memory_Protection;

   package Address_To_Gpio_Registers_Pointer is new
      System.Address_To_Access_Conversions (GPIO.Registers_Type);

   use Address_To_Gpio_Registers_Pointer;

   type GPIO_Pin_Irq_Info_Type is record
      Pin_Irq_Handler : GPIO_Pin_Irq_Handler_Type := null;
      Pin_Info : Pin_Info_Type;
   end record;

   --
   --  Table of GPIO Pin IRQ handlers
   --
   type GPIO_Pin_Irq_Handlers_Type is
     array (Pin_Port_Type, Pin_Index_Type) of GPIO_Pin_Irq_Info_Type
     with Alignment => MPU_Region_Alignment,
          Size => 40 * MPU_Region_Alignment * Byte'Size;

   GPIO_Pin_Irq_Handlers : GPIO_Pin_Irq_Handlers_Type;

   type GPIO_Port_IRQ_Info_Type is limited record
      IRQ_Number : IRQ_Index_Type;
      Enabled_In_NVIC : Boolean := False;
   end record;

   GPIO_Port_IRQs : array (Pin_Port_Type) of GPIO_Port_IRQ_Info_Type :=
     (PIN_PORT_A => (IRQ_Number => Kinetis_K64F.PORTA_IRQ'Enum_Rep,
                     others => <>),
      PIN_PORT_B => (IRQ_Number => Kinetis_K64F.PORTB_IRQ'Enum_Rep,
                     others => <>),
      PIN_PORT_C => (IRQ_Number => Kinetis_K64F.PORTC_IRQ'Enum_Rep,
                     others => <>),
      PIN_PORT_D => (IRQ_Number => Kinetis_K64F.PORTD_IRQ'Enum_Rep,
                     others => <>),
      PIN_PORT_E => (IRQ_Number => Kinetis_K64F.PORTE_IRQ'Enum_Rep,
                     others => <>));

   procedure GPIO_Irq_Common_Handler (Pin_Port : Pin_Port_Type)
     with Pre => not Are_Cpu_Interrupts_Disabled;

   procedure PORTA_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "PORTA_IRQ_Handler";

   procedure PORTB_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "PORTB_IRQ_Handler";

   procedure PORTC_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "PORTC_IRQ_Handler";

   procedure PORTD_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "PORTD_IRQ_Handler";

   procedure PORTE_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "PORTE_IRQ_Handler";

   -------------------------
   -- Activate_Output_Pin --
   -------------------------

   procedure Activate_Output_Pin (Gpio_Pin : Gpio_Pin_Type) is
      Gpio_Registers : GPIO_Registers_Access_Type renames
        Gpio_Ports (Gpio_Pin.Pin_Info.Pin_Port);
      PDDR_Value : Pin_Array_Type;
      Pin_Array_Value : Pin_Array_Type := (others => 0);
      Pin_Index : Pin_Index_Type renames Gpio_Pin.Pin_Info.Pin_Index;
      Old_IO_Region : MPU_Region_Descriptor_Type;
   begin
      PDDR_Value := Gpio_Registers.PDDR;
      pragma Assert (PDDR_Value (Pin_Index) /= 0);

      Set_Private_Data_Region (
         To_Address (Object_Pointer (Gpio_Registers)),
         GPIO.Registers_Type'Object_Size,
         Read_Write,
         Old_IO_Region);

      Pin_Array_Value (Pin_Index) := 1;
      if Gpio_Pin.Is_Active_High then
         Gpio_Registers.PSOR := Pin_Array_Value;
      else
         Gpio_Registers.PCOR := Pin_Array_Value;
      end if;

      Restore_Private_Data_Region (Old_IO_Region);
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
      Old_IO_Region : MPU_Region_Descriptor_Type;
   begin
      Old_Primask := Disable_Cpu_Interrupts;

      Pin_Mux_Driver.Set_Pin_Function (Gpio_Pin.Pin_Info,
                                       Drive_Strength_Enable, Pullup_Resistor);

      Set_Private_Data_Region (
         To_Address (Object_Pointer (Gpio_Registers)),
         GPIO.Registers_Type'Object_Size,
         Read_Write,
         Old_IO_Region);

      PDDR_Value := Gpio_Registers.PDDR;
      PDDR_Value (Gpio_Pin.Pin_Info.Pin_Index) := Boolean'Pos (Is_Output_Pin);
      Gpio_Registers.PDDR := PDDR_Value;

      Restore_Private_Data_Region (Old_IO_Region);

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
      Old_IO_Region : MPU_Region_Descriptor_Type;
   begin
      PDDR_Value := Gpio_Registers.PDDR;
      pragma Assert (PDDR_Value (Pin_Index) /= 0);

      Set_Private_Data_Region (
         To_Address (Object_Pointer (Gpio_Registers)),
         GPIO.Registers_Type'Object_Size,
         Read_Write,
         Old_IO_Region);

      Pin_Array_Value (Pin_Index) := 1;
      if Gpio_Pin.Is_Active_High then
         Gpio_Registers.PCOR := Pin_Array_Value;
      else
         Gpio_Registers.PSOR := Pin_Array_Value;
      end if;

      Restore_Private_Data_Region (Old_IO_Region);
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
      Pin_Irq_Mode : Pin_Irq_Mode_Type;
      Pin_Irq_Handler : GPIO_Pin_Irq_Handler_Type)
   is
      Old_Region : MPU_Region_Descriptor_Type;
      Old_Intmask : Unsigned_32;
   begin
      Set_Private_Data_Region (GPIO_Pin_Irq_Handlers'Address,
                               GPIO_Pin_Irq_Handlers'Size,
                               Read_Write,
                               Old_Region);
      Old_Intmask := Disable_Cpu_Interrupts;

      if not GPIO_Port_IRQs (Gpio_Pin.Pin_Info.Pin_Port).Enabled_In_NVIC then
         NVIC_Setup_External_Interrupt (
            GPIO_Port_IRQs (Gpio_Pin.Pin_Info.Pin_Port).IRQ_Number,
            Priority => Kinetis_K64F.GPIO_Interrupt_Priority);
         GPIO_Port_IRQs (Gpio_Pin.Pin_Info.Pin_Port).Enabled_In_NVIC := True;
      end if;

      GPIO_Pin_Irq_Handlers (Gpio_Pin.Pin_Info.Pin_Port,
                             Gpio_Pin.Pin_Info.Pin_Index) :=
        (Pin_Irq_Handler => Pin_Irq_Handler,
         Pin_Info => Gpio_Pin.Pin_Info);

      Restore_Cpu_Interrupts (Old_Intmask);
      Restore_Private_Data_Region (Old_Region);
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
      Old_IO_Region : MPU_Region_Descriptor_Type;
   begin
      PDDR_Value := Gpio_Registers.PDDR;
      pragma Assert (PDDR_Value (Pin_Index) /= 0);

      Set_Private_Data_Region (
         To_Address (Object_Pointer (Gpio_Registers)),
         GPIO.Registers_Type'Object_Size,
         Read_Write,
         Old_IO_Region);

      Pin_Array_Value (Pin_Index) := 1;
      Gpio_Registers.PTOR := Pin_Array_Value;

      Restore_Private_Data_Region (Old_IO_Region);
   end Toggle_Output_Pin;

   -----------------------
   -- PORTA_IRQ_Handler --
   -----------------------

   procedure PORTA_IRQ_Handler is
   begin
      GPIO_Irq_Common_Handler (PIN_PORT_A);
   end PORTA_IRQ_Handler;

   -----------------------
   -- PORTB_IRQ_Handler --
   -----------------------

   procedure PORTB_IRQ_Handler is
   begin
      GPIO_Irq_Common_Handler (PIN_PORT_B);
   end PORTB_IRQ_Handler;

   -----------------------
   -- PORTC_IRQ_Handler --
   -----------------------

   procedure PORTC_IRQ_Handler is
   begin
      GPIO_Irq_Common_Handler (PIN_PORT_C);
   end PORTC_IRQ_Handler;

   -----------------------
   -- PORTD_IRQ_Handler --
   -----------------------

   procedure PORTD_IRQ_Handler is
   begin
      GPIO_Irq_Common_Handler (PIN_PORT_D);
   end PORTD_IRQ_Handler;

   -----------------------
   -- PORTE_IRQ_Handler --
   -----------------------

   procedure PORTE_IRQ_Handler is
   begin
      GPIO_Irq_Common_Handler (PIN_PORT_E);
   end PORTE_IRQ_Handler;

   -----------------------------
   -- GPIO_Irq_Common_Handler --
   -----------------------------

   procedure GPIO_Irq_Common_Handler (Pin_Port : Pin_Port_Type)
   is
   begin
      for Pin_Index in Pin_Index_Type loop
	 declare
	    Pin_Irq_Info : GPIO_Pin_Irq_Info_Type renames
	       GPIO_Pin_Irq_Handlers (Pin_Port, Pin_Index);
	 begin
	    if Is_Irq_Raised (Pin_Irq_Info.Pin_Info) then
	       Clear_Pin_Irq (Pin_Irq_Info.Pin_Info);
	       if Pin_Irq_Info.Pin_Irq_Handler /= null then
		  Pin_Irq_Info.Pin_Irq_Handler.all;
	       end if;
	    end if;
	 end;
      end loop;
   end GPIO_Irq_Common_Handler;

end Gpio_Driver;
