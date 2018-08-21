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

with System.Storage_Elements;
with Interfaces.Bit_Types;
private with ARMv7M_MPU;

--
--  @summary Memory Protection Services
--
package Memory_Protection is
   use System.Storage_Elements;
   use System;
   use Interfaces.Bit_Types;
   use Interfaces;

   --
   --  MPU region alignment (in bytes)
   --
   MPU_Region_Alignment : constant := 32;

   --
   --  MPU regions assignment
   --
   type MPU_Region_Id_Type is (
      Global_Background_Data_Region,
      Global_Flash_Code_Region,
      Global_RAM_Code_Region,
      Global_Interrupt_Stack_Region,
      Thread_Stack_Data_Region,
      Private_Data_Region,
      Private_Code_Region);

   for MPU_Region_Id_Type use (Global_Background_Data_Region => 0,
                               Global_Flash_Code_Region => 1,
                               Global_RAM_Code_Region => 2,
                               Global_Interrupt_Stack_Region => 3,
                               Thread_Stack_Data_Region => 4,
                               Private_Data_Region => 5,
                               Private_Code_Region => 6);

   --
   --  Saved MPU region descriptor
   --
   type MPU_Region_Descriptor_Type is private;

   --
   --  Thread-private MPU regions
   --
   --  @field Stack_Region MPU region for the thread's stack
   --  @field Object_Data_Region MPU region for current provate object data
   --  region for the thread.
   --  @field Code_Region MPU region for the current private code region
   --  for the thread.
   --  @field Writable_Background_Region_Enabled Flag indicating if the
   --  background region is currently writable for the thread (true) or
   --  read-only (false).
   --
   type Thread_Regions_Type is limited record
      Stack_Region : MPU_Region_Descriptor_Type;
      Private_Data_Region : MPU_Region_Descriptor_Type;
      Private_Code_Region : MPU_Region_Descriptor_Type;
      Writable_Background_Region_Enabled : Boolean := False;
   end record;

   type Thread_Regions_Access_Type is access all Thread_Regions_Type;

   type Data_Permissions_Type is (None,
                                  Read_Only,
                                  Read_Write);

   procedure Initialize;
   --
   --  Initializes memory protection unit
   --

   -------------------------------------------------------------
   --  Subprograms to be invoked only from RTOS task support  --
   -------------------------------------------------------------

   procedure Restore_Thread_MPU_Regions (
      Thread_Regions : Thread_Regions_Type);
   --
   --  NOTE: This subporgram is tobe invoked only from the Ada runtime's
   --  context switch code and with the background region enabled
   --

   procedure Save_Thread_MPU_Regions (
      Thread_Regions : out Thread_Regions_Type);
   --
   --  NOTE: This subporgram is to be invoked only from the Ada runtime's
   --  context switch code and with the background region enabled
   --

   procedure Set_CPU_Writable_Background_Region (Enabled : Boolean);
   --  with Inline;

   procedure Set_CPU_Writable_Background_Region (Enabled : Boolean;
                                                 Old_Enabled : out Boolean);
   --  with Inline;

   procedure Disable_MPU;

   function Is_MPU_Enabled return Boolean;

   ---------------------------------------------------------
   --  Public interfaces to be invoked from applications  --
   ---------------------------------------------------------

   procedure Enable_MPU;
   --
   --  Enable MPU to enforce memory protection
   --
   --  NOTE: Set Enable_Precise_Write_Faults may degrade performance.
   --  It should be used only for debugging faults.
   --
   --  This subprogram should be invoked at the beginning of the main program
   --

   procedure Initialize_Private_Data_Region (
         Region : out MPU_Region_Descriptor_Type;
         First_Address : System.Address;
         Last_Address : System.Address;
         Permissions : Data_Permissions_Type)
         with Pre => First_Address /= Null_Address and
                     Last_Address /= Null_Address  and
                     To_Integer (First_Address) < To_Integer (Last_Address) and
                     Permissions /= None;

   procedure Initialize_Private_Data_Region (
      Region : out MPU_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bits : Integer_Address;
      Permissions : Data_Permissions_Type)
      with Pre => Start_Address /= Null_Address and
                  Size_In_Bits > 0 and
                  Size_In_Bits mod Byte'Size = 0 and
                  Permissions /= None;

   procedure Initialize_Private_Code_Region (
      Region : out MPU_Region_Descriptor_Type;
      First_Address : System.Address;
      Last_Address : System.Address)
      with Pre => First_Address /= Null_Address and
                  Last_Address /= Null_Address  and
                  To_Integer (First_Address) < To_Integer (Last_Address);

   procedure Restore_Private_Code_Region (
      Saved_Region : MPU_Region_Descriptor_Type);
      --  with Inline;

   procedure Restore_Private_Data_Region (
      Saved_Region : MPU_Region_Descriptor_Type);
      --  with Inline;

   --  Linker script symbol for the start address of the global RAM
   --  text region
   RAM_Text_Start : constant Unsigned_32;
   pragma Import (Asm, RAM_Text_Start, "__ram_text_start");

   --  Linker script symbol for the end address of the global RAM text
   --  region
   RAM_Text_End : constant Unsigned_32;
   pragma Import (Asm, RAM_Text_End, "__ram_text_end");

   --  Linker script symbol for the start address of the secret flash
   --  text region
   Secret_Flash_Text_Start : constant Unsigned_32;
   pragma Import (Asm, Secret_Flash_Text_Start, "__secret_flash_text_start");

   --  Linker script symbol for the end address of the secret flash text
   --  region
   Secret_Flash_Text_End : constant Unsigned_32;
   pragma Import (Asm, Secret_Flash_Text_End, "__secret_flash_text_end");

   --  Linker script symbol for the start address of the sectet RAM
   --  text region
   Secret_RAM_Text_Start : constant Unsigned_32;
   pragma Import (Asm, Secret_RAM_Text_Start, "__secret_ram_text_start");

   --  Linker script symbol for the end address of the secret RAM text
   --  region
   Secret_RAM_Text_End : constant Unsigned_32;
   pragma Import (Asm, Secret_RAM_Text_End, "__secret_ram_text_end");

   procedure Set_Private_Code_Region (
      First_Address : System.Address;
      Last_Address : System.Address)
      with Pre => To_Integer (First_Address) < To_Integer (Last_Address) and
                  ((To_Integer (First_Address) >=
                      To_Integer (Secret_Flash_Text_Start'Address) and
                    To_Integer (Last_Address) <
                      To_Integer (Secret_Flash_Text_End'Address)) or else
                   (To_Integer (First_Address) >=
                      To_Integer (Secret_RAM_Text_Start'Address)
                    and
                    To_Integer (Last_Address) <
                      To_Integer (Secret_RAM_Text_End'Address)));
      --  with Inline;

   procedure Set_Private_Code_Region (
      First_Address : System.Address;
      Last_Address : System.Address;
      Old_Region : out MPU_Region_Descriptor_Type)
      with Pre => To_Integer (First_Address) < To_Integer (Last_Address) and
                  ((To_Integer (First_Address) >=
                      To_Integer (Secret_Flash_Text_Start'Address) and
                    To_Integer (Last_Address) <
                      To_Integer (Secret_Flash_Text_End'Address)) or else
                   (To_Integer (First_Address) >=
                      To_Integer (Secret_RAM_Text_Start'Address)
                    and
                    To_Integer (Last_Address) <
                      To_Integer (Secret_RAM_Text_End'Address)));
      --  with Inline;

   procedure Set_Private_Code_Region (
      New_Region : MPU_Region_Descriptor_Type;
      Old_Region : out MPU_Region_Descriptor_Type);

   procedure Unset_Private_Code_Region;

   procedure Set_Private_Data_Region (
      Start_Address : System.Address;
      Size_In_Bits : Integer_Address;
      Permissions : Data_Permissions_Type)
      with Pre => Start_Address /= Null_Address and
                  Size_In_Bits > 0 and
                  Size_In_Bits mod Byte'Size = 0 and
                  Permissions /= None;
      --  with Inline;

   procedure Set_Private_Data_Region (
      Start_Address : System.Address;
      Size_In_Bits : Integer_Address;
      Permissions : Data_Permissions_Type;
      Old_Region : out MPU_Region_Descriptor_Type)
      with Pre => Start_Address /= Null_Address and
                  Size_In_Bits > 0 and
                  Size_In_Bits mod Byte'Size = 0 and
                  Permissions /= None;
      --  with Inline;

   procedure Set_Private_Data_Region (
      New_Region : MPU_Region_Descriptor_Type;
      Old_Region : out MPU_Region_Descriptor_Type);

   procedure UnSet_Private_Data_Region;

   function Last_Address (First_Address : System.Address;
                          Size_In_Bits : Integer_Address) return System.Address
   is (To_Address (To_Integer (First_Address) +
                   (Size_In_Bits / Interfaces.Bit_Types.Byte'Size) - 1))
   with Inline;

   procedure Dump_MPU_Region_Descriptors;

   function Size_Is_MPU_Region_Aligned (Size_In_Bits : Integer_Address)
      return Boolean
   is ((Size_In_Bits / Byte'Size) mod MPU_Region_Alignment = 0);

private
   use ARMv7M_MPU;

   --
   --  Saved MPU region descriptor
   --
   type MPU_Region_Descriptor_Type is record
      RBAR_Value : MPU_RBAR_Register_Type;
      RASR_Value : MPU_RASR_Register_Type;
   end record;

end Memory_Protection;
