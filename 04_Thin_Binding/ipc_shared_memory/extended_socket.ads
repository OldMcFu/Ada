with Interfaces.C;
with Interfaces.C.Pointers;
with Interfaces.C.Strings;
with GNAT.OS_Lib;
with GNAT.Sockets;
with Ada.Streams;
with System;
with Ada.Unchecked_Deallocation;
with Ada.Unchecked_Conversion;
with Ada.Text_IO;
package Extended_Socket is

   function Setup_Option_Timestamp_Udp (Socket : GNAT.Sockets.Socket_Type) return Interfaces.C.int;

   function Read_Msg_With_Timestamp
     (Socket     :     GNAT.Sockets.Socket_Type;
      Item       : out Ada.Streams.Stream_Element_Array;
      Last       : out Ada.Streams.Stream_Element_Offset;
      Time_Stamp : out Interfaces.C.long_long) return Interfaces.C.int;

private
   function C_Read_Msg
     (Socket : Interfaces.C.int; Message : System.Address;
      Len    : Interfaces.C.size_t; Time_Stamp : out Interfaces.C.long_long)
      return Interfaces.C.int;
   pragma Import (C, C_Read_Msg, "read_msg");

   function C_Setup_Timestamp_Udp
     (S : Interfaces.C.int) return Interfaces.C.int;
   pragma Import (C, C_Setup_Timestamp_Udp, "setup_timestamp_udp");

end Extended_Socket;
