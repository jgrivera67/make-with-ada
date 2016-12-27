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
   --  Sector size (in bytes) of the MCU's program flash memory
   --
   Nor_Flash_Sector_Size : constant := 1024;

   --
   --  MMIO ranges
   --
   Mcu_Peripheral_Bridge_Min_Addr : constant Integer_Address := 16#40000000#;
   Mcu_Peripheral_Bridge_Max_Addr : constant Integer_Address := 16#400FFFFF#;

   -- ** --

   procedure System_Reset with No_Return;

   function Find_System_Reset_Cause return System_Reset_Causes_Type;

   package Memory_Map is new
     Generic_Memory_Map (Mcu_Peripheral_Bridge_Min_Addr,
                         Mcu_Peripheral_Bridge_Max_Addr,
                         Mcu_Flash_Base_Addr,
                         Mcu_Flash_Size,
                         Mcu_Sram_Base_Addr,
                         Mcu_Sram_Size);

end Microcontroller.MCU_Specific;
