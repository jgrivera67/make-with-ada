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

with Devices.MCU_Specific;

--
--  @summary Pin MUX driver
--
package Pin_Mux_Driver is
   pragma Preelaborate;
   use Devices.MCU_Specific;
   use Devices;

   --
   --  Pin functions
   --
   type Pin_Function_Type is (PIN_FUNCTION_ALT0,
                              PIN_FUNCTION_ALT1,
                              PIN_FUNCTION_ALT2,
                              PIN_FUNCTION_ALT3,
                              PIN_FUNCTION_ALT4,
                              PIN_FUNCTION_ALT5,
                              PIN_FUNCTION_ALT6,
                              PIN_FUNCTION_ALT7);

   type Pin_Irq_Mode_Type is (Pin_Irq_None,
                              Pin_Irq_When_Logic_Zero,
                              Pin_Irq_On_Rising_Edge,
                              Pin_Irq_On_Falling_Edge,
                              Pin_Irq_On_Either_Edge,
                              Pin_Irq_When_Logic_One)
     with Size => Four_Bits'Size;

   for Pin_Irq_Mode_Type use (Pin_Irq_None => 16#0#,
                              Pin_Irq_When_Logic_Zero => 16#8#,
                              Pin_Irq_On_Rising_Edge => 16#9#,
                              Pin_Irq_On_Falling_Edge => 16#A#,
                              Pin_Irq_On_Either_Edge => 16#B#,
                              Pin_Irq_When_Logic_One => 16#C#);

   --
   --  Subtype declarations to make types visible to clients of this package
   --
   subtype Pin_Index_Type is PORT.Pin_Index_Type;
   subtype Pin_Array_Type is PORT.Pin_Array_Type;

   --
   --  Pin configuration parameters
   --
   type Pin_Info_Type is record
      Pin_Port : Pin_Port_Type;
      Pin_Index : Pin_Index_Type;
      Pin_Function : Pin_Function_Type;
   end record;

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;
   --
   --  Initialize the Pin Muxer hardware module
   --

   procedure Set_Pin_Function (
      Pin_Info : Pin_Info_Type;
      Drive_Strength_Enable : Boolean;
      Pullup_Resistor : Boolean)
     with Pre => Initialized;
   --
   --  Configure function for a given pin in the MCU's pin muxer
   --
   --  @param Pin_Info Pin to be configured
   --  @param Drive_Strength_Enable flag indicating if the DSE bit must be set
   --  @param Pullup_Resistor flag indicating if a pullup resister must be
   --  configured for the pin.
   --

   procedure Enable_Pin_Irq (Pin_Info : Pin_Info_Type;
                             Pin_Irq_Mode : Pin_Irq_Mode_Type);
   --  Enable generation of IRQs on a given pin
   --
   --  @param Pin_Info Pin information
   --  @param Pin_Irq_Mode  Pin IRQ mode
   --

   procedure Disable_Pin_Irq (Pin_Info : Pin_Info_Type);
   --
   --  Disable generation of IRQs on a given pin
   --
   --  @param Pin_Info Pin information
   --

   procedure Clear_Pin_Irq (Pin_Info : Pin_Info_Type);
   --
   --  Clear outstanding IRQ on a given pin
   --
   --  @param Pin_Info Pin information
   --

private

   Pin_Mux_Initialized : Boolean := False;

   function Initialized return Boolean is (Pin_Mux_Initialized);

end Pin_Mux_Driver;
