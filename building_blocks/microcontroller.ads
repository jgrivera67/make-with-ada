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

with System; use System;
with Interfaces; use Interfaces;
with Interfaces.Bit_Types; use Interfaces.Bit_Types;
with System.Storage_Elements; use System.Storage_Elements;

--
-- @summary Micrcontroller operations
--
package Microcontroller is
   pragma Preelaborate;

   type Bytes_Array is array (Positive range <>) of Byte;
   type Words_Array is array (Positive range <>) of Word;

   type Hertz_Type is range 1 .. 1_000_000_000;

   subtype Two_Bits is UInt2;
   subtype Three_Bits is UInt3;
   subtype Four_Bits is UInt4;
   subtype Five_Bits is UInt5;
   subtype Six_Bits is UInt6;
   subtype Nine_Bits is UInt9;
   subtype Half_Word is Unsigned_16;

   --
   --  System reset causes
   --
   type System_Reset_Causes_Type is (
      INVALID_RESET_CAUSE,
      POWER_ON_RESET,
      EXTERNAL_PIN_RESET,
      WATCHDOG_RESET,
      SOFTWARE_RESET,
      LOCKUP_EVENT_RESET,
      EXTERNAL_DEBUGGER_RESET,
      OTHER_HW_REASON_RESET,
      STOP_ACK_ERROR_RESET
    );

   --
   --  Constant strings for reset causes
   --
   INVALID_RESET_CAUSE_String : aliased constant String := "Invalid reset";
   POWER_ON_RESET_String : aliased constant String := "Power-on reset";
   EXTERNAL_PIN_RESET_String : aliased constant String := "External pin reset";
   WATCHDOG_RESET_String : aliased constant String :=  "Watchdog reset";
   SOFTWARE_RESET_String : aliased constant String := "Software reset";
   LOCKUP_EVENT_RESET_String : aliased constant String := "Lockup reset";
   EXTERNAL_DEBUGGER_RESET_String : aliased constant String :=
     "External debugger reset";
   OTHER_HW_REASON_RESET_String : aliased constant String :=
     "Other hardware-reason reset";
   STOP_ACK_ERROR_RESET_String : aliased constant String :=
     "Stop ack error reset";

   Reset_Cause_Strings :
     constant array (Microcontroller.System_Reset_Causes_Type) of
     not null access constant String :=
       (INVALID_RESET_CAUSE => INVALID_RESET_CAUSE_String'Access,
        POWER_ON_RESET =>  POWER_ON_RESET_String'Access,
        EXTERNAL_PIN_RESET => EXTERNAL_PIN_RESET_String'Access,
        WATCHDOG_RESET => WATCHDOG_RESET_String'Access,
        SOFTWARE_RESET => SOFTWARE_RESET_String'Access,
        LOCKUP_EVENT_RESET => LOCKUP_EVENT_RESET_String'Access,
        EXTERNAL_DEBUGGER_RESET => EXTERNAL_DEBUGGER_RESET_String'Access,
        OTHER_HW_REASON_RESET => OTHER_HW_REASON_RESET_String'Access,
        STOP_ACK_ERROR_RESET => STOP_ACK_ERROR_RESET_String'Access);

   -- ** --

   Mcu_Private_Peripherals_Min_Addr : constant Integer_Address := 16#E0000000#;
   Mcu_Private_Peripherals_Max_Addr : constant Integer_Address := 16#E00FFFFF#;

   -- ** --

   generic
      Mcu_Peripheral_Bridge_Min_Addr : Integer_Address;
      Mcu_Peripheral_Bridge_Max_Addr : Integer_Address;
      Mcu_Flash_Base_Addr : Integer_Address;
      Mcu_Flash_Size : Unsigned_32;
      Mcu_Sram_Base_Addr : Integer_Address;
      Mcu_Sram_Size : Unsigned_32;
   package Generic_Memory_Map is

      ------------------------
      -- Valid_MMIO_Address --
      ------------------------

      function Valid_MMIO_Address
        (Address_Value : Address)
         return Boolean
      is (To_Integer (Address_Value) in
            Mcu_Peripheral_Bridge_Min_Addr .. Mcu_Peripheral_Bridge_Max_Addr
          or else
          To_Integer (Address_Value) in
            Mcu_Private_Peripherals_Min_Addr .. Mcu_Private_Peripherals_Max_Addr);

      -------------------------
      -- Valid_Flash_Address --
      -------------------------

      function Valid_Flash_Address
        (Address_Value : Address)
         return Boolean
      is (To_Integer (Address_Value) in Mcu_Flash_Base_Addr + Integer_Address (1) ..
          Mcu_Flash_Base_Addr + Integer_Address (Mcu_Flash_Size - 1));

      -----------------------
      -- Valid_RAM_Address --
      -----------------------

      function Valid_RAM_Address
        (Address_Value : Address)
         return Boolean
      is (To_Integer (Address_Value) in Mcu_SRAM_Base_Addr ..
          Mcu_SRAM_Base_Addr + Integer_Address (Mcu_SRAM_Size - 1));

      -----------------------
      -- Valid_RAM_Pointer --
      -----------------------

      function Valid_RAM_Pointer
        (Address_Value : Address;
         Alignment : Positive)
         return Boolean
      is (Valid_RAM_Address (Address_Value) and then
          To_Integer (Address_Value) mod Integer_Address (Alignment) = 0);
      --
      --  Check that an address is a valid RAM pointer and has the given
      --  alignment to be used a valid pointer
      --
   end Generic_Memory_Map;
end Microcontroller;
