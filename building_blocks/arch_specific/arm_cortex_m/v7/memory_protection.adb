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

with System.BB.Parameters;
with System.Machine_Code;
with System.Text_IO.Extended;
with System.BB.Board_Support;
with System.BB.Threads;
with System.Multiprocessors;
with System.Address_To_Access_Conversions;

package body Memory_Protection is
   use Machine_Code;
   use System.Text_IO.Extended;

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
   Flash_Text_Start : constant Unsigned_32;
   pragma Import (Asm, Flash_Text_Start, "__flash_text_start");

   --  End address of the text section in flash
   --  Flash_Text_End : constant Unsigned_32;
   --  pragma Import (Asm, Flash_Text_End, "__flash_text_end");

   --  End address of the rodata section in flash
   Rom_End : constant Unsigned_32;
   pragma Import (Asm, Rom_End, "__rom_end");

   --  Linker script symbol for the start address of the global background
   --  data region. The global background data area spans to the end of the
   --  physical address space;
   Global_Background_Data_Region_Start : constant Unsigned_32;
   pragma Import (Asm, Global_Background_Data_Region_Start,
                  "__background_data_region_start");

   --  Start address of the stack for ISRs
   Interrupt_Stack_Start : constant Unsigned_32;
   pragma Import (Asm, Interrupt_Stack_Start, "__interrupt_stack_start");

   --  End address of the stack for ISRs
   Interrupt_Stack_End : constant Unsigned_32;
   pragma Import (Asm, Interrupt_Stack_End, "__interrupt_stack_end");

   procedure Build_Disabled_Subregions_Mask (
      Rounded_Down_First_Address : Address;
      Rounded_Up_Last_Address : Address;
      First_Address : Address;
      Last_Address : Address;
      Disabled_Subregions_Mask : out Subregions_Disabled_Mask_Type);

   function Round_Down (Value : Integer_Address;
                        Alignment : Integer_Address)
                        return Integer_Address
      with Inline;

   function Round_Down_Address (Address : System.Address;
                                Alignment : Integer_Address)
                                return System.Address
      with Inline;

   function Round_Up (Value : Integer_Address;
                      Alignment : Integer_Address)
                      return Integer_Address
      with Inline;

   function Round_Up_Address (Address : System.Address;
                              Alignment : Integer_Address)
                              return System.Address
      with Inline;

   function Round_Up_Region_Size_To_Power_Of_2 (
      Region_Size_Bytes : Integer_Address)
      return Integer_Address;

   procedure Define_MPU_Region (
      Region_Id : MPU_Region_Id_Type;
      First_Address : System.Address;
      Last_Address : System.Address;
      Read_Write_Permissions : Read_Write_Permissions_Type;
      Execute_Permission : Boolean := False)
      with Pre => First_Address <= Last_Address;
   --
   --  Configure an MPU region to cover a given range of addresses and with
   --  the given access permissions. It may need to round-down the first
   --  address and to round-up the last address  to meet the ARMv7-M MPU region
   --  alignment requirements:
   --  - The size of the region must be a power of 2
   --  - The region's start address must be a multiple of the region's size
   --

   procedure Define_MPU_Region (
      Region_Id : MPU_Region_Id_Type;
      First_Address : System.Address;
      Size_In_Bytes : Integer_Address;
      Read_Write_Permissions : Read_Write_Permissions_Type;
      Execute_Permission : Boolean := False);
   --
   --  Wrapper that allows caller to specfy the region size instead of the
   --  region's last address

   procedure Define_Rounded_MPU_Region (
      Region_Id : MPU_Region_Id_Type;
      Rounded_First_Address : System.Address;
      Rounded_Region_Size : Integer_Address;
      Subregions_Disabled_Mask : Subregions_Disabled_Mask_Type;
      Read_Write_Permissions : Read_Write_Permissions_Type;
      Execute_Permission : Boolean := False);
   --
   --  This procedure is to be called only from Define_MPU_Region.
   --

   procedure Memory_Barrier;

   procedure Restore_MPU_Region_Descriptor (
      Region_Id : MPU_Region_Id_Type;
      Saved_Region : MPU_Region_Descriptor_Type)
      with Pre => Memory_Protection_Var.Initialized
                  and
                  Region_Id in Thread_Stack_Data_Region ..
                               Private_Code_Region;
   --
   --  Restore the MPU region descriptor for the given MPU region.
   --

   procedure Save_MPU_Region_Descriptor (
      Region_Id : MPU_Region_Id_Type;
      Saved_Region : out MPU_Region_Descriptor_Type)
      with Pre => Memory_Protection_Var.Initialized
                  and
                  Region_Id in Thread_Stack_Data_Region ..
                               Private_Code_Region;
   --
   --  Save the MPU region descriptor for the given MPU region.
   --

   procedure Undefine_MPU_Region (
      Region_Id : MPU_Region_Id_Type)
      with Pre => Memory_Protection_Var.Initialized
           and
           Region_Id in Thread_Stack_Data_Region ..
                        Private_Code_Region;
   --
   --  Undefines the given region in the MPU. After this, all further
   --  accesses to the corresponding address range will cause bus fault
   --  exceptions.
   --

   function Disable_Cpu_Interrupts return Word;

   procedure Restore_Cpu_Interrupts (Old_Primask : Word);

   function Encode_Region_Size (Region_Size_Bytes : Integer_Address)
      return Encoded_Region_Size_Type
      with Pre => Region_Size_Bytes in 2 ** 5 .. 2 ** 31 or else
                  Region_Size_Bytes = 0; -- 0 means 4GiB;

   package Address_To_Thread_Id is new
      System.Address_To_Access_Conversions (
         System.BB.Threads.Thread_Descriptor);

   use Address_To_Thread_Id;

   ------------------------------------
   -- Build_Disabled_Subregions_Mask --
   ------------------------------------

   procedure Build_Disabled_Subregions_Mask (
      Rounded_Down_First_Address : Address;
      Rounded_Up_Last_Address : Address;
      First_Address : Address;
      Last_Address : Address;
      Disabled_Subregions_Mask : out Subregions_Disabled_Mask_Type)
   is
      Rounded_Region_Size : constant Integer_Address :=
         To_Integer (Rounded_Up_Last_Address) -
         To_Integer (Rounded_Down_First_Address) + 1;
      Subregion_Size : constant Integer_Address :=
         Rounded_Region_Size / Disabled_Subregions_Mask'Length;
      Subregion_Index1 : Subregion_Index_Type;
      Subregion_Index2 : Subregion_Index_Type;
      Subregion_Address : Address;
   begin
      Disabled_Subregions_Mask := (others => 0);
      if Subregion_Size < MPU_Region_Alignment then
         return;
      end if;

      Subregion_Index1 := Disabled_Subregions_Mask'First;
      Subregion_Address := Rounded_Down_First_Address;
      while Subregion_Address < First_Address loop
         Disabled_Subregions_Mask (Subregion_Index1) := 1;
         Subregion_Index1 := Subregion_Index1 + 1;
         Subregion_Address := To_Address (To_Integer (Subregion_Address) +
                                          Subregion_Size);
      end loop;

      pragma Assert (Subregion_Index1 <= Disabled_Subregions_Mask'Last);
      Subregion_Address := Rounded_Up_Last_Address;
      Subregion_Index2 := Disabled_Subregions_Mask'Last;
      while Subregion_Address > Last_Address loop
         pragma Assert (Subregion_Index2 > Subregion_Index1);
         Disabled_Subregions_Mask (Subregion_Index2) := 1;
         Subregion_Index2 := Subregion_Index2 - 1;
         Subregion_Address := To_Address (To_Integer (Subregion_Address) -
                                          Subregion_Size);
      end loop;

      pragma Assert (Subregion_Index1 <= Subregion_Index2);
   end Build_Disabled_Subregions_Mask;

   -----------------------
   -- Define_MPU_Region --
   -----------------------

   procedure Define_MPU_Region (
      Region_Id : MPU_Region_Id_Type;
      First_Address : System.Address;
      Last_Address : System.Address;
      Read_Write_Permissions : Read_Write_Permissions_Type;
      Execute_Permission : Boolean := False)
   is
      Rounded_Up_Region_Size : Integer_Address;
      Rounded_Down_First_Address : Address;
      Rounded_Up_Last_Address : Address;
      Subregions_Disabled_Mask : Subregions_Disabled_Mask_Type;
      Rounded_Region_Size_Bytes : Integer_Address;
   begin
      Rounded_Up_Region_Size :=
         Round_Up_Region_Size_To_Power_Of_2 (
            To_Integer (Last_Address) - To_Integer (First_Address) + 1);
      Rounded_Down_First_Address :=
         Round_Down_Address (First_Address, Rounded_Up_Region_Size);

      if To_Integer (Last_Address) = Integer_Address (Unsigned_32'Last) then
         Rounded_Up_Last_Address := Last_Address;
      else
         Rounded_Up_Last_Address :=
            To_Address (To_Integer (
               Round_Up_Address (To_Address (To_Integer (Last_Address) + 1),
                                 Rounded_Up_Region_Size)) - 1);
      end if;

      Build_Disabled_Subregions_Mask (
         Rounded_Down_First_Address,
         Rounded_Up_Last_Address,
         First_Address,
         Last_Address,
         Subregions_Disabled_Mask);

      Rounded_Region_Size_Bytes :=
         To_Integer (Rounded_Up_Last_Address) -
         To_Integer (Rounded_Down_First_Address) + 1;

      Define_Rounded_MPU_Region (
            Region_Id,
            Rounded_Down_First_Address,
            Rounded_Region_Size_Bytes,
            Subregions_Disabled_Mask,
            Read_Write_Permissions,
            Execute_Permission);
   end Define_MPU_Region;

   -----------------------
   -- Define_MPU_Region --
   -----------------------

   procedure Define_MPU_Region (
      Region_Id : MPU_Region_Id_Type;
      First_Address : System.Address;
      Size_In_Bytes : Integer_Address;
      Read_Write_Permissions : Read_Write_Permissions_Type;
      Execute_Permission : Boolean := False)
   is
   begin
      Define_MPU_Region (
         Region_Id,
         First_Address,
         To_Address (To_Integer (First_Address) + Size_In_Bytes - 1),
         Read_Write_Permissions,
         Execute_Permission);
   end Define_MPU_Region;

   -------------------------------
   -- Define_Rounded_MPU_Region --
   -------------------------------

   procedure Define_Rounded_MPU_Region (
      Region_Id : MPU_Region_Id_Type;
      Rounded_First_Address : System.Address;
      Rounded_Region_Size : Integer_Address;
      Subregions_Disabled_Mask : Subregions_Disabled_Mask_Type;
      Read_Write_Permissions : Read_Write_Permissions_Type;
      Execute_Permission : Boolean := False)
   is
      Region_Index : constant Byte := Region_Id'Enum_Rep;
      Encoded_Region_Size : constant Encoded_Region_Size_Type :=
         Encode_Region_Size (Rounded_Region_Size);
      Old_Intr_Mask : Word;
      RNR_Value : MPU_RNR_Register_Type;
      RBAR_Value : MPU_RBAR_Register_Type;
      RASR_Value : MPU_RASR_Register_Type;
      ADDR_Value : constant UInt27 :=
         UInt27 (Shift_Right (Unsigned_32 (To_Integer (Rounded_First_Address)),
                              5));
   begin
      Old_Intr_Mask := Disable_Cpu_Interrupts;

      --
      --  Configure region:
      --
      RNR_Value.REGION := Region_Index;
      MPU_Registers.MPU_RNR := RNR_Value;
      Memory_Barrier;
      RBAR_Value := (ADDR => ADDR_Value,
                     others => <>);
      MPU_Registers.MPU_RBAR := RBAR_Value;
      RASR_Value := (ENABLE => 1,
                     SIZE => Encoded_Region_Size,
                     SRD => Subregions_Disabled_Mask,
                     ATTRS => (AP => Read_Write_Permissions,
                               XN => (if Execute_Permission then 0 else 1),
                               others => <>));
      MPU_Registers.MPU_RASR := RASR_Value;

      Memory_Barrier;
      Restore_Cpu_Interrupts (Old_Intr_Mask);
   end Define_Rounded_MPU_Region;

   ----------------------------
   -- Disable_Cpu_Interrupts --
   ----------------------------

   function Disable_Cpu_Interrupts return Word is
      Reg_Value : Word;
   begin
      Asm ("mrs %0, primask" & ASCII.LF &
           "cpsid i" & ASCII.LF &
           "isb" & ASCII.LF,
           Outputs => Word'Asm_Output ("=r", Reg_Value),
           Volatile => True, Clobber => "memory");

      return Reg_Value;
   end Disable_Cpu_Interrupts;

   -----------------
   -- Disable_MPU --
   -----------------

   procedure Disable_MPU is
      MPU_CTRL_Value : MPU_CTRL_Register_Type;
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      pragma Assert (Memory_Protection_Var.Initialized);
      pragma Assert (Memory_Protection_Var.MPU_Enabled);

      Memory_Barrier;
      MPU_CTRL_Value := MPU_Registers.MPU_CTRL;
      MPU_CTRL_Value.ENABLE := 0;
      MPU_Registers.MPU_CTRL := MPU_CTRL_Value;
      Memory_Barrier;
      Memory_Protection_Var.MPU_Enabled := False;
   end Disable_MPU;

   ---------------------------------
   -- Dump_MPU_Region_Descriptors --
   ---------------------------------

   procedure Dump_MPU_Region_Descriptors is
      procedure Print_Region_Name (Region_Id : MPU_Region_Id_Type);

      procedure Print_Region_Name (Region_Id : MPU_Region_Id_Type) is
      begin
         case Region_Id is
            when Global_Background_Data_Region =>
               Put_String ("Global_Background_Data_Region");
            when Global_Flash_Code_Region =>
               Put_String ("Global_Flash_Code_Region");
            when Global_RAM_Code_Region =>
               Put_String ("Global_RAM_Code_Region");
            when Global_Interrupt_Stack_Region =>
               Put_String ("Global_Interrupt_Stack_Region");
            when Thread_Stack_Data_Region =>
               Put_String ("Thread_Stack_Data_Region");
            when Private_Data_Region =>
               Put_String ("Private_Data_Region");
            when Private_Code_Region =>
               Put_String ("Private_Code_Region");
         end case;
      end Print_Region_Name;

      Calling_Thread_Id : constant System.BB.Threads.Thread_Id :=
         System.BB.Threads.Thread_Self;
      Thread_Id_Addr : constant Address :=
         To_Address (Address_To_Thread_Id.Object_Pointer (Calling_Thread_Id));
      RNR_Value : MPU_RNR_Register_Type;
      RBAR_Value : MPU_RBAR_Register_Type;
      RASR_Value : MPU_RASR_Register_Type;
      RBAR_As_Integer : Unsigned_32 with Address => RBAR_Value'Address;
      RASR_As_Integer : Unsigned_32 with Address => RASR_Value'Address;
   begin
      Put_String ("Current thread pointer ");
      Print_Uint32_Hexadecimal (
         Unsigned_32 (To_Integer (Thread_Id_Addr)));
      Put_String (
         ASCII.LF & "MPU region descriptors:" & ASCII.LF);

      for I in 0 .. Memory_Protection_Var.Num_Regions - 1 loop
         RNR_Value.REGION := Byte (I);
         MPU_Registers.MPU_RNR := RNR_Value;
         Memory_Barrier;
         RBAR_Value := MPU_Registers.MPU_RBAR;
         RASR_Value := MPU_Registers.MPU_RASR;
         Put_String (ASCII.HT & "Region" & I'Image & " (");
         Print_Region_Name (MPU_Region_Id_Type'Val (I));
         Put_String ("): RBAR=");
         Print_Uint32_Hexadecimal (RBAR_As_Integer);
         Put_String (", RASR=");
         Print_Uint32_Hexadecimal (RASR_As_Integer);
         New_Line;
      end loop;
   end Dump_MPU_Region_Descriptors;

   ----------------
   -- Enable_MPU --
   ----------------

   procedure Enable_MPU is
      MPU_CTRL_Value : MPU_CTRL_Register_Type;
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      pragma Assert (Memory_Protection_Var.Initialized);
      pragma Assert (not Memory_Protection_Var.MPU_Enabled);

      Memory_Protection_Var.MPU_Enabled := True;
      Memory_Barrier;

      --
      --  Enable MPU:
      --
      MPU_CTRL_Value := MPU_Registers.MPU_CTRL;
      MPU_CTRL_Value.ENABLE := 1;
      MPU_Registers.MPU_CTRL := MPU_CTRL_Value;
   end Enable_MPU;

   ------------------------
   -- Encode_Region_Size --
   ------------------------

   function Encode_Region_Size (Region_Size_Bytes : Integer_Address)
      return Encoded_Region_Size_Type
   is
   begin
      for Log_Base2_Value in reverse Encoded_Region_Size_Type'Range loop
         if (Unsigned_32 (Region_Size_Bytes) and
             Shift_Left (Unsigned_32 (1), Natural (Log_Base2_Value))) /= 0
         then
            pragma Assert ((Region_Size_Bytes and
                            ((2 ** Natural (Log_Base2_Value)) - 1)) = 0);

            return Log_Base2_Value - 1;
         end if;
      end loop;

      pragma Assert (Region_Size_Bytes = 0); --  4GiB
      return Encoded_Region_Size_Type'Last;
   end Encode_Region_Size;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      MPU_TYPE_Value : MPU_TYPE_Register_Type;
      MPU_CTRL_Value : MPU_CTRL_Register_Type;
      RNR_Value : MPU_RNR_Register_Type;
      RASR_Value : MPU_RASR_Register_Type;
   begin
      if System.BB.Parameters.Use_MPU then
         --
         --  Verify that the MPU has enough regions:
         --
         MPU_TYPE_Value := MPU_Registers.MPU_TYPE;
         Memory_Protection_Var.Num_Regions :=
            Natural (MPU_TYPE_Value.DREGION_Num);

         pragma Assert (Memory_Protection_Var.Num_Regions >=
                        MPU_Region_Id_Type'Enum_Rep (MPU_Region_Id_Type'Last));

         --
         --  Disable MPU to configure it:
         --
         MPU_CTRL_Value := MPU_Registers.MPU_CTRL;
         MPU_CTRL_Value.ENABLE := 0;
         MPU_Registers.MPU_CTRL := MPU_CTRL_Value;

         --
         --  Disable the default background region:
         --
         MPU_CTRL_Value.PRIVDEFENA := 0;
         MPU_Registers.MPU_CTRL := MPU_CTRL_Value;

         --
         --  Disable access to all regions:
         --
         for I in 0 .. Memory_Protection_Var.Num_Regions - 1 loop
            RNR_Value.REGION := Byte (I);
            MPU_Registers.MPU_RNR := RNR_Value;
            Memory_Barrier;
            RASR_Value := (ENABLE => 0, others => <>);
            MPU_Registers.MPU_RASR := RASR_Value;
         end loop;

         --
         --  Set global region for executable code and constants in flash:
         --
         Define_MPU_Region (
            Global_Flash_Code_Region,
            Flash_Text_Start'Address,
            To_Address (To_Integer (Rom_End'Address) - 1),
            Privileged_Read_Only_Unprivileged_Read_Only,
            Execute_Permission => True);

         --
         --  Set global region for executable code in RAM:
         --
         Define_MPU_Region (
            Global_RAM_Code_Region,
            RAM_Text_Start'Address,
            To_Address (To_Integer (RAM_Text_End'Address) - 1),
            Privileged_Read_Only_Unprivileged_Read_Only,
            Execute_Permission => True);

         --
         --  Set global region for ISR stack:
         --
         Define_MPU_Region (
            Global_Interrupt_Stack_Region,
            Interrupt_Stack_Start'Address,
            To_Address (To_Integer (Interrupt_Stack_End'Address) - 1),
            Privileged_Read_Write_Unprivileged_No_Access);

         --
         --  NOTE: For the ARMV7-M MPU, we don't need to set a global region
         --  for accessing the MPU I/O registers, as they are always
         --  accessible:
         --

         --
         --  NOTE: We do not need to set a region for the ARM core
         --  memory-mapped control registers (private peripheral area:
         --  16#E000_0000# .. 16#E00F_FFFF#), as they are always accessible
         --  regardless of the MPU settings.
         --

         --
         --  Set MPU region that represents the global background region
         --  to have read-only permissions:
         --
         if Secret_Areas_Enabled then
            Define_MPU_Region (
               Global_Background_Data_Region,
               Global_Background_Data_Region_Start'Address,
               To_Address (Integer_Address (Unsigned_32'Last)),
               Privileged_Read_Only_Unprivileged_Read_Only);
         else
            Define_MPU_Region (
               Global_Background_Data_Region,
               To_Address (Integer_Address (Unsigned_32'First)),
               To_Address (Integer_Address (Unsigned_32'Last)),
               Privileged_Read_Only_Unprivileged_Read_Only);
         end if;

         --
         --  NOTE: Leave the MPU disabled, so that the Ada runtime startup code
         --  and global package elaboration can execute normally.
         --  The application's main rpogram is expected to call Enable_MPU
         --
      else
         MPU_CTRL_Value := MPU_Registers.MPU_CTRL;
         MPU_CTRL_Value.ENABLE := 0;
         MPU_Registers.MPU_CTRL := MPU_CTRL_Value;
      end if;

      Memory_Protection_Var.Return_From_Fault_Enabled := False;
      Memory_Protection_Var.Initialized := True;
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
      Rounded_Up_Region_Size : Integer_Address;
      Rounded_Down_First_Address : Address;
      Rounded_Up_Last_Address : Address;
      Subregions_Disabled_Mask : Subregions_Disabled_Mask_Type;
      ADDR_Value : UInt27;
      Encoded_Region_Size : Encoded_Region_Size_Type;
      Read_Write_Permissions : constant Read_Write_Permissions_Type :=
         (if Permissions = Read_Write then
             Privileged_Read_Write_Unprivileged_No_Access
          else
             Privileged_Read_Only_Unprivileged_No_Access);
   begin
      Rounded_Up_Region_Size :=
         Round_Up_Region_Size_To_Power_Of_2 (
            To_Integer (Last_Address) - To_Integer (First_Address) + 1);
      Rounded_Down_First_Address :=
         Round_Down_Address (First_Address, Rounded_Up_Region_Size);

      if To_Integer (Last_Address) = Integer_Address (Unsigned_32'Last) then
         Rounded_Up_Last_Address := Last_Address;
      else
         Rounded_Up_Last_Address :=
            To_Address (To_Integer (
               Round_Up_Address (To_Address (To_Integer (Last_Address) + 1),
                                 Rounded_Up_Region_Size)) - 1);
      end if;

      Build_Disabled_Subregions_Mask (
         Rounded_Down_First_Address,
         Rounded_Up_Last_Address,
         First_Address,
         Last_Address,
         Subregions_Disabled_Mask);

      Encoded_Region_Size := Encode_Region_Size (Rounded_Up_Region_Size);
      ADDR_Value := UInt27 (
         Shift_Right (Unsigned_32 (To_Integer (Rounded_Down_First_Address)),
                      5));
      Region.RBAR_Value := (ADDR => ADDR_Value,
                            others => <>);
      Region.RASR_Value := (ENABLE => 1,
                            SIZE => Encoded_Region_Size,
                            SRD => Subregions_Disabled_Mask,
                            ATTRS => (AP => Read_Write_Permissions,
                                      XN => 1,
                                      others => <>));
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
      Rounded_Up_Region_Size : Integer_Address;
      Rounded_Down_First_Address : Address;
      Rounded_Up_Last_Address : Address;
      Subregions_Disabled_Mask : Subregions_Disabled_Mask_Type;
      ADDR_Value : UInt27;
      Encoded_Region_Size : Encoded_Region_Size_Type;
   begin
      Rounded_Up_Region_Size :=
         Round_Up_Region_Size_To_Power_Of_2 (
            To_Integer (Last_Address) - To_Integer (First_Address) + 1);
      Rounded_Down_First_Address :=
         Round_Down_Address (First_Address, Rounded_Up_Region_Size);

      if To_Integer (Last_Address) = Integer_Address (Unsigned_32'Last) then
         Rounded_Up_Last_Address := Last_Address;
      else
         Rounded_Up_Last_Address :=
            To_Address (To_Integer (
               Round_Up_Address (To_Address (To_Integer (Last_Address) + 1),
                                 Rounded_Up_Region_Size)) - 1);
      end if;

      Build_Disabled_Subregions_Mask (
         Rounded_Down_First_Address,
         Rounded_Up_Last_Address,
         First_Address,
         Last_Address,
         Subregions_Disabled_Mask);

      Encoded_Region_Size := Encode_Region_Size (Rounded_Up_Region_Size);
      ADDR_Value := UInt27 (
         Shift_Right (Unsigned_32 (To_Integer (Rounded_Down_First_Address)),
                      5));
      Region.RBAR_Value := (ADDR => ADDR_Value,
                            others => <>);
      Region.RASR_Value :=
         (ENABLE => 1,
          SIZE => Encoded_Region_Size,
          SRD => Subregions_Disabled_Mask,
          ATTRS => (AP => Privileged_Read_Only_Unprivileged_No_Access,
                    XN => 0,
                    others => <>));
   end Initialize_Private_Code_Region;

   --------------------
   -- Is_MPU_Enabled --
   --------------------

   function Is_MPU_Enabled return Boolean is
      (Memory_Protection_Var.MPU_Enabled);

   --------------------
   -- Memory_Barrier --
   --------------------

   procedure Memory_Barrier is
   begin
      Asm ("dsb" & ASCII.LF &
           "isb" & ASCII.LF,
           Clobber => "memory",
           Volatile => True);
   end Memory_Barrier;

   ----------------------------
   -- Restore_Cpu_Interrupts --
   ----------------------------

   procedure Restore_Cpu_Interrupts (Old_Primask : Word) is
   begin
      if (Old_Primask and 16#1#) = 0 then
         Asm ("isb" & ASCII.LF &
              "cpsie i" & ASCII.LF,
              Clobber => "memory",
              Volatile => True);
      end if;
   end Restore_Cpu_Interrupts;

   -----------------------------------
   -- Restore_MPU_Region_Descriptor --
   -----------------------------------

   procedure Restore_MPU_Region_Descriptor (
      Region_Id : MPU_Region_Id_Type;
      Saved_Region : MPU_Region_Descriptor_Type)
   is
      RNR_Value : MPU_RNR_Register_Type;
   begin
      RNR_Value.REGION := Region_Id'Enum_Rep;
      MPU_Registers.MPU_RNR := RNR_Value;
      MPU_Registers.MPU_RBAR := Saved_Region.RBAR_Value;
      MPU_Registers.MPU_RASR := Saved_Region.RASR_Value;
      Memory_Barrier;
   end Restore_MPU_Region_Descriptor;

   ---------------------------------
   -- Restore_Private_Code_Region --
   ---------------------------------

   procedure Restore_Private_Code_Region (
      Saved_Region : MPU_Region_Descriptor_Type)
   is
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      Restore_MPU_Region_Descriptor (Private_Code_Region, Saved_Region);
   end Restore_Private_Code_Region;

   ---------------------------------
   -- Restore_Private_Data_Region --
   ---------------------------------

   procedure Restore_Private_Data_Region (
      Saved_Region : MPU_Region_Descriptor_Type)
   is
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      Restore_MPU_Region_Descriptor (Private_Data_Region, Saved_Region);
   end Restore_Private_Data_Region;

   --------------------------------
   -- Restore_Thread_MPU_Regions --
   --------------------------------

   procedure Restore_Thread_MPU_Regions (Thread_Regions : Thread_Regions_Type)
   is
      use System.Multiprocessors;
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      pragma Assert (Memory_Protection_Var.Initialized);
      --  For now we only support systems with one CPU core
      pragma Assert (System.BB.Board_Support.Multiprocessors.Current_CPU =
                     CPU'First);

      Restore_MPU_Region_Descriptor (
         Region_Id => Thread_Stack_Data_Region,
         Saved_Region => Thread_Regions.Stack_Region);

      Restore_MPU_Region_Descriptor (
         Region_Id => Private_Data_Region,
         Saved_Region => Thread_Regions.Private_Data_Region);

      Restore_MPU_Region_Descriptor (
         Region_Id => Private_Code_Region,
         Saved_Region => Thread_Regions.Private_Code_Region);

      Set_CPU_Writable_Background_Region (
         Thread_Regions.Writable_Background_Region_Enabled);

      if Debug_MPU_Enabled then
         System.Text_IO.Extended.Put_String (
            "Restore_Thread_MPU_Regions:" & ASCII.LF);
         Dump_MPU_Region_Descriptors;
      end if;
   end Restore_Thread_MPU_Regions;

   ----------------
   -- Round_Down --
   ----------------

   function Round_Down (Value : Integer_Address;
                        Alignment : Integer_Address)
                        return Integer_Address
   is ((Value / Alignment) * Alignment);

   ------------------------
   -- Round_Down_Address --
   ------------------------

   function Round_Down_Address (Address : System.Address;
                                Alignment : Integer_Address)
                                return System.Address
   is (To_Address (Round_Down (To_Integer (Address), Alignment)));

   --------------
   -- Round_Up --
   --------------

   function Round_Up (Value : Integer_Address;
                      Alignment : Integer_Address)
                      return Integer_Address
   is ((((Value - 1) / Alignment) + 1) * Alignment);

   ----------------------
   -- Round_Up_Address --
   ----------------------

   function Round_Up_Address (Address : System.Address;
                              Alignment : Integer_Address)
                              return System.Address
   is (To_Address (Round_Up (To_Integer (Address), Alignment)));

   ----------------------------------------
   -- Round_Up_Region_Size_To_Power_Of_2 --
   ----------------------------------------

   function Round_Up_Region_Size_To_Power_Of_2 (
      Region_Size_Bytes : Integer_Address)
      return Integer_Address
   is
      Power_Of_2 : Integer_Address;
   begin
      for Log_Base2_Value in reverse Encoded_Region_Size_Type'Range loop
         Power_Of_2 := 2 ** Natural (Log_Base2_Value);
         if (Unsigned_32 (Region_Size_Bytes) and
             Shift_Left (Unsigned_32 (1), Natural (Log_Base2_Value))) /= 0
         then
            if (Region_Size_Bytes and (Power_Of_2 - 1)) = 0 then
               return Power_Of_2;
            else
               if Log_Base2_Value = Encoded_Region_Size_Type'Last then
                  return 0; -- 4GiB encoded in 32-bits
               else
                  return Power_Of_2 * 2;
               end if;
            end if;
         end if;
      end loop;

      return 0; -- 4GiB encoded in 32-bits
   end Round_Up_Region_Size_To_Power_Of_2;

   --------------------------------
   -- Save_MPU_Region_Descriptor --
   --------------------------------

   procedure Save_MPU_Region_Descriptor (
      Region_Id : MPU_Region_Id_Type;
      Saved_Region : out MPU_Region_Descriptor_Type)
   is
      RNR_Value : MPU_RNR_Register_Type;
   begin
      RNR_Value := (REGION => Region_Id'Enum_Rep, others => <>);
      MPU_Registers.MPU_RNR := RNR_Value;
      Saved_Region.RBAR_Value := MPU_Registers.MPU_RBAR;
      Saved_Region.RASR_Value := MPU_Registers.MPU_RASR;
   end Save_MPU_Region_Descriptor;

   -----------------------------
   -- Save_Thread_MPU_Regions --
   -----------------------------

   procedure Save_Thread_MPU_Regions (Thread_Regions : out Thread_Regions_Type)
   is
      Old_Enabled : Boolean;
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      pragma Assert (Memory_Protection_Var.Initialized);

      if Debug_MPU_Enabled then
         System.Text_IO.Extended.Put_String (
            "Save_Thread_MPU_Regions:" & ASCII.LF);
         Dump_MPU_Region_Descriptors;
      end if;

      Set_CPU_Writable_Background_Region (True, Old_Enabled);

      --
      --  Note: Although it may seem silly to have the Old_Enabled
      --  variable, instead of passing
      --  Thread_Regions.Writable_Background_Region_Enable directly
      --  in the call above, we cannot do that as we need to ensure
      --  we can write to it, by enabling writes on the background
      --  region first.
      --
      Thread_Regions.Writable_Background_Region_Enabled := Old_Enabled;

      Save_MPU_Region_Descriptor (
         Region_Id => Thread_Stack_Data_Region,
         Saved_Region => Thread_Regions.Stack_Region);

      Save_MPU_Region_Descriptor (
         Region_Id => Private_Data_Region,
         Saved_Region => Thread_Regions.Private_Data_Region);

      Save_MPU_Region_Descriptor (
         Region_Id => Private_Code_Region,
         Saved_Region => Thread_Regions.Private_Code_Region);

      --
      --  NOTE: We return leaving the background region enabled for writing
      --  so that the rest of the context switch logic in the Ada runtime
      --  can update its data structures.
      --
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
      RNR_Value : MPU_RNR_Register_Type;
      RASR_Value : MPU_RASR_Register_Type;
      Old_Intr_Mask : Word;
   begin
      if not System.BB.Parameters.Use_MPU then
         Old_Enabled := True;
         return;
      end if;

      Old_Intr_Mask := Disable_Cpu_Interrupts;
      RNR_Value.REGION := Global_Background_Data_Region'Enum_Rep;
      MPU_Registers.MPU_RNR := RNR_Value;

      RASR_Value := MPU_Registers.MPU_RASR;
      Old_Enabled := (RASR_Value.ATTRS.AP =
                      Privileged_Read_Write_Unprivileged_Read_Only);

      if Enabled then
         if Secret_Areas_Enabled then
            Define_MPU_Region (
               Global_Background_Data_Region,
               Global_Background_Data_Region_Start'Address,
               To_Address (Integer_Address (Unsigned_32'Last)),
               Privileged_Read_Write_Unprivileged_Read_Only);
         else
            Define_MPU_Region (
               Global_Background_Data_Region,
               To_Address (Integer_Address (Unsigned_32'First)),
               To_Address (Integer_Address (Unsigned_32'Last)),
               Privileged_Read_Write_Unprivileged_Read_Only);
         end if;
      else
         if Secret_Areas_Enabled then
            Define_MPU_Region (
               Global_Background_Data_Region,
               Global_Background_Data_Region_Start'Address,
               To_Address (Integer_Address (Unsigned_32'Last)),
               Privileged_Read_Only_Unprivileged_Read_Only);
         else
            Define_MPU_Region (
               Global_Background_Data_Region,
               To_Address (Integer_Address (Unsigned_32'First)),
               To_Address (Integer_Address (Unsigned_32'Last)),
               Privileged_Read_Only_Unprivileged_Read_Only);
         end if;
      end if;

      Memory_Barrier;
      Restore_Cpu_Interrupts (Old_Intr_Mask);
   end Set_CPU_Writable_Background_Region;

   -----------------------------
   -- Set_Private_Code_Region --
   -----------------------------

   procedure Set_Private_Code_Region (
      First_Address : System.Address;
      Last_Address : System.Address)
   is
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      Define_MPU_Region (Private_Code_Region,
                         First_Address,
                         Last_Address,
                         Privileged_Read_Only_Unprivileged_No_Access,
                         Execute_Permission => True);
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
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      Save_MPU_Region_Descriptor (Private_Code_Region,
                                  Old_Region);

      Define_MPU_Region (Private_Code_Region,
                         First_Address,
                         Last_Address,
                         Privileged_Read_Only_Unprivileged_No_Access,
                         Execute_Permission => True);
   end Set_Private_Code_Region;

   -----------------------------
   -- Set_Private_Code_Region --
   -----------------------------

   procedure Set_Private_Code_Region (
      New_Region : MPU_Region_Descriptor_Type;
      Old_Region : out MPU_Region_Descriptor_Type)
   is
   begin
      Save_MPU_Region_Descriptor (Region_Id => Private_Code_Region,
                                  Saved_Region => Old_Region);

      Restore_MPU_Region_Descriptor (Region_Id => Private_Code_Region,
                                     Saved_Region => New_Region);
   end Set_Private_Code_Region;

   -----------------------------
   -- Set_Private_Data_Region --
   -----------------------------

   procedure Set_Private_Data_Region (
      Start_Address : System.Address;
      Size_In_Bits : Integer_Address;
      Permissions : Data_Permissions_Type)
   is
      Read_Write_Permissions : constant Read_Write_Permissions_Type :=
         (if Permissions = Read_Write then
             Privileged_Read_Write_Unprivileged_No_Access
          else
             Privileged_Read_Only_Unprivileged_No_Access);
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      Define_MPU_Region (Private_Data_Region,
                         Start_Address,
                         Size_In_Bits / Byte'Size,
                         Read_Write_Permissions);
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
      Read_Write_Permissions : constant Read_Write_Permissions_Type :=
         (if Permissions = Read_Write then
             Privileged_Read_Write_Unprivileged_No_Access
          else
             Privileged_Read_Only_Unprivileged_No_Access);

   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      Save_MPU_Region_Descriptor (Private_Data_Region,
                                  Old_Region);

      Define_MPU_Region (Private_Data_Region,
                         Start_Address,
                         Size_In_Bits / Byte'Size,
                         Read_Write_Permissions);
   end Set_Private_Data_Region;

   -----------------------------
   -- Set_Private_Data_Region --
   -----------------------------

   procedure Set_Private_Data_Region (
      New_Region : MPU_Region_Descriptor_Type;
      Old_Region : out MPU_Region_Descriptor_Type)
   is
   begin
      Save_MPU_Region_Descriptor (Region_Id => Private_Data_Region,
                                  Saved_Region => Old_Region);

      Restore_MPU_Region_Descriptor (Region_Id => Private_Data_Region,
                                     Saved_Region => New_Region);

   end Set_Private_Data_Region;

   -------------------------
   -- Undefine_MPU_Region --
   -------------------------

   procedure Undefine_MPU_Region (
      Region_Id : MPU_Region_Id_Type)
   is
      RNR_Value : MPU_RNR_Register_Type;
   begin
      --
      --  Disable access to the region:
      --
      RNR_Value := (REGION => Region_Id'Enum_Rep, others => <>);
      MPU_Registers.MPU_RNR := RNR_Value;
      Memory_Barrier;
      MPU_Registers.MPU_RASR := (ENABLE => 0, others => <>);
   end Undefine_MPU_Region;

   -------------------------------
   -- Unset_Private_Code_Region --
   -------------------------------

   procedure Unset_Private_Code_Region
   is
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      Undefine_MPU_Region (Region_Id => Private_Code_Region);
   end Unset_Private_Code_Region;

   --------------------------------------
   -- UnSet_Private_Data_Region --
   --------------------------------------

   procedure UnSet_Private_Data_Region
   is
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      Undefine_MPU_Region (Region_Id => Private_Data_Region);
   end UnSet_Private_Data_Region;

end Memory_Protection;
