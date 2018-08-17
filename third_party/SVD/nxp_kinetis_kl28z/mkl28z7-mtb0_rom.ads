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

--  System ROM
package MKL28Z7.MTB0_ROM is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  Entry

   --  Entry
   type MTB0_ROM_ENTRY_Registers is array (0 .. 3) of MKL28Z7.Word;

   --  Peripheral ID Register

   --  Peripheral ID Register
   type MTB0_ROM_PERIPHID_Registers is array (0 .. 7) of MKL28Z7.Word;

   --  Component ID Register

   --  Component ID Register
   type MTB0_ROM_COMPID_Registers is array (0 .. 3) of MKL28Z7.Word;

   -----------------
   -- Peripherals --
   -----------------

   --  System ROM
   type MTB0_ROM_Peripheral is record
      --  Entry
      ENTRY_k   : MTB0_ROM_ENTRY_Registers;
      --  End of Table Marker Register
      TABLEMARK : MKL28Z7.Word;
      --  System Access Register
      SYSACCESS : MKL28Z7.Word;
      --  Peripheral ID Register
      PERIPHID  : MTB0_ROM_PERIPHID_Registers;
      --  Component ID Register
      COMPID    : MTB0_ROM_COMPID_Registers;
   end record
     with Volatile;

   for MTB0_ROM_Peripheral use record
      ENTRY_k   at 0 range 0 .. 127;
      TABLEMARK at 16 range 0 .. 31;
      SYSACCESS at 4044 range 0 .. 31;
      PERIPHID  at 4048 range 0 .. 255;
      COMPID    at 4080 range 0 .. 127;
   end record;

   --  System ROM
   MTB0_ROM_Periph : aliased MTB0_ROM_Peripheral
     with Import, Address => MTB0_ROM_Base;

end MKL28Z7.MTB0_ROM;
