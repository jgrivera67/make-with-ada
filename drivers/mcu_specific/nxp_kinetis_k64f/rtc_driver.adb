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
with MK64F12.RTC;
with Kinetis_K64F;
with Microcontroller.Arch_Specific;
with Microcontroller.CPU_Specific;
with Runtime_Logs;

package body RTC_Driver is
   pragma SPARK_Mode (Off);
   use MK64F12.SIM;
   use MK64F12.RTC;
   use MK64F12;
   use Microcontroller.Arch_Specific;
   use Microcontroller.CPU_Specific;

   procedure RTC_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "RTC_IRQ_Handler";

   procedure RTC_Seconds_IRQ_Handler
     with Export,
     Convention => C,
     External_Name => "RTC_Seconds_IRQ_Handler";

   -----------------------------------------------
   -- Disable_RTC_Periodic_One_Second_Interrupt --
   -----------------------------------------------

   procedure Disable_RTC_Periodic_One_Second_Interrupt is
      Old_Region : MPU_Region_Descriptor_Type;
      Old_Intmask : Word;
      IER_Value : RTC_IER_Register;
   begin
      Old_Intmask := Disable_Cpu_Interrupts;
      Set_Private_Data_Region (RTC_Periph'Address,
                               RTC_Periph'Size,
                               Read_Write,
                               Old_Region);

      IER_Value := RTC_Periph.IER;
      IER_Value.TSIE := IER_TSIE_Field_0;
      RTC_Periph.IER := IER_Value;

      Set_Private_Data_Region (RTC_Var'Address,
                               RTC_Var'Size,
                               Read_Write);

      RTC_Var.Periodic_One_Second_Callback := null;

      Restore_Private_Data_Region (Old_Region);
      Restore_Cpu_Interrupts (Old_Intmask);

   end Disable_RTC_Periodic_One_Second_Interrupt;

   ----------------------------------------------
   -- Enable_RTC_Periodic_One_Second_Interrupt --
   ----------------------------------------------

   procedure Enable_RTC_Periodic_One_Second_Interrupt (
      Periodic_One_Second_Callback : RTC_Callback_Type) is
      Old_Region : MPU_Region_Descriptor_Type;
      Old_Intmask : Word;
      IER_Value : RTC_IER_Register;
   begin
      Old_Intmask := Disable_Cpu_Interrupts;
      Set_Private_Data_Region (RTC_Var'Address,
                               RTC_Var'Size,
                               Read_Write,
                               Old_Region);

      RTC_Var.Periodic_One_Second_Callback := Periodic_One_Second_Callback;

      Set_Private_Data_Region (RTC_Periph'Address,
                               RTC_Periph'Size,
                               Read_Write);

      IER_Value := RTC_Periph.IER;
      IER_Value.TSIE := IER_TSIE_Field_1;
      RTC_Periph.IER := IER_Value;

      Restore_Private_Data_Region (Old_Region);
      Restore_Cpu_Interrupts (Old_Intmask);
   end Enable_RTC_Periodic_One_Second_Interrupt;

   ------------------
   -- Get_RTC_Time --
   ------------------

   function Get_RTC_Time return Seconds_Count
   is
      TSR_Value : MK64F12.Word;
   begin
      TSR_Value := RTC_Periph.TSR;
      return Seconds_Count (TSR_Value);
   end Get_RTC_Time;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
      SCGC6_Value : SIM_SCGC6_Register;
      SR_Value : RTC_SR_Register;
      CR_Value : RTC_CR_Register;
      TSR_Value : MK64F12.Word;
      IER_value : RTC_IER_Register;
      TAR_Value : Word;
      Old_Region : MPU_Region_Descriptor_Type;
      Old_Intmask : Word;
   begin
      Old_Intmask := Disable_Cpu_Interrupts;
      Set_Private_Data_Region (SIM_Periph'Address,
                               SIM_Periph'Size,
                               Read_Write,
                               Old_Region);

      --
      --  Enable the Clock to the RTC Module
      --
      SCGC6_Value := SIM_Periph.SCGC6;
      SCGC6_Value.RTC := SCGC6_RTC_Field_1;
      SIM_Periph.SCGC6 := SCGC6_Value;

      Set_Private_Data_Region (RTC_Periph'Address,
                               RTC_Periph'Size,
                               Read_Write);

      --
      --  Reset RTC device, if its state is invalid:
      --
      SR_Value := RTC_Periph.SR;
      if SR_Value.TIF = SR_TIF_Field_1 then
         CR_Value := RTC_Periph.CR;
         CR_Value.SWR := CR_SWR_Field_1;
         RTC_Periph.CR := CR_Value;

         CR_Value := RTC_Periph.CR;
         CR_Value.SWR := CR_SWR_Field_0;
         RTC_Periph.CR := CR_Value;

         --
         --  Set TSR value to 1 to avoid TIF flag to be set again in SR:
         --
         TSR_Value := 1;
         RTC_Periph.TSR := TSR_Value;
      end if;

      --
      --  Disable generation of all RTC interrupts:
      --
      IER_Value.TIIE := IER_TIIE_Field_0;
      IER_Value.TOIE := IER_TOIE_Field_0;
      IER_Value.TAIE := IER_TAIE_Field_0;
      IER_Value.TSIE := IER_TSIE_Field_0;
      IER_Value.WPON := IER_WPON_Field_0;
      RTC_Periph.IER := IER_Value;

      TAR_Value := 0;
      RTC_Periph.TAR := TAR_Value;

      --
      --  Enable the RTC 32KHz oscillator
      --
      CR_Value := RTC_Periph.CR;
      CR_Value.OSCE := CR_OSCE_Field_1;
      RTC_Periph.CR := CR_Value;

      --
      --  Enable RTC timer counter:
      --
      SR_Value := RTC_Periph.SR;
      SR_Value.TCE := SR_TCE_Field_1;
      RTC_Periph.SR := SR_Value;

      --
      --  Enable interrupts in the interrupt controller (NVIC):
      --
      NVIC_Setup_External_Interrupt (Kinetis_K64F.RTC_IRQ'Enum_Rep,
                                     Kinetis_K64F.RTC_Interrupt_Priority);
      NVIC_Setup_External_Interrupt (Kinetis_K64F.RTC_Seconds_IRQ'Enum_Rep,
                                     Kinetis_K64F.RTC_Interrupt_Priority);

      Set_Private_Data_Region (RTC_Var'Address,
                               RTC_Var'Size,
                               Read_Write);
      RTC_Var.Initialized := True;
      Restore_Private_Data_Region (Old_Region);
      Restore_Cpu_Interrupts (Old_Intmask);
   end Initialize;

   -------------------
   -- Set_RTC_Alarm --
   -------------------

   procedure Set_RTC_Alarm (Time_Secs : Unsigned_32;
                            RTC_Alarm_Callback : RTC_Callback_Type)
   is
      Old_Region : MPU_Region_Descriptor_Type;
      IER_value : RTC_IER_Register;
      TAR_Value : Word;
      Old_Intmask : Word;
   begin
      Old_Intmask := Disable_Cpu_Interrupts;

      --
      --  Enable the alarm interrupt:
      --
      IER_Value := RTC_Periph.IER;
      IER_Value.TAIE := IER_TAIE_Field_1;
      RTC_Periph.IER := IER_Value;

      Set_Private_Data_Region (RTC_Var'Address,
                               RTC_Var'Size,
                               Read_Write,
                               Old_Region);

      RTC_Var.Alarm_Callback := RTC_Alarm_Callback;

      Set_Private_Data_Region (RTC_Periph'Address,
                               RTC_Periph'Size,
                               Read_Write);

      TAR_Value := RTC_Periph.TSR + Time_Secs;
      RTC_Periph.TAR := TAR_Value;

      Restore_Private_Data_Region (Old_Region);
      Restore_Cpu_Interrupts (Old_Intmask);
   end Set_RTC_Alarm;

   ------------------
   -- Set_RTC_Time --
   ------------------

   procedure Set_RTC_Time (Wall_Time_Secs : Seconds_Count)
   is
      SR_Value : RTC_SR_Register;
      TSR_Value : MK64F12.Word;
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (RTC_Periph'Address,
                               RTC_Periph'Size,
                               Read_Write,
                               Old_Region);

      --
      --  Disable RTC timer counter before updading it:
      --
      SR_Value := RTC_Periph.SR;
      SR_Value.TCE := SR_TCE_Field_0;
      RTC_Periph.SR := SR_Value;

      --
      --  Update RTC timer counter
      --
      TSR_Value := MK64F12.Word (Wall_Time_Secs);
      RTC_Periph.TSR := TSR_Value;

      --
      --  Re-enable RTC timer counter:
      --
      SR_Value := RTC_Periph.SR;
      SR_Value.TCE := SR_TCE_Field_1;
      RTC_Periph.SR := SR_Value;

      Restore_Private_Data_Region (Old_Region);
   end Set_RTC_Time;

   ---------------------
   -- RTC_IRQ_Handler --
   ---------------------

   procedure RTC_IRQ_Handler is
      Old_Region : MPU_Region_Descriptor_Type;
      SR_Value : RTC_SR_Register;
      TAR_Value : MK64F12.Word;
   begin
      Set_Private_Data_Region (
	 RTC_Periph'Address,
	 RTC_Periph'Size,
	 Read_Write,
	 Old_Region);

      SR_Value := RTC_Periph.SR;
      if SR_Value.TAF = SR_TAF_Field_1 then
  	 --
 	 --  Clear interrupt source:
	 --
	 TAR_Value := 0;
	 RTC_Periph.TAR := TAR_Value;

	 if RTC_Var.Alarm_Callback /= null then
	    RTC_Var.Alarm_Callback.all;
	 end if;
      else
	 Runtime_Logs.Error_Print ("Unexpected RTC interrupt");
      end if;

      Restore_Private_Data_Region (Old_Region);
   end RTC_IRQ_Handler;

   ----------------------------
   -- RTC_Second_IRQ_Handler --
   ----------------------------

   procedure RTC_Seconds_IRQ_Handler is
   begin
      if RTC_Var.Periodic_One_Second_Callback /= null then
	 RTC_Var.Periodic_One_Second_Callback.all;
      end if;
   end RTC_Seconds_IRQ_Handler;

end RTC_Driver;
