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

with System.Storage_Elements; use System.Storage_Elements;

package Microcontroller.MCU_Specific is
   pragma Preelaborate;

   --
   --  NOR Flash base address
   --
   Mcu_Flash_Base_Addr : constant Integer_Address := 16#0#;

   --
   --  NOR Flash size in bytes
   --
   Mcu_Flash_Size : constant Unsigned_32 := 128 * 1024;

   --
   --   SRAM base address
   --
   Mcu_Sram_Base_Addr : constant Integer_Address := 16#1FFFF000#;

   --
   --  SRAM size in byte
   --
   Mcu_Sram_Size : constant Unsigned_32 := 16 * 1024;

   --
   --  MMIO ranges
   --
   Mcu_Peripheral_Bridge_Min_Addr : constant Integer_Address := 16#40000000#;
   Mcu_Peripheral_Bridge_Max_Addr : constant Integer_Address := 16#400FFFFF#;
   Mcu_Private_Peripherals_Min_Addr : constant Integer_Address := 16#E0000000#;
   Mcu_Private_Peripherals_Max_Addr : constant Integer_Address := 16#E00FFFFF#;

   -- ** --

   procedure System_Reset;

   function Find_System_Reset_Cause return System_Reset_Causes_Type;

   function Valid_MMIO_Address (Address_Value : Address) return Boolean
     with inline;

   function Valid_Flash_Address (Address_Value : Address) return Boolean
     with inline;
   --  Check that an address is in flash memory and it is not address 0x0

   function Valid_RAM_Address (Address_Value : Address) return Boolean
     with inline;
   --   Check that an address is in RAM memory

   function Valid_RAM_Pointer (Address_Value : Address;
                               Alignment : Positive) return Boolean
     with inline;
   --
   --  Check that an address is a valid RAM pointer and has the given
   --  alignment to be used a valid pointer
   --

end Microcontroller.MCU_Specific;
