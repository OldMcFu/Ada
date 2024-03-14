with Res_Socket;

package body Res_Socket is

   function Setup_Option_Timestamp_Udp (Socket : GNAT.Sockets.Socket_Type) return Interfaces.C.int

   is
      Res : Intefaces.C.int;
   begin

      Res := C_Setup_Timestamp_Udp(C.int (Socket));

      return Res;
   end Setup_Option_Timestamp_Udp;


   function Read_Msg_With_Timestamp
     (Socket     :     GNAT.Sockets.Socket_Type;
      Item       : out Ada.Streams.Stream_Element_Array;
      Last       : out Ada.Streams.Stream_Element_Offset;
      Time_Stamp : out Interfaces.C.int) return Interfaces.C.int
   is

      use type Ada.Streams.Stream_Element_Offset;

      Res : Intefaces.C.int;
      Ts  : Intefaces.C.int;

   begin
      Res :=
        C_Read_Msg
          (C.int (Socket), Item (Item'First)'Address, Item'Length,
           Ts);

      Last := Item'First + Ada.Streams.Stream_Element_Offset (Res - 1);
      Time_Stamp := Ts;
   end Read_Msg;
end Res_Socket;
