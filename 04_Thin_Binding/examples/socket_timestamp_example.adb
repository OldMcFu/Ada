with Ada.Text_IO;  use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams;
with Extended_Socket;
with Interfaces.C;

procedure Socket_Timestamp_Example is
    Client_Socket  : Socket_Type;
    Server_Address : Sock_Addr_Type;
    Client_Address : Sock_Addr_Type;
    Data           : constant Ada.Streams.Stream_Element_Array (1 .. 10) :=
       (47, 48, 49, 50, 51, 52, 53, 54, 55, 56);
    Last           : Ada.Streams.Stream_Element_Offset;

    Read_Data : Ada.Streams.Stream_Element_Array (1 .. 1024);

    Res : Interfaces.C.int;
    Ts : Interfaces.C.long_long;
begin
    -- Create a UDP socket
    Create_Socket
       (Client_Socket, Family_Inet, Socket_Datagram);
    Client_Address.Addr := Inet_Addr ("127.0.0.1");
    Client_Address.Port := 45000;
    Bind_Socket(Client_Socket, Client_Address);

    Res := Extended_Socket.Setup_Option_Timestamp_Udp(Client_Socket);
    -- Set the server address
    Server_Address.Addr := Inet_Addr ("127.0.0.1");
    Server_Address.Port := 45100;
    loop
    -- Send the message to the server
    Send_Socket (Client_Socket, Data, Last, Server_Address);

    Res := Extended_Socket.Read_Msg_With_Timestamp(Client_Socket, Read_Data, Last, Ts);
    Put_Line("Message received at: " & Interfaces.C.long_long'Image(Ts) & " And with a length of: " & Interfaces.C.int'Image(Res));
    for I in 1 .. Res loop
        Put(Ada.Streams.Stream_Element'Image(Read_Data(Ada.Streams.Stream_Element_Offset(I))));
    end loop;
    Put_Line("");

    delay 1.0;
    end loop;
    
    -- Close the socket
    Close_Socket (Client_Socket);
end Socket_Timestamp_Example;
