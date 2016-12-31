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
function Analyze_Camera_Frame (
   Car_Controller_Obj : in out Car_Controller_Type;
   Camera_Frame : TFC_Line_Scan_Camera.TFC_Camera_Frame_Type)
   return Boolean
is
   procedure Compute_Derivative (
      Camera_Frame : TFC_Camera_Frame_Type;
      Frame_Derivative : out Camera_Frame_Derivative_Type)
      with Pre => Camera_Frame'Length >= 2;
   --
   --  Compute the derivative of a function f, using the central-difference
   --  equations:
   --     f'(0) = (f(1) - f(0)) / 2
   --     f'(x) = (f(x + 1) - f(x - 1)) / 2, where x in 1 .. N - 2
   --     f'(n - 1) = (f(n - 1) - f(n - 2)) / 2
   --

   ------------------------
   -- Compute_Derivative --
   ------------------------

   procedure Compute_Derivative (
      Camera_Frame : TFC_Camera_Frame_Type;
      Frame_Derivative : out Camera_Frame_Derivative_Type)
   is
   begin
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

   -- ** --

   Left_Edge_Start_Index : TFC_Camera_Frame_Pixel_Index_Type;
   Right_Edge_Start_Index : TFC_Camera_Frame_Pixel_Index_Type;
   Min_Derivative : Float;
begin
   Compute_Derivative (Camera_Frame,
                       Car_Controller_Obj.Camera_Frame_Derivative);

   --
   --  Find right edge:
   --
   Min_Derivative := Float'Last;
   Right_Edge_Start_Index := TFC_Camera_Frame_Pixel_Index_Type'First;
   for I in reverse Camera_Frame'First .. Camera_Frame'Last loop
      if Car_Controller_Obj.Camera_Frame_Derivative (I) < Min_Derivative then
         Min_Derivative := Car_Controller_Obj.Camera_Frame_Derivative (I);
         Right_Edge_Start_Index := I;
      end if;
   end loop;

   --
   --  Find left edge:
   --
   Min_Derivative := Float'Last;
   Left_Edge_Start_Index := TFC_Camera_Frame_Pixel_Index_Type'Last;
   for I in Camera_Frame'First .. Camera_Frame'Last loop
      if Car_Controller_Obj.Camera_Frame_Derivative (I) < Min_Derivative then
         Min_Derivative := Car_Controller_Obj.Camera_Frame_Derivative (I);
         Left_Edge_Start_Index := I;
      end if;
   end loop;

   Car_Controller_Obj.Prev_Track_Right_Edge_Pixel_Index :=
      Car_Controller_Obj.Track_Right_Edge_Pixel_Index;

   Car_Controller_Obj.Track_Right_Edge_Pixel_Index := Right_Edge_Start_Index;

   Car_Controller_Obj.Prev_Track_Left_Edge_Pixel_Index :=
      Car_Controller_Obj.Track_Left_Edge_Pixel_Index;

   Car_Controller_Obj.Track_Left_Edge_Pixel_Index := Left_Edge_Start_Index;
   return True;
end Analyze_Camera_Frame;
