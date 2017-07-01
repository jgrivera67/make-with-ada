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

with MK64F12.SIM;
with Microcontroller.Arm_Cortex_M;
with Ada.Interrupts.Names;
with Memory_Protection;
with Interfaces.Bit_Types;
with Runtime_Logs;

package body DMA_Driver is
   pragma SPARK_Mode (Off);
   use Interfaces;
   use MK64F12.SIM;
   use Devices.MCU_Specific.DMA;
   use Microcontroller.Arm_Cortex_M;
   use Ada.Interrupts.Names;
   use Memory_Protection;
   use Interfaces.Bit_Types;

   --
   --  State information kept for a DMA channel
   --
   type DMA_Channel_State_Type is limited record
      Enabled : Boolean := False;
      Transfer_Started : Boolean := False;
      Transfer_Error_Count : Unsigned_32 := 0;
      Completion_Callback_Ptr : DMA_Completion_Callback_Access_Type := null;
   end record;

   type DMA_Channel_Array_Type is
     array (DMA_Channel_Type) of DMA_Channel_State_Type;

   --
   --  Global state of the DMA engine
   --
   type DMA_Engine_Type is limited record
      Initialized : Boolean := False;
      DMA_Channels : DMA_Channel_Array_Type;
   end record with Alignment => MPU_Region_Alignment,
                   Size => 7 * MPU_Region_Alignment * Byte'Size;

   DMA_Engine_Var : DMA_Engine_Type;

   --
   --  Protected object to define Interrupt handlers for all DMA channels
   --
   protected DMA_Interrupts_Object is
      pragma Interrupt_Priority (Microcontroller.DMA_Interrupt_Priority);
   private
      procedure DMA_Irq_Common_Handler (DMA_Channel : DMA_Channel_Type)
         with Pre => not Are_Cpu_Interrupts_Disabled;

      procedure DMA0_Irq_Handler;
      pragma Attach_Handler (DMA0_Irq_Handler, DMA0_Interrupt);

      procedure DMA1_Irq_Handler;
      pragma Attach_Handler (DMA1_Irq_Handler, DMA1_Interrupt);

      procedure DMA2_Irq_Handler;
      pragma Attach_Handler (DMA2_Irq_Handler, DMA2_Interrupt);

      procedure DMA3_Irq_Handler;
      pragma Attach_Handler (DMA3_Irq_Handler, DMA3_Interrupt);

      procedure DMA4_Irq_Handler;
      pragma Attach_Handler (DMA4_Irq_Handler, DMA4_Interrupt);

      procedure DMA5_Irq_Handler;
      pragma Attach_Handler (DMA5_Irq_Handler, DMA5_Interrupt);

      procedure DMA6_Irq_Handler;
      pragma Attach_Handler (DMA6_Irq_Handler, DMA6_Interrupt);

      procedure DMA7_Irq_Handler;
      pragma Attach_Handler (DMA7_Irq_Handler, DMA7_Interrupt);

      procedure DMA8_Irq_Handler;
      pragma Attach_Handler (DMA8_Irq_Handler, DMA8_Interrupt);

      procedure DMA9_Irq_Handler;
      pragma Attach_Handler (DMA9_Irq_Handler, DMA9_Interrupt);

      procedure DMA10_Irq_Handler;
      pragma Attach_Handler (DMA10_Irq_Handler, DMA10_Interrupt);

      procedure DMA11_Irq_Handler;
      pragma Attach_Handler (DMA11_Irq_Handler, DMA11_Interrupt);

      procedure DMA12_Irq_Handler;
      pragma Attach_Handler (DMA12_Irq_Handler, DMA12_Interrupt);

      procedure DMA13_Irq_Handler;
      pragma Attach_Handler (DMA13_Irq_Handler, DMA13_Interrupt);

      procedure DMA14_Irq_Handler;
      pragma Attach_Handler (DMA14_Irq_Handler, DMA14_Interrupt);

      procedure DMA15_Irq_Handler;
      pragma Attach_Handler (DMA15_Irq_Handler, DMA15_Interrupt);

      procedure DMA_Error_Irq_Handler;
      pragma Attach_Handler (DMA_Error_Irq_Handler, DMA_Error_Interrupt);
   end DMA_Interrupts_Object;
   pragma Unreferenced (DMA_Interrupts_Object);

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean is (DMA_Engine_Var.Initialized);

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
      SCGC7_Value : SIM_SCGC7_Register;
      SCGC6_Value : SIM_SCGC6_Register;
      Old_Region : MPU_Region_Descriptor_Type;
      DMAMUX_CHCFG_Disabled_Value : constant DMAMUX_CHCFG_Register :=
        (others => <>);
      DMA_CR_Value : DMA_CR_Register;
   begin
      Set_Private_Data_Region (SIM_Periph'Address,
                               SIM_Periph'Size,
                               Read_Write,
                               Old_Region);

      --
      --  Enable the Clock to the DMA Module
      --
      SCGC7_Value := SIM_Periph.SCGC7;
      SCGC7_Value.DMA := SCGC7_DMA_Field_1;
      SIM_Periph.SCGC7 := SCGC7_Value;

      --
      --  Enable the Clock to the DMAMUX Module
      --
      SCGC6_Value := SIM_Periph.SCGC6;
      SCGC6_Value.DMAMUX := SCGC6_DMAMUX_Field_1;
      SIM_Periph.SCGC6 := SCGC6_Value;

      Set_Private_Data_Region (DMAMUX_Periph'Address,
                               DMAMUX_Periph'Size,
                               Read_Write);

      --
      --  Initialize each DMA channel as disabled:
      --
      for I in DMAMUX_Periph.CHCFG'Range loop
         DMAMUX_Periph.CHCFG (I) := DMAMUX_CHCFG_Disabled_Value;

         --
         --  Enable interrupts in the interrupt controller (NVIC):
         --  NOTE: This is implicitly done by the Ada runtime
         --
      end loop;

      Set_Private_Data_Region (DMA_Engine_Var'Address,
                               DMA_Engine_Var'Size,
                               Read_Write);

      DMA_Engine_Var.Initialized := True;

      Set_Private_Data_Region (DMA_Periph'Address,
                               DMA_Periph'Size,
                               Read_Write);

      DMA_CR_Value.HALT := CR_HALT_Field_1;
      DMA_Periph.CR := DMA_CR_Value;
      Restore_Private_Data_Region (Old_Region);
   end Initialize;

   ------------------------
   -- Enable_DMA_Channel --
   ------------------------

   procedure Enable_DMA_Channel
     (DMA_Channel : DMA_Channel_Type;
      DMA_Request_Source : DMA_Request_Sources_Type;
      Periodic_Trigger : Boolean := False)
   is
      DMA_Channel_State : DMA_Channel_State_Type renames
        DMA_Engine_Var.DMA_Channels (DMA_Channel);
      DMAMUX_CHCFG_Value : DMAMUX_CHCFG_Register;
      SEEI_Value : DMA_SEEI_Register;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      pragma Assert (not DMA_Channel_State.Enabled);
      pragma Assert (not DMA_Channel_State.Transfer_Started);

      DMAMUX_CHCFG_Value := DMAMUX_Periph.CHCFG (DMA_Channel);
      pragma Assert (DMAMUX_CHCFG_Value.ENBL = CHCFG_ENBL_Field_0);
      pragma Assert (DMAMUX_CHCFG_Value.TRIG = CHCFG_TRIG_Field_0);
      pragma Assert (DMAMUX_CHCFG_Value.SOURCE = CHCFG_SOURCE_Field_0);

      DMAMUX_CHCFG_Value.ENBL := CHCFG_ENBL_Field_1;
      if Periodic_Trigger then
         DMAMUX_CHCFG_Value.TRIG := CHCFG_TRIG_Field_1;
      end if;

      DMAMUX_CHCFG_Value.SOURCE := DMA_Request_Source;

      Set_Private_Data_Region (DMAMUX_Periph'Address,
                               DMAMUX_Periph'Size,
                               Read_Write,
                               Old_Region);

      DMAMUX_Periph.CHCFG (DMA_Channel) := DMAMUX_CHCFG_Value;

      Set_Private_Data_Region (DMA_Periph'Address,
                               DMA_Periph'Size,
                               Read_Write);

      --
      --  Enable DMA error interrupt for the channel:
      --
      SEEI_Value.SEEI := SEEI_SEEI_Field (DMA_Channel);
      DMA_Periph.SEEI := SEEI_Value;

      Set_Private_Data_Region (DMA_Engine_Var'Address,
                               DMA_Engine_Var'Size,
                               Read_Write);

      DMA_Channel_State.Enabled := True;
      Restore_Private_Data_Region (Old_Region);
   end Enable_DMA_Channel;

   -------------------------
   -- Disable_DMA_Channel --
   -------------------------

   procedure Disable_DMA_Channel
     (DMA_Channel : DMA_Channel_Type)
   is
      DMA_Channel_State : DMA_Channel_State_Type renames
        DMA_Engine_Var.DMA_Channels (DMA_Channel);
      DMAMUX_CHCFG_Value : DMAMUX_CHCFG_Register;
      CEEI_Value : DMA_CEEI_Register;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      pragma Assert (DMA_Channel_State.Enabled);
      pragma Assert (not DMA_Channel_State.Transfer_Started);

      DMAMUX_CHCFG_Value := DMAMUX_Periph.CHCFG (DMA_Channel);
      pragma Assert (DMAMUX_CHCFG_Value.ENBL = CHCFG_ENBL_Field_1);
      pragma Assert (DMAMUX_CHCFG_Value.SOURCE /= DMA_No_Source);
      DMAMUX_CHCFG_Value.ENBL := CHCFG_ENBL_Field_0;
      DMAMUX_CHCFG_Value.TRIG := CHCFG_TRIG_Field_0;
      DMAMUX_CHCFG_Value.SOURCE := DMA_No_Source;

      Set_Private_Data_Region (DMAMUX_Periph'Address,
                               DMAMUX_Periph'Size,
                               Read_Write,
                               Old_Region);

      DMAMUX_Periph.CHCFG (DMA_Channel) := DMAMUX_CHCFG_Value;

      Set_Private_Data_Region (DMA_Periph'Address,
                               DMA_Periph'Size,
                               Read_Write);

      --
      --  Disable DMA error interrupt for the channel:
      --
      CEEI_Value.CEEI := CEEI_CEEI_Field (DMA_Channel);
      DMA_Periph.CEEI := CEEI_Value;

      Set_Private_Data_Region (DMA_Engine_Var'Address,
                               DMA_Engine_Var'Size,
                               Read_Write);

      DMA_Channel_State.Enabled := False;

      Restore_Private_Data_Region (Old_Region);
   end Disable_DMA_Channel;

   ------------------------
   -- Start_DMA_Transfer --
   ------------------------

   procedure Start_DMA_Transfer
     (DMA_Channel : DMA_Channel_Type;
      Dest_Address : System.Address;
      Src_Address : System.Address;
      Total_Transfer_Size : DMA_Transfer_Size_Type;
      Per_Bus_Cycle_Transfer_Size : DMA_Per_Bus_Cycle_Transfer_Size_Type;
      Completion_Callback_Ptr : DMA_Completion_Callback_Access_Type)
   is
      function Encode_Per_Bus_Cycle_Transfer_Size (
         Per_Bus_Cycle_Transfer_Size : DMA_Per_Bus_Cycle_Transfer_Size_Type)
         return Natural;

      DMA_Channel_State : DMA_Channel_State_Type renames
        DMA_Engine_Var.DMA_Channels (DMA_Channel);
      Old_Region : MPU_Region_Descriptor_Type;
      TCD_Value : TCD_Type;
      SERQ_Value : DMA_SERQ_Register;

      ----------------------------------------
      -- Encode_Per_Bus_Cycle_Transfer_Size --
      ----------------------------------------

      function Encode_Per_Bus_Cycle_Transfer_Size (
         Per_Bus_Cycle_Transfer_Size : DMA_Per_Bus_Cycle_Transfer_Size_Type)
         return Natural is
      begin
         case Per_Bus_Cycle_Transfer_Size is
            when 1 =>
               return 0;
            when 2 =>
               return 1;
            when 4 =>
               return 2;
            when 16 =>
               return 4;
            when 32 =>
               return 5;
         end case;
      end Encode_Per_Bus_Cycle_Transfer_Size;

   begin
      pragma Assert (DMA_Channel_State.Enabled);
      pragma Assert (not DMA_Channel_State.Transfer_Started);

      Set_Private_Data_Region (DMA_Engine_Var'Address,
                               DMA_Engine_Var'Size,
                               Read_Write,
                               Old_Region);

      DMA_Channel_State.Completion_Callback_Ptr := Completion_Callback_Ptr;

      Set_Private_Data_Region (DMA_Periph'Address,
                               DMA_Periph'Size,
                               Read_Write);

      --
      --  Reset TCD before populating it:
      --
      DMA_Periph.TCD_Array (DMA_Channel) := TCD_Value;

      --
      --  Populate TCD:
      --
      TCD_Value.TCD_SADDR := Word (To_Integer (Src_Address));
      TCD_Value.TCD_DADDR := Word (To_Integer (Dest_Address));
      TCD_Value.TCD_ATTR.SSIZE := TCD_ATTR0_SSIZE_Field'Enum_Val (
         Encode_Per_Bus_Cycle_Transfer_Size (Per_Bus_Cycle_Transfer_Size));
      TCD_Value.TCD_ATTR.DSIZE := TCD_Value.TCD_ATTR.SSIZE'Enum_Rep;
      TCD_Value.TCD_NBYTES.NBYTES_MLNO := Word (Per_Bus_Cycle_Transfer_Size);
      if Memory_Map.Valid_MMIO_Address (Src_Address) then
         TCD_Value.TCD_SOFF := 0;
      else
         TCD_Value.TCD_SOFF := Short (Per_Bus_Cycle_Transfer_Size);
      end if;

      if Memory_Map.Valid_MMIO_Address (Dest_Address) then
         TCD_Value.TCD_DOFF := 0;
      else
         TCD_Value.TCD_DOFF := Short (Per_Bus_Cycle_Transfer_Size);
      end if;

      TCD_Value.TCD_CITER.TCD_CITER_ELINKNO.CITER :=
         TCD_CITER_ELINKNO0_CITER_Field (
            Total_Transfer_Size / Per_Bus_Cycle_Transfer_Size);
      TCD_Value.TCD_BITER.TCD_BITER_ELINKNO.BITER :=
         TCD_Value.TCD_CITER.TCD_CITER_ELINKNO.CITER;

      TCD_Value.TCD_CSR.DREQ := TCD_CSR0_DREQ_Field_1;
      TCD_Value.TCD_CSR.INTMAJOR := TCD_CSR0_INTMAJOR_Field_1;
      DMA_Periph.TCD_Array (DMA_Channel) := TCD_Value;

      --
      --  Start DMA transfer in the DMA controller:
      --
      SERQ_Value.SERQ := SERQ_SERQ_Field (DMA_Channel);
      DMA_Periph.SERQ := SERQ_Value;

      Set_Private_Data_Region (DMA_Engine_Var'Address,
                               DMA_Engine_Var'Size,
                               Read_Write);

      DMA_Channel_State.Transfer_Started := True;
      Restore_Private_Data_Region (Old_Region);
   end Start_DMA_Transfer;

   -----------------------
   -- Stop_DMA_Transfer --
   -----------------------

   procedure Stop_DMA_Transfer
     (DMA_Channel : DMA_Channel_Type)
   is
       CERQ_Value : DMA_CERQ_Register;
       Old_Region : MPU_Region_Descriptor_Type;
       DMA_Channel_State : DMA_Channel_State_Type renames
          DMA_Engine_Var.DMA_Channels (DMA_Channel);
   begin
      Set_Private_Data_Region (DMA_Periph'Address,
                               DMA_Periph'Size,
                               Read_Write,
                               Old_Region);

      CERQ_Value.CERQ := SERQ_SERQ_Field (DMA_Channel);
      DMA_Periph.CERQ := CERQ_Value;

      pragma Assert (DMA_Channel_State.Enabled);
      if DMA_Channel_State.Transfer_Started then
         Set_Private_Data_Region (DMA_Engine_Var'Address,
                                  DMA_Engine_Var'Size,
                                  Read_Write);
         DMA_Channel_State.Transfer_Started := False;
         Runtime_Logs.Error_Print ("DMA transfer aborted for channel" &
                                   DMA_Channel'Image);
      end if;

      Restore_Private_Data_Region (Old_Region);
   end Stop_DMA_Transfer;

   --
   --  Interrupt handlers
   --
   protected body DMA_Interrupts_Object is

      procedure DMA0_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (0);
      end DMA0_Irq_Handler;

      procedure DMA1_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (1);
      end DMA1_Irq_Handler;

      procedure DMA2_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (2);
      end DMA2_Irq_Handler;

      procedure DMA3_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (3);
      end DMA3_Irq_Handler;

      procedure DMA4_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (4);
      end DMA4_Irq_Handler;

      procedure DMA5_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (5);
      end DMA5_Irq_Handler;

      procedure DMA6_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (6);
      end DMA6_Irq_Handler;

      procedure DMA7_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (7);
      end DMA7_Irq_Handler;

      procedure DMA8_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (8);
      end DMA8_Irq_Handler;

      procedure DMA9_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (9);
      end DMA9_Irq_Handler;

      procedure DMA10_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (10);
      end DMA10_Irq_Handler;

      procedure DMA11_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (11);
      end DMA11_Irq_Handler;

      procedure DMA12_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (12);
      end DMA12_Irq_Handler;

      procedure DMA13_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (13);
      end DMA13_Irq_Handler;

      procedure DMA14_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (14);
      end DMA14_Irq_Handler;

      procedure DMA15_Irq_Handler is
      begin
         DMA_Irq_Common_Handler (15);
      end DMA15_Irq_Handler;

      ----------------------------
      -- DMA_Irq_Common_Handler --
      ----------------------------

      procedure DMA_Irq_Common_Handler
        (DMA_Channel : DMA_Channel_Type)
      is
         CINT_Value : DMA_CINT_Register;
         ERR_Value : DMA_ERR_Register;
         Old_Region : MPU_Region_Descriptor_Type;
         DMA_Channel_State : DMA_Channel_State_Type renames
            DMA_Engine_Var.DMA_Channels (DMA_Channel);
      begin
         Set_Private_Data_Region (DMA_Periph'Address,
                                  DMA_Periph'Size,
                                  Read_Write,
                                  Old_Region);

         CINT_Value.CINT := CINT_CINT_Field (DMA_Channel);
         DMA_Periph.CINT := CINT_Value;
         ERR_Value := DMA_Periph.ERR;
         pragma Assert (ERR_Value.ERR.Arr (DMA_Channel) = ERR_ERR0_Field_0);
         if DMA_Channel_State.Completion_Callback_Ptr /= null then
            DMA_Channel_State.Completion_Callback_Ptr (DMA_Channel, True);
         end if;
         Restore_Private_Data_Region (Old_Region);
      end DMA_Irq_Common_Handler;

      ---------------------------
      -- DMA_Error_Irq_Handler --
      ---------------------------

      procedure DMA_Error_Irq_Handler is
         ERR_Value : DMA_ERR_Register;
         CERR_Value : DMA_CERR_Register;
         Old_Region : MPU_Region_Descriptor_Type;
      begin
         Set_Private_Data_Region (DMA_Periph'Address,
                                  DMA_Periph'Size,
                                  Read_Write,
                                  Old_Region);

         ERR_Value := DMA_Periph.ERR;
         for Channel in DMA_Channel_Type loop
             if ERR_Value.ERR.Arr (Channel) = ERR_ERR0_Field_1 then
                Runtime_Logs.Error_Print ("DMA error happened for channel" &
                                          Channel'Image);

                --
                --  Clear error interrupt for the channel
                --
                CERR_Value.CERR := CERR_CERR_Field (Channel);
                DMA_Periph.CERR.CERR := CERR_Value.CERR;
             end if;
         end loop;

         Set_Private_Data_Region (DMA_Engine_Var'Address,
                                  DMA_Engine_Var'Size,
                                  Read_Write);

         for Channel in DMA_Channel_Type loop
            if ERR_Value.ERR.Arr (Channel) = ERR_ERR0_Field_1 then
               declare
                  DMA_Channel_State : DMA_Channel_State_Type renames
                     DMA_Engine_Var.DMA_Channels (Channel);
               begin
                  DMA_Channel_State.Transfer_Error_Count :=
                     DMA_Channel_State.Transfer_Error_Count + 1;
               end;
            end if;
         end loop;

         Restore_Private_Data_Region (Old_Region);
      end DMA_Error_Irq_Handler;

   end DMA_Interrupts_Object;

end DMA_Driver;
