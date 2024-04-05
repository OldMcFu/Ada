with Interfaces.C;
with Linux.Ipc_Posix_Msg_Queue;

with Ada.Text_IO;

procedure Ipc_Posix_Msg_Queue_Example is
    Message_Queue_Name : constant String := "/msq1";
    use type Interfaces.C.int;
    Ret : Interfaces.C.int;
    Msg : Character;
    Ipc_Queue_Read : Linux.Ipc_Posix_Msg_Queue.Ipc_Posix_Msg_Queue_Class := new Linux.Ipc_Posix_Msg_Queue.Ipc_Posix_Msg_Queue_Type;
    Ipc_Queue_Write : Linux.Ipc_Posix_Msg_Queue.Ipc_Posix_Msg_Queue_Class := new Linux.Ipc_Posix_Msg_Queue.Ipc_Posix_Msg_Queue_Type;
    
begin

    Ret := Ipc_Queue_Write.Open(Message_Queue_Name, Linux.Ipc_Posix_Msg_Queue.Read_Write);
    if Ret < 0 then Ada.Text_IO.Put_Line("Error By Open Writer!"); end if;
    Ret := Ipc_Queue_Read.Open(Message_Queue_Name, Linux.Ipc_Posix_Msg_Queue.Read_Only);
    if Ret < 0 then Ada.Text_IO.Put_Line("Error By Open Reader!"); end if;
    Ret := Ipc_Queue_Write.Write('A');
    if Ret < 0 then Ada.Text_IO.Put_Line("Error By Write Msg!"); end if;
    Ret := Ipc_Queue_Read.Read(Msg);
    if Ret < 0 then Ada.Text_IO.Put_Line("Error By Read Msg!"); end if;

    Ada.Text_IO.Put_Line(Character'Image(Msg));

    Ipc_Queue_Read.Close;
    Ipc_Queue_Write.Close;

end Ipc_Posix_Msg_Queue_Example;