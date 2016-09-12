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

--  VBAT register file
package MK64F12.RFVBAT is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype REG_LL_Field is MK64F12.Byte;
   subtype REG_LH_Field is MK64F12.Byte;
   subtype REG_HL_Field is MK64F12.Byte;
   subtype REG_HH_Field is MK64F12.Byte;

   --  VBAT register file register
   type RFVBAT_REG_Register is record
      --  Low lower byte
      LL : REG_LL_Field := 16#0#;
      --  Low higher byte
      LH : REG_LH_Field := 16#0#;
      --  High lower byte
      HL : REG_HL_Field := 16#0#;
      --  High higher byte
      HH : REG_HH_Field := 16#0#;
   end record
     with Volatile_Full_Access, Size => 32,
          Bit_Order => System.Low_Order_First;

   for RFVBAT_REG_Register use record
      LL at 0 range 0 .. 7;
      LH at 0 range 8 .. 15;
      HL at 0 range 16 .. 23;
      HH at 0 range 24 .. 31;
   end record;

   --  VBAT register file register
   type RFVBAT_REG_Registers is array (0 .. 7) of RFVBAT_REG_Register;

   -----------------
   -- Peripherals --
   -----------------

   --  VBAT register file
   type RFVBAT_Peripheral is record
      --  VBAT register file register
      REG : RFVBAT_REG_Registers;
   end record
     with Volatile;

   for RFVBAT_Peripheral use record
      REG at 0 range 0 .. 255;
   end record;

   --  VBAT register file
   RFVBAT_Periph : aliased RFVBAT_Peripheral
     with Import, Address => RFVBAT_Base;

end MK64F12.RFVBAT;
