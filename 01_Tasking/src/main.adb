with tasking;
with error_handler;

procedure Main is
--type index is range 1 .. 3;
--type task_array is array (index) of tasking.run_type;

--Arr : task_array;
--T1 : tasking.blub;
begin

    error_handler.Search_Directory;
    error_handler.p_obj.Open_Log_File;
    error_handler.p_obj.Write_Error ("Msg : in String");
    error_handler.p_obj.Write_Error ("Msg : in String");
    error_handler.p_obj.Write_Error ("Msg : in String");
    error_handler.p_obj.Close_Log_File;

    --for i in index loop
        --Arr(i).play (True);
    --end loop;

end;