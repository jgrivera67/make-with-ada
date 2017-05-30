--
--  Copyright (c) 2017, German Rivera
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

with Memory_Protection;
with Interfaces.Bit_Types;
with SPI_Driver;
with Devices.MCU_Specific;

--
--  LCD display services implementation
--
package body LCD_Display is
   pragma SPARK_Mode (Off);
   use Memory_Protection;
   use Interfaces.Bit_Types;

   --
   --  State variables of the LCD display
   --
   type LCD_Display_Type is limited record
      Initialized : Boolean := False;
   end record with Alignment => MPU_Region_Alignment,
                   Size => MPU_Region_Alignment * Byte'Size;

   LCD_Display_Var : LCD_Display_Type;

   -- ** --


   procedure Initialize is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      SPI_Driver.Initialize (SPI_Device_Id => Devices.MCU_Specific.SPI2,
                             Master_Mode => True,
                             Frame_Size => 1,
                             Sck_Frequency_Hz => 8_000_000);

      Set_Private_Object_Data_Region (LCD_Display_Var'Address,
                                      LCD_Display_Var'Size,
                                      Read_Write,
                                      Old_Region);

      LCD_Display_Var.Initialized := True;
      Restore_Private_Object_Data_Region (Old_Region);
   end Initialize;

   -- ** --

   function Initialized return Boolean is (LCD_Display_Var.Initialized);

   -- ** --

end LCD_Display;
