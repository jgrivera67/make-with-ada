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

package body Generic_Ring_Buffers is

   function Initialized (Ring_Buffer : Ring_Buffer_Type) return Boolean is
     (Ring_Buffer.Initialized);

   -- ** --

   procedure Initialize (Ring_Buffer : out Ring_Buffer_Type;
                         Name : not null access constant String) is
   begin
      pragma Assert (not Ring_Buffer.Initialized);
      Set_False (Ring_Buffer.Not_Empty_Condvar);
      Set_True (Ring_Buffer.Not_Full_Condvar);
      Ring_Buffer.Name := Name;
      Ring_Buffer.Initialized := True;
   end Initialize;

   -- ** --

   procedure Read (Ring_Buffer : in out Ring_Buffer_Type;
                   Element : out Element_Type) is
      Read_Ok : Boolean;
   begin
      loop
         Suspend_Until_True (Ring_Buffer.Not_Empty_Condvar);
         Ring_Buffer.Buffer.Read (Element,
                                  Read_Ok,
                                  Ring_Buffer.Not_Empty_Condvar,
                                  Ring_Buffer.Not_Full_Condvar);
         exit when Read_Ok;
      end loop;
   end Read;

   -- ** --

   procedure Write (Ring_Buffer : in out Ring_Buffer_Type;
                    Element : Element_Type) is
      Write_Ok : Boolean;
   begin
      loop
         Suspend_Until_True (Ring_Buffer.Not_Full_Condvar);
         Ring_Buffer.Buffer.Write (Element,
                                   Write_Ok,
                                   Ring_Buffer.Not_Empty_Condvar,
                                   Ring_Buffer.Not_Full_Condvar);
         exit when Write_Ok;
      end loop;
   end Write;

   -- ** --

   procedure Write_Non_Blocking (Ring_Buffer : in out Ring_Buffer_Type;
                                 Element : Element_Type;
                                 Write_Ok : out Boolean) is
   begin
      Ring_Buffer.Buffer.Write (Element,
                                Write_Ok,
                                Ring_Buffer.Not_Empty_Condvar,
                                Ring_Buffer.Not_Full_Condvar);
   end Write_Non_Blocking;

   -- ** --

   protected body Buffer_Type is

      procedure Read (Element : out Element_Type;
                      Read_Ok : out Boolean;
                      Not_Empty_Condvar : in out Suspension_Object;
                      Not_Full_Condvar : in out Suspension_Object) is
      begin
         if Num_Elements_Filled = 0 then
            Set_False (Not_Empty_Condvar);
            Read_Ok := False;
         else
            Element := Buffer_Data (Read_Cursor);
            if Read_Cursor < Buffer_Index_Type'Last then
               Read_Cursor := Read_Cursor + 1;
            else
               Read_Cursor := 1;
            end if;

            Num_Elements_Filled := Num_Elements_Filled - 1;
            Set_True (Not_Full_Condvar);
            Read_Ok := True;
         end if;
      end Read;

      -- ** --

      procedure Write (Element : Element_Type;
                       Write_Ok : out Boolean;
                       Not_Empty_Condvar : in out Suspension_Object;
                       Not_Full_Condvar : in out Suspension_Object) is
      begin
         if Num_Elements_Filled = Max_Num_Elements then
            Set_False (Not_Full_Condvar);
            Write_Ok := False;
         else
            Buffer_Data (Write_Cursor) := Element;
            if Write_Cursor < Buffer_Index_Type'Last then
               Write_Cursor := Write_Cursor + 1;
            else
               Write_Cursor := Buffer_Index_Type'First;
            end if;

            Num_Elements_Filled := Num_Elements_Filled + 1;
            Set_True (Not_Empty_Condvar);
            Write_Ok := True;
         end if;
      end Write;

   end Buffer_Type;

end Generic_Ring_Buffers;
