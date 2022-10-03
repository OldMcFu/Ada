with Udp_Sockets;
with Ada.Streams;
with Ada.Text_Io;
with Ada.Unchecked_Conversion;
procedure Main is
   Obj : udp_sockets.Udp_Socket_Class := new udp_sockets.Udp_Socket;
   Msg : Ada.Streams.Stream_Element_Array(1 .. 30) := (others => 45);
begin

   Obj.Init("127.0.0.1", 10001, "127.0.0.1", 10002);
   Obj.Write(Msg);
   declare
      In_Msg : Ada.Streams.Stream_Element_Array := Obj.Read;
      subtype str is String(Integer(In_Msg'First) .. Integer(In_Msg'Last));
      subtype arr is Ada.Streams.Stream_Element_Array(In_Msg'Range);
      function magic is new Ada.Unchecked_Conversion(arr,str);
   begin
      Ada.Text_Io.Put_Line(magic(In_Msg));
   end;
end Main;
