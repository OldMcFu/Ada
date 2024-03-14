with Ada.Text_IO;
with Ada.IO_Exceptions;
with GNAT.Sockets;
with Ada.Streams;
procedure main is
   Receiver   : GNAT.Sockets.Socket_Type;
   Connection : GNAT.Sockets.Socket_Type;
   Client     : GNAT.Sockets.Sock_Addr_Type;
   Channel    : GNAT.Sockets.Stream_Access;
   Offset :    Ada.Streams.Stream_Element_Count;
   Buffer : Ada.Streams.Stream_Element_Array (1 .. 1);
begin
   GNAT.Sockets.Create_Socket (Socket => Receiver);
   GNAT.Sockets.Set_Socket_Option
     (Socket => Receiver,
      Level  => GNAT.Sockets.Socket_Level,
      Option => (Name    => GNAT.Sockets.Reuse_Address, Enabled => True));
   GNAT.Sockets.Bind_Socket
     (Socket  => Receiver,
      Address => (Family => GNAT.Sockets.Family_Inet,
                  Addr   => GNAT.Sockets.Inet_Addr ("127.0.0.1"),
                  Port   => 12321));
   GNAT.Sockets.Listen_Socket (Socket => Receiver);
   GNAT.Sockets.Accept_Socket
        (Server  => Receiver,
         Socket  => Connection,
         Address => Client);
      Ada.Text_IO.Put_Line
        ("Client connected from " & GNAT.Sockets.Image (Client));
   loop
      Channel := GNAT.Sockets.Stream (Connection);
      String'Output(Channel, "Hello Client!\n");
      begin
         loop
            declare
               Char : Character;
            begin
               Character'Read(Channel, Char);
               Ada.Text_IO.Put ("This is the Char: ");
               Ada.Text_IO.Put_Line (Integer'Image(Character'Pos(Char)));

               Character'Output(Channel, Char);
            end;
            delay 1.0;
         end loop;
      exception
         when Ada.IO_Exceptions.End_Error =>
            Ada.Text_IO.Put ("null;;or");
            exit;
         when others =>
            Ada.Text_IO.Put ("Error");
            exit;
      end;
      
   end loop;
   GNAT.Sockets.Close_Socket (Connection);
end main;
