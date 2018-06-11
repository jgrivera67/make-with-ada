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
-- MPL3115A2 barometric pressure sensor registers
--
private package Barometric_Pressure_Sensor.Mpl3115A2_Private is
   use Interfaces.Bit_Types;

   type Barometric_Pressure_Sensor_Registers_Type is
      (REG_STATUS,
       REG_OUT_P_MSB,
       REG_OUT_P_CSB,
       REG_OUT_P_LSB,
       REG_OUT_T_MSB,
       REG_OUT_T_LSB,
       REG_DR_STATUS,
       REG_OUT_P_DELTA_MSB,
       REG_OUT_P_DELTA_CSB,
       REG_OUT_P_DELTA_LSB,
       REG_OUT_T_DELTA_MSB,
       REG_OUT_T_DELTA_LSB,
       REG_WHO_AM_I,
       REG_F_STATUS,
       REG_F_DATA,
       REG_F_SETUP,
       REG_TIME_DLY,
       REG_SYSMOD,
       REG_INT_SOURCE,
       REG_PT_DATA_CFG,
       REG_BAR_IN_MSB,
       REG_BAR_IN_LSB,
       REG_P_TGT_MSB,
       REG_P_TGT_LSB,
       REG_T_TGT,
       REG_P_WND_MSB,
       REG_P_WND_LSB,
       REG_T_WND,
       REG_P_MIN_MSB,
       REG_P_MIN_CSB,
       REG_P_MIN_LSB,
       REG_T_MIN_MSB,
       REG_T_MIN_LSB,
       REG_P_MAX_MSB,
       REG_P_MAX_CSB,
       REG_P_MAX_LSB,
       REG_T_MAX_MSB,
       REG_T_MAX_LSB,
       REG_CTRL_REG1,
       REG_CTRL_REG2,
       REG_CTRL_REG3,
       REG_CTRL_REG4,
       REG_CTRL_REG5,
       REG_OFF_P,
       REG_OFF_T,
       REG_OFF_H)
      with Size => Byte'Size;

   for Barometric_Pressure_Sensor_Registers_Type use
      (REG_STATUS => 16#00#,
       REG_OUT_P_MSB => 16#01#,
       REG_OUT_P_CSB => 16#02#,
       REG_OUT_P_LSB => 16#03#,
       REG_OUT_T_MSB => 16#04#,
       REG_OUT_T_LSB => 16#05#,
       REG_DR_STATUS => 16#06#,
       REG_OUT_P_DELTA_MSB => 16#07#,
       REG_OUT_P_DELTA_CSB => 16#08#,
       REG_OUT_P_DELTA_LSB => 16#09#,
       REG_OUT_T_DELTA_MSB => 16#0A#,
       REG_OUT_T_DELTA_LSB => 16#0B#,
       REG_WHO_AM_I => 16#0C#,
       REG_F_STATUS => 16#0D#,
       REG_F_DATA => 16#0E#,
       REG_F_SETUP => 16#0F#,
       REG_TIME_DLY => 16#10#,
       REG_SYSMOD => 16#11#,
       REG_INT_SOURCE => 16#12#,
       REG_PT_DATA_CFG => 16#13#,
       REG_BAR_IN_MSB => 16#14#,
       REG_BAR_IN_LSB => 16#15#,
       REG_P_TGT_MSB => 16#16#,
       REG_P_TGT_LSB => 16#17#,
       REG_T_TGT => 16#18#,
       REG_P_WND_MSB => 16#19#,
       REG_P_WND_LSB => 16#1A#,
       REG_T_WND => 16#1B#,
       REG_P_MIN_MSB => 16#1C#,
       REG_P_MIN_CSB => 16#1D#,
       REG_P_MIN_LSB => 16#1E#,
       REG_T_MIN_MSB => 16#1F#,
       REG_T_MIN_LSB => 16#20#,
       REG_P_MAX_MSB => 16#21#,
       REG_P_MAX_CSB => 16#22#,
       REG_P_MAX_LSB => 16#23#,
       REG_T_MAX_MSB => 16#24#,
       REG_T_MAX_LSB => 16#25#,
       REG_CTRL_REG1 => 16#26#,
       REG_CTRL_REG2 => 16#27#,
       REG_CTRL_REG3 => 16#28#,
       REG_CTRL_REG4 => 16#29#,
       REG_CTRL_REG5 => 16#2A#,
       REG_OFF_P => 16#2B#,
       REG_OFF_T => 16#2C#,
       REG_OFF_H => 16#2D#);

   --
   --  Expected value for REG_WHO_AM_I register
   --
   Expected_Whoam_I_Value : constant Byte := 16#C4#;

   --
   --  Minimum times (ms) between data samples
   --
   type OS_Type is (OS_6_Ms,
                    OS_10_Ms,
                    OS_18_Ms,
                    OS_34_Ms,
                    OS_66_Ms,
                    OS_130_Ms,
                    OS_258_Ms,
                    OS_512_Ms)
      with Size => UInt3'Size;

   for OS_Type use (OS_6_Ms => 2#000#,
                    OS_10_Ms => 2#001#,
                    OS_18_Ms => 2#010#,
                    OS_34_Ms => 2#011#,
                    OS_66_Ms => 2#100#,
                    OS_130_Ms => 2#101#,
                    OS_258_Ms => 2#110#,
                    OS_512_Ms => 2#111#);

   type Reg_Ctrl_Reg1_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    SBYB : Bit;
	    OST : Bit;
	    RST : Bit;
	    OS : OS_Type;
	    RAW : Bit;
	    ALT : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Reg_Ctrl_Reg1_Type use record
      Value	at 0 range 0 .. 7;
      SBYB      at 0 range 0 .. 0;
      OST       at 0 range 1 .. 1;
      RST       at 0 range 2 .. 2;
      OS        at 0 range 3 .. 5;
      RAW       at 0 range 6 .. 6;
      ALT       at 0 range 7 .. 7;
   end record;

   type Reg_Ctrl_Reg4_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    INT_EN_TCHG : Bit;
	    INT_EN_PCHG : Bit;
	    INT_EN_TTH : Bit;
	    INT_EN_PTH : Bit;
	    INT_EN_TW : Bit;
	    INT_EN_PW : Bit;
	    INT_EN_FIFO : Bit;
	    INT_EN_DRDY : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Reg_Ctrl_Reg4_Type use record
      Value	    at 0 range 0 .. 7;
      INT_EN_TCHG   at 0 range 0 .. 0;
      INT_EN_PCHG   at 0 range 1 .. 1;
      INT_EN_TTH    at 0 range 2 .. 2;
      INT_EN_PTH    at 0 range 3 .. 3;
      INT_EN_TW     at 0 range 4 .. 4;
      INT_EN_PW     at 0 range 5 .. 5;
      INT_EN_FIFO   at 0 range 6 .. 6;
      INT_EN_DRDY   at 0 range 7 .. 7;
   end record;

   type Interrupt_Pin_Type is (Int2, Int1)
     with Size => 1;

   for Interrupt_Pin_Type use
     (Int2 => 0,
      Int1 => 1);

   type Reg_Ctrl_Reg5_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    INT_CFG_TCHG : Interrupt_Pin_Type;
	    INT_CFG_PCHG : Interrupt_Pin_Type;
	    INT_CFG_TTH : Interrupt_Pin_Type;
	    INT_CFG_PTH : Interrupt_Pin_Type;
	    INT_CFG_TW : Interrupt_Pin_Type;
	    INT_CFG_PW : Interrupt_Pin_Type;
	    INT_CFG_FIFO : Interrupt_Pin_Type;
	    INT_CFG_DRDY : Interrupt_Pin_Type;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Reg_Ctrl_Reg5_Type use record
      Value		at 0 range 0 .. 7;
      INT_CFG_TCHG      at 0 range 0 .. 0;
      INT_CFG_PCHG      at 0 range 1 .. 1;
      INT_CFG_TTH       at 0 range 2 .. 2;
      INT_CFG_PTH       at 0 range 3 .. 3;
      INT_CFG_TW        at 0 range 4 .. 4;
      INT_CFG_PW        at 0 range 5 .. 5;
      INT_CFG_FIFO      at 0 range 6 .. 6;
      INT_CFG_DRDY      at 0 range 7 .. 7;
   end record;

   type Reg_Pt_Data_Cfg_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    TDEFE : Bit;
	    PDEFE : Bit;
	    DREM : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Reg_Pt_Data_Cfg_Type use record
      Value	at 0 range 0 .. 7;
      TDEFE     at 0 range 0 .. 0;
      PDEFE     at 0 range 1 .. 1;
      DREM      at 0 range 2 .. 2;
   end record;

   type Reg_Int_Source_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    SRC_TCHG : Bit;
	    SRC_PCHG : Bit;
	    SRC_TTH : Bit;
	    SRC_PTH : Bit;
	    SRC_TW : Bit;
	    SRC_PW : Bit;
	    SRC_FIFO : Bit;
	    SRC_DRDY : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Reg_Int_Source_Type use record
      Value	 at 0 range 0 .. 7;
      SRC_TCHG   at 0 range 0 .. 0;
      SRC_PCHG   at 0 range 1 .. 1;
      SRC_TTH    at 0 range 2 .. 2;
      SRC_PTH    at 0 range 3 .. 3;
      SRC_TW     at 0 range 4 .. 4;
      SRC_PW     at 0 range 5 .. 5;
      SRC_FIFO   at 0 range 6 .. 6;
      SRC_DRDY   at 0 range 7 .. 7;
   end record;

   type Reg_Dr_Status_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    TDR : Bit;
	    PDR : Bit;
	    PTDR : Bit;
	    TOW : Bit;
	    POW : Bit;
	    PTOW : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Reg_Dr_Status_Type use record
      Value	 at 0 range 0 .. 7;
      TDR        at 0 range 1 .. 1;
      PDR        at 0 range 2 .. 2;
      PTDR       at 0 range 3 .. 3;
      TOW        at 0 range 5 .. 5;
      POW        at 0 range 6 .. 6;
      PTOW       at 0 range 7 .. 7;
   end record;

end Barometric_Pressure_Sensor.Mpl3115A2_Private;
