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

separate (Car_Controller)
procedure Analyze_Camera_Frame (
   Car_Controller_Obj : in out Car_Controller_Type;
   Camera_Frame : TFC_Line_Scan_Camera.TFC_Camera_Frame_Type)
is
   procedure Compute_Derivative (
      Camera_Frame : TFC_Camera_Frame_Type;
      Frame_Derivative : out Camera_Frame_Derivative_Type)
      with Pre => Camera_Frame'Length >= 2;

   function Find_Track_Left_Edge (
      Frame_Derivative : Camera_Frame_Derivative_Type)
      return TFC_Camera_Frame_Pixel_Index_Type;

   function Find_Track_Right_Edge (
      Frame_Derivative : Camera_Frame_Derivative_Type)
      return TFC_Camera_Frame_Pixel_Index_Type;

   procedure Gaussian_Filter (
      Raw_Camera_Frame : TFC_Camera_Frame_Type;
      Num_Filter_Points : Positive;
      Filtered_Camera_Frame : out TFC_Camera_Frame_Type)
      with Pre => Raw_Camera_Frame'Length >= Num_Filter_Points and
                  Num_Filter_Points mod 2 /= 0;

   procedure Moving_Average_Filter (
      Raw_Camera_Frame : TFC_Camera_Frame_Type;
      Num_Filter_Points : Positive;
      Filtered_Camera_Frame : out TFC_Camera_Frame_Type)
      with Pre => Raw_Camera_Frame'Length >= Num_Filter_Points and
                  Num_Filter_Points mod 2 /= 0;

   ------------------------
   -- Compute_Derivative --
   ------------------------

   procedure Compute_Derivative (
      Camera_Frame : TFC_Camera_Frame_Type;
      Frame_Derivative : out Camera_Frame_Derivative_Type)
   is
   begin
      --  Compute the derivative of a camera frame using the central-difference
      --  equations:
      --     f'(0) = (f(1) - f(0)) / 2
      --     f'(x) = (f(x + 1) - f(x - 1)) / 2, where x in 1 .. N - 2
      --     f'(n - 1) = (f(n - 1) - f(n - 2)) / 2
      --
      Frame_Derivative (Frame_Derivative'First) :=
         Float (Integer (Camera_Frame (Camera_Frame'First + 1)) -
                Integer (Camera_Frame (Camera_Frame'First))) / 2.0;

      for X in Camera_Frame'First + 1 .. Camera_Frame'Last - 1 loop
         Frame_Derivative (X) :=
            Float (Integer (Camera_Frame (X + 1)) -
                   Integer (Camera_Frame (X - 1))) / 2.0;
      end loop;

      Frame_Derivative (Frame_Derivative'Last) :=
         Float (Integer (Camera_Frame (Camera_Frame'Last)) -
                Integer (Camera_Frame (Camera_Frame'Last - 1))) / 2.0;
   end Compute_Derivative;

   --------------------------
   -- Find_Track_Left_Edge --
   --------------------------

   function Find_Track_Left_Edge (
      Frame_Derivative : Camera_Frame_Derivative_Type)
      return TFC_Camera_Frame_Pixel_Index_Type
   is
      Track_Edge_Start_Index : TFC_Camera_Frame_Pixel_Index_Type;
      Track_Edge_End_Index : TFC_Camera_Frame_Pixel_Index_Type;
      Min_Derivative : Float;
      Max_Derivative : Float;
   begin
      --
      --  Try to detect the left edge of the track by analyzing the derivative
      --  of a given camera frame:
      --  - Traverse derivative from right to the left, to find biggest
      --    positive derivative
      --  - Traverse derivative from index of biggest positive derivative to
      --    the left, to find biggest negative derivative.
      --
      Max_Derivative := 0.0;
      Track_Edge_Start_Index := Frame_Derivative'First;
      for I in reverse Frame_Derivative'Range loop
         if Frame_Derivative (I) > Max_Derivative then
            Max_Derivative := Frame_Derivative (I);
            Track_Edge_Start_Index := I;
         end if;
      end loop;

      Min_Derivative := 0.0;
      Track_Edge_End_Index := Frame_Derivative'First;
      for I in reverse Frame_Derivative'First .. Track_Edge_Start_Index loop
         if Frame_Derivative (I) < Min_Derivative then
            Min_Derivative := Frame_Derivative (I);
            Track_Edge_End_Index := I;
         end if;
      end loop;

      if Track_Edge_End_Index = Frame_Derivative'First then
         Track_Edge_Start_Index := Frame_Derivative'First;
      end if;

      return Track_Edge_Start_Index;
   end Find_Track_Left_Edge;

   ---------------------------
   -- Find_Track_Right_Edge --
   ---------------------------

   function Find_Track_Right_Edge (
      Frame_Derivative : Camera_Frame_Derivative_Type)
      return TFC_Camera_Frame_Pixel_Index_Type
   is
      Track_Edge_Start_Index : TFC_Camera_Frame_Pixel_Index_Type;
      Track_Edge_End_Index : TFC_Camera_Frame_Pixel_Index_Type;
      Min_Derivative : Float;
      Max_Derivative : Float;
   begin
      --
      --  Try to detect the right edge of the track by analyzing the derivative
      --  of a given camera frame:
      --  - Traverse derivative from left to right, to find biggest
      --    negative derivative
      --  - Traverse derivative from index of biggest negative derivative to
      --    the right, to find biggest positive derivative.
      --
      Min_Derivative := 0.0;
      Track_Edge_Start_Index := Frame_Derivative'Last;
      for I in Frame_Derivative'Range loop
         if Frame_Derivative (I) < Min_Derivative then
            Min_Derivative := Frame_Derivative (I);
            Track_Edge_Start_Index := I;
         end if;
      end loop;

      Max_Derivative := 0.0;
      Track_Edge_End_Index := Frame_Derivative'Last;
      for I in Track_Edge_Start_Index .. Frame_Derivative'Last loop
         if Frame_Derivative (I) > Max_Derivative then
            Max_Derivative := Frame_Derivative (I);
            Track_Edge_End_Index := I;
         end if;
      end loop;

      if Track_Edge_End_Index = Frame_Derivative'Last then
         Track_Edge_Start_Index := Frame_Derivative'Last;
      end if;

      return Track_Edge_Start_Index;
   end Find_Track_Right_Edge;

   ---------------------
   -- Gaussian_Filter --
   ---------------------

   procedure Gaussian_Filter (
      Raw_Camera_Frame : TFC_Camera_Frame_Type;
      Num_Filter_Points : Positive;
      Filtered_Camera_Frame : out TFC_Camera_Frame_Type)
   is
      Temp_Camera_Frame : TFC_Camera_Frame_Type;
   begin
      --
      --  Implementation of the Gausian filter with a 4-pass moving average
      --  filter
      --
      Moving_Average_Filter (Raw_Camera_Frame,
                             Num_Filter_Points,
                             Temp_Camera_Frame);

      Moving_Average_Filter (Temp_Camera_Frame,
                             Num_Filter_Points,
                             Filtered_Camera_Frame);

      Moving_Average_Filter (Filtered_Camera_Frame,
                             Num_Filter_Points,
                             Temp_Camera_Frame);

      Moving_Average_Filter (Temp_Camera_Frame,
                             Num_Filter_Points,
                             Filtered_Camera_Frame);
   end Gaussian_Filter;

   ---------------------------
   -- Moving_Average_Filter --
   ---------------------------

   procedure Moving_Average_Filter (
      Raw_Camera_Frame : TFC_Camera_Frame_Type;
      Num_Filter_Points : Positive;
      Filtered_Camera_Frame : out TFC_Camera_Frame_Type)
   is
      Half_Num_Filter_Points : constant Integer := Num_Filter_Points / 2;
      Sum : Integer;
   begin
      --
      --  Applies a moving average filter of 'Num_Filter_Points' points to a
      --  raw camera frame, doing symetric averaging in the range
      --   X - Num_Filter_Points / 2 .. X + Num_Filter_Points / 2, for each
      --   pixel index X
      --

      --
      --  TODO: Optimize the algorithm below to avoid redundant calculations
      --  by using the recurrence equation 15-3.
      --
      for I in Integer (TFC_Camera_Frame_Type'First) + Half_Num_Filter_Points
               ..
               Integer (TFC_Camera_Frame_Type'Last) - Half_Num_Filter_Points
      loop
         Sum := 0;
         for J in -Half_Num_Filter_Points .. Half_Num_Filter_Points loop
            Sum := Sum + Integer (Raw_Camera_Frame (Unsigned_8 (I + J)));
         end loop;

         Filtered_Camera_Frame (Unsigned_8 (I)) :=
            Unsigned_8 (Sum / Num_Filter_Points);
      end loop;

      for I in Integer (TFC_Camera_Frame_Type'First) ..
               Integer (TFC_Camera_Frame_Type'First) +
                  Half_Num_Filter_Points - 1 loop
         Filtered_Camera_Frame (Unsigned_8 (I)) :=
            Filtered_Camera_Frame (TFC_Camera_Frame_Type'First +
                                   Unsigned_8 (Half_Num_Filter_Points));
      end loop;

      for I in Integer (TFC_Camera_Frame_Type'Last) -
                  Half_Num_Filter_Points + 1
               ..
               Integer (TFC_Camera_Frame_Type'Last) loop
         Filtered_Camera_Frame (Unsigned_8 (I)) :=
            Filtered_Camera_Frame (TFC_Camera_Frame_Type'Last -
                                   Unsigned_8 (Half_Num_Filter_Points));
      end loop;

   end Moving_Average_Filter;

   -- ** --

   --
   --  Number of points  for moving average filter (-8 .. 8 symetric averaging)
   --
   Num_Filter_Points : constant Positive := 17;
   Middle_Pixel_Index : constant TFC_Camera_Frame_Pixel_Index_Type :=
      (TFC_Camera_Frame_Pixel_Index_Type'First +
       TFC_Camera_Frame_Pixel_Index_Type'Last) / 2;
   Track_Edge_Start_Index : TFC_Camera_Frame_Pixel_Index_Type;

begin -- Analyze_Camera_Frame
   --
   --  Note: Camera_Frame'First is the index of the most left pixel in the
   --  frame and Camera_Frame'Last is the index of the right most pixel in the
   --  frame
   --
   Moving_Average_Filter (Camera_Frame,
                          Num_Filter_Points,
                          Car_Controller_Obj.Filtered_Camera_Frame);

   Compute_Derivative (Car_Controller_Obj.Filtered_Camera_Frame,
                       Car_Controller_Obj.Camera_Frame_Derivative);

   case Car_Controller_Obj.Track_Edge_Tracing_State is
      when No_Track_Edge_Detected =>
         --
         --  Try to find track right edge first. If no right edge detected,
         --  then try to find the track left edge:
         --
         Track_Edge_Start_Index :=
            Find_Track_Right_Edge (
               Car_Controller_Obj.Camera_Frame_Derivative (
                  Middle_Pixel_Index .. Camera_Frame'Last));

         if Track_Edge_Start_Index < Camera_Frame'Last then
            Car_Controller_Obj.Track_Edge_Tracing_State :=
               Following_Right_Track_Edge;
            Car_Controller_Obj.Reference_Track_Edge_Pixel_Index :=
               Camera_Frame'Last;
         else
            Track_Edge_Start_Index :=
               Find_Track_Left_Edge (
                  Car_Controller_Obj.Camera_Frame_Derivative (
                     Camera_Frame'First .. Middle_Pixel_Index));

            if Track_Edge_Start_Index > Camera_Frame'First then
               Car_Controller_Obj.Track_Edge_Tracing_State :=
                  Following_Left_Track_Edge;
               Car_Controller_Obj.Reference_Track_Edge_Pixel_Index :=
                  Camera_Frame'First;
            else
               return;
            end if;
         end if;

         Car_Controller_Obj.Current_Track_Edge_Pixel_Index :=
            Track_Edge_Start_Index; --??? move tihs after the case

         Car_Controller_Obj.Previous_PID_Error := 0;
         Car_Controller_Obj.PID_Integral_Term := 0;
      when Following_Left_Track_Edge =>
         Track_Edge_Start_Index :=
            Find_Track_Left_Edge (Car_Controller_Obj.Camera_Frame_Derivative);

         if Track_Edge_Start_Index = Camera_Frame'First then
            Car_Controller_Obj.Track_Edge_Tracing_State :=
               No_Track_Edge_Detected;
            return;
         end if;

         Car_Controller_Obj.Current_Track_Edge_Pixel_Index :=
            Track_Edge_Start_Index;

      when Following_Right_Track_Edge =>
         Track_Edge_Start_Index :=
            Find_Track_Right_Edge (Car_Controller_Obj.Camera_Frame_Derivative);

         if Track_Edge_Start_Index = Camera_Frame'Last then
            Car_Controller_Obj.Track_Edge_Tracing_State :=
               No_Track_Edge_Detected;
            return;
         end if;

         Car_Controller_Obj.Current_Track_Edge_Pixel_Index :=
            Track_Edge_Start_Index;
   end case;
end Analyze_Camera_Frame;
