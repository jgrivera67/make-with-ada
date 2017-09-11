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

with Interfaces.Bit_Types;

--
-- MAX30101 heart rate monitor registers
--
private package Heart_Rate_Monitor.Max30101_Private is
   use Interfaces.Bit_Types;

   --
   --  Heart_Rate_Monitor registers
   --
   type Heart_Rate_Monitor_Registers_Type is
      (REG_INT_STATUS_1,
       REG_INT_STATUS_2,
       REG_INT_ENABLE_1,
       REG_INT_ENABLE_2,
       REG_FIFO_WR_PTR,
       REG_FIFO_OV_PTR,
       REG_FIFO_RD_PTR,
       REG_FIFO_DATA,
       REG_FIFO_CFG,
       REG_MODE_CFG,
       REG_SPO2_CFG,
       REG_LED_RED_PA,
       REG_LED_IR_PA,
       REG_LED_GREEN_PA,
       REG_PROXY_PA,
       REG_MULTILED_MODE_CR_12,
       REG_MULTILED_MODE_CR_34,
       REG_TEMP_INT,
       REG_TEMP_FRAC,
       REG_TEMP_CONFIG,
       REG_PROXY_INT_THR,
       REG_REV_ID,
       REG_PART_ID)
      with Size => Byte'Size;

   for Heart_Rate_Monitor_Registers_Type use
      (REG_INT_STATUS_1 => 16#00#,
       REG_INT_STATUS_2 => 16#01#,
       REG_INT_ENABLE_1 => 16#02#,
       REG_INT_ENABLE_2 => 16#03#,
       REG_FIFO_WR_PTR => 16#04#,
       REG_FIFO_OV_PTR => 16#05#,
       REG_FIFO_RD_PTR => 16#06#,
       REG_FIFO_DATA => 16#07#,
       REG_FIFO_CFG => 16#08#,
       REG_MODE_CFG => 16#09#,
       REG_SPO2_CFG => 16#0A#,
       REG_LED_RED_PA => 16#0C#,
       REG_LED_IR_PA => 16#0D#,
       REG_LED_GREEN_PA => 16#0E#,
       REG_PROXY_PA => 16#10#,
       REG_MULTILED_MODE_CR_12 => 16#11#,
       REG_MULTILED_MODE_CR_34 => 16#12#,
       REG_TEMP_INT => 16#1F#,
       REG_TEMP_FRAC => 16#20#,
       REG_TEMP_CONFIG => 16#21#,
       REG_PROXY_INT_THR => 16#30#,
       REG_REV_ID => 16#FE#,
       REG_PART_ID => 16#FF#);

   --
   --  Expected value for REG_PART_ID register
   --
   Expected_Part_Id_Value : constant Byte := 16#15#;

   --
   --  Registers Layouts
   --

   type Mode_Type is
      (Off_Mode,
       Heart_Rate_Mode,
       SpO2_Mode,
       Multi_LED_Mode)
      with Size => UInt3'Size;

   for Mode_Type use
      (Off_Mode => 2#000#,
       Heart_Rate_Mode => 2#010#,
       SpO2_Mode => 2#011#,
       Multi_LED_Mode => 2#111#);

   type Reg_Mode_Cfg_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
            Mode : Mode_Type;
	    Reset : Bit;
	    Sleep : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Reg_Mode_Cfg_Type use record
      Value	at 0 range 0 .. 7;
      Mode      at 0 range 0 .. 2;
      Reset     at 0 range 6 .. 6;
      Sleep     at 0 range 7 .. 7;
   end record;

   type Reg_Int_Enable_1_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
            Prox_Int_En : Bit;
	    Alc_Ovf_En : Bit;
	    Ppg_Rdy_En : Bit;
	    A_Full_En : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Reg_Int_Enable_1_Type use record
      Value	    at 0 range 0 .. 7;
      Prox_Int_En   at 0 range 4 .. 4;
      Alc_Ovf_En    at 0 range 5 .. 5;
      Ppg_Rdy_En    at 0 range 6 .. 6;
      A_Full_En     at 0 range 7 .. 7;
   end record;

   type Reg_Int_Status_1_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
            Pwr_Rdy_En : Bit;
            Prox_Int_En : Bit;
	    Alc_Ovf_En : Bit;
	    Ppg_Rdy_En : Bit;
	    A_Full_En : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Reg_Int_Status_1_Type use record
      Value	    at 0 range 0 .. 7;
      Pwr_Rdy_En    at 0 range 0 .. 0;
      Prox_Int_En   at 0 range 4 .. 4;
      Alc_Ovf_En    at 0 range 5 .. 5;
      Ppg_Rdy_En    at 0 range 6 .. 6;
      A_Full_En     at 0 range 7 .. 7;
   end record;

  type Reg_Fifo_Cfg_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
            Fifo_A_Full : UInt4;
            Fifo_Rollover_En : Bit;
	    Smp_Ave : UInt3;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Reg_Fifo_Cfg_Type use record
      Value	        at 0 range 0 .. 7;
      Fifo_A_Full       at 0 range 0 .. 3;
      Fifo_Rollover_En  at 0 range 4 .. 4;
      Smp_Ave           at 0 range 5 .. 7;
   end record;

end Heart_Rate_Monitor.Max30101_Private;
