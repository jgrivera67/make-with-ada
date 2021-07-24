--
--  Copyright (c) 2021, German Rivera
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

with Interfaces;
with RP2040.CLOCKS;
with RP2040.PLL_SYS;
with RP2040.PLL_USB;
with RP2040.RESETS;
with RP2040.WATCHDOG;
with RP2040.XOSC;

package body Clocks is
   use Interfaces;
   use RP2040.CLOCKS;
   use RP2040.RESETS;
   use RP2040.WATCHDOG;
   use RP2040.XOSC;
   use type RP2040.Bit;
   use type RP2040.UInt3;
   use type RP2040.UInt6;
   use type RP2040.UInt12;

   -----------------------
   -- Initialize_Clocks --
   -----------------------

   procedure Initialize_Clocks with SPARK_Mode => Off is
      XOSC_MHZ : constant := 12;
      MHZ : constant := 1_000_000;

      ---------------------
      -- Init_XOSC_Clock --
      ---------------------

      procedure Init_XOSC_Clock is
         PICO_XOSC_STARTUP_DELAY_MULTIPLIER : constant := 1;
         XOSC_STATUS_Value : STATUS_Register;
      begin
         --  Initikize XOSC clock:
         XOSC_Periph.CTRL.FREQ_RANGE := Val_1_15MHZ;
         XOSC_Periph.STARTUP.DELAY_k :=
            STARTUP_DELAY_Field (((((XOSC_MHZ * MHZ) / 1000) + 128) / 256)
                                 * PICO_XOSC_STARTUP_DELAY_MULTIPLIER);
         XOSC_Periph.CTRL.ENABLE := ENABLE;
         --  Wait for XOSC to be stable
         loop
            XOSC_STATUS_Value := XOSC_Periph.STATUS;
            exit when XOSC_STATUS_Value.STABLE = 1;
         end loop;
      end Init_XOSC_Clock;

      ------------------
      -- Pll_Sys_Init --
      ------------------

      procedure Pll_Sys_Init (Refdiv : RP2040.UInt6;
                              Vco_Freq : Unsigned_32;
                              Post_Div1 : RP2040.UInt3;
                              Post_Div2 : RP2040.UInt3) is
         use RP2040.PLL_SYS;
         Ref_Mhz : constant Unsigned_32 := XOSC_MHZ / Unsigned_32 (Refdiv);
         Fbdiv : constant RP2040.UInt12 :=
            RP2040.UInt12 (Vco_Freq / (Ref_Mhz * MHZ));
         CS_Reg_Value : constant CS_Register := PLL_SYS_Periph.CS;
      begin
         --  What are we multiplying the reference clock by to get the vco freq
         --  (The regs are called div, because you divide the vco output and
         --   compare it to the refclk)
         pragma Assert (Fbdiv in 16 .. 320);

         --  postdiv1 is designed to operate with a higher input frequency
         --  than postdiv2
         pragma Assert (Post_Div2 <= Post_Div1);

         pragma Assert (Ref_Mhz <= (Vco_Freq / 16));

         --  div1 feeds into div2 so if div1 is 5 and div2 is 2 then you get a
         --  divide by 10

         if CS_Reg_Value.LOCK = 1 and then
            Refdiv = CS_Reg_Value.REFDIV and then
            Fbdiv = PLL_SYS_Periph.FBDIV_INT.FBDIV_INT and then
            Post_Div1 = PLL_SYS_Periph.PRIM.POSTDIV1 and then
            Post_Div2 = PLL_SYS_Periph.PRIM.POSTDIV2
         then
            --  do not disrupt PLL that is already correctly configured and
            --  operating
            return;
         end if;

         RESETS_Periph.RESET.pll_sys := 1;
         RESETS_Periph.RESET.pll_sys := 0;
         loop
            exit when RESETS_Periph.RESET_DONE.pll_sys = 1;
         end loop;

         --  Load VCO-related dividers before starting VCO
         PLL_SYS_Periph.CS := (REFDIV => Refdiv, others => <>);
         PLL_SYS_Periph.FBDIV_INT := (FBDIV_INT => Fbdiv, others => <>);

         --  Turn on PLL
         PLL_SYS_Periph.PWR.PD := 0;
         PLL_SYS_Periph.PWR.VCOPD := 0;

         --  Wait for PLL to lock
         loop
            exit when PLL_SYS_Periph.CS.LOCK = 1;
         end loop;

         --  Set up post dividers
         PLL_SYS_Periph.PRIM := (POSTDIV1 => Post_Div1, POSTDIV2 => Post_Div2,
                                 others => <>);

         --  Turn on post divider
         PLL_SYS_Periph.PWR.POSTDIVPD := 0;
      end Pll_Sys_Init;

      ------------------
      -- Pll_Usb_Init --
      ------------------

      procedure Pll_Usb_Init (Refdiv : RP2040.UInt6;
                              Vco_Freq : Unsigned_32;
                              Post_Div1 : RP2040.UInt3;
                              Post_Div2 : RP2040.UInt3) is
         use RP2040.PLL_USB;
         Ref_Mhz : constant Unsigned_32 := XOSC_MHZ / Unsigned_32 (Refdiv);
         Fbdiv : constant RP2040.UInt12 :=
            RP2040.UInt12 (Vco_Freq / (Ref_Mhz * MHZ));
         CS_Reg_Value : constant CS_Register := PLL_USB_Periph.CS;
      begin
         --  What are we multiplying the reference clock by to get the vco freq
         --  (The regs are called div, because you divide the vco output and
         --   compare it to the refclk)
         pragma Assert (Fbdiv in 16 .. 320);

         --  postdiv1 is designed to operate with a higher input frequency
         --  than postdiv2
         pragma Assert (Post_Div2 <= Post_Div1);

         pragma Assert (Ref_Mhz <= (Vco_Freq / 16));

         --  div1 feeds into div2 so if div1 is 5 and div2 is 2 then you get a
         --  divide by 10

         if CS_Reg_Value.LOCK = 1 and then
            Refdiv = CS_Reg_Value.REFDIV and then
            Fbdiv = PLL_USB_Periph.FBDIV_INT.FBDIV_INT and then
            Post_Div1 = PLL_USB_Periph.PRIM.POSTDIV1 and then
            Post_Div2 = PLL_USB_Periph.PRIM.POSTDIV2
         then
            --  do not disrupt PLL that is already correctly configured and
            --  operating
            return;
         end if;

         RESETS_Periph.RESET.pll_usb := 1;
         RESETS_Periph.RESET.pll_usb := 0;
         loop
            exit when RESETS_Periph.RESET_DONE.pll_usb = 1;
         end loop;

         --  Load VCO-related dividers before starting VCO
         PLL_USB_Periph.CS := (REFDIV => Refdiv, others => <>);
         PLL_USB_Periph.FBDIV_INT := (FBDIV_INT => Fbdiv, others => <>);

         --  Turn on PLL
         PLL_USB_Periph.PWR.PD := 0;
         PLL_USB_Periph.PWR.VCOPD := 0;

         --  Wait for PLL to lock
         loop
            exit when PLL_USB_Periph.CS.LOCK = 1;
         end loop;

         --  Set up post dividers
         PLL_USB_Periph.PRIM := (POSTDIV1 => Post_Div1, POSTDIV2 => Post_Div2,
                                 others => <>);

         --  Turn on post divider
         PLL_USB_Periph.PWR.POSTDIVPD := 0;
      end Pll_Usb_Init;

      -----------------------------
      -- Clock_Configure_Clk_Ref --
      -----------------------------

      procedure Clock_Configure_Clk_Ref (Src : CLK_REF_CTRL_SRC_Field;
                                         Auxsrc : CLK_REF_CTRL_AUXSRC_Field;
                                         Src_Freq : Unsigned_32;
                                         Freq : Unsigned_32)
         with Pre => Src_Freq >= Freq
      is
         use type CLK_REF_DIV_INT_Field;
         --  Div register is 24.8 int.frac divider so multiply by 2^8
         Div : constant CLK_REF_DIV_INT_Field :=
            CLK_REF_DIV_INT_Field ((Src_Freq * (2**8)) / Freq);
      begin
         --  If increasing divisor, set divisor before source. Otherwise set
         --  source before divisor. This avoids a momentary overspeed when e.g.
         --  switching to a faster source and increasing divisor to compensate.
         if Div > CLOCKS_Periph.CLK_REF_DIV.INT then
            CLOCKS_Periph.CLK_REF_DIV.INT := Div;
         end if;

         --  If switching a glitchless slice (ref or sys) to an aux source,
         --  switch away from aux *first* to avoid passing glitches when
         --  changing aux mux.
         --  Assume glitchless source 0 is no faster than the aux source.
         if  Src = clksrc_clk_ref_aux then
            CLOCKS_Periph.CLK_REF_CTRL.SRC := rosc_clksrc_ph;
            loop
               exit when (Unsigned_32 (CLOCKS_Periph.CLK_REF_SELECTED) and
                          16#1#) /= 16#0#;
            end loop;
         end if;

         --  Set aux mux first, and then glitchless mux if this clock has one
         CLOCKS_Periph.CLK_REF_CTRL.AUXSRC := Auxsrc;

         --  For Ref and Sys
         CLOCKS_Periph.CLK_REF_CTRL.SRC := Src;
         loop
            exit when (Unsigned_32 (CLOCKS_Periph.CLK_REF_SELECTED) and
                       Shift_Left (1, CLK_REF_CTRL_SRC_Field'Enum_Rep (Src)))
                       /= 16#0#;
         end loop;

         --  Enable clock. On clk_ref and clk_sys this does nothing,
         --  all other clocks have the ENABLE bit in the same position.

         --  Now that the source is configured, we can trust that the
         --  user-supplied divisor is a safe value.
         CLOCKS_Periph.CLK_REF_DIV.INT := Div;
      end Clock_Configure_Clk_Ref;

      -----------------------------
      -- Clock_Configure_Clk_Sys --
      -----------------------------

      procedure Clock_Configure_Clk_Sys (Src : CLK_SYS_CTRL_SRC_Field;
                                         Auxsrc : CLK_SYS_CTRL_AUXSRC_Field;
                                         Src_Freq : Unsigned_32;
                                         Freq : Unsigned_32)
         with Pre => Src_Freq >= Freq
      is
         use type CLK_SYS_DIV_INT_Field;
         --  Div register is 24.8 int.frac divider so multiply by 2^8
         Div : constant CLK_SYS_DIV_INT_Field :=
            CLK_SYS_DIV_INT_Field ((Src_Freq * (2**8)) / Freq);
      begin
         --  If increasing divisor, set divisor before source. Otherwise set
         --  source before divisor. This avoids a momentary overspeed when e.g.
         --  switching to a faster source and increasing divisor to compensate.
         if Div > CLOCKS_Periph.CLK_SYS_DIV.INT then
            CLOCKS_Periph.CLK_SYS_DIV.INT := Div;
         end if;

         --  If switching a glitchless slice (ref or sys) to an aux source,
         --  switch away from aux *first* to avoid passing glitches when
         --  changing aux mux.
         --  Assume glitchless source 0 is no faster than the aux source.
         if  Src = clksrc_clk_sys_aux then
            CLOCKS_Periph.CLK_SYS_CTRL.SRC := clk_ref;
            loop
               exit when (Unsigned_32 (CLOCKS_Periph.CLK_SYS_SELECTED) and
                          16#1#) /= 16#0#;
            end loop;
         end if;

         --  Set aux mux first, and then glitchless mux if this clock has one
         CLOCKS_Periph.CLK_SYS_CTRL.AUXSRC := Auxsrc;

         --  For Ref and Sys
         CLOCKS_Periph.CLK_SYS_CTRL.SRC := Src;
         loop
            exit when (Unsigned_32 (CLOCKS_Periph.CLK_SYS_SELECTED) and
                       Shift_Left (1, CLK_SYS_CTRL_SRC_Field'Enum_Rep (Src)))
                      /= 16#0#;
         end loop;

         --  Enable clock. On clk_ref and clk_sys this does nothing,
         --  all other clocks have the ENABLE bit in the same position.

         --  Now that the source is configured, we can trust that the
         --  user-suplied divisor is a safe value.
         CLOCKS_Periph.CLK_SYS_DIV.INT := Div;
      end Clock_Configure_Clk_Sys;

      -----------------------------
      -- Clock_Configure_Clk_Usb --
      -----------------------------

      procedure Clock_Configure_Clk_Usb (Auxsrc : CLK_USB_CTRL_AUXSRC_Field;
                                         Src_Freq : Unsigned_32;
                                         Freq : Unsigned_32)
         with Pre => Src_Freq >= Freq
      is
         use type CLK_USB_DIV_INT_Field;
         --  Div register is 24.8 int.frac divider so multiply by 2^8
         Div : constant CLK_USB_DIV_INT_Field :=
            CLK_USB_DIV_INT_Field ((Src_Freq * (2**8)) / Freq);
      begin
         --  If increasing divisor, set divisor before source. Otherwise set
         --  source before divisor. This avoids a momentary overspeed when e.g.
         --  switching to a faster source and increasing divisor to compensate.
         if Div > CLOCKS_Periph.CLK_USB_DIV.INT then
            CLOCKS_Periph.CLK_USB_DIV.INT := Div;
         end if;

         --  Cleanly stop the clock to avoid glitches propagating when changing
         --  aux mux.
         CLOCKS_Periph.CLK_USB_CTRL.ENABLE := 0;

         --  Set aux mux first, and then glitchless mux if this clock has one
         CLOCKS_Periph.CLK_USB_CTRL.AUXSRC := Auxsrc;

         --  Enable clock. On clk_ref and clk_sys this does nothing,
         --  all other clocks have the ENABLE bit in the same position.
         CLOCKS_Periph.CLK_USB_CTRL.ENABLE := 1;

         --  Now that the source is configured, we can trust that the
         --  user-suplied divisor is a safe value.
         CLOCKS_Periph.CLK_USB_DIV.INT := Div;
      end Clock_Configure_Clk_Usb;

      -----------------------------
      -- Clock_Configure_Clk_Adc --
      -----------------------------

      procedure Clock_Configure_Clk_Adc (Auxsrc : CLK_ADC_CTRL_AUXSRC_Field;
                                         Src_Freq : Unsigned_32;
                                         Freq : Unsigned_32)
         with Pre => Src_Freq >= Freq
      is
         use type CLK_ADC_DIV_INT_Field;
         --  Div register is 24.8 int.frac divider so multiply by 2^8
         Div : constant CLK_ADC_DIV_INT_Field :=
            CLK_ADC_DIV_INT_Field ((Src_Freq * (2**8)) / Freq);
      begin
         --  If increasing divisor, set divisor before source. Otherwise set
         --  source before divisor. This avoids a momentary overspeed when
         --  e.g. switching
         --  to a faster source and increasing divisor to compensate.
         if Div > CLOCKS_Periph.CLK_ADC_DIV.INT then
            CLOCKS_Periph.CLK_ADC_DIV.INT := Div;
         end if;

         --  Cleanly stop the clock to avoid glitches propagating when changing
         --  aux mux.
         CLOCKS_Periph.CLK_ADC_CTRL.ENABLE := 0;

         --  Set aux mux first, and then glitchless mux if this clock has one
         CLOCKS_Periph.CLK_ADC_CTRL.AUXSRC := Auxsrc;

         --  Enable clock. On clk_ref and clk_sys this does nothing,
         --  all other clocks have the ENABLE bit in the same position.
         CLOCKS_Periph.CLK_ADC_CTRL.ENABLE := 1;

         --  Now that the source is configured, we can trust that the
         --  user-suplied divisor is a safe value.
         CLOCKS_Periph.CLK_ADC_DIV.INT := Div;
      end Clock_Configure_Clk_Adc;

      -----------------------------
      -- Clock_Configure_Clk_Rtc --
      -----------------------------

      procedure Clock_Configure_Clk_Rtc (Auxsrc : CLK_RTC_CTRL_AUXSRC_Field;
                                         Src_Freq : Unsigned_32;
                                         Freq : Unsigned_32)
         with Pre => Src_Freq >= Freq
      is
         use type CLK_RTC_DIV_INT_Field;
         --  Div register is 24.8 int.frac divider so multiply by 2^8
         Div : constant CLK_RTC_DIV_INT_Field :=
            CLK_RTC_DIV_INT_Field ((Src_Freq * (2**8)) / Freq);
      begin
         --  If increasing divisor, set divisor before source. Otherwise set
         --  source before divisor. This avoids a momentary overspeed when e.g.
         --  switching to a faster source and increasing divisor to compensate.
         if Div > CLOCKS_Periph.CLK_RTC_DIV.INT then
            CLOCKS_Periph.CLK_RTC_DIV.INT := Div;
         end if;

         --  Cleanly stop the clock to avoid glitches propagating when changing
         --  aux mux.
         CLOCKS_Periph.CLK_RTC_CTRL.ENABLE := 0;

         --  Set aux mux first, and then glitchless mux if this clock has one
         CLOCKS_Periph.CLK_RTC_CTRL.AUXSRC := Auxsrc;

         --  Enable clock. On clk_ref and clk_sys this does nothing,
         --  all other clocks have the ENABLE bit in the same position.
         CLOCKS_Periph.CLK_RTC_CTRL.ENABLE := 1;

         --  Now that the source is configured, we can trust that the
         --  user-suplied divisor is a safe value.
         CLOCKS_Periph.CLK_RTC_DIV.INT := Div;
      end Clock_Configure_Clk_Rtc;

      ------------------------------
      -- Clock_Configure_Clk_Peri --
      ------------------------------

      procedure Clock_Configure_Clk_Peri (Auxsrc : CLK_PERI_CTRL_AUXSRC_Field)
      is
      begin
         --  Cleanly stop the clock to avoid glitches propagating when changing
         --  aux mux.
         CLOCKS_Periph.CLK_PERI_CTRL.ENABLE := 0;

         --  Set aux mux first, and then glitchless mux if this clock has one
         CLOCKS_Periph.CLK_PERI_CTRL.AUXSRC := Auxsrc;

         --  Enable clock. On clk_ref and clk_sys this does nothing,
         --  all other clocks have the ENABLE bit in the same position.
         CLOCKS_Periph.CLK_PERI_CTRL.ENABLE := 1;
      end Clock_Configure_Clk_Peri;

   begin
      --
      --  Configure Watchdog tick to 12MHz frequency:
      --
      WATCHDOG_Periph.TICK := (CYCLES => XOSC_MHZ, ENABLE => 1,
                                 others => <>);

      CLOCKS_Periph.CLK_SYS_RESUS_CTRL := (others => <>);

      Init_XOSC_Clock;

      --  Before we touch PLLs, switch sys and ref cleanly away from their aux
      --  sources.
      CLOCKS_Periph.CLK_SYS_CTRL.SRC := clk_ref;
      loop
         exit when Unsigned_32 (CLOCKS_Periph.CLK_SYS_SELECTED) = 16#1#;
      end loop;

      CLOCKS_Periph.CLK_REF_CTRL.SRC := rosc_clksrc_ph;
      loop
         exit when Unsigned_32 (CLOCKS_Periph.CLK_REF_SELECTED) = 16#1#;
      end loop;

      --  Configure PLLs
      --                    REF     FBDIV VCO            POSTDIV
      --  PLL SYS: 12 / 1 = 12MHz * 125 = 1500MHZ / 6 / 2 = 125MHz
      --  PLL USB: 12 / 1 = 12MHz * 40  = 480 MHz / 5 / 2 =  48MHz
      Pll_Sys_Init (1, 1500 * MHZ, 6, 2);
      Pll_Usb_Init (1, 480 * MHZ, 5, 2);

      --  Configure clocks
      --  CLK_REF = XOSC (12MHz) / 1 = 12MHz
      Clock_Configure_Clk_Ref (
                      xosc_clksrc,
                      clksrc_pll_usb,
                      12 * MHZ,
                      12 * MHZ);

      --  CLK SYS = PLL SYS (125MHz) / 1 = 125MHz
      Clock_Configure_Clk_Sys (
                      clksrc_clk_sys_aux,
                      clksrc_pll_sys,
                      125 * MHZ,
                      125 * MHZ);

      --  CLK USB = PLL USB (48MHz) / 1 = 48MHz
      Clock_Configure_Clk_Usb (
                      clksrc_pll_usb,
                      48 * MHZ,
                      48 * MHZ);

      --  CLK ADC = PLL USB (48MHZ) / 1 = 48MHz
      Clock_Configure_Clk_Adc (
                      clksrc_pll_usb,
                      48 * MHZ,
                      48 * MHZ);

      --  CLK RTC = PLL USB (48MHz) / 1024 = 46875Hz
      Clock_Configure_Clk_Rtc (
                      clksrc_pll_usb,
                      48 * MHZ,
                      46875);

      --  CLK PERI = clk_sys. Used as reference clock for Peripherals. No
      --  dividers so just select and enable
      Clock_Configure_Clk_Peri (clk_sys);
   end Initialize_Clocks;

end Clocks;
