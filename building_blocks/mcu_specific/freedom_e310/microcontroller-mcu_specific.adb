--
--  Copyright (c) 2018, German Rivera
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

with Microcontroller.Clocks;
with Microcontroller.Arch_Specific;
with Low_Level_Debug;
with FE310.CLINT;

package body Microcontroller.MCU_Specific is
   use Microcontroller.Arch_Specific;
   use FE310;

   CPU_Clock_Frequency : Hertz_Type;

   -----------------------------
   -- Find_System_Reset_Cause --
   -----------------------------

   function Find_System_Reset_Cause return System_Reset_Causes_Type
   is
   begin
      return INVALID_RESET_CAUSE; --???
   end Find_System_Reset_Cause;

   -----------------------------
   -- Get_CPU_Clock_Frequency --
   -----------------------------

   function Get_CPU_Clock_Frequency return Hertz_Type is
     (CPU_Clock_Frequency);

   ---------------------------
   -- Measure_CPU_Frequency --
   ---------------------------

   procedure Measure_CPU_Frequency is
      function Do_Measure_CPU_Frequency (N : Unsigned_32) return Hertz_Type
        with No_Inline;

      function Do_Measure_CPU_Frequency (N : Unsigned_32) return Hertz_Type is
         Mtime_Frequency : constant := 32768;
         Start_Mtime_Lo, End_Mtime_Lo : Uint32;
         Delta_Mtime_Lo : Unsigned_32;
         Start_Mcycle : Unsigned_32;
         Delta_Mcycle : Unsigned_32;
      begin
         -- Don't start measuruing until we see an mtime tick
         Start_Mtime_Lo := CLINT.CLINT_Periph.MTIME_LO;

         loop
            End_Mtime_Lo := CLINT.CLINT_Periph.MTIME_LO;
            Delta_Mtime_Lo := Unsigned_32 (End_Mtime_Lo - Start_Mtime_Lo);
            exit when Delta_Mtime_Lo /= 0;
         end loop;

	 Start_Mtime_Lo := End_Mtime_Lo;
         Start_Mcycle := Get_Mcycle;
         loop
            End_Mtime_Lo := CLINT.CLINT_Periph.MTIME_LO;
            Delta_Mtime_Lo := Unsigned_32 (End_Mtime_Lo - Start_Mtime_Lo);
            exit when Delta_Mtime_Lo >= N;
         end loop;

         Delta_Mcycle := Get_Mcycle - Start_Mcycle;
         return Hertz_Type (
            (Delta_Mcycle / Delta_Mtime_Lo) * Mtime_Frequency +
             (((Delta_Mcycle mod Delta_Mtime_Lo) * Mtime_Frequency) /
              Delta_Mtime_Lo));

      end Do_Measure_CPU_Frequency;

      Dummy_Value : Hertz_Type with Unreferenced;
   begin
      --  Warm up:
      Dummy_Value := Do_Measure_CPU_Frequency (1);

      --  Measrure for real:
      CPU_Clock_Frequency := Do_Measure_CPU_Frequency (10);
   end Measure_CPU_Frequency;

   --------------------------
   -- Pre_Elaboration_Init --
   --------------------------

   procedure Pre_Elaboration_Init is
   begin
      Microcontroller.Arch_Specific.Disable_Cpu_Interrupts;
      Low_Level_Debug.Initialize_Rgb_Led;
      Microcontroller.Clocks.Initialize;
      Low_Level_Debug.Initialize_Uart;
      Microcontroller.Arch_Specific.Interrupt_Handling_Init;
      --Microcontroller.Arch_Specific.Enable_Cpu_Interrupts;
   end Pre_Elaboration_Init;

   ------------------
   -- System_Reset --
   ------------------

   procedure System_Reset is
   begin
      --??? Set MCU register to trigger reset

      Data_Synchronization_Barrier;

      --  Wait until reset is completed.
      loop
         null;
      end loop;

   end System_Reset;

end Microcontroller.MCU_Specific;
