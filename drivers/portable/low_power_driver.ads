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

with Pin_Mux_Driver;
with Memory_Protection;
with Interfaces.Bit_Types;

--
--  @summary Low power driver
--
package Low_Power_Driver is
   use Pin_Mux_Driver;
   use Memory_Protection;
   use Interfaces.Bit_Types;

   function Initialized return Boolean;
   --  @private (Used only in contracts)

   procedure Initialize
     with Pre => not Initialized;
   --
   --  Initialize the low power hardware module
   --

   procedure Set_Low_Power_Run_Mode
      with Pre => Initialized;

   type Wakeup_Callback_Type is access procedure;

   procedure Set_Low_Power_Stop_Mode (Wakeup_Callback : Wakeup_Callback_Type)
      with Pre => Initialized and
                  Wakeup_Callback /= null;

   procedure Set_Normal_Run_Mode
      with Pre => Initialized;

   procedure Set_Very_Low_Power_Stop_Mode (
      Wakeup_Callback : Wakeup_Callback_Type)
      with Pre => Initialized and
                  Wakeup_Callback /= null;

   procedure Set_Low_Power_Wakeup_Source (Pin_Info : Pin_Info_Type;
                                          Pin_Irq_Mode : Pin_Irq_Mode_Type)
     with Pre => Initialized;
   --
   --  Set the low-power wakeup source
   --
   --  @param Pin_Info : Pin to be set as the wakeup source
   --

private

   --
   --  State variables of the low-power module
   --
   --  @field Initialized Flag indicating if this device has been initialized
   --  @field Wakeup_Pin : Pin to cause wake-up from low power sleep
   --
   type Low_Power_Var_Type is limited record
      Initialized : Boolean := False;
      Low_Power_Run_Mode : Boolean := False;
      Wakeup_Callback : Wakeup_Callback_Type := null;
      Wakeup_Pin : Pin_Info_Type;
   end record with Alignment => MPU_Region_Alignment,
                   Size => MPU_Region_Alignment * Byte'Size;

   Low_Power_Var : Low_Power_Var_Type;

   function Initialized return Boolean is
     (Low_Power_Var.Initialized);

end Low_Power_Driver;
