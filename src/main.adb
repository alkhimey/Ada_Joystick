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

procedure Main is

   
   type Logiteck_Extreme_3D_Pro_Axis_Type is
      (STICK_X, STICK_Y, STICK_Z, THROTTLE, HAT_X, HAT_Y);

   type Logiteck_Extreme_3D_Pro_Button_Type is 
      (BUTTON_01, BUTTON_02, BUTTON_03, BUTTON_04,
       BUTTON_05, BUTTON_06, BUTTON_07, BUTTON_08,
       BUTTON_09, BUTTON_10, BUTTON_11, BUTTON_12);

   
   package L3D is new Linux_Joystick(Button_Type => Logiteck_Extreme_3D_Pro_Button_Type,
                                     Axis_Type   => Logiteck_Extreme_3D_Pro_Axis_Type);

begin

   declare
      Opended_Device_Path : String := L3D.Open;
   begin
      Text_IO.Put_Line("Opended device at: " & Opended_Device_Path);
   
      loop
         declare
            Js_Event :  L3D.Js_Event_Type := L3D.Read;
         begin
            L3D.Put(Js_Event);
         end;
      end loop;
      
      L3D.Close;

   end;

end Main;
