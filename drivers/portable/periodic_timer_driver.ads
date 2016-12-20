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
--  @summary Periodic timer driver
--
package Periodic_Timer_Driver is
   pragma SPARK_Mode (Off);
   use Devices.MCU_Specific;
   use Devices.MCU_Specific.PIT;
   use Interfaces;

   type Timer_Callback_Access_Type is access procedure;

   function Initialized
      (Periodic_Timer_Id : Periodic_Timer_Device_Id_Type) return Boolean;
   --  @private (Used only in contracts)

   type Timer_Period_Ms_Type is range 1 .. Unsigned_16'Last;

   subtype Periodic_Timer_Channel_Id_Type is Integer range
      PIT_Channel_Array_Type'First .. PIT_Channel_Array_Type'Last;

   procedure Initialize (Periodic_Timer_Id : Periodic_Timer_Device_Id_Type)
     with Pre => not Initialized (Periodic_Timer_Id);
   --
   --  Initialize the given periodic timer device
   --
   --  @param Periodic_Timer_Id Periodic timer device Id
   --

   procedure Start_Timer_Channel (
      Periodic_Timer_Id : Periodic_Timer_Device_Id_Type;
      Timer_Channel_Id : Periodic_Timer_Channel_Id_Type;
      Timer_Period_Ms : Timer_Period_Ms_Type;
      Timer_Callback_Ptr : Timer_Callback_Access_Type)
     with Pre => Initialized (Periodic_Timer_Id);
   --
   --  Starts the given channel on a periodic timer device
   --
   --  @param Periodic_Timer_Id Periodic timer device Id
   --  @param Timer_Channel_Id channel to be started in the timer device
   --  @param Timer_Period_Ms  period for the channel in milliseconds
   --  @param Timer_Callback Callback procedure to be invoked every
   --  Timer_Period_Ms milliseconds
   --  @param Timer_Callback_Arg Argument to be passed in to the timer callback
   --  procedure
   --

   procedure Stop_Timer_Channel (
      Periodic_Timer_Id : Periodic_Timer_Device_Id_Type;
      Timer_Channel_Id : Periodic_Timer_Channel_Id_Type)
      with Pre => Initialized (Periodic_Timer_Id);
   --
   --  Stops the given channel on a periodic timer device
   --
   --  @param Periodic_Timer_Id Periodic timer device Id
   --  @param Timer_Channel_Id channel to be stopped in the timer device
   --
end Periodic_Timer_Driver;
