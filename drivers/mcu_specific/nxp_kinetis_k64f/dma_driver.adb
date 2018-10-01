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
with Microcontroller.Arch_Specific;
with Microcontroller.CPU_Specific;
with Number_Conversion_Utils;
with Kinetis_K64F;
with Memory_Protection;
with Interfaces.Bit_Types;
with Runtime_Logs;
with RTOS.API;

package body DMA_Driver is
   pragma SPARK_Mode (Off);
   use Interfaces;
   use MK64F12.SIM;
   use Devices.MCU_Specific.DMA;
   use Microcontroller.Arch_Specific;
   use Microcontroller.CPU_Specific;
   use Number_Conversion_Utils;
   use Memory_Protection;
   use Interfaces.Bit_Types;

   --
   --  State information kept for a DMA channel
   --
   type DMA_Channel_State_Type is limited record
      Enabled : Boolean := False;
      Transfer_Triggered_By_Peripheral : Boolean := False;
      Transfer_Error_Count : Unsigned_32 := 0;
      Transfer_Completed : RTOS.RTOS_Semaphore_Type;
   end record;

   type DMA_Channel_Array_Type is
     array (Valid_DMA_Channel_Type) of DMA_Channel_State_Type;

   --
   --  Global state of the DMA engine
   --
   type DMA_Engine_Type is limited record
      Initialized : Boolean := False;
      DMA_Channels : DMA_Channel_Array_Type;
   end record with Alignment => Memory_Protection.MPU_Region_Alignment;

   DMA_Engine_Var : DMA_Engine_Type;

   procedure DMA0_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA0_IRQ_Handler";

   procedure DMA1_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA1_IRQ_Handler";

   procedure DMA2_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA2_IRQ_Handler";

   procedure DMA3_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA3_IRQ_Handler";

   procedure DMA4_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA4_IRQ_Handler";

   procedure DMA5_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA5_IRQ_Handler";

   procedure DMA6_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA6_IRQ_Handler";

   procedure DMA7_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA7_IRQ_Handler";

   procedure DMA8_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA8_IRQ_Handler";

   procedure DMA9_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA9_IRQ_Handler";

   procedure DMA10_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA10_IRQ_Handler";

   procedure DMA11_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA11_IRQ_Handler";

   procedure DMA12_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA12_IRQ_Handler";

   procedure DMA13_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA13_IRQ_Handler";

   procedure DMA14_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA14_IRQ_Handler";

   procedure DMA15_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA15_IRQ_Handler";

   procedure DMA_Error_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "DMA_Error_IRQ_Handler";

   procedure DMA_IRQ_Common_Handler (DMA_Channel : Valid_DMA_Channel_Type)
      with Pre => not Are_Cpu_Interrupts_Disabled;

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
      end loop;

      for Irq_Num in Kinetis_K64F.DMA0_IRQ .. Kinetis_K64F.DMA_Error_IRQ loop
         --
         --  Enable interrupts in the interrupt controller (NVIC):
         --
         NVIC_Setup_External_Interrupt (Irq_Num'Enum_Rep,
                                        Kinetis_K64F.DMA_Interrupt_Priority);
      end loop;

      Set_Private_Data_Region (DMA_Periph'Address,
                               DMA_Periph'Size,
                               Read_Write);

      --
      --  Disable DMA module before doing global configuration:
      --
      DMA_CR_Value.HALT := CR_HALT_Field_1;
      DMA_Periph.CR := DMA_CR_Value;

      --
      --  Do global configuration of DMA module:
      --  - Enable minor loop mapping for TDC word2
      --  - Select round robin arbitration of DMA channels instead of fixed
      --    prioritiy
      --  - Enable DMA module
      --
      DMA_CR_Value.EMLM := CR_EMLM_Field_1;
      DMA_CR_Value.ERCA := CR_ERCA_Field_0;
      DMA_CR_Value.HALT := CR_HALT_Field_0;
      DMA_Periph.CR := DMA_CR_Value;

      Set_Private_Data_Region (DMA_Engine_Var'Address,
                               DMA_Engine_Var'Size,
                               Read_Write);

      for DMA_Channel of DMA_Engine_Var.DMA_Channels loop
         RTOS.API.RTOS_Semaphore_Init (DMA_Channel.Transfer_Completed,
                                       Initial_Count => 0);
      end loop;

      DMA_Engine_Var.Initialized := True;

      Restore_Private_Data_Region (Old_Region);
   end Initialize;

   ------------------------
   -- Enable_DMA_Channel --
   ------------------------

   procedure Enable_DMA_Channel
     (DMA_Channel : Valid_DMA_Channel_Type;
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

      DMAMUX_CHCFG_Value := DMAMUX_Periph.CHCFG (DMA_Channel);
      pragma Assert (DMAMUX_CHCFG_Value.ENBL = CHCFG_ENBL_Field_0);
      pragma Assert (DMAMUX_CHCFG_Value.TRIG = CHCFG_TRIG_Field_0);
      pragma Assert (DMAMUX_CHCFG_Value.SOURCE = DMA_No_Source);

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
      DMA_Channel_State.Transfer_Triggered_By_Peripheral :=
         (DMA_Request_Source /= DMA_No_Source);

      Restore_Private_Data_Region (Old_Region);
   end Enable_DMA_Channel;

   -------------------------
   -- Disable_DMA_Channel --
   -------------------------

   procedure Disable_DMA_Channel
     (DMA_Channel : Valid_DMA_Channel_Type)
   is
      DMA_Channel_State : DMA_Channel_State_Type renames
        DMA_Engine_Var.DMA_Channels (DMA_Channel);
      DMAMUX_CHCFG_Value : DMAMUX_CHCFG_Register;
      CEEI_Value : DMA_CEEI_Register;
      CERQ_Value : DMA_CERQ_Register;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      pragma Assert (DMA_Channel_State.Enabled);

      DMAMUX_CHCFG_Value := DMAMUX_Periph.CHCFG (DMA_Channel);
      pragma Assert (DMAMUX_CHCFG_Value.ENBL = CHCFG_ENBL_Field_1);
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
      --  Disable triggering of DMA requests from peripheral:
      --
      if DMA_Channel_State.Transfer_Triggered_By_Peripheral then
         CERQ_Value.CERQ := CERQ_CERQ_Field (DMA_Channel);
         DMA_Periph.CERQ := CERQ_Value;
      end if;

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

   --------------------------
   -- Prepare_DMA_Transfer --
   --------------------------

   procedure Prepare_DMA_Transfer (
      DMA_Channel : Valid_DMA_Channel_Type;
      Dest_Address : System.Address;
      Increment_Dest_Address : Boolean;
      Src_Address : System.Address;
      Increment_Source_Address : Boolean;
      Total_Transfer_Size : DMA_Transfer_Size_Type;
      Per_DMA_Transaction_Transfer_Size : DMA_Transfer_Size_Type;
      Per_Bus_Cycle_Transfer_Size : DMA_Per_Bus_Cycle_Transfer_Size_Type;
      Enable_Transfer_Completion_Interrupt : Boolean := False;
      Per_DMA_Transaction_Linked_Channel : DMA_Channel_Type :=
         DMA_Channel_None;
      Transfer_Completion_Linked_Channel : DMA_Channel_Type :=
         DMA_Channel_None)
   is
      function Encode_Per_Bus_Cycle_Transfer_Size (
         Per_Bus_Cycle_Transfer_Size : DMA_Per_Bus_Cycle_Transfer_Size_Type)
         return Natural;

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

      Old_Region : MPU_Region_Descriptor_Type;
      TCD_Value : TCD_Type;
      SERQ_Value : DMA_SERQ_Register;
      CDNE_Value : DMA_CDNE_Register;
      DMA_Channel_State : DMA_Channel_State_Type renames
        DMA_Engine_Var.DMA_Channels (DMA_Channel);
   begin
      pragma Assert (DMA_Channel_State.Enabled);
      pragma Assert (RTOS.API.RTOS_Semaphore_Get_Count (
                        DMA_Channel_State.Transfer_Completed) = 0);

      Set_Private_Data_Region (DMA_Periph'Address,
                               DMA_Periph'Size,
                               Read_Write,
                               Old_Region);

      --
      --  Clear DONE Bit for the channel, before setting the channel's TCD:
      --
      CDNE_Value.CDNE := CDNE_CDNE_Field (DMA_Channel);
      DMA_Periph.CDNE := CDNE_Value;

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
      TCD_Value.TCD_ATTR.DSIZE :=
         TCD_ATTR0_DSIZE_Field (TCD_Value.TCD_ATTR.SSIZE'Enum_Rep);

      TCD_Value.TCD_NBYTES.TCD_NBYTES_MLOFFNO :=
        (SMLOE => TCD_NBYTES_MLOFFNO0_SMLOE_Field_0,
         DMLOE => TCD_NBYTES_MLOFFNO0_DMLOE_Field_0,
         NBYTES =>
            TCD_NBYTES_MLOFFNO0_NBYTES_Field (
               Per_DMA_Transaction_Transfer_Size));

      --
      --  Set source address increment after every read bus access
      --
      if Increment_Source_Address then
         TCD_Value.TCD_SOFF := Short (Per_Bus_Cycle_Transfer_Size);
      else
         TCD_Value.TCD_SOFF := 0;
      end if;

      --
      --  Set destination address increment after every write bus access
      --
      if Increment_Dest_Address then
         TCD_Value.TCD_DOFF := Short (Per_Bus_Cycle_Transfer_Size);
      else
         TCD_Value.TCD_DOFF := 0;
      end if;

      if Per_DMA_Transaction_Linked_Channel /= DMA_Channel_None then
         TCD_Value.TCD_CITER.TCD_CITER_ELINKYES.ELINK :=
            TCD_CITER_ELINKYES0_ELINK_Field_1;
         TCD_Value.TCD_CITER.TCD_CITER_ELINKYES.LINKCH :=
            TCD_CITER_ELINKYES0_LINKCH_Field (
               Per_DMA_Transaction_Linked_Channel);
         TCD_Value.TCD_CITER.TCD_CITER_ELINKYES.CITER :=
            TCD_CITER_ELINKYES0_CITER_Field (
               Total_Transfer_Size / Per_DMA_Transaction_Transfer_Size);
         TCD_Value.TCD_BITER.TCD_BITER_ELINKYES.ELINK :=
            TCD_BITER_ELINKYES0_ELINK_Field_1;
         TCD_Value.TCD_BITER.TCD_BITER_ELINKYES.LINKCH :=
            TCD_BITER_ELINKYES0_LINKCH_Field (
               Per_DMA_Transaction_Linked_Channel);
         TCD_Value.TCD_BITER.TCD_BITER_ELINKYES.BITER :=
            TCD_Value.TCD_CITER.TCD_CITER_ELINKYES.CITER;
      else
         TCD_Value.TCD_CITER.TCD_CITER_ELINKNO.ELINK :=
            TCD_CITER_ELINKNO0_ELINK_Field_0;
         TCD_Value.TCD_CITER.TCD_CITER_ELINKNO.CITER :=
            TCD_CITER_ELINKNO0_CITER_Field (
               Total_Transfer_Size / Per_DMA_Transaction_Transfer_Size);
         TCD_Value.TCD_BITER.TCD_BITER_ELINKNO.ELINK :=
            TCD_BITER_ELINKNO0_ELINK_Field_0;
         TCD_Value.TCD_BITER.TCD_BITER_ELINKNO.BITER :=
            TCD_Value.TCD_CITER.TCD_CITER_ELINKNO.CITER;
      end if;

      if Transfer_Completion_Linked_Channel /= DMA_Channel_None then
         TCD_Value.TCD_CSR.MAJORELINK := TCD_CSR0_MAJORELINK_Field_1;
         TCD_Value.TCD_CSR.MAJORLINKCH :=
            TCD_CSR0_MAJORLINKCH_Field (Transfer_Completion_Linked_Channel);
      end if;

      --
      --  Enable automatic disabling of REQ upon completion of major loop
      --  for peripheral triggered DMA transfers
      --
      if DMA_Channel_State.Transfer_Triggered_By_Peripheral then
         TCD_Value.TCD_CSR.DREQ := TCD_CSR0_DREQ_Field_1;
      end if;

      --
      --  Enable generation of interrupts on major loop completion
      --
      if Enable_Transfer_Completion_Interrupt then
         TCD_Value.TCD_CSR.INTMAJOR := TCD_CSR0_INTMAJOR_Field_1;
      end if;

      --
      --  Update TCD in the DMA module:
      --
      DMA_Periph.TCD_Array (DMA_Channel) := TCD_Value;

      if DMA_Channel_State.Transfer_Triggered_By_Peripheral then
         --
         --  Enable DMA requests triggered from a peripheral (DMA request
         --  source peripheral):
         --
         SERQ_Value.SERQ := SERQ_SERQ_Field (DMA_Channel);
         DMA_Periph.SERQ := SERQ_Value;
      end if;

      Restore_Private_Data_Region (Old_Region);
   end Prepare_DMA_Transfer;

   ------------------------
   -- Start_DMA_Transfer --
   ------------------------

   procedure Start_DMA_Transfer (DMA_Channel : Valid_DMA_Channel_Type)
   is
      Old_Region : MPU_Region_Descriptor_Type;
      SSRT_Value : DMA_SSRT_Register;
      DMA_Channel_State : DMA_Channel_State_Type renames
        DMA_Engine_Var.DMA_Channels (DMA_Channel);
   begin
      pragma Assert (not DMA_Channel_State.Transfer_Triggered_By_Peripheral);

      Set_Private_Data_Region (DMA_Periph'Address,
                               DMA_Periph'Size,
                               Read_Write,
                               Old_Region);

      --
      --  Start DMA transfer in the DMA controller:
      --
      SSRT_Value.SSRT := SSRT_SSRT_Field (DMA_Channel);
      DMA_Periph.SSRT := SSRT_Value;

      Restore_Private_Data_Region (Old_Region);
   end Start_DMA_Transfer;

   ------------------------------
   -- Wait_Until_DMA_Completed --
   ------------------------------

   procedure Wait_Until_DMA_Completed (DMA_Channel : Valid_DMA_Channel_Type)
   is
      DMA_Channel_State : DMA_Channel_State_Type renames
          DMA_Engine_Var.DMA_Channels (DMA_Channel);
   begin
      RTOS.API.RTOS_Semaphore_Wait (DMA_Channel_State.Transfer_Completed);
   end Wait_Until_DMA_Completed;

   procedure DMA0_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (0);
   end DMA0_IRQ_Handler;

   procedure DMA1_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (1);
   end DMA1_IRQ_Handler;

   procedure DMA2_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (2);
   end DMA2_IRQ_Handler;

   procedure DMA3_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (3);
   end DMA3_IRQ_Handler;

   procedure DMA4_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (4);
   end DMA4_IRQ_Handler;

   procedure DMA5_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (5);
   end DMA5_IRQ_Handler;

   procedure DMA6_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (6);
   end DMA6_IRQ_Handler;

   procedure DMA7_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (7);
   end DMA7_IRQ_Handler;

   procedure DMA8_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (8);
   end DMA8_IRQ_Handler;

   procedure DMA9_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (9);
   end DMA9_IRQ_Handler;

   procedure DMA10_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (10);
   end DMA10_IRQ_Handler;

   procedure DMA11_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (11);
   end DMA11_IRQ_Handler;

   procedure DMA12_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (12);
   end DMA12_IRQ_Handler;

   procedure DMA13_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (13);
   end DMA13_IRQ_Handler;

   procedure DMA14_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (14);
   end DMA14_IRQ_Handler;

   procedure DMA15_IRQ_Handler is
   begin
      DMA_IRQ_Common_Handler (15);
   end DMA15_IRQ_Handler;

   ----------------------------
   -- DMA_IRQ_Common_Handler --
   ----------------------------

   procedure DMA_IRQ_Common_Handler
     (DMA_Channel : Valid_DMA_Channel_Type)
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
      RTOS.API.RTOS_Semaphore_Signal (DMA_Channel_State.Transfer_Completed);

      Restore_Private_Data_Region (Old_Region);
   end DMA_IRQ_Common_Handler;

   ---------------------------
   -- DMA_Error_IRQ_Handler --
   ---------------------------

   procedure DMA_Error_IRQ_Handler is
      ERR_Value : DMA_ERR_Register;
      CERR_Value : DMA_CERR_Register;
      Old_Region : MPU_Region_Descriptor_Type;
      Dec_Num_Str : String (1 .. 2);
      Dec_Num_Str_Length : Positive;
   begin
      Set_Private_Data_Region (DMA_Periph'Address,
			       DMA_Periph'Size,
			       Read_Write,
			       Old_Region);

      ERR_Value := DMA_Periph.ERR;
      for Channel in Valid_DMA_Channel_Type loop
         if ERR_Value.ERR.Arr (Channel) = ERR_ERR0_Field_1 then
            Unsigned_To_Decimal_String (Unsigned_32 (Channel),
                                        Dec_Num_Str,
                                        Dec_Num_Str_Length);
	    Runtime_Logs.Error_Print ("DMA error happened for channel " &
			              Dec_Num_Str (1 .. Dec_Num_Str_Length));

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

      for Channel in Valid_DMA_Channel_Type loop
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
   end DMA_Error_IRQ_Handler;

end DMA_Driver;
