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

--
--  @summary sensor reading
--

with Memory_Protection;

package body Sensor_Reading is
   use Memory_Protection;

   protected body Reading_Protected_Type is

      ----------
      -- Read --
      ----------

      procedure Read (Reading_Value : out Reading_Type)
      is
         Old_region : MPU_Region_Descriptor_Type;
      begin
         Set_Private_Data_Region (Reading_Value'Address,
                                  Reading_Value'Size,
                                  Read_Write,
                                  Old_Region);

         Reading_Value := Reading_Protected_Type.Reading_Value;

         Restore_Private_Data_Region (Old_Region);
      end Read;

      -----------
      -- Write --
      -----------

      procedure Write (Reading_Value : Reading_Type) is
         Old_region : MPU_Region_Descriptor_Type;
      begin
         Set_Private_Data_Region (Reading_Protected_Type.Reading_Value'Address,
                                  Reading_Protected_Type.Reading_Value'Size,
                                  Read_Write,
                                  Old_Region);

         Reading_Protected_Type.Reading_Value := Reading_Value;

         Restore_Private_Data_Region (Old_Region);
      end Write;

   end Reading_Protected_Type;

end Sensor_Reading;
