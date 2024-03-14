with Extended_Socket;
with Ada.Text_IO;
with Ada.Characters;
package body Extended_Socket is

   function Setup_Option_Timestamp_Udp (Socket : GNAT.Sockets.Socket_Type) return Interfaces.C.int

   is
      Res : Interfaces.C.int;
   begin

      Res := C_Setup_Timestamp_Udp(Interfaces.C.int(GNAT.Sockets.To_C (Socket)));

      return Res;
   end Setup_Option_Timestamp_Udp;


   function Read_Msg_With_Timestamp
     (Socket     :     GNAT.Sockets.Socket_Type;
      Item       : out Ada.Streams.Stream_Element_Array;
      Last       : out Ada.Streams.Stream_Element_Offset;
      Time_Stamp : out Interfaces.C.long_long) return Interfaces.C.int
   is

      use type Ada.Streams.Stream_Element_Offset;
   use type Interfaces.C.Int;
      Res : Interfaces.C.int;
      Ts  : Interfaces.C.long_long;

   begin
      Res := C_Read_Msg(Interfaces.C.int (Gnat.Sockets.To_C(Socket)), Item (Item'First)'Address, Item'Length, Ts);
      Last := Item'First + Ada.Streams.Stream_Element_Offset (Res - 1);
      Time_Stamp := Ts;

      return Res;
   end Read_Msg_With_Timestamp;
end Extended_Socket;
