package body Linux.Ipc_Posix_Msg_Queue is

  function Open (This : in out Ipc_Posix_Msg_Queue_Type; Name : in String; Mode : in Linux.Ipc_Posix_Msg_Queue.Mode_Type) return Interfaces.C.int is
    Bounded_Name : Message_Name_Type.Bounded_String := Message_Name_Type.To_Bounded_String(Name);
  begin
    This.Mode := Mode;
    This.Name := Bounded_Name;
    
    if (Mode = Linux.Ipc_Posix_Msg_Queue.Read_Only) then
      This.Fd := Create_Reader_Mq(Interfaces.C.Strings.New_String(Name));
    else
      This.Fd := Create_Writer_Mq(Interfaces.C.Strings.New_String(Name));
    end if;

    if This.Fd < 0 then 
      return -1;
    else
      return 0;
    end if;

  end Open;

  function Write (This : in Ipc_Posix_Msg_Queue_Type; Value : in Message_Type) return Interfaces.C.int is
    Ret : Interfaces.C.int := -1;
  begin

    if (This.Mode = Linux.Ipc_Posix_Msg_Queue.Read_Only) then
      Ret := -1;
    else
      Ret := Writer_Mq(This.Fd, Value);
    end if;

    return Ret;

  end Write;

  function Read (This : in  Ipc_Posix_Msg_Queue_Type; Value : out Message_Type) return Interfaces.C.int is
    Ret : Interfaces.C.int := -1;

  begin
    Ret := Reader_Mq(This.Fd, Value);

    return Ret;

  end Read;

  procedure Close (This : in Ipc_Posix_Msg_Queue_Type) is
  begin

    if (This.Mode = Linux.Ipc_Posix_Msg_Queue.Read_Only) then
      Close_Reader_Mq(This.Fd);
    else
      Close_Write_Mq(This.Fd, Interfaces.C.Strings.New_String(Message_Name_Type.To_String(This.Name)));
    end if;

  end Close;
  

end Linux.Ipc_Posix_Msg_Queue;