--
--  Copyright (c) 2017, German Rivera
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

with Memory_Protection;
with Interfaces.Bit_Types;
with Serial_Console;
with Devices;
with System.Storage_Elements;
with System.Address_To_Access_Conversions;

package body MPU_Tests is
   pragma SPARK_Mode (Off);
   use Memory_Protection;
   use Interfaces.Bit_Types;
   use Interfaces;
   use Devices;
   use System.Storage_Elements;

   package Address_To_Unsigned_32_Pointer is new
      System.Address_To_Access_Conversions (Unsigned_32);

   use Address_To_Unsigned_32_Pointer;

   type My_Global_Data_Type is record
      Value : Unsigned_32 := 0;
      Public_RAM_Code_Executed : Boolean := False;
      Buffer : Bytes_Array_Type (1 .. 53);
   end record with Alignment => MPU_Region_Alignment,
                   Size => 2 * MPU_Region_Alignment * Byte'Size;

   type My_Secret_Data_Type is record
      Secret_Value : Unsigned_32 := 0;
      Secret_Flash_Code_Executed : Boolean := False;
      Secret_RAM_Code_Executed : Boolean := False;
   end record with Alignment => MPU_Region_Alignment,
                   Size => MPU_Region_Alignment * Byte'Size;

   My_Global_Data : My_Global_Data_Type;

   My_Secret_Data : My_Secret_Data_Type with Linker_Section => ".secret_data";

   procedure My_Public_RAM_Code with Linker_Section => ".ram_text";

   procedure My_Secret_Flash_Code with Linker_Section => ".secret_flash_text";

   procedure My_Secret_RAM_Code with Linker_Section => ".secret_ram_text";

   ------------------------
   -- My_Public_RAM_Code --
   ------------------------

   procedure My_Public_RAM_Code is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      pragma Assert (not My_Global_Data.Public_RAM_Code_Executed);
      Set_Private_Object_Data_Region (My_Global_Data'Address,
                                      My_Global_Data'Size,
                                      Read_Write,
                                      Old_Region);

      My_Global_Data.Public_RAM_Code_Executed := True;

      Restore_Private_Object_Data_Region (Old_Region);
   end My_Public_RAM_Code;

   --------------------------
   -- My_Secret_Flash_Code --
   --------------------------

   procedure My_Secret_Flash_Code is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Object_Data_Region (My_Secret_Data'Address,
                                      My_Secret_Data'Size,
                                      Read_Write,
                                      Old_Region);

      pragma Assert (not My_Secret_Data.Secret_Flash_Code_Executed);
      My_Secret_Data.Secret_Flash_Code_Executed := True;

      Restore_Private_Object_Data_Region (Old_Region);
   end My_Secret_Flash_Code;

   ------------------------
   -- My_Secret_RAM_Code --
   ------------------------

   procedure My_Secret_RAM_Code is
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Object_Data_Region (My_Secret_Data'Address,
                                      My_Secret_Data'Size,
                                      Read_Write,
                                      Old_Region);

      pragma Assert (not My_Secret_Data.Secret_RAM_Code_Executed);
      My_Secret_Data.Secret_RAM_Code_Executed := True;

      Restore_Private_Object_Data_Region (Old_Region);
   end My_Secret_RAM_Code;

   -------------------------------------------------
   -- Test_Forbidden_Execute_To_Secret_Flash_Code --
   --------------------------------------------------

   procedure Test_Forbidden_Execute_To_Secret_Flash_Code is
   begin
      pragma Assert (To_Integer (My_Secret_Flash_Code'Address) >=
                       To_Integer (Secret_Flash_Text_Start'Address)
                     and
                     To_Integer (My_Secret_Flash_Code'Address) <
                       To_Integer (Secret_Flash_Text_End'Address));

      My_Secret_Flash_Code;
      pragma Assert (False);
   end Test_Forbidden_Execute_To_Secret_Flash_Code;

   -----------------------------------------------
   -- Test_Forbidden_Execute_To_Secret_RAM_Code --
   -----------------------------------------------

   procedure Test_Forbidden_Execute_To_Secret_RAM_Code is
   begin
      pragma Assert (To_Integer (My_Secret_RAM_Code'Address) >=
                       To_Integer (Secret_RAM_Text_Start'Address)
                     and
                     To_Integer (My_Secret_RAM_Code'Address) <
                       To_Integer (Secret_RAM_Text_End'Address));

      My_Secret_RAM_Code;
      pragma Assert (False);
   end Test_Forbidden_Execute_To_Secret_RAM_Code;

   ----------------------------------------
   -- Test_Forbidden_Read_To_Secret_Data --
   ----------------------------------------

   procedure Test_Forbidden_Read_To_Secret_Data is
   begin
      pragma Assert (My_Secret_Data.Secret_Value = 0);
   end Test_Forbidden_Read_To_Secret_Data;

   -----------------------------------------
   -- Test_Forbidden_Write_To_Global_Data --
   -----------------------------------------

   procedure Test_Forbidden_Write_To_Global_Data is
   begin
      My_Global_Data.Value := 88;

      pragma Assert (False);
   end Test_Forbidden_Write_To_Global_Data;

   -----------------------------------------
   -- Test_Forbidden_Write_To_Secret_Data --
   -----------------------------------------

   procedure Test_Forbidden_Write_To_Secret_Data is
   begin
      My_Secret_Data.Secret_Value := 67;

      pragma Assert (False);
   end Test_Forbidden_Write_To_Secret_Data;

   -------------------------
   -- Test_Stack_Overrun --
   -------------------------

   procedure Test_Stack_Overrun is
      Stack_Var : Unsigned_32;
      Stack_Var_Address : System.Address := Stack_Var'Address;
   begin
      loop
         declare
            Stack_Entry : Unsigned_32 with Address => Stack_Var_Address;
         begin
            Stack_Entry := 0;
            Stack_Var_Address :=
               To_Address (
                  To_Integer (Stack_Var_Address) -
                  (Unsigned_32'Size / Byte'Size));
         end;
      end loop;

      pragma Assert (False);
   end Test_Stack_Overrun;

   -------------------------
   -- Test_Valid_Accesses --
   -------------------------

   procedure Test_Valid_Accesses is
      Old_Region : MPU_Region_Descriptor_Type;
      Old_Code_Region : MPU_Region_Descriptor_Type;
   begin
      --
      --  Test valid read from global data:
      --
      pragma Assert (My_Global_Data.Value = 0);

      --
      --  Test valid write to global data:
      --
      pragma Assert (Size_Is_MPU_Region_Aligned (My_Global_Data'Size));
      Set_Private_Object_Data_Region (My_Global_Data'Address,
                                      My_Global_Data'Size,
                                      Read_Write,
                                      Old_Region);
      My_Global_Data.Value := 88;
      pragma Assert (My_Global_Data.Value = 88);
      My_Global_Data.Value := 0;

      --
      --  Test valid execute to public RAM code:
      --
      pragma Assert (To_Integer (My_Public_RAM_Code'Address) >=
                       To_Integer (RAM_Text_Start'Address)
                     and
                     To_Integer (My_Public_RAM_Code'Address) <
                       To_Integer (RAM_Text_End'Address));
      My_Public_RAM_Code;
      pragma Assert (My_Global_Data.Public_RAM_Code_Executed);
      My_Global_Data.Public_RAM_Code_Executed := False;

      --
      --  Test valid read to secret data:
      --
      Set_Private_Object_Data_Region (My_Secret_Data'Address,
                                      My_Secret_Data'Size,
                                      Read_Only);
      pragma Assert (My_Secret_Data.Secret_Value = 0);

      --
      --  Test valid write to secret data:
      --
      Set_Private_Object_Data_Region (My_Secret_Data'Address,
                                      My_Secret_Data'Size,
                                      Read_Write);
      My_Secret_Data.Secret_Value := 67;
      pragma Assert (My_Secret_Data.Secret_Value = 67);
      My_Secret_Data.Secret_Value := 0;

      --
      --  Test valid execute to secret flash code:
      --
      Set_Private_Code_Region (Secret_Flash_Text_Start'Address,
                               Secret_Flash_Text_End'Address,
                               Old_Code_Region);
      My_Secret_Flash_Code;
      pragma Assert (My_Secret_Data.Secret_Flash_Code_Executed);
      My_Secret_Data.Secret_Flash_Code_Executed := False;

      --
      --  Test valid execute to secret RAM code:
      --
      Set_Private_Code_Region (Secret_RAM_Text_Start'Address,
                               Secret_RAM_Text_End'Address);
      My_Secret_RAM_Code;
      pragma Assert (My_Secret_Data.Secret_RAM_Code_Executed);
      My_Secret_Data.Secret_RAM_Code_Executed := False;

      Restore_Private_Code_Region (Old_Code_Region);
      Restore_Private_Object_Data_Region (Old_Region);
      Serial_Console.Print_String ("*** test passed ***" & ASCII.LF);
   end Test_Valid_Accesses;

end MPU_Tests;
