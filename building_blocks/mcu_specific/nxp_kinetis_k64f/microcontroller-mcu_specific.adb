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

with Microcontroller.Arch_Specific;
with Microcontroller.CPU_Specific;
with Kinetis_K64F.RCM;
with Interfaces.Bit_Types;

package body Microcontroller.MCU_Specific is
   use Microcontroller.Arch_Specific;
   use Microcontroller.CPU_Specific;
   use Kinetis_K64F;
   use Interfaces.Bit_Types;

   -----------------------------
   -- Find_System_Reset_Cause --
   -----------------------------

   function Find_System_Reset_Cause return System_Reset_Causes_Type is
      SRS0_Value : RCM.SRS0_Type;
      SRS1_Value : RCM.SRS1_Type;
      Reset_Cause : System_Reset_Causes_Type := INVALID_RESET_CAUSE;
      SRS0_Byte_Value : Byte with Address => SRS0_Value'Address;
   begin
      SRS0_Value := RCM.Registers.SRS0;
      if SRS0_Value.POR = 1 then
         Reset_Cause := POWER_ON_RESET;
      elsif SRS0_Value.PIN = 1 then
         Reset_Cause := EXTERNAL_PIN_RESET;
      elsif SRS0_Value.WDOG = 1 then
         Reset_Cause := WATCHDOG_RESET;
      elsif SRS0_Byte_Value /= 0 then
         Reset_Cause := OTHER_HW_REASON_RESET;
      else
         SRS1_Value := RCM.Registers.SRS1;
         if SRS1_Value.SW = 1 then
            Reset_Cause := SOFTWARE_RESET;
         elsif SRS1_Value.MDM_AP = 1 then
            Reset_Cause := EXTERNAL_DEBUGGER_RESET;
         elsif SRS1_Value.LOCKUP = 1 then
            Reset_Cause := LOCKUP_EVENT_RESET;
         elsif SRS1_Value.SACKERR = 1 then
            Reset_Cause := STOP_ACK_ERROR_RESET;
         end if;
      end if;

      return Reset_Cause;
   end Find_System_Reset_Cause;

   ------------------
   -- System_Reset --
   ------------------

   procedure System_Reset is
      AIRCR_Value : AIRCR_Type;
      Old_Primask : Word with Unreferenced;
   begin
      Old_Primask := Disable_Cpu_Interrupts;
      Data_Synchronization_Barrier;
      AIRCR_Value := SCB.AIRCR;
      AIRCR_Value := (VECTKEY => 16#5FA#,
                      SYSRESETREQ => 1,
                      PRIGROUP => AIRCR_Value.PRIGROUP,
                      others => 0);

      SCB.AIRCR := AIRCR_Value;
      Data_Synchronization_Barrier;

      --  Wait until reset is completed.
      loop
         null;
      end loop;

   end System_Reset;

end Microcontroller.MCU_Specific;
