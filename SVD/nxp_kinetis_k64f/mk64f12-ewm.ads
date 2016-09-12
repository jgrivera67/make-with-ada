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

--  External Watchdog Monitor
package MK64F12.EWM is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CTRL_EWMEN_Field is MK64F12.Bit;
   subtype CTRL_ASSIN_Field is MK64F12.Bit;
   subtype CTRL_INEN_Field is MK64F12.Bit;
   subtype CTRL_INTEN_Field is MK64F12.Bit;

   --  Control Register
   type EWM_CTRL_Register is record
      --  EWM enable.
      EWMEN        : CTRL_EWMEN_Field := 16#0#;
      --  EWM_in's Assertion State Select.
      ASSIN        : CTRL_ASSIN_Field := 16#0#;
      --  Input Enable.
      INEN         : CTRL_INEN_Field := 16#0#;
      --  Interrupt Enable.
      INTEN        : CTRL_INTEN_Field := 16#0#;
      --  unspecified
      Reserved_4_7 : MK64F12.UInt4 := 16#0#;
   end record
     with Volatile_Full_Access, Size => 8, Bit_Order => System.Low_Order_First;

   for EWM_CTRL_Register use record
      EWMEN        at 0 range 0 .. 0;
      ASSIN        at 0 range 1 .. 1;
      INEN         at 0 range 2 .. 2;
      INTEN        at 0 range 3 .. 3;
      Reserved_4_7 at 0 range 4 .. 7;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  External Watchdog Monitor
   type EWM_Peripheral is record
      --  Control Register
      CTRL : EWM_CTRL_Register;
      --  Service Register
      SERV : MK64F12.Byte;
      --  Compare Low Register
      CMPL : MK64F12.Byte;
      --  Compare High Register
      CMPH : MK64F12.Byte;
   end record
     with Volatile;

   for EWM_Peripheral use record
      CTRL at 0 range 0 .. 7;
      SERV at 1 range 0 .. 7;
      CMPL at 2 range 0 .. 7;
      CMPH at 3 range 0 .. 7;
   end record;

   --  External Watchdog Monitor
   EWM_Periph : aliased EWM_Peripheral
     with Import, Address => EWM_Base;

end MK64F12.EWM;
