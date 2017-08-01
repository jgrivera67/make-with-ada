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

with Ada.Real_Time;

--
--  @summary Real-Time Clock (RTC) driver
--
package RTC_Driver is
   use Ada.Real_Time;

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

private

   RTC_Initialized : Boolean := False;

   function Initialized return Boolean is (RTC_Initialized);

end RTC_Driver;
