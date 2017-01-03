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

with Periodic_Timer_Driver;
with Ada.Synchronous_Task_Control;
with Gpio_Driver;
with Pin_Mux_Driver;
with Microcontroller.Arm_Cortex_M;

package body TFC_Line_Scan_Camera is
   pragma SPARK_Mode (Off);
   use Ada.Synchronous_Task_Control;
   use Gpio_Driver;
   use Pin_Mux_Driver;

   --
   --  Periodic timer device used to capture camera frames
   --
   Frame_Capture_Timer_Id : constant Periodic_Timer_Device_Id_Type :=
      Periodic_Timer0;

   --
   --  Deadline (in milliseconds) to capture the next Line-scan camera frame
   --
   Frame_Capture_Period_Ms : constant := 20;

   --
   --  States of capturing camera frames
   --
   type Frame_Capture_State_Type is (Frame_Capture_Not_Started,
                                     Frame_Capture_SI_High_Clk_Low,
                                     Frame_Capture_SI_High_Clk_High,
                                     Frame_Capture_SI_Low_Clk_High,
                                     Frame_Capture_SI_Low_Clk_Low,
                                     Frame_Capture_Finished);

   type Ping_Pong_Frame_Buffer_Id_Type is mod 2;

   type Ping_Pong_Frame_Buffers_Type is
      array (Ping_Pong_Frame_Buffer_Id_Type) of aliased TFC_Camera_Frame_Type;

   --
   --  Camera frame capture constant object type
   --
   --  @field SI_Pin SI signal output pin for KL25Z micrcontroller (input to
   --         the camera chip)
   --  @field CLK_Pin CLK signal output pin for KL25Z micrcontroller (input to
   --         the camera chip)
   --  @field AO0_Pin  AO0 signal input pin for KL25Z micrcontroller (output
   --         from the camera chip)
   --
   type Frame_Capture_Const_Type is limited record
      SI_Pin :  Gpio_Pin_Type;
      CLK_Pin :  Gpio_Pin_Type;
      AO0_Pin : Gpio_Pin_Type;
   end record;

   Frame_Capture_Const : constant Frame_Capture_Const_Type :=
      (SI_Pin => (Pin_Info => (Pin_Port => PIN_PORT_D,
                               Pin_Index => 7,
                               Pin_Function => PIN_FUNCTION_ALT1),
                  Is_Active_High => True),

       CLK_Pin => (Pin_Info => (Pin_Port => PIN_PORT_E,
                               Pin_Index => 1,
                               Pin_Function => PIN_FUNCTION_ALT1),
                   Is_Active_High => True),

       AO0_Pin => (Pin_Info => (Pin_Port => PIN_PORT_D,
                               Pin_Index => 5,
                               Pin_Function => PIN_FUNCTION_ALT0),
                   Is_Active_High => True));

   --
   --  Camera frame capture state variables
   --
   --  @field Initialized Flag indicating if Initialize has been called
   --  @field ADC_Device_Id A/D converter device Id to use
   --  @field State Current state in the capture of the current camera frame
   --  @field Camera_ADC_Channel ADC channel for the analog input pin from the
   --         camera
   --  @field Ping_Pong_Frame_Buffers
   --  @field Last_Filled_Frame_Buffer Index of last frame buffer filled, in
   --         Ping_Pong_Frame_Buffers
   --  @field Current_Frame_Buffer Index of current frame being captured, in
   --         Ping_Pong_Frame_Buffers
   --  @field Remaining_Pixels_Count Count of remaining pixels to capture for
   --         the current frame  being captured
   --  @field Frame_Capture_Completed_Susp_Obj Suspension object to be signaled
   --         when the  current frame capture completes
   --  @field Piggybacked_AD_Conversion_Array_Ptr Pointer to array of
   --         piggybacked ADC conversions
   --  @field Next_Piggybacked_AD_Conversion Index of next piggybacked ADC
   --         conversion to start
   --  @field Pending_Piggybacked_AD_Conversion Flag that indicates if there
   --         is a piggybacked ADC conversion in flight.
   --
   type Frame_Capture_Var_Type is limited record
      Initialized : Boolean := False;
      ADC_Device_Id : ADC_Device_Id_Type;
      State : Frame_Capture_State_Type := Frame_Capture_Not_Started;
      Camera_ADC_Channel : Unsigned_8;
      Camera_Frame_Buffer : TFC_Camera_Frame_Type;
      Camera_Frame_Captured : Boolean := False;
      Frames_Captured_Count : Unsigned_32 := 0;
      Remaining_Pixels_Count : Unsigned_8 range 0 .. TFC_Num_Camera_Pixels;
      Frame_Capture_Completed_Susp_Obj : Suspension_Object;
      Piggybacked_AD_Conversion_Array_Ptr :
         Piggybacked_AD_Conversion_Array_Access_Type;
      Next_Piggybacked_AD_Conversion : Positive;
      Pending_Piggybakced_AD_Conversion : Boolean := False;
   end record;

   Frame_Capture_Var : aliased Frame_Capture_Var_Type;

   --
   --  Periodic timer channel used to capture camera frames
   --
   Frame_Capture_Timer_Channel_Id :
      constant Periodic_Timer_Driver.Periodic_Timer_Channel_Id_Type := 0;

   procedure AD_Conversion_Completion_Callback (ADC_Reading : Unsigned_16);
   --
   --  A/D conversion completion callback
   --

   procedure Complete_Piggybacked_AD_Conversion (
      Frame_Capture_Var : in out Frame_Capture_Var_Type;
      ADC_Reading : Unsigned_16);
   --
   --  Completes a piggybacked A/D conversion
   --

   procedure Periodic_Timer_Callback;
   --
   --  Triggers A/D conversions
   --

   procedure Start_Piggybacked_AD_Conversion (
      Frame_Capture_Var : in out Frame_Capture_Var_Type);
   --
   --  Start a piggybacked A/D conversion
   --

   ---------------------------------------
   -- AD_Conversion_Completion_Callback --
   ---------------------------------------

   procedure AD_Conversion_Completion_Callback (ADC_Reading : Unsigned_16)
   is
      Piggybacked_AD_Conversion_End : constant Positive :=
         Frame_Capture_Var.Piggybacked_AD_Conversion_Array_Ptr.all'Last + 1;

   begin -- AD_Conversion_Completion_Callback
      if Frame_Capture_Var.Pending_Piggybakced_AD_Conversion then
         Complete_Piggybacked_AD_Conversion (Frame_Capture_Var, ADC_Reading);
      end if;

      case Frame_Capture_Var.State is
         when Frame_Capture_SI_High_Clk_Low =>
            Activate_Output_Pin (Frame_Capture_Const.CLK_Pin);
            Frame_Capture_Var.State := Frame_Capture_SI_High_Clk_High;

            --
            --  Start dummy async ADC conversion to pace SI and CLK signals,
            --  or start a piggybacked ADC conversion if any:
            --
            if Frame_Capture_Var.Next_Piggybacked_AD_Conversion =
                  Piggybacked_AD_Conversion_End
            then
               --
               --  Dummy ADC conversion:
               --
               ADC_Driver.Start_Async_Conversion (
                  Frame_Capture_Var.ADC_Device_Id,
                  Frame_Capture_Var.Camera_ADC_Channel,
                  Hardware_Average_On => False,
                  Mux_Selector => ADC_Mux_Side_B,
                  ADC_Completion_Callback_Ptr =>
                     AD_Conversion_Completion_Callback'Access);
            else
               Start_Piggybacked_AD_Conversion (Frame_Capture_Var);
            end if;

         when Frame_Capture_SI_High_Clk_High =>
            Deactivate_Output_Pin (Frame_Capture_Const.SI_Pin);
            Frame_Capture_Var.State := Frame_Capture_SI_Low_Clk_High;
            Frame_Capture_Var.Remaining_Pixels_Count := TFC_Num_Camera_Pixels;

            --
            --  Start async ADC conversion to capture first pixel (right most
            --  pixel):
            --
            ADC_Driver.Start_Async_Conversion (
                  Frame_Capture_Var.ADC_Device_Id,
                  Frame_Capture_Var.Camera_ADC_Channel,
                  Hardware_Average_On => False,
                  Mux_Selector => ADC_Mux_Side_B,
                  ADC_Completion_Callback_Ptr =>
                     AD_Conversion_Completion_Callback'Access);

         when Frame_Capture_SI_Low_Clk_High =>
            Deactivate_Output_Pin (Frame_Capture_Const.CLK_Pin);

            --
            --  Save current pixel reading:
            --
            --  NOTE: Pixels are stored in the resverse order in which they are
            --  received, so that:
            --  - Right most pixel is stored at
            --    Camera_Frame (Camerara_Frame'Last)
            --  - Left most pixel is stored at
            --    Camera_Frame (Camerara_Frame'First)
            --
            if Frame_Capture_Var.Remaining_Pixels_Count > 0 then
               Frame_Capture_Var.State := Frame_Capture_SI_Low_Clk_Low;
               pragma Assert (ADC_Reading <= Unsigned_16 (Unsigned_8'Last));
               Frame_Capture_Var.Camera_Frame_Buffer
                  (Frame_Capture_Var.Remaining_Pixels_Count) :=
                  Unsigned_8 (ADC_Reading);

               Frame_Capture_Var.Remaining_Pixels_Count :=
                  Frame_Capture_Var.Remaining_Pixels_Count - 1;

               --
               --  Start dummy async ADC conversion to pace CLK signal,
               --  or start a piggybacked ADC conversion if any:
               --
               if  Frame_Capture_Var.Next_Piggybacked_AD_Conversion =
                      Piggybacked_AD_Conversion_End
               then
                  --
                  --  Dummy ADC conversion:
                  --
                  ADC_Driver.Start_Async_Conversion (
                     Frame_Capture_Var.ADC_Device_Id,
                     Frame_Capture_Var.Camera_ADC_Channel,
                     Hardware_Average_On => False,
                     Mux_Selector => ADC_Mux_Side_B,
                     ADC_Completion_Callback_Ptr =>
                        AD_Conversion_Completion_Callback'Access);
               else
                  Start_Piggybacked_AD_Conversion (Frame_Capture_Var);
               end if;
            else
               Frame_Capture_Var.State := Frame_Capture_Finished;
               --pragma Assert (not Frame_Capture_Var.Camera_Frame_Captured);
               Frame_Capture_Var.Camera_Frame_Captured := True;
               Set_True (Frame_Capture_Var.Frame_Capture_Completed_Susp_Obj);

               pragma Assert (Frame_Capture_Var.Next_Piggybacked_AD_Conversion
                              = Piggybacked_AD_Conversion_End);

               Frame_Capture_Var.Next_Piggybacked_AD_Conversion :=
                  Frame_Capture_Var.Piggybacked_AD_Conversion_Array_Ptr'First;
            end if;

         when Frame_Capture_SI_Low_Clk_Low =>
            Activate_Output_Pin (Frame_Capture_Const.CLK_Pin);
            Frame_Capture_Var.State := Frame_Capture_SI_Low_Clk_High;

            --
            --  Start async ADC conversion to capture next pixel:
            --
            ADC_Driver.Start_Async_Conversion (
                     Frame_Capture_Var.ADC_Device_Id,
                     Frame_Capture_Var.Camera_ADC_Channel,
                     Hardware_Average_On => False,
                     Mux_Selector => ADC_Mux_Side_B,
                     ADC_Completion_Callback_Ptr =>
                        AD_Conversion_Completion_Callback'Access);

         when others =>
            pragma Assert (False);
      end case;
   end AD_Conversion_Completion_Callback;

   ----------------------------------------
   -- Complete_Piggybacked_AD_Conversion --
   ----------------------------------------

   procedure Complete_Piggybacked_AD_Conversion (
      Frame_Capture_Var : in out Frame_Capture_Var_Type;
      ADC_Reading : Unsigned_16)
   is
      Piggybacked_AD_Conversion_End : constant Positive :=
         Frame_Capture_Var.Piggybacked_AD_Conversion_Array_Ptr.all'Last + 1;
      Piggybacked_AD_Conversion_Var : Piggybacked_AD_Conversion_Type renames
         Frame_Capture_Var.Piggybacked_AD_Conversion_Array_Ptr (
            Frame_Capture_Var.Next_Piggybacked_AD_Conversion);
   begin
      pragma Assert (Frame_Capture_Var.Pending_Piggybakced_AD_Conversion);
      pragma Assert (Frame_Capture_Var.Next_Piggybacked_AD_Conversion <
                     Piggybacked_AD_Conversion_End);
      pragma Assert (ADC_Reading <= Unsigned_16 (Unsigned_8'Last));

      Piggybacked_AD_Conversion_Var.ADC_Reading := Unsigned_8 (ADC_Reading);

      Frame_Capture_Var.Pending_Piggybakced_AD_Conversion := False;
      Frame_Capture_Var.Next_Piggybacked_AD_Conversion :=
         Frame_Capture_Var.Next_Piggybacked_AD_Conversion + 1;
   end Complete_Piggybacked_AD_Conversion;

   --------------------
   -- Get_Next_Frame --
   --------------------

   procedure Get_Next_Frame (Camera_Frame : out TFC_Camera_Frame_Type)
   is
      Int_Mask : Unsigned_32;
   begin
      Suspend_Until_True (Frame_Capture_Var.Frame_Capture_Completed_Susp_Obj);

      pragma Assert (Frame_Capture_Var.Camera_Frame_Captured);
      Int_Mask := Microcontroller.Arm_Cortex_M.Disable_Cpu_Interrupts;
      Camera_Frame := Frame_Capture_Var.Camera_Frame_Buffer;
      Frame_Capture_Var.Camera_Frame_Captured := False;
      Microcontroller.Arm_Cortex_M.Restore_Cpu_Interrupts (Int_Mask);
   end Get_Next_Frame;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (
      ADC_Device_Id : ADC_Device_Id_Type;
      Camera_ADC_Channel : Unsigned_8;
      Piggybacked_AD_Conversion_Array_Ptr :
         Piggybacked_AD_Conversion_Array_Access_Type)
   is
   begin
      --
      --  Setup GPIO pins for camera signals:
      --

      Configure_Pin (Frame_Capture_Const.SI_Pin,
                            Drive_Strength_Enable => True,
                            Pullup_Resistor => False,
                            Is_Output_Pin => True);

      Configure_Pin (Frame_Capture_Const.CLK_Pin,
                            Drive_Strength_Enable => True,
                            Pullup_Resistor => False,
                            Is_Output_Pin => True);

      Configure_Pin (Frame_Capture_Const.AO0_Pin,
                     Drive_Strength_Enable => True,
                     Pullup_Resistor => False,
                     Is_Output_Pin => False);

      Deactivate_Output_Pin (Frame_Capture_Const.SI_Pin);
      Deactivate_Output_Pin (Frame_Capture_Const.CLK_Pin);

      Frame_Capture_Var.ADC_Device_Id := ADC_Device_Id;
      Frame_Capture_Var.Piggybacked_AD_Conversion_Array_Ptr :=
         Piggybacked_AD_Conversion_Array_Ptr;
      Frame_Capture_Var.Next_Piggybacked_AD_Conversion :=
         Piggybacked_AD_Conversion_Array_Ptr.all'First;

      Frame_Capture_Var.Camera_ADC_Channel := Camera_ADC_Channel;
      Frame_Capture_Var.Piggybacked_AD_Conversion_Array_Ptr :=
         Piggybacked_AD_Conversion_Array_Ptr;
      Frame_Capture_Var.Initialized := True;

      Periodic_Timer_Driver.Initialize (Frame_Capture_Timer_Id);
   end Initialize;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean is (Frame_Capture_Var.Initialized);

   -----------------------------
   -- Periodic_Timer_Callback --
   -----------------------------

   procedure Periodic_Timer_Callback
   is
   begin
      pragma Assert (Frame_Capture_Var.State in
                     Frame_Capture_Not_Started | Frame_Capture_Finished);
      pragma Assert (not Frame_Capture_Var.Pending_Piggybakced_AD_Conversion);
      pragma Assert (Frame_Capture_Var.Next_Piggybacked_AD_Conversion =
                     Frame_Capture_Var.
                        Piggybacked_AD_Conversion_Array_Ptr.all'First);

      --
      --  Start capture of next camera frame:
      --

      Activate_Output_Pin (Frame_Capture_Const.SI_Pin);
      Frame_Capture_Var.State := Frame_Capture_SI_High_Clk_Low;

      --
      --  Start dummy async ADC conversion to pace SI and CLK signals,
      --  or start a piggybacked ADC conversion if any:
      --
      if Frame_Capture_Var.Next_Piggybacked_AD_Conversion =
         Frame_Capture_Var.Piggybacked_AD_Conversion_Array_Ptr.all'Last
      then
         --
         --  Dummy ADC conversion:
         --
         ADC_Driver.Start_Async_Conversion (
            Frame_Capture_Var.ADC_Device_Id,
            Frame_Capture_Var.Camera_ADC_Channel,
            Hardware_Average_On => False,
            Mux_Selector => ADC_Mux_Side_B,
            ADC_Completion_Callback_Ptr =>
               AD_Conversion_Completion_Callback'Access);
      else
         Start_Piggybacked_AD_Conversion (Frame_Capture_Var);
      end if;

   end Periodic_Timer_Callback;

   -------------------------
   -- Start_Frame_Capture --
   -------------------------

   procedure Start_Frame_Capture
   is
   begin
      Periodic_Timer_Driver.Start_Timer_Channel (
         Frame_Capture_Timer_Id,
         Frame_Capture_Timer_Channel_Id,
         Frame_Capture_Period_Ms,
         Periodic_Timer_Callback'Access);
   end Start_Frame_Capture;

   -------------------------------------
   -- Start_Piggybacked_AD_Conversion --
   -------------------------------------

   procedure Start_Piggybacked_AD_Conversion (
      Frame_Capture_Var : in out Frame_Capture_Var_Type)
   is
      Piggybacked_AD_Conversion_End : constant Positive :=
         Frame_Capture_Var.Piggybacked_AD_Conversion_Array_Ptr.all'Last + 1;
      Piggybacked_Conversion_Var : Piggybacked_AD_Conversion_Type renames
         Frame_Capture_Var.Piggybacked_AD_Conversion_Array_Ptr (
            Frame_Capture_Var.Next_Piggybacked_AD_Conversion);
   begin
      pragma Assert (not Frame_Capture_Var.Pending_Piggybakced_AD_Conversion);
      pragma Assert (Frame_Capture_Var.Next_Piggybacked_AD_Conversion <
                   Piggybacked_AD_Conversion_End);

      Frame_Capture_Var.Pending_Piggybakced_AD_Conversion := True;

      ADC_Driver.Start_Async_Conversion (
         Frame_Capture_Var.ADC_Device_Id,
         Piggybacked_Conversion_Var.ADC_Channel,
         Hardware_Average_On => False,
         Mux_Selector => Piggybacked_Conversion_Var.ADC_Mux_Selector,
         ADC_Completion_Callback_Ptr =>
         AD_Conversion_Completion_Callback'Access);
   end Start_Piggybacked_AD_Conversion;

   ------------------------
   -- Stop_Frame_Capture --
   ------------------------

   procedure Stop_Frame_Capture
   is
   begin
      if Frame_Capture_Var.State /= Frame_Capture_Not_Started then
         Periodic_Timer_Driver.Stop_Timer_Channel (
            Frame_Capture_Timer_Id,
            Frame_Capture_Timer_Channel_Id);
      end if;
   end Stop_Frame_Capture;

end TFC_Line_Scan_Camera;
