with Ada.Directories;
with Ada.Calendar;            use Ada.Calendar;
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;

package body error_handler is

   procedure Init_Error_Handler is
      --"XXXX-XX-XX XX:XX:XX" 19 Chars
   begin
      null;
   end Init_Error_Handler;

   procedure Search_Directory is
      use Ada.Directories;
      Oldest_File : String := Image (Clock);
      Cnt         : Natural := 0;
      
      procedure Write_Search_Item(Search_Item : in Directory_Entry_Type) is
         File_Name : String := Simple_Name(Directory_Entry => Search_Item);
      begin
         if Value (Date => File_Name(1 .. 19)) < Value (Date => Oldest_File) then
            Oldest_File := File_Name(1 .. 19);
         end if;
         Cnt := Cnt + 1;
         if Cnt = Max_Log_Files then
            declare
               F         : Ada.Text_IO.File_Type;
            begin
               Ada.Text_IO.Create (F, Ada.Text_IO.Out_File, File_Path & Oldest_File & ".log");
               Ada.Text_IO.Delete (F);   
            end;
         end if;
      end Write_Search_Item;

      Filter : Constant Filter_Type := (Ordinary_File => True,
                                        Special_File => False,
                                        Directory => True);         
   begin
      Search(Directory => File_Path,
             Pattern => ("*.log"),
             Filter => Filter,
             Process => Write_Search_Item'Access);           
   end Search_Directory;



   protected body p_obj is
      
      procedure Open_Log_File is
         Log_File_Path : constant String := File_Path & Image (Clock) & ".log";
      begin
         Ada.Text_IO.Create (F, Ada.Text_IO.Append_File, Log_File_Path);
      end Open_Log_File;

      procedure Write_Error(Msg : in String) is
         Time_Stamp : String := Image (Clock);
      begin
         Ada.Text_IO.Put_Line (F, Time_Stamp & ": " & Msg);
         
      end Write_Error;

      procedure Close_Log_File is

      begin
         Ada.Text_IO.Close (F);
      end Close_Log_File;
   end p_obj;

end error_handler;