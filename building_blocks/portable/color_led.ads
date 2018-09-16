--
--  Copyright (c) 2018, German Rivera
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

with RTOS;
with Interfaces;--???
private with Gpio_Driver;
private with Memory_Protection;

--
--  @summary Multi-color LED services
--
package Color_Led is
   use type RTOS.RTOS_Time_Ms_Type;

   type Led_Color_Type is (Black,
                           Red,
                           Green,
                           Yellow,
                           Blue,
                           Magenta,
                           Cyan,
                           White);

   function Initialized return Boolean with Inline;
   --  @private (Used only in contracts)

   procedure Initialize with Pre => not Initialized;
   --
   --  Initializes the multi-color LED peripheral
   --

   procedure Set_Color (Color : Led_Color_Type)
      with Pre => Initialized;
   --
   --  Set the current color of the multi-color LED
   --
   --  @param Color color to be set on the LED
   --

   function Set_Color (New_Color : Led_Color_Type) return Led_Color_Type
     with Pre => Initialized;
   --
   --  Set the current color of the multi-color LED
   --
   --  @param New_Color new color to be set on the LED
   --
   --  @return previous color the LED had
   --

   procedure Toggle_Color (Color : Led_Color_Type)
     with Pre => Initialized;
   --
   --  Toggle the given color. If the current LED color is 'Color',
   --

   procedure Turn_On_Blinker (Period : RTOS.RTOS_Time_Ms_Type)
     with Pre => Initialized and then
                 Period /= 0;
   --
   --  Turn on LED blinking every 'Period' milliseconds, using current color
   --

   procedure Turn_Off_Blinker
     with Pre => Initialized;
   --
   --  Turn off LED blinking, leaving the LED steady in the current color
   --

   Led_Blinker_Task_Obj : RTOS.RTOS_Task_Type;

   procedure Led_Blinker_Task_Proc
     with Convention => C;

   --???
   procedure jgr_print_reg (reg : Interfaces.Unsigned_32) with
     Export,
     Convention => C,
     External_Name => "jgr_print_reg";

private
   use Gpio_Driver;

   type Rgb_Led_Pins_Type is record
      Red_Pin : Gpio_Pin_Type;
      Green_Pin : Gpio_Pin_Type;
      Blue_Pin : Gpio_Pin_Type;
   end record;

   type Rgb_Led_Type (
      Pins_Ptr : not null access constant Rgb_Led_Pins_Type)
   is limited record
      Initialized : Boolean := False;
      Current_Color : Led_Color_Type := Black;
      Current_Toggle : Boolean := False;
      Blinking_Period_Ms : RTOS.RTOS_Time_Ms_Type := 0;
   end record with Alignment => Memory_Protection.MPU_Region_Alignment;

end Color_Led;
