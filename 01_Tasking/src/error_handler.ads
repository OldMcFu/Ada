with Ada.Text_IO;

package error_handler is
    
    procedure Init_Error_Handler;
    procedure Search_Directory;

    protected p_obj is
        procedure Open_Log_File;
        procedure Write_Error(Msg : in String);
        procedure Close_Log_File;
    private
        F : Ada.Text_IO.File_Type;
    end p_obj;
    
    private

    File_Path : constant String := "/home/romer/workspace/tasking/logs/";
    Max_Log_Files : Natural := 10;

    

end error_handler;