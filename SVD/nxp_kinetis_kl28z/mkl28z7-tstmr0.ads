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

--  This spec has been automatically generated from MKL28Z7.svd

pragma Restrictions (No_Elaboration_Code);
pragma Ada_2012;

with System;

--  Timestamp Timer
package MKL28Z7.TSTMR0 is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype H_VALUE_Field is MKL28Z7.UInt24;

   --  Time Stamp Timer Register High
   type TSTMR0_H_Register is record
      --  Read-only. Time Stamp Timer High
      VALUE          : H_VALUE_Field;
      --  unspecified
      Reserved_24_31 : MKL28Z7.Byte;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for TSTMR0_H_Register use record
      VALUE          at 0 range 0 .. 23;
      Reserved_24_31 at 0 range 24 .. 31;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Timestamp Timer
   type TSTMR0_Peripheral is record
      --  Time Stamp Timer Register Low
      L : MKL28Z7.Word;
      --  Time Stamp Timer Register High
      H : TSTMR0_H_Register;
   end record
     with Volatile;

   for TSTMR0_Peripheral use record
      L at 0 range 0 .. 31;
      H at 4 range 0 .. 31;
   end record;

   --  Timestamp Timer
   TSTMR0_Periph : aliased TSTMR0_Peripheral
     with Import, Address => TSTMR0_Base;

end MKL28Z7.TSTMR0;
