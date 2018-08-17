--  Redistribution and use in source and binary forms, with or without modification,
--  are permitted provided that the following conditions are met:
--   o Redistributions of source code must retain the above copyright notice, this list
--   of conditions and the following disclaimer.
--   o Redistributions in binary form must reproduce the above copyright notice, this
--   list of conditions and the following disclaimer in the documentation and/or
--   other materials provided with the distribution.
--   o Neither the name of Freescale Semiconductor, Inc. nor the names of its
--   contributors may be used to endorse or promote products derived from this
--   software without specific prior written permission.
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--   DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
--   ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
--   ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--  This spec has been automatically generated from MK64F12.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;

with System;

package MK64F12.GPIO is
   pragma No_Elaboration_Code_All;

   ---------------
   -- Registers --
   ---------------

   -----------------
   -- Peripherals --
   -----------------

   --  General Purpose Input/Output
   type GPIO_Peripheral is record
      --  Port Data Output Register
      PDOR : MK64F12.Word;
      --  Port Set Output Register
      PSOR : MK64F12.Word;
      --  Port Clear Output Register
      PCOR : MK64F12.Word;
      --  Port Toggle Output Register
      PTOR : MK64F12.Word;
      --  Port Data Input Register
      PDIR : MK64F12.Word;
      --  Port Data Direction Register
      PDDR : MK64F12.Word;
   end record
     with Volatile;

   for GPIO_Peripheral use record
      PDOR at 0 range 0 .. 31;
      PSOR at 4 range 0 .. 31;
      PCOR at 8 range 0 .. 31;
      PTOR at 12 range 0 .. 31;
      PDIR at 16 range 0 .. 31;
      PDDR at 20 range 0 .. 31;
   end record;

   --  General Purpose Input/Output
   GPIOA_Periph : aliased GPIO_Peripheral
     with Import, Address => GPIOA_Base;

   --  General Purpose Input/Output
   GPIOB_Periph : aliased GPIO_Peripheral
     with Import, Address => GPIOB_Base;

   --  General Purpose Input/Output
   GPIOC_Periph : aliased GPIO_Peripheral
     with Import, Address => GPIOC_Base;

   --  General Purpose Input/Output
   GPIOD_Periph : aliased GPIO_Peripheral
     with Import, Address => GPIOD_Base;

   --  General Purpose Input/Output
   GPIOE_Periph : aliased GPIO_Peripheral
     with Import, Address => GPIOE_Base;

end MK64F12.GPIO;
