with GNAT.Sockets;

package udp_sockets is
   type udp_socket is abstract tagged private<

   procedure sock_init;
   procedure write(Stream : in out Datagram_Socket_Stream_Type; 
      Item   : Ada.Streams.Stream_Element_Array) ;
   procedure read();
   
private
   type udp_socket is abstract tagged
      record
         Client : GNAT.Sockets.Socket_Type;
         
      end record;
end udp_sockets;
