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

with MK64F12.LLWU;
with MK64F12.SMC;
with Microcontroller.CPU_Specific;
with Devices.MCU_Specific;
with Kinetis_K64F.PORT;
with RTOS.API;
with Runtime_Logs;
with Kinetis_K64F.MCG;

package body Low_Power_Driver
   with SPARK_Mode => Off
is
   use MK64F12.LLWU;
   use MK64F12.SMC;
   use Devices.MCU_Specific;
   use Kinetis_K64F.PORT;
   use Microcontroller.CPU_Specific;
   use Kinetis_K64F;

   procedure Set_Low_Leakage_Stop_Mode (Very_Low : Boolean;
                                        Wakeup_Callback : Wakeup_Callback_Type);

   procedure Set_Run_Mode (Low_Power : Boolean);

   procedure LLWU_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "LLWU_IRQ_Handler";

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
      Old_Region : MPU_Region_Descriptor_Type;
      PMPROT_Value : SMC_PMPROT_Register;
   begin
      Set_Private_Data_Region (SMC_Periph'Address,
                               SMC_Periph'Size,
                               Read_Write,
                               Old_Region);

      --
      --  Enable being able to set low-leakage-stop mode, very-low-leakage-stop
      --  mode and very-low-power run mode:
      --
      PMPROT_Value.ALLS := PMPROT_ALLS_Field_1;
      PMPROT_Value.AVLLS := PMPROT_AVLLS_Field_1;
      PMPROT_Value.AVLP := PMPROT_AVLP_Field_1;
      SMC_Periph.PMPROT := PMPROT_Value;

      Set_Private_Data_Region (Low_Power_Var'Address,
                               Low_Power_Var'Size,
                               Read_Write);

      --
      --  Enable interrupts in the interrupt controller (NVIC):
      --
      NVIC_Setup_External_Interrupt (LLWU_IRQ'Enum_Rep,
                                     Kinetis_K64F.LLWU_Interrupt_Priority);

      Low_Power_Var.Initialized := True;
      Restore_Private_Data_Region (Old_Region);
   end Initialize;

   ----------------------------------
   -- Schedule_Low_Power_Stop_Mode --
   ----------------------------------

   procedure Schedule_Low_Power_Stop_Mode
   is
      SCR_Value : SCR_Type;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (SCB'Address,
                               SCB'Size,
                               Read_Write,
                               Old_Region);

      --
      --  Enable deep sleep mode (stop mode) in the ARM Cortex-M core, so
      --  that the MCU goes to "stop" mode, instead of "wait" mode the next time
      --  that it executes a WFI instruction:
      --
      SCR_Value := SCB.SCR;
      SCR_Value.SLEEPDEEP := 1;
      SCB.SCR := SCR_Value;

      Restore_Private_Data_Region (Old_Region);
   end Schedule_Low_Power_Stop_Mode;

   -------------------------------
   -- Set_Low_Leakage_Stop_Mode --
   -------------------------------

   procedure Set_Low_Leakage_Stop_Mode (Very_Low : Boolean;
                                        Wakeup_Callback : Wakeup_Callback_Type)
   is
      PMCTRL_Value : SMC_PMCTRL_Register;
      Dummy_PMCTRL_Value : SMC_PMCTRL_Register with Unreferenced;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (Low_Power_Var'Address,
                               Low_Power_Var'Size,
                               Read_Write,
                               Old_Region);

      Low_Power_Var.Wakeup_Callback := Wakeup_Callback;

      Set_Private_Data_Region (SMC_Periph'Address,
                               SMC_Periph'Size,
                               Read_Write);

      PMCTRL_Value := SMC_Periph.PMCTRL;
      if Very_Low then
         -- Select Very-Low-Leakage Stop (VLLS) mode:
         PMCTRL_Value.STOPM := PMCTRL_STOPM_Field_100;
      else
         -- Select Low-Leakage Stop (LLS) mode:
         PMCTRL_Value.STOPM := PMCTRL_STOPM_Field_011;
      end if;

      SMC_Periph.PMCTRL := PMCTRL_Value;

      --
      --  Do a dummy read of PMCTRL to ensure that the previous register write
      --  completes before proceeding:
      --
      --  NOTE: We have to ensure it is complete before the caller executes a
      --  WFI.
      --
      Dummy_PMCTRL_Value := SMC_Periph.PMCTRL;

      Restore_Private_Data_Region (Old_Region);
   end Set_Low_Leakage_Stop_Mode;

   ----------------------------
   -- Set_Low_Power_Run_Mode --
   ----------------------------

   procedure Set_Low_Power_Run_Mode is
   begin
      Set_Run_Mode (Low_Power => True);
   end Set_Low_Power_Run_Mode;

   -----------------------------
   -- Set_Low_Power_Stop_Mode --
   -----------------------------

   procedure Set_Low_Power_Stop_Mode (Wakeup_Callback : Wakeup_Callback_Type)
   is
   begin
      Set_Low_Leakage_Stop_Mode(Very_Low => False,
                                Wakeup_Callback => Wakeup_Callback);
   end Set_Low_Power_Stop_Mode;

   -------------------------
   -- Set_Normal_Run_Mode --
   -------------------------

   procedure Set_Normal_Run_Mode is
   begin
      Set_Run_Mode (Low_Power => False);
   end Set_Normal_Run_Mode;

   ------------------
   -- Set_Run_Mode --
   ------------------

   procedure Set_Run_Mode (Low_Power : Boolean)
   is
      PMCTRL_Value : SMC_PMCTRL_Register;
      Dummy_PMCTRL_Value : SMC_PMCTRL_Register with Unreferenced;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (SMC_Periph'Address,
                               SMC_Periph'Size,
                               Read_Write,
                               Old_Region);

      PMCTRL_Value := SMC_Periph.PMCTRL;

      if Low_Power then
         --
         --  Select very-low-power run mode:
         --
         PMCTRL_Value.RUNM := PMCTRL_RUNM_Field_10;
      else
         --
         --  Select normal run mode
         --
         PMCTRL_Value.RUNM := PMCTRL_RUNM_Field_00;
      end if;

      SMC_Periph.PMCTRL := PMCTRL_Value;

      --
      --  Do a dummy read of PMCTRL to ensure that the previous register write
      --  completes before proceeding:
      --
      --  NOTE: We have to ensure it is complete before the caller executes a
      --  WFI.
      --
      Dummy_PMCTRL_Value := SMC_Periph.PMCTRL;

      Set_Private_Data_Region (Low_Power_Var'Address,
                               Low_Power_Var'Size,
                               Read_Write);

      Low_Power_Var.Low_Power_Run_Mode := Low_Power;

      Restore_Private_Data_Region (Old_Region);
   end Set_Run_Mode;

   ----------------------------------
   -- Set_Very_Low_Power_Stop_Mode --
   ----------------------------------

   procedure Set_Very_Low_Power_Stop_Mode (
      Wakeup_Callback : Wakeup_Callback_Type) is
   begin
      Set_Low_Leakage_Stop_Mode (Very_Low => True,
                                 Wakeup_Callback => Wakeup_Callback);
   end Set_Very_Low_Power_Stop_Mode;

   ---------------------------------
   -- Set_Low_Power_Wakeup_Source --
   ---------------------------------

   procedure Set_Low_Power_Wakeup_Source (Pin_Info : Pin_Info_Type;
                                          Pin_Irq_Mode : Pin_Irq_Mode_Type)
   is
      Old_Region : MPU_Region_Descriptor_Type;
      LLWU_PE2_Value : LLWU_PE2_Register;
   begin
      Set_Private_Data_Region (LLWU_Periph'Address,
                               LLWU_Periph'Size,
                               Read_Write,
                               Old_Region);

      -- See Table 3-15. Wakeup sources for LLWU inputs
      if Pin_Info.Pin_Port = PIN_PORT_C and then
         Pin_Info.Pin_Index = 1
      then
         LLWU_PE2_Value.Arr (6) :=
            (case Pin_Irq_Mode is
                when Pin_Irq_On_Rising_Edge => PE2_WUPE4_Field_01,
                when Pin_Irq_On_Falling_Edge => PE2_WUPE4_Field_10,
                when Pin_Irq_On_Either_Edge => PE2_WUPE4_Field_11,
                when others => PE2_WUPE4_Field_00);

         LLWU_Periph.PE2 := LLWU_PE2_Value;
      else
         Runtime_Logs.Error_Print ("Unsupported Pin");
         raise Program_Error with "Unsupported Pin";
      end if;

      Set_Private_Data_Region (Low_Power_Var'Address,
                               Low_Power_Var'Size,
                               Read_Write);
      Low_Power_Var.Wakeup_Pin := Pin_Info;
      Restore_Private_Data_Region (Old_Region);
   end Set_Low_Power_Wakeup_Source;

   ----------------------
   -- LLWU_IRQ_Handler --
   ----------------------

   procedure LLWU_IRQ_Handler is
      use MK64F12;
      Old_Region : MPU_Region_Descriptor_Type;
      F1_Value : LLWU_F1_Register;
      PMSTAT_Value : SMC_PMSTAT_Register;
      SCR_Value : SCR_Type;
   begin
      RTOS.API.RTOS_Enter_Isr;
      --
      --  Low-leakage stop modes changed the MCG clock mode from PEE to PBE,
      --  so we need to change the MCG clock mode back to PEE
      --
      MCG.Registers.C1 := (FRDIV => 5, IRCLKEN => 1, CLKS => 0,
			   others => 0);

      --  Wait until output of the PLL is selected:
      loop
	 exit when MCG.Registers.S.CLKST = 2#11#;
      end loop;

      Set_Private_Data_Region (
	 LLWU_Periph'Address,
	 LLWU_Periph'Size,
	 Read_Write,
	 Old_Region);

      if Low_Power_Var.Wakeup_Pin.Pin_Port = PIN_PORT_C and then
	 Low_Power_Var.Wakeup_Pin.Pin_Index = 1
      then
	 F1_Value := LLWU_Periph.F1;
	 pragma Assert (F1_Value.WUF6 = F1_WUF6_Field_1);

	 --
	 --  Clear the wake-up flag (w1c):
	 --
	 F1_Value := (WUF6 => F1_WUF6_Field_1, others => <>);
	 LLWU_Periph.F1 := F1_Value;

	 --
	 --  Disable deep sleep mode (stop mode) in the ARM Cortex-M core, so
	 --  that the MCU goes to "wait" mode, instead of "stop" mode when
	 --  executing a WFI instruction:
	 --
	 Set_Private_Data_Region (SCB'Address,
				  SCB'Size,
				  Read_Write);
	 SCR_Value := SCB.SCR;
	 SCR_Value.SLEEPDEEP := 0;
	 SCB.SCR := SCR_Value;
      else
	 Runtime_Logs.Error_Print ("Unexpected low power wake-up Pin");
      end if;

      PMSTAT_Value := SMC_Periph.PMSTAT;
      pragma Assert (PMSTAT_Value.PMSTAT = 2#0001#);

      if Low_Power_Var.Low_Power_Run_Mode then
	 Set_Low_Power_Run_Mode;
      end if;

      Runtime_Logs.Debug_Print ("LLWU interrupt");

      if Low_Power_Var.Wakeup_Callback /= null then
	 Low_Power_Var.Wakeup_Callback.all;
      end if;

      Restore_Private_Data_Region (Old_Region);
      RTOS.API.RTOS_Exit_Isr;
   end LLWU_IRQ_Handler;

end Low_Power_Driver;
