with GNAT.Sockets;
with Ada.Streams;

package udp_sockets is
   type Udp_Socket is tagged private;
   type Udp_Socket_Class is access Udp_Socket'Class;

   procedure Init (This : in out Udp_Socket; 
      My_Addr : in String; 
      My_Port : in Natural; 
      Their_Addr : in String; 
      Their_Port : in Natural);

   procedure Write(This : in Udp_Socket; 
      Item   : Ada.Streams.Stream_Element_Array) ;
   
   function Read(This : in Udp_Socket) return Ada.Streams.Stream_Element_Array;
   
private
   type Udp_Socket is tagged
      record
         Socket       : GNAT.Sockets.Socket_Type;
         My_Sock_Addr : GNAT.Sockets.Sock_Addr_Type;
         Their_Sock_Addr : GNAT.Sockets.Sock_Addr_Type;
      end record;
end udp_sockets;
