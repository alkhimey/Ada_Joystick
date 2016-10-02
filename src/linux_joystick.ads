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

with System;

generic
   type Button_Type is (<>);
   type Axis_Type   is (<>);
package Linux_Joystick is

   type Milliseconds_Type is range 0..(2**32)-1;
   for Milliseconds_Type'Size use 32;

   type Value_Type is range -32767..32767;
   for Value_Type'Size use 16; 

   type Event_Type_Type is (JS_EVENT_BUTTON, JS_EVENT_AXIS);
   for Event_Type_Type use (JS_EVENT_BUTTON => 1, JS_EVENT_AXIS => 2);

   type Button_Action_Type is (RELEASE, DEPRESS);
   for Button_Action_Type use (RELEASE => 0, DEPRESS => 1);
  

   for Event_Type_Type'Size use 7;

   type Js_Event_Type(Event_Type : Event_Type_Type) is
      record
         Time               : Milliseconds_Type; 
         Is_Init_Event      : Boolean;

         case Event_Type is
            when JS_EVENT_BUTTON =>
               Button        : Button_Type;
               Button_Action : Button_Action_Type;

            when JS_EVENT_AXIS   =>
               Axis  : Axis_Type;
               Value : Value_Type;
         end case;

      end record;



   procedure Put(Js_Event : in Js_Event_Type);
   procedure Open(Name : String := "/dev/input/js1");
   function Read return Js_Event_Type;
   procedure Close;


end Linux_Joystick;


