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
-- FXOS8700CQ accelerometer registers
--
private package Accelerometer.Fxos8700cq_Private is
   use Interfaces.Bit_Types;

   --
   --  Accelerometer registers
   --
   type Accelerometer_Registers_Type is
      (Accel_Status,
       Accel_Out_X_Msb,
       Accel_Out_Y_Msb,
       Accel_Out_Z_Msb,
       Accel_F_Setup,
       Accel_Int_Source,
       Accel_Who_Am_I,
       Accel_XYZ_Data_Cfg,
       Accel_HP_Filter_Cutoff,
       Accel_FF_MT_Cfg,
       Accel_FF_MT_Src,
       Accel_FF_MT_Threshold,
       Accel_FF_MT_Count,
       Accel_Pulse_Cfg,
       Accel_Pulse_Src,
       Accel_Pulse_Threshold_X,
       Accel_Pulse_Threshold_Y,
       Accel_Pulse_Threshold_Z,
       Accel_Pulse_Tmlt,
       Accel_Pulse_Ltcy,
       Accel_Pulse_Wind,
       Accel_Aslp_Count, --  Auto Sleep Inactivity Timer register
       Accel_Ctrl_Reg1,
       Accel_Ctrl_Reg2,
       Accel_Ctrl_Reg3,
       Accel_Ctrl_Reg4,
       Accel_Ctrl_Reg5)
      with Size => Byte'Size;

   for Accelerometer_Registers_Type use
      (Accel_Status => 16#00#,
       Accel_Out_X_Msb => 16#01#,
       Accel_Out_Y_Msb => 16#03#,
       Accel_Out_Z_Msb => 16#05#,
       Accel_F_Setup => 16#09#,
       Accel_Int_Source => 16#0C#,
       Accel_Who_Am_I => 16#0D#,
       Accel_XYZ_Data_Cfg => 16#0E#,
       Accel_HP_Filter_Cutoff => 16#0F#,
       Accel_FF_MT_Cfg => 16#15#,
       Accel_FF_MT_Src => 16#16#,
       Accel_FF_MT_Threshold => 16#17#,
       Accel_FF_MT_Count => 16#18#,
       Accel_Pulse_Cfg => 16#21#,
       Accel_Pulse_Src => 16#22#,
       Accel_Pulse_Threshold_X => 16#23#,
       Accel_Pulse_Threshold_Y => 16#24#,
       Accel_Pulse_Threshold_Z => 16#25#,
       Accel_Pulse_Tmlt => 16#26#,
       Accel_Pulse_Ltcy => 16#27#,
       Accel_Pulse_Wind => 16#28#,
       Accel_Aslp_Count => 16#29#,
       Accel_Ctrl_Reg1 => 16#2A#,
       Accel_Ctrl_Reg2 => 16#2B#,
       Accel_Ctrl_Reg3 => 16#2C#,
       Accel_Ctrl_Reg4 => 16#2D#,
       Accel_Ctrl_Reg5 => 16#2E#);

   --
   --  Magnetometer Registers:
   --
   type Magnetometer_Registers_Type is
      (Magnet_Out_X_Ms,
       Magnet_Out_Y_Ms,
       Magnet_Out_Z_Ms,
       Magnet_Ctrl_Reg1,
       Magnet_Ctrl_Reg2);

   for Magnetometer_Registers_Type use
      (Magnet_Out_X_Ms => 16#33#,
       Magnet_Out_Y_Ms => 16#35#,
       Magnet_Out_Z_Ms => 16#37#,
       Magnet_Ctrl_Reg1 => 16#5B#,
       Magnet_Ctrl_Reg2 => 16#5C#);

   --
   --  Expected value for ACCEL_WHO_AM_I register
   --
   Expected_Who_Am_I_Value : constant Byte := 16#C7#;

   --
   --  Registers Layouts
   --

   type Aslp_Rate_Type is
      (Aslp_Rate_20Ms,
       Aslp_Rate_80Ms,
       Aslp_Rate_160Ms,
       Aslp_Rate_640Ms)
      with Size => UInt2'Size;

   for Aslp_Rate_Type use
      (Aslp_Rate_20Ms    => 16#00#,
       Aslp_Rate_80Ms    => 16#01#,
       Aslp_Rate_160Ms   => 16#02#,
       Aslp_Rate_640Ms   => 16#03#);

   type Dr_Type is
      (Dr_800Hz,    --  every 1.25 ms
       Dr_400Hz,    --  every 2.5 ms
       Dr_200Hz,    --  every 5 ms
       Dr_100Hz,    --  every 10 ms
       Dr_50Hz,     --  every 20 ms
       Dr_12_5Hz,   --  every 80 ms
       Dr_6_25Hz,   --  every 160 ms
       Dr_1_56Hz)   --  every 640 ms
       with Size => UInt3'Size;

   for Dr_Type use
      (Dr_800Hz     => 16#0#,
       Dr_400Hz     => 16#1#,
       Dr_200Hz     => 16#2#,
       Dr_100Hz     => 16#3#,
       Dr_50Hz      => 16#4#,
       Dr_12_5Hz    => 16#5#,
       Dr_6_25Hz    => 16#6#,
       Dr_1_56Hz    => 16#7#);

   type Accel_Ctrl_Reg1_Register_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    Active : Bit;
	    Fread : Bit;
	    Lnoise : Bit;
	    Dr : Dr_Type;
	    Aslp_Rate : Aslp_Rate_Type := Aslp_Rate_20Ms;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Accel_Ctrl_Reg1_Register_Type use record
      Value	at 0 range 0 .. 7;
      Active    at 0 range 0 .. 0;
      Fread     at 0 range 1 .. 1;
      Lnoise    at 0 range 2 .. 2;
      Dr        at 0 range 3 .. 5;
      Aslp_Rate at 0 range 6 .. 7;
   end record;

   type Mods_Type is
      (Mods_Normal,
       Mods_Low_Noise,
       Mods_High_Res,
       Mods_Low_Power)
       with Size => Uint2'Size;

   for Mods_Type use
      (Mods_Normal       => 16#0#,
       Mods_Low_Noise    => 16#1#,
       Mods_High_Res     => 16#2#,
       Mods_Low_Power    => 16#3#);

   type Smods_Type is
      (Smod_Normal,
       Smod_Low_Noise,
       Smod_High_Res,
       Smod_Low_Power)
       with Size => Uint2'Size;

   for Smods_Type use
      (Smod_Normal       => 16#0#,
       Smod_Low_Noise    => 16#1#,
       Smod_High_Res     => 16#2#,
       Smod_Low_Power    => 16#3#);

   type Accel_Ctrl_Reg2_Register_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    Mods : Mods_Type;
	    Slpe : Bit;
	    Smods : Smods_Type;
	    Rst : Bit;
	    St : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Accel_Ctrl_Reg2_Register_Type use record
      Value at 0 range 0 .. 7;
      Mods  at 0 range 0 .. 1;
      Slpe  at 0 range 2 .. 2;
      Smods at 0 range 3 .. 4;
      Rst   at 0 range 6 .. 6;
      St    at 0 range 7 .. 7;
   end record;

   type Accel_Ctrl_Reg3_Register_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    Pp_Od : Bit;
	    Ipol : Bit;
	    Wake_Ff_Mt : Bit;
	    Wake_Pulse : Bit;
	    Wake_Lndprt : Bit;
	    Wake_Trans : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Accel_Ctrl_Reg3_Register_Type use record
      Value	    at 0 range 0 .. 7;
      Pp_Od         at 0 range 0 .. 0;
      Ipol          at 0 range 1 .. 1;
      Wake_Ff_Mt    at 0 range 3 .. 3;
      Wake_Pulse    at 0 range 4 .. 4;
      Wake_Lndprt   at 0 range 5 .. 5;
      Wake_Trans    at 0 range 6 .. 6;
   end record;

   type Accel_Ctrl_Reg4_Register_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    Int_En_Drdy : Bit;
	    Int_En_Ff_Mt : Bit;
	    Int_En_Pulse : Bit;
	    Int_En_Lndprt : Bit;
	    Int_En_Trans : Bit;
	    Int_En_Aslp : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Accel_Ctrl_Reg4_Register_Type use record
      Value	    at 0 range 0 .. 7;
      Int_En_Drdy   at 0 range 0 .. 0;
      Int_En_Ff_Mt  at 0 range 2 .. 2;
      Int_En_Pulse  at 0 range 3 .. 3;
      Int_En_Lndprt at 0 range 4 .. 4;
      Int_En_Trans  at 0 range 5 .. 5;
      Int_En_Aslp   at 0 range 7 .. 7;
   end record;

   type Interrupt_Pin_Type is (Int2, Int1)
     with Size => 1;

   for Interrupt_Pin_Type use
     (Int2 => 0,
      Int1 => 1);

   type Accel_Ctrl_Reg5_Register_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    Int_Cfg_Drdy : Interrupt_Pin_Type;
	    Int_Cfg_Ff_Mt : Interrupt_Pin_Type;
	    Int_Cfg_Pulse : Interrupt_Pin_Type;
	    Int_Cfg_Lndprt : Interrupt_Pin_Type;
	    Int_Cfg_Trans  : Interrupt_Pin_Type;
	    Int_Cfg_Fifo : Interrupt_Pin_Type;
	    Int_Cfg_Aslp : Interrupt_Pin_Type;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Accel_Ctrl_Reg5_Register_Type use record
      Value		at 0 range 0 .. 7;
      Int_Cfg_Drdy      at 0 range 0 .. 0;
      Int_Cfg_Ff_Mt     at 0 range 2 .. 2;
      Int_Cfg_Pulse     at 0 range 3 .. 3;
      Int_Cfg_Lndprt    at 0 range 4 .. 4;
      Int_Cfg_Trans     at 0 range 5 .. 5;
      Int_Cfg_Fifo      at 0 range 6 .. 6;
      Int_Cfg_Aslp      at 0 range 7 .. 7;
   end record;

   type F_Setup_Mode_Type is
      (F_Setup_Mode_Disabled,
       F_Setup_Mode_Circular,
       F_Setup_Mode_Fill,
       F_Setup_Mode_Trigger)
       with Size => UInt2'Size;

   for F_Setup_Mode_Type use
      (F_Setup_Mode_Disabled => 16#0#,
       F_Setup_Mode_Circular => 16#1#,
       F_Setup_Mode_Fill     => 16#2#,
       F_Setup_Mode_Trigger  => 16#3#);

   type Accel_F_Setup_Register_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    Wmrk : Uint6 := 0;
	    Mode : F_Setup_Mode_Type := F_Setup_Mode_Disabled;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Accel_F_Setup_Register_Type use record
      Value at 0 range 0 .. 7;
      Wmrk  at 0 range 0 .. 5;
      Mode  at 0 range 6 .. 7;
   end record;

   type Accel_Status_Register_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    X_DR : Bit;
	    Y_DR : Bit;
	    Z_DR : Bit;
	    ZYX_DR : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Accel_Status_Register_Type use record
      Value	at 0 range 0 .. 7;
      X_DR	at 0 range 0 .. 0;
      Y_DR	at 0 range 1 .. 1;
      Z_DR	at 0 range 2 .. 2;
      ZYX_DR	at 0 range 3 .. 3;
   end record;

   type XYZ_Data_Cfg_FS_Type is
      (XYZ_Data_Cfg_FS_2g,  --  each count corresponds to 1g/4096 = 0.25mg
       XYZ_Data_Cfg_FS_4g,  --	each count corresponds to 1g/2048
       XYZ_Data_Cfg_FS_8g)  --  each count corresponds to 1g/1024 = 0.98mg
       with Size => UInt2'Size;

   for XYZ_Data_Cfg_FS_Type use
      (XYZ_Data_Cfg_FS_2g => 16#0#,
       XYZ_Data_Cfg_FS_4g => 16#1#,
       XYZ_Data_Cfg_FS_8g => 16#2#);

   type Accel_XYZ_Data_Cfg_Register_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    FS : XYZ_Data_Cfg_FS_Type;
	    HPF_Out : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Accel_XYZ_Data_Cfg_Register_Type use record
      Value	at 0 range 0 .. 7;
      FS	at 0 range 0 .. 1;
      HPF_Out	at 0 range 4 .. 4;
   end record;

   type Accel_FF_MT_Cfg_Register_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    X_EFE : Bit;
	    Y_EFE : Bit;
	    Z_EFE : Bit;
	    OAE : Bit;
	    ELE : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Accel_FF_MT_Cfg_Register_Type use record
      Value at 0 range 0 .. 7;
      X_EFE at 0 range 3 .. 3;
      Y_EFE at 0 range 4 .. 4;
      Z_EFE at 0 range 5 .. 5;
      OAE   at 0 range 6 .. 6;
      ELE   at 0 range 7 .. 7;
   end record;

   type Accel_FF_MT_Threshold_Register_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    Threshold : UInt7;
	    Threshold_DBCNTM : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Accel_FF_MT_Threshold_Register_Type use record
      Value	        at 0 range 0 .. 7;
      Threshold	        at 0 range 0 .. 6;
      Threshold_DBCNTM  at 0 range 7 .. 7;
   end record;

   type Accel_FF_MT_SRC_Register_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    X_HP : Bit;
	    X_HE : Bit;
	    Y_HP : Bit;
	    Y_HE : Bit;
	    Z_HP : Bit;
	    Z_HE : Bit;
	    EA : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Accel_FF_MT_SRC_Register_Type use record
      Value at 0 range 0 .. 7;
      X_HP   at 0 range 0 .. 0;
      X_HE   at 0 range 1 .. 1;
      Y_HP   at 0 range 2 .. 2;
      Y_HE   at 0 range 3 .. 3;
      Z_HP   at 0 range 4 .. 4;
      Z_HE   at 0 range 5 .. 5;
      EA     at 0 range 7 .. 7;
   end record;

   type Accel_Pulse_Source_Register_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    Pol_X : Bit;
            Pol_Y : Bit;
            Pol_Z : Bit;
            DPE : Bit;
            AX_X : Bit;
	    AX_Y : Bit;
            AX_Z : Bit;
	    EA : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Accel_Pulse_Source_Register_Type use record
      Value at 0 range 0 .. 7;
      Pol_X  at 0 range 0 .. 0;
      Pol_Y  at 0 range 1 .. 1;
      Pol_Z  at 0 range 2 .. 2;
      DPE    at 0 range 3 .. 3;
      AX_X   at 0 range 4 .. 4;
      AX_Y   at 0 range 5 .. 5;
      AX_Z   at 0 range 6 .. 6;
      EA     at 0 range 7 .. 7;
   end record;

   type Magnet_Ctrl_Reg1_Register_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    HMS : UInt2;
	    OSR : UInt3;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Magnet_Ctrl_Reg1_Register_Type use record
      Value at 0 range 0 .. 7;
      HMS   at 0 range 0 .. 1;
      OSR   at 0 range 2 .. 4;
   end record;

   type Magnet_Ctrl_Reg2_Register_Type (As_Value : Boolean := True) is record
      case As_Value is
	 when True =>
	    Value : Byte := 0;
	 when False =>
	    Rst_Cnt : UInt2;
	    Maxmin_Rst : Bit;
	    Maxmin_Dis_Threshold : Bit;
	    Maxmin_Dis : Bit;
	    Hyb_Autoinc : Bit;
      end case;
   end record
      with Unchecked_Union, Size => Byte'Size;

   for Magnet_Ctrl_Reg2_Register_Type use record
      Value		    at 0 range 0 .. 7;
      Rst_Cnt		    at 0 range 0 .. 1;
      Maxmin_Rst	    at 0 range 2 .. 2;
      Maxmin_Dis_Threshold  at 0 range 3 .. 3;
      Maxmin_Dis	    at 0 range 4 .. 4;
      Hyb_Autoinc	    at 0 range 5 .. 5;
   end record;

end Accelerometer.Fxos8700cq_Private;
