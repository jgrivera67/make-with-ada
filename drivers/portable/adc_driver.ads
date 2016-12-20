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

with Devices.MCU_Specific;
with Interfaces;

--
--  @summary Analog-to-Digital Converter (ADC) driver
--
package ADC_Driver is
   use Devices.MCU_Specific;
   use Devices.MCU_Specific.ADC;
   use Interfaces;

   ADC_Channel_None : constant := 16#1F#;

   --
   --  ADC Mux selector
   --
   type ADC_Mux_Selector_Type is (ADC_Mux_Side_A,
                                  ADC_Mux_Side_B);

   --
   --  A/D conversion resolution in bits
   --
   type ADC_Resolution_Type is (ADC_Resolution_8_Bits,
                                ADC_Resolution_10_Bits,
                                ADC_Resolution_12_Bits,
                                ADC_Resolution_16_Bits);

   for ADC_Resolution_Type use (ADC_Resolution_8_Bits => 8,
                                ADC_Resolution_10_Bits => 10,
                                ADC_Resolution_12_Bits => 12,
                                ADC_Resolution_16_Bits => 16);

   type ADC_Completion_Callback_Access_Type is access
      procedure (Conversion_Result : Unsigned_16);

   function Initialized (
      ADC_Device_Id : ADC_Device_Id_Type) return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize (ADC_Device_Id : ADC_Device_Id_Type;
                         ADC_Resolution : ADC_Resolution_Type)
     with Pre => not Initialized (ADC_Device_Id);
   --
   --  Initialize the given ADC device
   --
   --  @param ADC_Device_Id ADC device Id
   --  @param ADC_Resolution ADC conversion resolution in bits
   --

   procedure Start_Async_Conversion (ADC_Device_Id : ADC_Device_Id_Type;
                                     ADC_Channel : Unsigned_8;
                                     Hardware_Average_On : Boolean;
                                     Mux_Selector : ADC_Mux_Selector_Type;
                                     ADC_Completion_Callback_Ptr :
                                        ADC_Completion_Callback_Access_Type)
      with Pre => Initialized (ADC_Device_Id) and
                  ADC_Channel /= ADC_Channel_None and
                  ADC_Completion_Callback_Ptr /= null;
   --
   --  Starts an asynchronous A/D conversion for a given ADC channel.
   --  When the conversion is completed the specified callback is
   --  invoked from the ADC completion ISR.
   --
   --  @param ADC_Device_Id ADC device Id
   --  @param ADC_Channel A/D converter channel to use
   --  @param Hardware_Average_On Flag to enable hardware average
   --  @param Mux_Selector A/D converter mux side selector
   --  @param ADC_Completion_Callback_Ptr Conversion completion callback
   --         function pointer
   --  @param completion_callback_arg: arg to be passed to the completion
   --         callback
   --
   --  @pre Another conversion must not be started (even on a different
   --       channel) until after the completion of the last conversion
   --       started. The caller is responsible for providing proper
   --       serialization.
   --
   --       NOTE: For the KL25 ADC, only one software-triggered
   --       conversion can be done at one time, regardless of
   --       using different channels.
   --
   --  @pre: This function cannot be use in the same program with
   --        ADC_Read_Channel.
   --

end ADC_Driver;
