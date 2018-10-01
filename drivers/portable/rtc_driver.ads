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

with Interfaces;
private with Memory_Protection;
private with System;
--
--  @summary Real-Time Clock (RTC) driver
--
package RTC_Driver is
   use Interfaces;

   type Seconds_Count is new Unsigned_32;

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;
   --
   --  Initialize the CRC-32 accelerator hardware module
   --

   function Get_RTC_Time return Seconds_Count
     with Pre => Initialized;
   --
   --  Read the current time from the RTC device
   --
   --  @return Current wall time in seconds
   --

   procedure Set_RTC_Time (Wall_Time_Secs : Seconds_Count)
     with Pre => Initialized;
   --
   --  Set the current date and time in the RTC device
   --
   --  @param Wall_Time_Seconds : Date and time encoded in seconds since
   --

   type RTC_Callback_Type is access procedure;

   procedure Set_RTC_Alarm (Time_Secs : Unsigned_32;
                            RTC_Alarm_Callback : RTC_Callback_Type)
     with Pre => Initialized and RTC_Alarm_Callback /= null;
   --
   --  Set an alarm to fire at the specfied time
   --
   --  @param Time_Secs Number of second sin the future when the alarm is to
   --  fire
   --  @param RTC_Alarm_Callback callback to be invoked when the alarm fires
   --

   procedure Enable_RTC_Periodic_One_Second_Interrupt (
                Periodic_One_Second_Callback : RTC_Callback_Type)
     with Pre => Initialized and Periodic_One_Second_Callback /= null;
   --
   --  Enable RTC once-a-second peridic interrupt
   --
   --  @param Periodic_One_Second_Callback callback to be invoked once a second
   --

   procedure Disable_RTC_Periodic_One_Second_Interrupt
      with Pre => Initialized;

private
   use Memory_Protection;

   type RTC_Var_Type is limited record
      Initialized : Boolean := False;
      Alarm_Callback : RTC_Callback_Type := null;
      Periodic_One_Second_Callback : RTC_Callback_Type := null;
   end record with Alignment => MPU_Region_Alignment,
                   Size => MPU_Region_Alignment * System.Storage_Unit;

   RTC_Var : RTC_Var_Type;

   function Initialized return Boolean is (RTC_Var.Initialized);

end RTC_Driver;
