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
with Microcontroller.Arch_Specific;
with Number_Conversion_Utils;
with Runtime_Logs;
with MK64F12;
with Memory_Utils;
with Memory_Protection;
with System.Address_To_Access_Conversions;

package body Nor_Flash_Driver is
   pragma SPARK_Mode (Off);
   use Devices.MCU_Specific;
   use Microcontroller.Arch_Specific;
   use Number_Conversion_Utils;
   use Memory_Utils;
   use Memory_Protection;

   package Address_To_NOR_Flash_Registers_Pointer is new
      System.Address_To_Access_Conversions (NOR.FTFE_Peripheral);

   use Address_To_NOR_Flash_Registers_Pointer;

   --
   --  NOR Flash programming acceleration 4KB buffer address
   --
   Programming_Acceleration_Buffer_Address : constant System.Address :=
     To_Address (16#14000000#);

   Word_Size : constant := Unsigned_32'Size / Unsigned_8'Size;

   --
   --  Record type for the constant portion of the NOR flash object
   --
   --  @field Registers_Ptr Pointer to the NOR flash registers
   --
   type Nor_Flash_Const_Type is limited record
      Registers_Ptr : not null access NOR.FTFE_Peripheral;
   end record;

   --
   --  NOR flash device constant object (placed in flash)
   --
   Nor_Flash_Const : constant Nor_Flash_Const_Type :=
      (Registers_Ptr => NOR.FTFE_Periph'Access);

   type Nor_Flash_Var_Type is limited record
      Initialized : Boolean := False;
   end record;

   Nor_Flash_Var : Nor_Flash_Var_Type;

   type Nor_Flash_Commands is (Cmd_Erase_Sector,
                               Cmd_Program_Section);

   for Nor_Flash_Commands use (Cmd_Erase_Sector => 16#09#,
                               Cmd_Program_Section => 16#0b#);

   function Erase_Sector (Sector_Address : System.Address) return Boolean;
   --
   --  Erase the given sector of NOR flash
   --

   function Execute_Nor_Flash_Command return Boolean
      with Linker_Section => ".ram_text";
   --
   --  Execute NOR flash command currently loaded in the FCCOBx registers.
   --
   --  It launches the NOR flash command and waits for its completion
   --
   --  NOTE: To prevent a read from NOR flash while a NOR flash command is
   --  being executed, we need to make sure that the polling loop to wait for
   --  command completion runs from RAM instead of flash, to avoid
   --  instruction fetches from flash. Also, we disable interrupts to
   --  ensure that the polling loop is not preempted by any other code
   --  as that may cause instruction fetches from flash.
   --
   --  @return True, on success
   --  @return False, on failure
   --

   function Write_Section (Dest_Address : System.Address;
                           Src_Address : System.Address;
                           Section_Size : Unsigned_32) return Boolean;
   --
   --  Programs a section of NOR flash
   --

   ------------------
   -- Erase_Sector --
   ------------------

   function Erase_Sector (Sector_Address : System.Address) return Boolean
   is
      use NOR;
      FSTAT_Value : FTFE_FSTAT_Register;
      Sector_Addr_Value : constant Unsigned_32 :=
         Unsigned_32 (To_Integer (Sector_Address));
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      pragma Assert (Sector_Addr_Value < 16#01000000#);

      --
      --  Clear error flags (w1c) from previous command, if any:
      --
      FSTAT_Value := Nor_Flash_Const.Registers_Ptr.FSTAT;
      pragma Assert (FSTAT_Value.CCIF = FSTAT_CCIF_Field_1);

      Set_Private_Data_Region (
         To_Address (Object_Pointer (Nor_Flash_Const.Registers_Ptr)),
         NOR.FTFE_Peripheral'Object_Size,
         Read_Write,
         Old_Region);

      if FSTAT_Value.ACCERR = FSTAT_ACCERR_Field_1 or else
         FSTAT_Value.FPVIOL = FSTAT_FPVIOL_Field_1
      then
         Nor_Flash_Const.Registers_Ptr.FSTAT :=
            (ACCERR => FSTAT_ACCERR_Field_1,
             FPVIOL => FSTAT_FPVIOL_Field_1,
             others => <>);
      end if;

      --
      --  Populate NOR flash command registers:
      --
      Nor_Flash_Const.Registers_Ptr.FCCOB.FCCOB0 := Cmd_Erase_Sector'Enum_Rep;
      Nor_Flash_Const.Registers_Ptr.FCCOB.FCCOB1 :=
         Unsigned_8 (Shift_Right (Sector_Addr_Value, 16) and 16#ff#);
      Nor_Flash_Const.Registers_Ptr.FCCOB.FCCOB2 :=
         Unsigned_8 (Shift_Right (Sector_Addr_Value, 8) and 16#ff#);
      Nor_Flash_Const.Registers_Ptr.FCCOB.FCCOB3 :=
         Unsigned_8 (Sector_Addr_Value and 16#ff#);

      Restore_Private_Data_Region (Old_Region);
      return Execute_Nor_Flash_Command;
   end Erase_Sector;

   -------------------------------
   -- Execute_Nor_Flash_Command --
   -------------------------------

   function Execute_Nor_Flash_Command return Boolean
   is
      use NOR;
      use MK64F12;
      Int_Mask : Unsigned_32;
      FSTAT_Value : FTFE_FSTAT_Register;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Int_Mask := Disable_Cpu_Interrupts;
      Set_Private_Data_Region (
         To_Address (Object_Pointer (Nor_Flash_Const.Registers_Ptr)),
         NOR.FTFE_Peripheral'Object_Size,
         Read_Write,
         Old_Region);

      --
      --  Launch the command by clearing FSTAT register's CCIF bit (w1c):
      --
      Nor_Flash_Const.Registers_Ptr.FSTAT := (CCIF => FSTAT_CCIF_Field_1,
                                              others => <>);

      loop
         FSTAT_Value := Nor_Flash_Const.Registers_Ptr.FSTAT;
         exit when FSTAT_Value.CCIF /= NOR.FSTAT_CCIF_Field_0;
      end loop;

      Restore_Private_Data_Region (Old_Region);
      Restore_Cpu_Interrupts (Int_Mask);
      if FSTAT_Value.ACCERR = FSTAT_ACCERR_Field_1 or else
         FSTAT_Value.FPVIOL = FSTAT_FPVIOL_Field_1 or else
         FSTAT_Value.MGSTAT0 = 1
      then
         Runtime_Logs.Error_Print ("NOR flash command failed");
         return False;
      end if;

      return True;
   end Execute_Nor_Flash_Command;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Nor_Flash_Var'Address,
                               Nor_Flash_Var'Size,
                               Read_Write,
                               Old_Region);

      Nor_Flash_Var.Initialized := True;
      Restore_Private_Data_Region (Old_Region);
   end Initialize;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean is
      (Nor_Flash_Var.Initialized);

   -----------
   -- Write --
   -----------

   function Write (Dest_Addr : Address;
                   Src_Addr : Address;
                   Src_Size : Unsigned_32) return Boolean
   is
      Dest_Addr_Value : constant Integer_Address := To_Integer (Dest_Addr);
      Sector_Addr_Value : Integer_Address := Dest_Addr_Value;
      Num_Sectors : constant Unsigned_32 :=
         How_Many (Src_Size, Nor_Flash_Sector_Size);
      Highest_Code_Addr_Value : constant Integer_Address :=
         Mcu_Flash_Base_Addr + Integer_Address (Get_Flash_Used);
      Erase_Ok : Boolean;
      Write_Ok : Boolean;
      Hex_Num_Str : String (1 .. 8);
   begin
      pragma Assert (Memory_Map.Valid_Flash_Address (Dest_Addr));
      pragma Assert (Dest_Addr_Value mod Nor_Flash_Sector_Size = 0);
      pragma Assert (
         Memory_Map.Valid_RAM_Pointer (Src_Addr,
                                       Unsigned_32'Size / Unsigned_8'Size));
      pragma Assert (Src_Size /= 0 and
                     Src_Size mod (Unsigned_32'Size / Unsigned_8'Size) = 0);

      if Dest_Addr_Value <= Highest_Code_Addr_Value then
         --
         --  Destination address overlaps with code
         --
         Unsigned_To_Hexadecimal_String (Unsigned_32 (Dest_Addr_Value),
                                         Hex_Num_Str);
         Runtime_Logs.Error_Print (
            "NOR flash cannot be written at given address: " & Hex_Num_Str);

         return False;
      end if;

      --
      --  Erase sectors to be written:
      --
      for I in 1 .. Num_Sectors loop
         Erase_Ok := Erase_Sector (To_Address (Sector_Addr_Value));
         if not Erase_Ok then
            return False;
         end if;

         Sector_Addr_Value := Sector_Addr_Value + Nor_Flash_Sector_Size;
      end loop;

      --
      --  Write data to NOR flash:
      --
      Write_Ok := Write_Section (Dest_Addr, Src_Addr, Src_Size);
      if not Write_Ok then
         return False;
      end if;

      return True;
   end Write;

   -------------------
   -- Write_Section --
   -------------------

   function Write_Section (Dest_Address : System.Address;
                           Src_Address : System.Address;
                           Section_Size : Unsigned_32) return Boolean
   is
      use NOR;
      Num_128bit_Chunks : constant Unsigned_16 :=
         Unsigned_16 (How_Many (Section_Size, 16));
      Num_Words : constant Unsigned_32 := Section_Size / Word_Size;
      Src_Words :
         Devices.Words_Array_Type (1 .. Positive (Num_Words)) with
             Address => Src_Address;
      Dest_Words :
         Devices.Words_Array_Type (1 .. Positive (Num_Words)) with
            Address => Programming_Acceleration_Buffer_Address;
      FSTAT_Value : FTFE_FSTAT_Register;
      Dest_Addr_Value : constant Unsigned_32 :=
         Unsigned_32 (To_Integer (Dest_Address));
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (
         Dest_Words'Address,
         Dest_Words'Size,
         Read_Write,
         Old_Region);

      --
      --  Copy source section to the NOR flash programming acceleration buffer:
      --
      Dest_Words := Src_Words;

      Set_Private_Data_Region (
         To_Address (Object_Pointer (Nor_Flash_Const.Registers_Ptr)),
         NOR.FTFE_Peripheral'Object_Size,
         Read_Write);

      --
      --  Clear error flags (w1c) from previous command, if any:
      --
      FSTAT_Value := Nor_Flash_Const.Registers_Ptr.FSTAT;
      pragma Assert (FSTAT_Value.CCIF = FSTAT_CCIF_Field_1);
      if FSTAT_Value.ACCERR = FSTAT_ACCERR_Field_1 or else
         FSTAT_Value.FPVIOL = FSTAT_FPVIOL_Field_1
      then
         Nor_Flash_Const.Registers_Ptr.FSTAT :=
            (ACCERR => FSTAT_ACCERR_Field_1,
             FPVIOL => FSTAT_FPVIOL_Field_1,
             others => <>);
      end if;

      --
      --  Populate NOR flash command registers:
      --
      Nor_Flash_Const.Registers_Ptr.FCCOB.FCCOB0 :=
         Cmd_Program_Section'Enum_Rep;
      Nor_Flash_Const.Registers_Ptr.FCCOB.FCCOB1 :=
         Unsigned_8 (Shift_Right (Dest_Addr_Value, 16) and 16#ff#);
      Nor_Flash_Const.Registers_Ptr.FCCOB.FCCOB2 :=
         Unsigned_8 (Shift_Right (Dest_Addr_Value, 8) and 16#ff#);
      Nor_Flash_Const.Registers_Ptr.FCCOB.FCCOB3 :=
         Unsigned_8 (Dest_Addr_Value and 16#ff#);
      Nor_Flash_Const.Registers_Ptr.FCCOB.FCCOB4 :=
         Unsigned_8 (Shift_Right (Num_128bit_Chunks, 8) and 16#ff#);
      Nor_Flash_Const.Registers_Ptr.FCCOB.FCCOB5 :=
         Unsigned_8 (Num_128bit_Chunks and 16#ff#);

      Restore_Private_Data_Region (Old_Region);
      return Execute_Nor_Flash_Command;
   end Write_Section;

end Nor_Flash_Driver;
