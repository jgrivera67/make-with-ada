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

with Interfaces;
with ADC_Driver;
with Devices.MCU_Specific;

--
--  @summary TFC line scan camera driver
--
package TFC_Line_Scan_Camera is
   use Interfaces;
   use ADC_Driver;
   use Devices.MCU_Specific;

   --
   --  Number of pixels per frame
   --
   TFC_Num_Camera_Pixels : constant := 128;

   subtype TFC_Camera_Frame_Pixel_Index_Type is
      Unsigned_8 range 1 .. TFC_Num_Camera_Pixels;

   --
   --  Line-scan camera frame
   --
   --  The left most pixel correspond to TFC_Camera_Frame_Type'First
   --  The right most pixel correspond to TFC_Camera_Frame_Type'Last
   --
   type TFC_Camera_Frame_Type is
      array (TFC_Camera_Frame_Pixel_Index_Type) of Unsigned_8;

   --
   --  ADC conversion piggy-backed during the sequential ADC conversions
   --  done for capturing a camera frame.
   --
   --  @field ADC_Channel A/D converter channel for the piggybacked conversion
   --  @field ADC_Mux_Selector ADC MUX selector for the ADC channel
   --  @field ADC_Reading A/D conversion resul
   --
   type Piggybacked_AD_Conversion_Type is limited record
      ADC_Channel : Unsigned_8;
      ADC_Mux_Selector : ADC_Mux_Selector_Type;
      ADC_Reading : Unsigned_8;
   end record;

   type Piggybacked_AD_Conversion_Array_Type is
      array (Positive range <>) of Piggybacked_AD_Conversion_Type;

   type Piggybacked_AD_Conversion_Array_Access_Type is
      access all Piggybacked_AD_Conversion_Array_Type;

   function Initialized return Boolean;

   procedure Initialize (
      ADC_Device_Id : ADC_Device_Id_Type;
      Camera_ADC_Channel : Unsigned_8;
      Piggybacked_AD_Conversion_Array_Ptr :
         Piggybacked_AD_Conversion_Array_Access_Type)
      with Pre => not Initialized;

   procedure Start_Frame_Capture
      with Pre => Initialized;

   procedure Stop_Frame_Capture
      with Pre => Initialized;

   procedure Get_Next_Frame (Camera_Frame : out TFC_Camera_Frame_Type)
      with Pre => Initialized;

end TFC_Line_Scan_Camera;
