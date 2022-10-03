package body udp_sockets is

   procedure Init (This : in out Udp_Socket; My_Addr : in String; My_Port : in Natural; 
   Their_Addr : in String; 
   Their_Port : in Natural) is
      Tmp : GNAT.Sockets.Sock_Addr_Type;
   begin
      Tmp.Addr := GNAT.Sockets.Inet_Addr(My_Addr);
      Tmp.Port := GNAT.Sockets.Port_Type(My_Port);
      This.My_Sock_Addr := Tmp;
      
      Tmp.Addr := GNAT.Sockets.Inet_Addr(Their_Addr);
      Tmp.Port := GNAT.Sockets.Port_Type(Their_Port);
      This.Their_Sock_Addr := Tmp;

      GNAT.Sockets.Initialize;
      -- Create the UDP Client Socket
      GNAT.Sockets.Create_Socket  (Socket => This.Socket, Family => GNAT.Sockets.Family_Inet, Mode => GNAT.Sockets.Socket_Datagram);
      
      GNAT.Sockets.Set_Socket_Option (This.Socket, GNAT.Sockets.Socket_Level, (GNAT.Sockets.Reuse_Address, True));
      
      GNAT.Sockets.Bind_Socket (This.Socket, This.My_Sock_Addr);
   end Init;
   
   procedure Write(This : in Udp_Socket; Item   : Ada.Streams.Stream_Element_Array) is
      use Ada.Streams;
      First : Ada.Streams.Stream_Element_Offset          := Item'First; 
      Index : Ada.Streams.Stream_Element_Offset          := First - 1; 
      Max   : constant Ada.Streams.Stream_Element_Offset := Item'Last; 
   begin
      GNAT.Sockets.Send_Socket(Socket => This.Socket, Item => Item, Last => Index, To => This.Their_Sock_Addr);
   end write;
   
   function Read (This : in Udp_Socket) return Ada.Streams.Stream_Element_Array is
      Msg : Ada.Streams.Stream_Element_Array(1 .. 65000);
      Last : Ada.Streams.Stream_Element_Offset;
      Sender_Addr : GNAT.Sockets.Sock_Addr_Type;
   begin

      GNAT.Sockets.Receive_Socket(Socket => This.Socket, 
      Item   => Msg, 
      Last   =>Last, 
      From   => Sender_Addr);

      return Msg(1 .. Last);
      
   end Read;

end udp_sockets;
