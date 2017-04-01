--  The MIT License (MIT)
--
--  Copyright (c) 2016 artium@nihamkin.com
--
--  Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:
--
--  The above copyright notice and this permission notice shall be included in
--  all copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--  THE SOFTWARE.
-- 
--



with Linux_Joystick;
with Text_IO;
with Ada.Characters.Latin_1;

procedure Main is

   type Common_Axis_Type   is range 0..20;
   type Common_Button_Type is range 0..20;
   package LJS is new Linux_Joystick(Button_Type => Common_Button_Type,
                                     Axis_Type   => Common_Axis_Type);

   generic
      with package JSP is new Linux_Joystick (<>);
   procedure Put(Js_Event : in JSP.Js_Event_Type);
   
   procedure Put(Js_Event : in JSP.Js_Event_Type) is

      package Millisecinds_IO is new Text_IO.Integer_IO(JSP.Milliseconds_Type);
      package Value_IO        is new Text_IO.Integer_IO(JSP.Value_Type);

   begin
      Text_IO.Put(if Js_Event.Is_Init_Event then "I" else " ");
      Text_IO.Put(Ada.Characters.Latin_1.HT);

      Millisecinds_IO.Put(Js_Event.Time);
      Text_IO.Put(Ada.Characters.Latin_1.HT);

      Text_IO.Put(JSP.Event_Type_Type'Image(Js_Event.Event_Type));
      Text_IO.Put(Ada.Characters.Latin_1.HT);

      case Js_Event.Event_Type is      
         when JSP.JS_EVENT_BUTTON =>
            Text_IO.Put(JSP.Button_Type'Image(Js_Event.Button));
            Text_IO.Put(Ada.Characters.Latin_1.HT);            
            
            Text_IO.Put(JSP.Button_Action_Type'Image(Js_Event.Button_Action));

         when JSP.JS_EVENT_AXIS =>
         
            Text_IO.Put(JSP.Axis_Type'Image(Js_Event.Axis));
            Text_IO.Put(Ada.Characters.Latin_1.HT);

            Value_IO.Put(Js_Event.Value);
      end case;   

      Text_IO.New_Line;
   end;

   procedure Put_LJS is new Put(LJS);

begin

   declare
      -- It is also possible to use Open without parameters, it will automatically locate
      -- an available "js*" file.
      --
      Opended_Device_Path : String := "/dev/input/js1";
     
   begin
      LJS.Open(Opended_Device_Path);
      Text_IO.Put_Line("Opended device at: " & Opended_Device_Path);

      loop
         declare
            Js_Event :  LJS.Js_Event_Type := LJS.Read;
         begin
            Put_LJS(Js_Event);
         end;
      end loop;
   exception
      -- It is advisable to handle the exceptions here:
      -- ADA.IO_EXCEPTION.DEVICE_ERROR, LJS.No_Joystick_Device_Found etc.
      --
      when others =>
         LJS.Close;
         raise;
   end;

end Main;
