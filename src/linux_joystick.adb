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

with Text_IO;
with Ada.Sequential_IO;
with Ada.Characters.Latin_1;
with Ada.Directories;

package body Linux_Joystick is

   type Axis_Button_Number_Type is range 0..(2**8)-1;
   for  Axis_Button_Number_Type'Size use 8;

   type Raw_Js_Event_Type is
      record
         Time               : Milliseconds_Type;
         Value              : Value_Type;
         Is_Init_Event      : Boolean;
         Event_Type         : Event_Type_Type;
         Axis_Button_Number : Axis_Button_Number_Type;
      end record;

   for Raw_Js_Event_Type use
      record
         Time               at 0 range 0..31;
         Value              at 4 range 0..15;
         Is_Init_Event      at 6 range 0..0;
         Event_Type         at 6 range 1..7;
         Axis_Button_Number at 7 range 0..7;  
      end record;

   for Raw_Js_Event_Type'Bit_Order use System.High_Order_First; -- TODO: veriy that this is enough 

   package SIO is new Ada.Sequential_IO(Raw_Js_Event_Type);

   Input_File : SIO.File_Type;
      
   procedure Put(Js_Event : in Js_Event_Type) is

      package Millisecinds_IO is new Text_IO.Integer_IO(Milliseconds_Type);
      package Value_IO        is new Text_IO.Integer_IO(Value_Type);

   begin
      Text_IO.Put(if Js_Event.Is_Init_Event then "I" else " ");
      Text_IO.Put(Ada.Characters.Latin_1.HT);

      Millisecinds_IO.Put(Js_Event.Time);
      Text_IO.Put(Ada.Characters.Latin_1.HT);

      Text_IO.Put(Event_Type_Type'Image(Js_Event.Event_Type));
      Text_IO.Put(Ada.Characters.Latin_1.HT);

      case Js_Event.Event_Type is      
         when JS_EVENT_BUTTON =>
            Text_IO.Put(Button_Type'Image(Js_Event.Button));
            Text_IO.Put(Ada.Characters.Latin_1.HT);            
            
            Text_IO.Put(Button_Action_Type'Image(Js_Event.Button_Action));

         when JS_EVENT_AXIS =>
         
            Text_IO.Put(Axis_Type'Image(Js_Event.Axis));
            Text_IO.Put(Ada.Characters.Latin_1.HT);

            Value_IO.Put(Js_Event.Value);
      end case;   

      Text_IO.New_Line;
   end;


   procedure Open(Name : String) is

   begin
      SIO.Open (File => Input_File,
                Mode => SIO.IN_FILE,
                Name => Name);
   end;

   function Open return String is
      Search      : Ada.Directories.Search_Type;
      Dir_Ent     : Ada.Directories.Directory_Entry_Type;
   begin
      Ada.Directories.Start_Search (Search, "/dev/input/", "js*");
 
      if not Ada.Directories.More_Entries (Search) then
         Ada.Directories.End_Search (Search);
         raise No_Joystick_Device_Found;
      end if;
 
      Ada.Directories.Get_Next_Entry (Search, Dir_Ent);
      
      declare
          Device_Path : String := Ada.Directories.Full_Name (Dir_Ent); 
      begin
         Ada.Directories.End_Search (Search);
         Open(Device_Path);
         return Device_Path;
      end;
   end;


   function Read return Js_Event_Type is
      Raw_Js_Event : Raw_Js_Event_Type;
   begin
      SIO.Read(File => Input_File, 
               Item => Raw_Js_Event);

      case Raw_Js_Event.Event_Type is
         
         when JS_EVENT_BUTTON =>
         
            return (Event_Type     => JS_EVENT_BUTTON,
                    Time           => Raw_Js_Event.Time,
                    Is_Init_Event  => Raw_Js_Event.Is_Init_Event,
                    Button         => Button_Type'Val(Raw_Js_Event.Axis_Button_Number),
                    Button_Action  => Button_Action_Type'Val(Raw_Js_Event.Value) );  -- TODO: Convert...
         when JS_EVENT_AXIS =>
         
            return (Event_Type     => JS_EVENT_AXIS,
                    Time           => Raw_Js_Event.Time,
                    Is_Init_Event  => Raw_Js_Event.Is_Init_Event,
                    Axis           => Axis_Type'Val(Raw_Js_Event.Axis_Button_Number), 
                    Value          => Raw_Js_Event.Value );  
      end case;                     
   end;

   procedure Close is
   begin
      SIO.Close(Input_File);
   end;

end Linux_Joystick;
