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

with Pin_Mux_Driver;
private with Devices.MCU_Specific;

--
--  @summary GPIO driver
--
package Gpio_Driver is
   use Pin_Mux_Driver;

   --
   --  GPIO pin configuration parameters
   --
   type Gpio_Pin_Type is record
      Pin_Info : Pin_Info_Type;
      Is_Active_High : Boolean;
   end record;

   procedure Configure_Pin (Gpio_Pin : Gpio_Pin_Type;
                            Drive_Strength_Enable : Boolean;
                            Pullup_Resistor : Boolean;
                            Is_Output_Pin : Boolean);

   procedure Activate_Output_Pin (Gpio_Pin : Gpio_Pin_Type);

   procedure Deactivate_Output_Pin (Gpio_Pin : Gpio_Pin_Type);

   procedure Toggle_Output_Pin (Gpio_Pin : Gpio_Pin_Type);

   function Read_Input_Pin (Gpio_Pin : Gpio_Pin_Type) return Boolean;

   procedure Enable_Pin_Irq (Gpio_Pin : Gpio_Pin_Type;
                             Pin_Irq_Mode : Pin_Irq_Mode_Type);

   procedure Disable_Pin_Irq (Gpio_Pin : Gpio_Pin_Type);

   procedure Clear_Pin_Irq (Gpio_Pin : Gpio_Pin_Type);

private
   type GPIO_Registers_Access_Type is
      access all Devices.MCU_Specific.GPIO.Registers_Type;

end Gpio_Driver;
