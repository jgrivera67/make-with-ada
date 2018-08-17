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
with Kinetis_K64F.SCS;
with System.Text_IO.Extended;
with System.BB.Threads;
with System.Multiprocessors;
with System.BB.Board_Support;
with System.Address_To_Access_Conversions;

package body Memory_Protection is
   use Machine_Code;
   use Kinetis_K64F.SCS;
   use Kinetis_K64F.MPU;

   --
   --  Flag to enable/disable at compile time the support for secret areas.
   --  If secret areas support is disabled, the MPU default background region
   --  is used as the global background region. The default background region
   --  covers the entire address space. If secret areas support is
   --  enabled, the MPU default background region is disabled and the global
   --  background region is represented by a dedicated MPU region. This region
   --  covers the entire address space except for the secret data and code
   --  areas.
   --  In both cases the global background region has read-only permissions
   --  by default.
   --
   Secret_Areas_Enabled : constant Boolean := True;

   pragma Compile_Time_Error (
      MPU_Region_Alignment /= Kinetis_K64F.MPU.MPU_Region_Alignment,
      "MPU region alignment must match hardware MPU");

   pragma Compile_Time_Error (
      MPU_Region_Id_Type'Enum_Rep (MPU_Region_Id_Type'First) <
      Kinetis_K64F.MPU.Region_Index_Type'First
      or
      MPU_Region_Id_Type'Enum_Rep (MPU_Region_Id_Type'Last) >
      Kinetis_K64F.MPU.Region_Index_Type'Last,
      "MPU_Region_Id_Type contains invalid region numbers");

   Num_Mpu_Regions_Table : constant array (0 .. 2) of Natural :=
      (0 => 8,
       1 => 12,
       2 => 16);

   Debug_MPU_Enabled : constant Boolean := False;

   --
   --  Address range and permissions for a given thread-private data region
   --
   type Data_Region_Type is record
      First_Address : System.Address;
      Last_Address : System.Address;
      Permissions : Data_Permissions_Type := None;
   end record;

   --
   --  Address range and permissions for a given thread-private code region
   --
   type Code_Region_Type is record
      First_Address : System.Address;
      Last_Address : System.Address;
      Enabled : Boolean := False;
   end record;

   --
   --  Global state of the memory protection services
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
   --  embedded-runtimes/bsps/kinetis_k64f_common/bsp/common-ROM.ld
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

   procedure Define_MPU_Region (
      Region_Id : MPU_Region_Id_Type;
      Bus_Master : Bus_Master_Type;
      First_Address : System.Address;
      Last_Address : System.Address;
      Type1_Permissions : Bus_Master_Permissions_Type1;
      Type2_Permissions : Bus_Master_Permissions_Type2)
      with Pre => Region_Id >= Global_Flash_Code_Region;
   --
   --  Configure an MPU region to cover a given range of addresses and with
   --  the given access permissions, for the given bus master.
   --

   procedure Define_Private_Code_Region (Region : Code_Region_Type)
      with Pre => Memory_Protection_Var.Initialized;
   --
   --  Defines a private code region in the MPU to be accessible from the CPU,
   --  to execute instructions.
   --

   procedure Define_Private_Data_Region (
      Region_Id : MPU_Region_Id_Type;
      Region : Data_Region_Type)
      with Pre => Memory_Protection_Var.Initialized
                  and
                  Region_Id in Thread_Stack_Data_Region ..
                               Private_Data_Region;
   --
   --  Defines a data region in the MPU to be accessible from the CPU,
   --  associated with the corresponding MPU region Id.
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
           Region_Id > Global_RAM_Code_Region;
   --
   --  Undefines the given region in the MPU. After this, all further
   --  accesses to the corresponding address range will cause bus fault
   --  exceptions.
   --

   function Disable_Cpu_Interrupts return Word;

   procedure Restore_Cpu_Interrupts (Old_Primask : Word);

   --  function EDR_Register_To_Unsigned_32 is
   --    new Ada.Unchecked_Conversion (Source => EDR_Register_Type,
   --                                  Target => Unsigned_32);

   package Address_To_Thread_Id is new
      System.Address_To_Access_Conversions (
         System.BB.Threads.Thread_Descriptor);

   use Address_To_Thread_Id;

   -----------------------
   -- Define_MPU_Region --
   -----------------------

   procedure Define_MPU_Region (
      Region_Id : MPU_Region_Id_Type;
      Bus_Master : Bus_Master_Type;
      First_Address : System.Address;
      Last_Address : System.Address;
      Type1_Permissions : Bus_Master_Permissions_Type1;
      Type2_Permissions : Bus_Master_Permissions_Type2)
   is
      WORD2_Value : WORD2_Register_Type;
      WORD3_Value : WORD3_Register_Type;
      Region_Index : constant Region_Index_Type := Region_Id'Enum_Rep;
      Old_Intr_Mask : Word;
   begin
      Old_Intr_Mask := Disable_Cpu_Interrupts;

      --
      --  Configure region:
      --
      --  NOTE: writing to registers WORD0, WORD1 and WORD2 of the region
      --  descriptor for region 'Region_Index' will disable access to
      --  the region (turn off bit MPU_WORD_VLD_MASK in register WORD3):
      --

      MPU_Registers.Region_Descriptors (Region_Index).WORD0 :=
         Unsigned_32 (To_Integer (First_Address));

      MPU_Registers.Region_Descriptors (Region_Index).WORD1 :=
          Unsigned_32 (To_Integer (Last_Address));

      WORD2_Value := MPU_Registers.Region_Descriptors (Region_Index).WORD2;

      case Bus_Master is
         when Cpu_Core0 =>
            WORD2_Value.Bus_Master_CPU_Core_Perms := Type1_Permissions;
         when DMA_Device_DMA_Engine =>
            WORD2_Value.Bus_Master_DMA_EZport_Perms := Type1_Permissions;
         when DMA_Device_ENET =>
            WORD2_Value.Bus_Master_ENET_Perms := Type1_Permissions;
         when DMA_Device_USB =>
            WORD2_Value.Bus_Master_USB_Perms := Type2_Permissions;
         when DMA_Device_SDHC =>
            WORD2_Value.Bus_Master_SDHC_Perms := Type2_Permissions;
         when DMA_Device_Master6 =>
            WORD2_Value.Bus_Master6_Perms := Type2_Permissions;
         when DMA_Device_Master7 =>
            WORD2_Value.Bus_Master7_Perms := Type2_Permissions;
         when others =>
            pragma Assert (False);
      end case;

      MPU_Registers.Region_Descriptors (Region_Index).WORD2 := WORD2_Value;

      --
      --  Re-enable access to the region:
      --
      WORD3_Value := MPU_Registers.Region_Descriptors (Region_Index).WORD3;
      WORD3_Value.VLD := 1;
      MPU_Registers.Region_Descriptors (Region_Index).WORD3 := WORD3_Value;

      Memory_Barrier;
      Restore_Cpu_Interrupts (Old_Intr_Mask);
   end Define_MPU_Region;

   --------------------------------
   -- Define_Private_Code_Region --
   --------------------------------

   procedure Define_Private_Code_Region (Region : Code_Region_Type)
   is
      Type1_Read_Execute_Permissions : constant Bus_Master_Permissions_Type1 :=
         (User_Mode_Permissions => (Execute_Allowed => 1,
                                    Write_Allowed => 0,
                                    Read_Allowed => 1),
          others => <>);

      Dummy_Type2_Permissions : Bus_Master_Permissions_Type2;
   begin
      pragma Assert (Region.Enabled);
      Define_MPU_Region (Private_Code_Region,
                         Cpu_Core0,
                         Region.First_Address,
                         Region.Last_Address,
                         Type1_Read_Execute_Permissions,
                         Dummy_Type2_Permissions);
   end Define_Private_Code_Region;

   --------------------------------
   -- Define_Private_Data_Region --
   --------------------------------

   procedure Define_Private_Data_Region (Region_Id : MPU_Region_Id_Type;
                                         Region : Data_Region_Type)
   is
      Type1_Read_Write_Permissions : constant Bus_Master_Permissions_Type1 :=
         (User_Mode_Permissions => (Execute_Allowed => 0,
                                    Write_Allowed => 1,
                                    Read_Allowed => 1),
          others => <>);

      Type1_Read_Only_Permissions : constant Bus_Master_Permissions_Type1 :=
         (User_Mode_Permissions => (Execute_Allowed => 0,
                                    Write_Allowed => 0,
                                    Read_Allowed => 1),
          others => <>);

      Type1_Permissions : Bus_Master_Permissions_Type1;
      Dummy_Type2_Permissions : Bus_Master_Permissions_Type2;
   begin
      pragma Assert (Region.Permissions /= None);
      if Region.Permissions = Read_Write then
         Type1_Permissions := Type1_Read_Write_Permissions;
      else
         Type1_Permissions := Type1_Read_Only_Permissions;
      end if;

      Define_MPU_Region (Region_Id,
                         Cpu_Core0,
                         Region.First_Address,
                         Region.Last_Address,
                         Type1_Permissions,
                         Dummy_Type2_Permissions);
   end Define_Private_Data_Region;

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
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      pragma Assert (Memory_Protection_Var.Initialized);
      pragma Assert (Memory_Protection_Var.MPU_Enabled);

      Memory_Barrier;
      MPU_Registers.CESR := (VLD => 0, others => <>);
      Memory_Barrier;
      Memory_Protection_Var.MPU_Enabled := False;
   end Disable_MPU;

   ------------------------------
   -- Dump_MPU_Error_Registers --
   ------------------------------

   procedure Dump_MPU_Error_Registers is
      procedure Dump_EACD_Field (EACD : Unsigned_16);

      procedure Dump_EDR_Register (EDR : EDR_Register_Type);

      procedure Dump_EATTR_Field (EATTR : UInt3);

      procedure Dump_EACD_Field (EACD : Unsigned_16) is
         Bits_Left : Unsigned_16 := EACD;
         Region_Count : Natural := 0;
      begin
         for Bit_Index in 0 .. 11 loop
            if (Bits_Left and 2#1#) /= 0 then
               if Region_Count > 0 then
                  System.Text_IO.Put (' ');
               end if;

               System.Text_IO.Extended.Put_String (Bit_Index'Image);
               Region_Count := Region_Count + 1;
            end if;

            Bits_Left := Shift_Right (Bits_Left, 1);
         end loop;

         if Region_Count = 0 then
            System.Text_IO.Extended.Put_String ("none");
         end if;
      end Dump_EACD_Field;

      procedure Dump_EATTR_Field (EATTR : UInt3) is
      begin
         case EATTR is
            when 2#000# =>
               System.Text_IO.Extended.Put_String (
                  "unprivileged mode, instruction access");
            when 2#001# =>
               System.Text_IO.Extended.Put_String (
                  "unprivileged mode, data access");
            when 2#010# =>
               System.Text_IO.Extended.Put_String (
                  "privileged mode, instruction access");
            when 2#011# =>
               System.Text_IO.Extended.Put_String (
                  "privileged mode, data access");
            when others =>
               System.Text_IO.Extended.Put_String (
                  "unknown value (" & EATTR'Image & ")");
         end case;
      end Dump_EATTR_Field;

      procedure Dump_EDR_Register (EDR : EDR_Register_Type) is
      begin
         System.Text_IO.Extended.Put_String (
            ASCII.HT & "  Error details: " &
            "bus master " & EDR.EMN'Image & ", ");
         Dump_EATTR_Field (EDR.EATTR);
         System.Text_IO.Extended.Put_String (
            " (" & (if EDR.ERW = 0 then "read" else "write"));
         System.Text_IO.Extended.Put_String ("), fault in regions ");
         Dump_EACD_Field (EDR.EACD);
         --  System.Text_IO.Extended.Put_String (" (EDR value=");
         --  System.Text_IO.Extended.Print_Uint32_Hexadecimal (
         --     EDR_Register_To_Unsigned_32 (EDR));
         System.Text_IO.Extended.Put_String (")" & ASCII.LF);
      end Dump_EDR_Register;

      EAR_Value : Word;
      EDR_Value : EDR_Register_Type;
   begin
      System.Text_IO.Extended.Put_String (
         "MPU error registers:" & ASCII.LF);

      if MPU_Registers.CESR.SPERR.Slave_Port0_Error = 1 then
         EAR_Value := MPU_Registers.Slave_Ports (0).EAR;
         System.Text_IO.Extended.Put_String (
            ASCII.HT & "Slave port 0 error registers:" & ASCII.LF &
            ASCII.HT & "  Error Address: ");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (EAR_Value);
         System.Text_IO.Extended.New_Line;

         EDR_Value := MPU_Registers.Slave_Ports (0).EDR;
         Dump_EDR_Register (EDR_Value);
      end if;

      if MPU_Registers.CESR.SPERR.Slave_Port1_Error = 1 then
         EAR_Value := MPU_Registers.Slave_Ports (1).EAR;
         System.Text_IO.Extended.Put_String (
            ASCII.HT & "Slave port 1 error registers:" & ASCII.LF &
            ASCII.HT & "  Error Address: ");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (EAR_Value);
         System.Text_IO.Extended.New_Line;

         EDR_Value := MPU_Registers.Slave_Ports (1).EDR;
         Dump_EDR_Register (EDR_Value);
      end if;

      if MPU_Registers.CESR.SPERR.Slave_Port2_Error = 1 then
         EAR_Value := MPU_Registers.Slave_Ports (2).EAR;
         System.Text_IO.Extended.Put_String (
            ASCII.HT & "Slave port 2 error registers:" & ASCII.LF &
            ASCII.HT & "  Error Address: ");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (EAR_Value);
         System.Text_IO.Extended.New_Line;

         EDR_Value := MPU_Registers.Slave_Ports (2).EDR;
         Dump_EDR_Register (EDR_Value);
      end if;

      if MPU_Registers.CESR.SPERR.Slave_Port3_Error = 1 then
         EAR_Value := MPU_Registers.Slave_Ports (3).EAR;
         System.Text_IO.Extended.Put_String (
            ASCII.HT & "Slave port 3 error registers:" & ASCII.LF &
            ASCII.HT & "  Error Address: ");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (EAR_Value);
         System.Text_IO.Extended.New_Line;

         EDR_Value := MPU_Registers.Slave_Ports (3).EDR;
         Dump_EDR_Register (EDR_Value);
      end if;

      if MPU_Registers.CESR.SPERR.Slave_Port4_Error = 1 then
         EAR_Value := MPU_Registers.Slave_Ports (4).EAR;
         System.Text_IO.Extended.Put_String (
            ASCII.HT & "Slave port 4 error registers:" & ASCII.LF &
            ASCII.HT & "  Error Address: ");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (EAR_Value);
         System.Text_IO.Extended.New_Line;

         EDR_Value := MPU_Registers.Slave_Ports (4).EDR;
         Dump_EDR_Register (EDR_Value);
      end if;
   end Dump_MPU_Error_Registers;

   ---------------------------------
   -- Dump_MPU_Region_Descriptors --
   ---------------------------------

   procedure Dump_MPU_Region_Descriptors is
      procedure Print_Region_Name (Region_Id : MPU_Region_Id_Type);

      procedure Print_Region_Name (Region_Id : MPU_Region_Id_Type) is
      begin
         case Region_Id is
            when Default_Background_Region =>
               System.Text_IO.Extended.Put_String (
                  "Default_Background_Region");
            when Global_Flash_Code_Region =>
               System.Text_IO.Extended.Put_String ("Global_Flash_Code_Region");
            when Global_RAM_Code_Region =>
               System.Text_IO.Extended.Put_String ("Global_RAM_Code_Region");
            when Global_Interrupt_Stack_Region =>
               System.Text_IO.Extended.Put_String (
                  "Global_Interrupt_Stack_Region");
            when Global_MPU_IO_Region =>
               System.Text_IO.Extended.Put_String ("Global_MPU_IO_Region");
            when Global_Background_Data_Region =>
               System.Text_IO.Extended.Put_String (
                  "Global_Background_Data_Region");
            when Thread_Stack_Data_Region =>
               System.Text_IO.Extended.Put_String ("Thread_Stack_Data_Region");
            when Private_Data_Region =>
               System.Text_IO.Extended.Put_String (
                  "Private_Data_Region");
            when Private_Code_Region =>
               System.Text_IO.Extended.Put_String ("Private_Code_Region");
            when DMA_Region1 =>
               System.Text_IO.Extended.Put_String ("DMA_Region1");
            when DMA_Region2 =>
               System.Text_IO.Extended.Put_String ("DMA_Region2");
            when DMA_Region3 =>
               System.Text_IO.Extended.Put_String ("DMA_Region3");
         end case;
      end Print_Region_Name;

      Calling_Thread_Id : constant System.BB.Threads.Thread_Id :=
         System.BB.Threads.Thread_Self;
      Thread_Id_Addr : constant Address :=
         To_Address (Address_To_Thread_Id.Object_Pointer (Calling_Thread_Id));

      Saved_Region : MPU_Region_Descriptor_Type;
      RGDAAC_Value : RGDAAC_Register_Type;
      RGDAAC_As_Integer : Unsigned_32 with Address => RGDAAC_Value'Address;
   begin
      System.Text_IO.Extended.Put_String (
         "Current thread pointer ");
      System.Text_IO.Extended.Print_Uint32_Hexadecimal (
         Unsigned_32 (To_Integer (Thread_Id_Addr)));
      System.Text_IO.Extended.Put_String (
         ASCII.LF & "MPU region descriptors:" & ASCII.LF);

      for Region_Id in MPU_Region_Id_Type loop
         Save_MPU_Region_Descriptor (Region_Id, Saved_Region);
         RGDAAC_Value :=  MPU_Registers.RGDAAC (Region_Id'Enum_Rep);
         System.Text_IO.Extended.Put_String (
            ASCII.HT & "Region" & Region_Id'Image & " (");
         Print_Region_Name (Region_Id);
         System.Text_IO.Extended.Put_String ("): Word0=");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (Saved_Region.WORD0);
         System.Text_IO.Extended.Put_String (", Word1=");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (Saved_Region.WORD1);
         System.Text_IO.Extended.Put_String (", Word2=");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (Saved_Region.WORD2);
         System.Text_IO.Extended.Put_String (", Word3=");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (Saved_Region.WORD3);
         System.Text_IO.Extended.Put_String (", RGDAAC=");
         System.Text_IO.Extended.Print_Uint32_Hexadecimal (RGDAAC_As_Integer);
         System.Text_IO.Extended.New_Line;
      end loop;
   end Dump_MPU_Region_Descriptors;

   ----------------
   -- Enable_MPU --
   ----------------

   procedure Enable_MPU (Enable_Precise_Write_Faults : Boolean := False) is
      ACTLR_Value : ACTLR_Register;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      pragma Assert (Memory_Protection_Var.Initialized);
      pragma Assert (not Memory_Protection_Var.MPU_Enabled);

      Memory_Protection_Var.MPU_Enabled := True;
      Memory_Barrier;
      MPU_Registers.CESR := (VLD => 1, others => <>);
      Memory_Barrier;
      if Enable_Precise_Write_Faults then
         --
         --  Disable write buffer, so that precise write faults can be
         --  generated:
         --
         Set_Private_Data_Region (SCS_Registers'Address,
                                         SCS_Registers'Size,
                                         Read_Write,
                                         Old_Region);

         ACTLR_Value := SCS_Registers.ACTLR;
         ACTLR_Value.DISDEFWBUF := 1;
         SCS_Registers.ACTLR := ACTLR_Value;
         Memory_Barrier;
         Restore_Private_Data_Region (Old_Region);
      end if;
   end Enable_MPU;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      Type1_Read_Execute_Permissions : constant Bus_Master_Permissions_Type1 :=
         (User_Mode_Permissions => (Execute_Allowed => 1,
                                    Write_Allowed => 0,
                                    Read_Allowed => 1),
          others => <>);

      Type1_Read_Write_Permissions : constant Bus_Master_Permissions_Type1 :=
         (User_Mode_Permissions => (Execute_Allowed => 0,
                                    Write_Allowed => 1,
                                    Read_Allowed => 1),
          others => <>);

      Type1_Read_Only_Permissions : constant Bus_Master_Permissions_Type1 :=
         (User_Mode_Permissions => (Execute_Allowed => 0,
                                    Write_Allowed => 0,
                                    Read_Allowed => 1),
          others => <>);

      CESR_Value : CESR_Register_Type;
      WORD2_Value : WORD2_Register_Type;
      WORD3_Value : WORD3_Register_Type;
      Dummy_Type2_Permissions : Bus_Master_Permissions_Type2;
   begin
      if System.BB.Parameters.Use_MPU then
         --
         --  Verify that the MPU has enough regions:
         --
         CESR_Value := MPU_Registers.CESR;
         pragma Assert (Natural (CESR_Value.NRGD) <=
                        Num_Mpu_Regions_Table'Last);

         Memory_Protection_Var.Num_Regions :=
            Num_Mpu_Regions_Table (Natural (CESR_Value.NRGD));

         pragma Assert (Memory_Protection_Var.Num_Regions >=
                        MPU_Region_Id_Type'Enum_Rep (
                           MPU_Region_Id_Type'Last));

         --
         --  Disable MPU to configure it:
         --
         MPU_Registers.CESR := (VLD => 0, others => <>);

         --
         --  Disable access to all regions other than the background region:
         --
         WORD3_Value := (VLD => 0, others => <>);
         WORD2_Value := (others => <>);
         for I in Default_Background_Region'Enum_Rep + 1 ..
                  Region_Index_Type'Last loop
            MPU_Registers.Region_Descriptors (I).WORD2 := WORD2_Value;
            MPU_Registers.Region_Descriptors (I).WORD3 := WORD3_Value;
         end loop;

         --
         --  Set global region for executable code and constants in flash:
         --
         Define_MPU_Region (
            Global_Flash_Code_Region,
            Cpu_Core0,
            Flash_Text_Start'Address,
            To_Address (To_Integer (Rom_End'Address) - 1),
            Type1_Read_Execute_Permissions,
            Dummy_Type2_Permissions);

         --
         --  Set global region for executable code in RAM:
         --
         Define_MPU_Region (
            Global_RAM_Code_Region,
            Cpu_Core0,
            RAM_Text_Start'Address,
            To_Address (To_Integer (RAM_Text_End'Address) - 1),
            Type1_Read_Execute_Permissions,
            Dummy_Type2_Permissions);

         --
         --  Set global region for ISR stack:
         --
         Define_MPU_Region (
            Global_Interrupt_Stack_Region,
            Cpu_Core0,
            Interrupt_Stack_Start'Address,
            To_Address (To_Integer (Interrupt_Stack_End'Address) - 1),
            Type1_Read_Write_Permissions,
            Dummy_Type2_Permissions);

         --
         --  Set global region for accessing the MPU I/O registers:
         --
         --  NOTE: Once the background region is disabled for writes,
         --  we won't be able to modify any MPU region descriptor unless
         --  we reserve a region for the MPU itself.
         --
         Define_MPU_Region (
            Global_MPU_IO_Region,
            Cpu_Core0,
            MPU_Registers'Address,
            Last_Address (MPU_Registers'Address, MPU_Registers'Size),
            Type1_Read_Write_Permissions,
            Dummy_Type2_Permissions);

         --
         --  NOTE: We do not need to set a region for the ARM core
         --  memory-mapped control registers (private peripheral area:
         --  16#E000_0000# .. 16#E00F_FFFF#), as they are always accessible
         --  regardless of the MPU settings.
         --

         if Secret_Areas_Enabled then
            --
            --  Disable access to the background region for all masters:
            --
            MPU_Registers.RGDAAC (Default_Background_Region'Enum_Rep) :=
               (others => <>);

            --
            --  NOTE: We cannot physically disable the default background
            --  region as that will cause a hard fault.
            --  MPU_Registers.Region_Descriptors (
            --    Default_Background_Region'Enum_Rep).WORD3 :=
            --    (VLD => 0, others => <>);
            --

            --
            --  Set MPU region that represents the global background region
            --  to have read-only permissions:
            --
            Define_MPU_Region (
               Global_Background_Data_Region,
               Cpu_Core0,
               Global_Background_Data_Region_Start'Address,
               To_Address (Integer_Address (Unsigned_32'Last)),
               Type1_Read_Only_Permissions,
               Dummy_Type2_Permissions);
         else
            --
            --  Use the MPU default background region as the global
            --  background region:
            --

            --
            --  Disable access to the background region for all masters, except
            --  for the CPU. For the CPU enable Read-only access by default.
            --
            MPU_Registers.RGDAAC (Default_Background_Region'Enum_Rep) :=
               (Bus_Master_CPU_Core_Perms =>
                   (User_Mode_Permissions => (Read_Allowed => 1,
                                              Write_Allowed => 0,
                                              Execute_Allowed => 0),
                    others => <>),
                others => <>);
         end if;

         --
         --  NOTE: Leave the MPU disabled, so that the Ada runtime startup code
         --  and global package elaboration can execute normally.
         --  The application's main rpogram is expected to call Enable_MPU
         --
      else
         MPU_Registers.CESR := (VLD => 0, others => <>);
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
      Rounded_Down_First_Address : constant System.Address :=
         Round_Down_Address (First_Address, MPU_Region_Alignment);
      Rounded_Up_Last_Address : constant System.Address :=
         Round_Up_Address (Last_Address, MPU_Region_Alignment);
      Type1_Read_Write_Permissions : constant Bus_Master_Permissions_Type1 :=
         (User_Mode_Permissions => (Execute_Allowed => 0,
                                    Write_Allowed => 1,
                                    Read_Allowed => 1),
          others => <>);

      Type1_Read_Only_Permissions : constant Bus_Master_Permissions_Type1 :=
         (User_Mode_Permissions => (Execute_Allowed => 0,
                                    Write_Allowed => 0,
                                    Read_Allowed => 1),
          others => <>);

      Type1_Permissions : constant Bus_Master_Permissions_Type1 :=
         (if Permissions = Read_Write then Type1_Read_Write_Permissions
          else Type1_Read_Only_Permissions);

      MPU_Region_Descriptor : Kinetis_K64F.MPU.Region_Descriptor_Type with
         Import, Address => Region'Address;
   begin
      pragma Assert (Region'Size = MPU_Region_Descriptor'Size);
      MPU_Region_Descriptor.WORD0 :=
         Unsigned_32 (To_Integer (Rounded_Down_First_Address));
      MPU_Region_Descriptor.WORD1 :=
        Unsigned_32 (To_Integer (Rounded_Up_Last_Address));
      MPU_Region_Descriptor.WORD2 :=
        (Bus_Master_CPU_Core_Perms => Type1_Permissions,
         others => <>);
      MPU_Region_Descriptor.WORD3 := (VLD => 1, others => <>);
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
      Size_In_Bytes : constant Integer_Address := Size_In_Bits / Byte'Size;
      Last_Address : constant Address :=
         To_Address (Round_Up (To_Integer (Start_Address) + Size_In_Bytes,
                               MPU_Region_Alignment) - 1);
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
      Rounded_Down_First_Address : constant System.Address :=
         Round_Down_Address (First_Address, MPU_Region_Alignment);
      Rounded_Up_Last_Address : constant System.Address :=
         Round_Up_Address (Last_Address, MPU_Region_Alignment);
      Type1_Permissions : constant Bus_Master_Permissions_Type1 :=
         (User_Mode_Permissions => (Execute_Allowed => 1,
                                    Write_Allowed => 0,
                                    Read_Allowed => 1),
          others => <>);

      MPU_Region_Descriptor : Kinetis_K64F.MPU.Region_Descriptor_Type with
         Import, Address => Region'Address;
   begin
      MPU_Region_Descriptor.WORD0 :=
         Unsigned_32 (To_Integer (Rounded_Down_First_Address));
      MPU_Region_Descriptor.WORD1 :=
         Unsigned_32 (To_Integer (Rounded_Up_Last_Address));
      MPU_Region_Descriptor.WORD2 :=
        (Bus_Master_CPU_Core_Perms => Type1_Permissions, others => <>);
      MPU_Region_Descriptor.WORD3 := (VLD => 1, others => <>);
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
      Region_Index : constant Region_Index_Type := Region_Id'Enum_Rep;
      MPU_Region_Descriptor : Kinetis_K64F.MPU.Region_Descriptor_Type with
        Import, Address => Saved_Region'Address;
   begin
      MPU_Registers.Region_Descriptors (Region_Index).WORD0 :=
         MPU_Region_Descriptor.WORD0;
      MPU_Registers.Region_Descriptors (Region_Index).WORD1 :=
         MPU_Region_Descriptor.WORD1;
      MPU_Registers.Region_Descriptors (Region_Index).WORD2 :=
         MPU_Region_Descriptor.WORD2;
      MPU_Registers.Region_Descriptors (Region_Index).WORD3 :=
         MPU_Region_Descriptor.WORD3;
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

   --------------------------------
   -- Save_MPU_Region_Descriptor --
   --------------------------------

   procedure Save_MPU_Region_Descriptor (
      Region_Id : MPU_Region_Id_Type;
      Saved_Region : out MPU_Region_Descriptor_Type)
   is
      Region_Index : constant Region_Index_Type := Region_Id'Enum_Rep;
      MPU_Region_Descriptor : Kinetis_K64F.MPU.Region_Descriptor_Type with
        Import, Address => Saved_Region'Address;
   begin
      MPU_Region_Descriptor.WORD0 :=
         MPU_Registers.Region_Descriptors (Region_Index).WORD0;
      MPU_Region_Descriptor.WORD1 :=
         MPU_Registers.Region_Descriptors (Region_Index).WORD1;
      MPU_Region_Descriptor.WORD2 :=
         MPU_Registers.Region_Descriptors (Region_Index).WORD2;
      MPU_Region_Descriptor.WORD3 :=
         MPU_Registers.Region_Descriptors (Region_Index).WORD3;
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
      Type1_Read_Write_Permissions : constant Bus_Master_Permissions_Type1 :=
         (User_Mode_Permissions => (Execute_Allowed => 0,
                                    Write_Allowed => 1,
                                    Read_Allowed => 1),
          others => <>);

      Type1_Read_Only_Permissions : constant Bus_Master_Permissions_Type1 :=
         (User_Mode_Permissions => (Execute_Allowed => 0,
                                    Write_Allowed => 0,
                                    Read_Allowed => 1),
          others => <>);

      WORD2_Value : WORD2_Register_Type;
      Type1_Permissions : Bus_Master_Permissions_Type1;
      Type2_Permissions : Bus_Master_Permissions_Type2;
      RGDAAC_Value : RGDAAC_Register_Type;
      Old_Intr_Mask : Word;

   begin
      if not System.BB.Parameters.Use_MPU then
         Old_Enabled := True;
         return;
      end if;

      Old_Intr_Mask := Disable_Cpu_Interrupts;

      if Secret_Areas_Enabled then
         WORD2_Value := MPU_Registers.Region_Descriptors (
            Global_Background_Data_Region'Enum_Rep).WORD2;

         Old_Enabled := (WORD2_Value.Bus_Master_CPU_Core_Perms.
                           User_Mode_Permissions.Write_Allowed = 1);

         if Enabled then
            Type1_Permissions := Type1_Read_Write_Permissions;
         else
            Type1_Permissions := Type1_Read_Only_Permissions;
         end if;

         Define_MPU_Region (
            Global_Background_Data_Region,
            Cpu_Core0,
            Global_Background_Data_Region_Start'Address,
            To_Address (Integer_Address (Unsigned_32'Last)),
            Type1_Permissions,
            Type2_Permissions);
      else
         RGDAAC_Value :=
            MPU_Registers.RGDAAC (Default_Background_Region'Enum_Rep);

         --
         --  NOTE: We are assuming here that we have permission to write to
         --  Old_Enabled. One way the caller can ensure that is to use a
         --  a local variable as Old_Enabled, as it will be on the stack
         --  and the stack is always writable.
         --
         Old_Enabled :=
            (RGDAAC_Value.Bus_Master_CPU_Core_Perms.User_Mode_Permissions.
                Write_Allowed = 1);

         RGDAAC_Value.Bus_Master_CPU_Core_Perms.User_Mode_Permissions.
            Write_Allowed := (if Enabled then 1 else 0);

         MPU_Registers.RGDAAC (Default_Background_Region'Enum_Rep) :=
            RGDAAC_Value;
      end if;

      Memory_Barrier;
      Restore_Cpu_Interrupts (Old_Intr_Mask);
   end Set_CPU_Writable_Background_Region;

   --------------------
   -- Set_DMA_Region --
   --------------------

   procedure Set_DMA_Region (Region_Id : MPU_Region_Id_Type;
                             DMA_Master : Bus_Master_Type;
                             Start_Address : System.Address;
                             Size_In_Bits : Integer_Address;
                             Permissions : Data_Permissions_Type)
   is
      First_Address : constant Address :=
         Round_Down_Address (Start_Address, MPU_Region_Alignment);

      Size_In_Bytes : constant Integer_Address := Size_In_Bits / Byte'Size;
      Last_Address : constant Address :=
         To_Address (if Size_In_Bytes = 0 then
                        Integer_Address'Last
                     else
                        Round_Up (To_Integer (Start_Address) + Size_In_Bytes,
                                  MPU_Region_Alignment) - 1);

      Type1_Read_Write_Permissions : constant Bus_Master_Permissions_Type1 :=
         (User_Mode_Permissions => (Execute_Allowed => 0,
                                    Write_Allowed => 1,
                                    Read_Allowed => 1),
          others => <>);

      Type1_Read_Only_Permissions : constant Bus_Master_Permissions_Type1 :=
         (User_Mode_Permissions => (Execute_Allowed => 0,
                                    Write_Allowed => 0,
                                    Read_Allowed => 1),
          others => <>);

      Type2_Read_Write_Permissions : constant Bus_Master_Permissions_Type2 :=
         (Write_Allowed => 1, Read_Allowed => 1);

      Type2_Read_Only_Permissions : constant Bus_Master_Permissions_Type2 :=
         (Write_Allowed => 0, Read_Allowed => 1);

      Type1_Permissions : Bus_Master_Permissions_Type1;
      Type2_Permissions : Bus_Master_Permissions_Type2;
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      if Permissions = Read_Only then
         if DMA_Master <= DMA_Device_ENET then
            Type1_Permissions := Type1_Read_Only_Permissions;
         else
            Type2_Permissions := Type2_Read_Only_Permissions;
         end if;
      else
         pragma Assert (Permissions = Read_Write);
         if DMA_Master <= DMA_Device_ENET then
            Type1_Permissions := Type1_Read_Write_Permissions;
         else
            Type2_Permissions := Type2_Read_Write_Permissions;
         end if;
      end if;

      pragma Assert (
         MPU_Registers.Region_Descriptors (Region_Id'Enum_Rep).WORD3.VLD = 0);

      Define_MPU_Region (Region_Id,
                         DMA_Master,
                         First_Address,
                         Last_Address,
                         Type1_Permissions,
                         Type2_Permissions);

   end Set_DMA_Region;

   -----------------------------
   -- Set_Private_Code_Region --
   -----------------------------

   procedure Set_Private_Code_Region (
      First_Address : System.Address;
      Last_Address : System.Address)
   is
      New_Region : constant Code_Region_Type :=
         (First_Address => Round_Down_Address (First_Address,
                                               MPU_Region_Alignment),
          Last_Address => Round_Up_Address (Last_Address,
                                            MPU_Region_Alignment),
          Enabled => True);
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      Define_Private_Code_Region (Region => New_Region);
   end Set_Private_Code_Region;

   -----------------------------
   -- Set_Private_Code_Region --
   -----------------------------

   procedure Set_Private_Code_Region (
      First_Address : System.Address;
      Last_Address : System.Address;
      Old_Region : out MPU_Region_Descriptor_Type)
   is
      New_Region : constant Code_Region_Type :=
         (First_Address => Round_Down_Address (First_Address,
                                               MPU_Region_Alignment),
          Last_Address => Round_Up_Address (Last_Address,
                                            MPU_Region_Alignment),
          Enabled => True);
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      Save_MPU_Region_Descriptor (Region_Id => Private_Code_Region,
                                  Saved_Region => Old_Region);

      Define_Private_Code_Region (Region => New_Region);
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
      New_Region : constant Data_Region_Type :=
         (First_Address => Round_Down_Address (Start_Address,
                                               MPU_Region_Alignment),
          Last_Address => To_Address (Round_Up (To_Integer (Start_Address) +
                                                Size_In_Bits / Byte'Size,
                                                MPU_Region_Alignment) - 1),
          Permissions => Permissions);
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      Define_Private_Data_Region (
           Region_Id => Private_Data_Region,
           Region => New_Region);
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
      New_Region : constant Data_Region_Type :=
         (First_Address => Round_Down_Address (Start_Address,
                                               MPU_Region_Alignment),
          Last_Address => To_Address (Round_Up (To_Integer (Start_Address) +
                                                Size_In_Bits / Byte'Size,
                                                MPU_Region_Alignment) - 1),
          Permissions => Permissions);
   begin
      if not System.BB.Parameters.Use_MPU then
         return;
      end if;

      Save_MPU_Region_Descriptor (Region_Id => Private_Data_Region,
                                  Saved_Region => Old_Region);

      Define_Private_Data_Region (
           Region_Id => Private_Data_Region,
           Region => New_Region);
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
      Region_Index : constant Region_Index_Type :=
         Region_Id'Enum_Rep;
   begin
      --
      --  Disable access to the region:
      --
      MPU_Registers.Region_Descriptors (Region_Index).WORD3 :=
         (VLD => 0, others => <>);
   end Undefine_MPU_Region;

   ----------------------
   -- Unset_DMA_Region --
   ----------------------

   procedure Unset_DMA_Region (Region_Id : MPU_Region_Id_Type)
   is
   begin
      Undefine_MPU_Region (Region_Id);
   end Unset_DMA_Region;

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
