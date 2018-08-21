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

with System.Machine_Code;
with System.Address_To_Access_Conversions;

package body Memory_Protection is
   use Machine_Code;

   --
   --  Flag to enable/disable at compile time the support for secret areas.
   --  If secret areas support is disabled, the global background region covers
   --  the entire address space. If secret areas support is enabled, the global
   --  background region excludes the secret data and code areas.
   --  In both cases the global background region has read-only permissions
   --  by default.
   --
   Secret_Areas_Enabled : constant Boolean := True;

   Debug_MPU_Enabled : constant Boolean := False;

   --
   --  Memory protection state
   --
   type Memory_Protection_Type is record
      Initialized : Boolean := False;
      MPU_Enabled : Boolean := False;
      Return_From_Fault_Enabled : Boolean := False;
      Fault_Happened_Flag : Boolean := False;
      Num_Regions : Natural := 0;
   end record;

   Memory_Protection_Var : Memory_Protection_Type;

   --
   --  Linker-script symbols defined in
   --  embedded-runtimes/bsps/kinetis_KL28Z_common/bsp/common-ROM.ld
   --

   --  Start address of the normal text section in flash
   --??? Flash_Text_Start : constant Unsigned_32;
   --??? pragma Import (Asm, Flash_Text_Start, "__flash_text_start");

   --  End address of the text section in flash
   --  Flash_Text_End : constant Unsigned_32;
   --  pragma Import (Asm, Flash_Text_End, "__flash_text_end");

   --  End address of the rodata section in flash
   --??? Rom_End : constant Unsigned_32;
   --??? pragma Import (Asm, Rom_End, "__rom_end");

   --  Linker script symbol for the start address of the global background
   --  data region. The global background data area spans to the end of the
   --  physical address space;
   --??? Global_Background_Data_Region_Start : constant Unsigned_32;
   --??? pragma Import (Asm, Global_Background_Data_Region_Start,
   --???                "__background_data_region_start");

   --  Start address of the stack for ISRs
   --??? Interrupt_Stack_Start : constant Unsigned_32;
   --??? pragma Import (Asm, Interrupt_Stack_Start, "__interrupt_stack_start");

   --  End address of the stack for ISRs
   --??? Interrupt_Stack_End : constant Unsigned_32;
   --??? pragma Import (Asm, Interrupt_Stack_End, "__interrupt_stack_end");

   -----------------
   -- Disable_MPU --
   -----------------

   procedure Disable_MPU is
   begin
      null; --???
   end Disable_MPU;

   ---------------------------------
   -- Dump_MPU_Region_Descriptors --
   ---------------------------------

   procedure Dump_MPU_Region_Descriptors is
   begin
      null; --???
   end Dump_MPU_Region_Descriptors;

   ----------------
   -- Enable_MPU --
   ----------------

   procedure Enable_MPU is
   begin
      null; --???
   end Enable_MPU;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      null; --???
   end Initialize;

   ------------------------------------
   -- Initialize_Private_Data_Region --
   ------------------------------------

   procedure Initialize_Private_Data_Region (
      Region : out MPU_Region_Descriptor_Type;
      First_Address : System.Address;
      Last_Address : System.Address;
      Permissions : Data_Permissions_Type)
   is
   begin
      null; --???
   end Initialize_Private_Data_Region;

   ------------------------------------
   -- Initialize_Private_Data_Region --
   ------------------------------------

   procedure Initialize_Private_Data_Region (
      Region : out MPU_Region_Descriptor_Type;
      Start_Address : System.Address;
      Size_In_Bits : Integer_Address;
      Permissions : Data_Permissions_Type)
   is
      Last_Address : constant System.Address :=
         Memory_Protection.Last_Address (Start_Address, Size_In_Bits);
   begin
      Initialize_Private_Data_Region (Region,
                                      Start_Address,
                                      Last_Address,
                                      Permissions);
   end Initialize_Private_Data_Region;

   ------------------------------------
   -- Initialize_Private_Code_Region --
   ------------------------------------

   procedure Initialize_Private_Code_Region (
      Region : out MPU_Region_Descriptor_Type;
      First_Address : System.Address;
      Last_Address : System.Address)
   is
   begin
      null; --???
   end Initialize_Private_Code_Region;

   --------------------
   -- Is_MPU_Enabled --
   --------------------

   function Is_MPU_Enabled return Boolean is
      (Memory_Protection_Var.MPU_Enabled);

   ---------------------------------
   -- Restore_Private_Code_Region --
   ---------------------------------

   procedure Restore_Private_Code_Region (
      Saved_Region : MPU_Region_Descriptor_Type)
   is
   begin
      null; --???
   end Restore_Private_Code_Region;

   ---------------------------------
   -- Restore_Private_Data_Region --
   ---------------------------------

   procedure Restore_Private_Data_Region (
      Saved_Region : MPU_Region_Descriptor_Type)
   is
   begin
      null; --???
   end Restore_Private_Data_Region;

   --------------------------------
   -- Restore_Thread_MPU_Regions --
   --------------------------------

   procedure Restore_Thread_MPU_Regions (Thread_Regions : Thread_Regions_Type)
   is
   begin
      null; --???
   end Restore_Thread_MPU_Regions;

   -----------------------------
   -- Save_Thread_MPU_Regions --
   -----------------------------

   procedure Save_Thread_MPU_Regions (Thread_Regions : out Thread_Regions_Type)
   is
   begin
      null; --???
   end Save_Thread_MPU_Regions;

   ----------------------------------------
   -- Set_CPU_Writable_Background_Region --
   ----------------------------------------

   procedure Set_CPU_Writable_Background_Region (Enabled : Boolean)
   is
      Old_Enabled : Boolean with Unreferenced;
   begin
      Set_CPU_Writable_Background_Region (Enabled, Old_Enabled);
   end Set_CPU_Writable_Background_Region;

   ----------------------------------------
   -- Set_CPU_Writable_Background_Region --
   ----------------------------------------

   procedure Set_CPU_Writable_Background_Region (Enabled : Boolean;
                                                 Old_Enabled : out Boolean)
   is
   begin
      Old_Enabled := False; --???
   end Set_CPU_Writable_Background_Region;

   -----------------------------
   -- Set_Private_Code_Region --
   -----------------------------

   procedure Set_Private_Code_Region (
      First_Address : System.Address;
      Last_Address : System.Address)
   is
   begin
      null; --???
   end Set_Private_Code_Region;

   -----------------------------
   -- Set_Private_Code_Region --
   -----------------------------

   procedure Set_Private_Code_Region (
      First_Address : System.Address;
      Last_Address : System.Address;
      Old_Region : out MPU_Region_Descriptor_Type)
   is
   begin
      null; --???
   end Set_Private_Code_Region;

   -----------------------------
   -- Set_Private_Code_Region --
   -----------------------------

   procedure Set_Private_Code_Region (
      New_Region : MPU_Region_Descriptor_Type;
      Old_Region : out MPU_Region_Descriptor_Type)
   is
   begin
      null; --???
   end Set_Private_Code_Region;

   -----------------------------
   -- Set_Private_Data_Region --
   -----------------------------

   procedure Set_Private_Data_Region (
      Start_Address : System.Address;
      Size_In_Bits : Integer_Address;
      Permissions : Data_Permissions_Type)
   is
   begin
      null; --???
   end Set_Private_Data_Region;

   -----------------------------
   -- Set_Private_Data_Region --
   -----------------------------

   procedure Set_Private_Data_Region (
      Start_Address : System.Address;
      Size_In_Bits : Integer_Address;
      Permissions : Data_Permissions_Type;
      Old_Region : out MPU_Region_Descriptor_Type)
   is
   begin
      null; --???
   end Set_Private_Data_Region;

   -----------------------------
   -- Set_Private_Data_Region --
   -----------------------------

   procedure Set_Private_Data_Region (
      New_Region : MPU_Region_Descriptor_Type;
      Old_Region : out MPU_Region_Descriptor_Type)
   is
   begin
      null; --???
   end Set_Private_Data_Region;

   -------------------------------
   -- Unset_Private_Code_Region --
   -------------------------------

   procedure Unset_Private_Code_Region
   is
   begin
      null; --???
   end Unset_Private_Code_Region;

   --------------------------------------
   -- UnSet_Private_Data_Region --
   --------------------------------------

   procedure UnSet_Private_Data_Region
   is
   begin
      null; --???
   end UnSet_Private_Data_Region;

end Memory_Protection;
