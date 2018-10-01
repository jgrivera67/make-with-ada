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

with RTOS.API;
with Interfaces;

package body Generic_Ring_Buffers is
   use Interfaces;

   function Initialized (Ring_Buffer : Ring_Buffer_Type) return Boolean is
     (Ring_Buffer.Initialized);

   -- ** --

   procedure Initialize (Ring_Buffer : out Ring_Buffer_Type;
                         Name : not null access constant String) is
   begin
      pragma Assert (not Ring_Buffer.Initialized);
      RTOS.API.RTOS_Semaphore_Init (Ring_Buffer.Not_Empty_Semaphore,
                                    Initial_Count => 0);
      RTOS.API.RTOS_Semaphore_Init (Ring_Buffer.Not_Full_Semaphore,
                                    Initial_Count =>
                                      Unsigned_32 (Max_Num_Elements));
      Ring_Buffer.Name := Name;
      Ring_Buffer.Initialized := True;
   end Initialize;

   -- ** --

   procedure Read (Ring_Buffer : in out Ring_Buffer_Type;
                   Element : out Element_Type) is
      Old_Intmask : Unsigned_32;
   begin
      RTOS.API.RTOS_Semaphore_Wait (Ring_Buffer.Not_Empty_Semaphore);
      Old_Intmask := Disable_Cpu_Interrupts;

      Element := Ring_Buffer.Buffer_Data (Ring_Buffer.Read_Cursor);
      if Ring_Buffer.Read_Cursor < Buffer_Index_Type'Last then
	 Ring_Buffer.Read_Cursor := Ring_Buffer.Read_Cursor + 1;
      else
	 Ring_Buffer.Read_Cursor := Buffer_Index_Type'First;
      end if;

      Restore_Cpu_Interrupts (Old_Intmask);
      RTOS.API.RTOS_Semaphore_Signal (Ring_Buffer.Not_Full_Semaphore);
   end Read;

   -- ** --

   procedure Write (Ring_Buffer : in out Ring_Buffer_Type;
                    Element : Element_Type) is
      Old_Intmask : Unsigned_32;
   begin
      RTOS.API.RTOS_Semaphore_Wait (Ring_Buffer.Not_Full_Semaphore);
      Old_Intmask := Disable_Cpu_Interrupts;

      Ring_Buffer.Buffer_Data (Ring_Buffer.Write_Cursor) := Element;
      if Ring_Buffer.Write_Cursor < Buffer_Index_Type'Last then
	 Ring_Buffer.Write_Cursor := Ring_Buffer.Write_Cursor + 1;
      else
	 Ring_Buffer.Write_Cursor := Buffer_Index_Type'First;
      end if;

      Restore_Cpu_Interrupts (Old_Intmask);
      RTOS.API.RTOS_Semaphore_Signal (Ring_Buffer.Not_Empty_Semaphore);
   end Write;

   -- ** --

   procedure Write_Non_Blocking (Ring_Buffer : in out Ring_Buffer_Type;
                                 Element : Element_Type;
                                 Write_Ok : out Boolean) is
     Old_Intmask : Unsigned_32;
     Sem_status : Unsigned_8;
   begin
      RTOS.API.RTOS_Semaphore_Wait (Ring_Buffer.Not_Full_Semaphore,
                                    Timeout_Ms => 0,
                                    Status => Sem_Status);
      if Sem_Status = 0 then
	 Write_Ok := False;
 	 return;
      end if;

      Old_Intmask := Disable_Cpu_Interrupts;
      Ring_Buffer.Buffer_Data (Ring_Buffer.Write_Cursor) := Element;
      if Ring_Buffer.Write_Cursor < Buffer_Index_Type'Last then
	 Ring_Buffer.Write_Cursor := Ring_Buffer.Write_Cursor + 1;
      else
	 Ring_Buffer.Write_Cursor := Buffer_Index_Type'First;
      end if;

      Restore_Cpu_Interrupts (Old_Intmask);
      RTOS.API.RTOS_Semaphore_Signal (Ring_Buffer.Not_Empty_Semaphore);
      Write_Ok := True;
   end Write_Non_Blocking;

end Generic_Ring_Buffers;
