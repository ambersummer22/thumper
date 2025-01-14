---------------------------------------------------------------------------
-- FILE    : server_logger.adb
-- SUBJECT : Body of a log management package.
-- AUTHOR  : (C) Copyright 2022 by Peter Chapin
--
-- Please send comments or bug reports to
--
--      Peter Chapin <chapinp@acm.org>
---------------------------------------------------------------------------

-- This is Off for now. Turning it on requires that we refine Log_Stream which, right now
-- needs to say something about the external file system. I don't think I'm ready to let
-- that information propagate upward just yet. Maybe later.
pragma SPARK_Mode(Off);

with Ada.Text_IO;
with Ada.Calendar;

use Ada.Calendar;

package body Server_Logger is

   function Format_Timestamp return String is
      Current_Time   : constant Time    := Clock;
      Year_String    : constant String  := Integer'Image(Year (Current_Time));
      Month_String   : constant String  := Integer'Image(Month(Current_Time));
      Day_String     : constant String  := Integer'Image(Day  (Current_Time));

      Seconds_Time   : constant Integer := Integer(Seconds(Current_Time));
      Hour_Number    : constant Integer := Integer(Seconds_Time / 3600);
      Minute_Number  : constant Integer := (Seconds_Time - (Hour_Number * 3600)) / 60;
      Seconds_Number : constant Integer := Seconds_Time - (Hour_Number * 3600) - (Minute_Number * 60);

      Hour_String    : constant String  := Integer'Image(Hour_Number);
      Minute_String  : constant String  := Integer'Image(Minute_Number);
      Second_String  : constant String  := Integer'Image(Seconds_Number);
      Full_Seconds_String : constant String :=
        (if Hour_String'Length   = 2 then "0" else "") & Hour_String  (2 .. Hour_String'Last)   & ":" &
        (if Minute_String'Length = 2 then "0" else "") & Minute_String(2 .. Minute_String'Last) & ":" &
        (if Second_String'Length = 2 then "0" else "") & Second_String(2 .. Second_String'Last);
   begin
      return
        Year_String (2 .. Year_String'Last)  & "-"  &
        (if Month_String'Length = 2 then "0" else "") & Month_String(2 .. Month_String'Last) & "-" &
        (if Day_String'Length   = 2 then "0" else "") & Day_String  (2 .. Day_String'Last)   & " " &
        Full_Seconds_String & ": ";
   end Format_Timestamp;


   procedure Write_Information(Message : in String) is
   begin
      Ada.Text_IO.Put_Line(Format_Timestamp & "*** INF: " & Message);
   end Write_Information;


   procedure Write_Warning(Message : in String) is
   begin
      Ada.Text_IO.Put_Line(Format_Timestamp & "*** WRN: " & Message);
   end Write_Warning;


   procedure Write_Error(Message : in String) is
   begin
      Ada.Text_IO.Put_Line(Format_Timestamp & "*** ERR: " & Message);
   end Write_Error;

end Server_Logger;
