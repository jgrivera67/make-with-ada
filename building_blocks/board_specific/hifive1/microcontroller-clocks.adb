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
with FE310.AON;
with FE310.PRIC;
with FE310.SPI;
with FE310.CLINT;
with Microcontroller.MCU_Specific;

package body Microcontroller.Clocks with
   SPARK_Mode => Off
is
   use FE310;

   --
   --  Iniitalize the microcontroller clocks
   --
   procedure Initialize is
      procedure Pll_Init;

      procedure Pll_Init is
         PLLCFG_Value : PRIC.PLLCFG_Register;
         PLLOUTDIV_Value : PRIC.PLLOUTDIV_Register;
         SPI_SCKDIV_Value : SPI.SCKDIV_Register;
         MTIME_LO_Value1 : Uint32;
         MTIME_LO_Value2 : Uint32;
      begin
         --
         --  Ensure the PLL is not selected as clock source, before configuring
         --  it:
         --
	 PLLCFG_Value := PRIC.PRIC_Periph.PLLCFG;
         PLLCFG_Value.SEL := PRIC.Internal;
         PRIC.PRIC_Periph.PLLCFG := PLLCFG_Value;

         --
         --  Set the QSPI clock divider appropriately
         --  before boosting the clock frequency (Div = f_sck/2):
         SPI_SCKDIV_Value.SCALE := 8;
         SPI.QSPI0_Periph.SCKDIV := SPI_SCKDIV_Value;

         --
         --  Set final output divide to divide-by-1:
         --
         PLLOUTDIV_Value.DIV_BY_1 := 1;
         PLLOUTDIV_Value.DIV := 0;
         PRIC.PRIC_Periph.PLLOUTDIV := PLLOUTDIV_Value;

         --
         --  Set DIV Settings for PLL
         --  Both HFROSC and HFXOSC are modeled as ideal
         --  16MHz sources (assuming dividers are set properly for HFROSC).
         --  (Legal values of f_REF are 6-48MHz)
         --
         --  - Set DIVR to divide-by-2 to get 8MHz frequency
         --    (legal values of f_R are 6-12 MHz)
         --  - Set DIVF to get 512Mhz frequency. There is an implied
         --    multiply-by-2, 16Mhz. So need to write 32-1
         --    (legal values of f_F are 384-768 MHz)
         --  - Set DIVQ to divide-by-2 to get 256 MHz frequency
         --    (legal values of f_Q are 50-400Mhz)
         --
         PLLCFG_Value.REFSEL := PRIC.Internal;
         PLLCFG_Value.BYPASS := 1;
         PLLCFG_Value.R := 1;
         PLLCFG_Value.F := 31;
         PLLCFG_Value.Q := 1;
         PRIC.PRIC_Periph.PLLCFG := PLLCFG_Value;

         --
         --  Un-Bypass the PLL:
         --
         PLLCFG_Value := PRIC.PRIC_Periph.PLLCFG;
         PLLCFG_Value.BYPASS := 0;
         PRIC.PRIC_Periph.PLLCFG := PLLCFG_Value;

         --
         --  Wait for PLL Lock
         --  Note that the Lock signal can be glitchy.
         --  Need to wait 100 us. RTC is running at 32kHz, so wait 4 ticks of
         --  RTC:
         --
         MTIME_LO_Value1 := CLINT.CLINT_Periph.MTIME_LO;
         loop
            MTIME_LO_Value2 := CLINT.CLINT_Periph.MTIME_LO;
            exit when MTIME_LO_Value2 - MTIME_LO_Value1 >= 4;
         end loop;

         --
         --   Now it is safe to check for PLL Lock:
         --
         loop
            PLLCFG_Value := PRIC.PRIC_Periph.PLLCFG;
            exit when PLLCFG_Value.LOCK = 1;
         end loop;

         --
         --  Select PLL as clock source:
         --
         PLLCFG_Value := PRIC.PRIC_Periph.PLLCFG;
         PLLCFG_Value.SEL := PRIC.Pll;
         PRIC.PRIC_Periph.PLLCFG := PLLCFG_Value;
      end Pll_Init;

      LFROSCCFG_Value : AON.LFROSCCFG_Register;
      HFROSCCFG_Value : PRIC.HFROSCCFG_Register;
   begin -- Initialize
      --
      --  Turn off LFROSC
      --
      LFROSCCFG_Value := AON.AON_Periph.LFROSCCFG;
      LFROSCCFG_Value.ENABLE := 0;
      AON.AON_Periph.LFROSCCFG := LFROSCCFG_Value;

      --
      --  Make sure the HFROSC is running at its default setting
      --
      HFROSCCFG_Value.DIV := 4;
      HFROSCCFG_Value.TRIM := 16;
      HFROSCCFG_Value.ENABLE := 1;
      PRIC.PRIC_Periph.HFROSCCFG := HFROSCCFG_Value;
      loop
         HFROSCCFG_Value := PRIC.PRIC_Periph.HFROSCCFG;
         exit when HFROSCCFG_Value.READY = 1;
      end loop;

      Pll_Init;

      Microcontroller.MCU_Specific.Measure_CPU_Frequency;
   end Initialize;

end Microcontroller.Clocks;
