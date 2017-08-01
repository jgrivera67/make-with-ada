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
with Memory_Protection;

package body RTC_Driver is
   pragma SPARK_Mode (Off);
   use MK64F12.SIM;
   use MK64F12.RTC;
   use Memory_Protection;

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
      Old_Region : MPU_Region_Descriptor_Type;
   begin
      Set_Private_Data_Region (SIM_Periph'Address,
                               SIM_Periph'Size,
                               Read_Write,
                               Old_Region);

      --
      --  Enable the Clock to the CRC Module
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

      Set_Private_Data_Region (RTC_Initialized'Address,
                               RTC_Initialized'Size,
                               Read_Write);
      RTC_Initialized := True;
      Restore_Private_Data_Region (Old_Region);
   end Initialize;

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

end RTC_Driver;
