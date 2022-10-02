package body udp_sockets is

   procedure write (Stream : in out Datagram_Socket_Stream_Type; 
                    Item   : Ada.Streams.Stream_Element_Array)  is
      First : Ada.Streams.Stream_Element_Offset          := Item'First; 
      Index : Ada.Streams.Stream_Element_Offset          := First - 1; 
      Max   : constant Ada.Streams.Stream_Element_Offset := Item'Last; 
   begin
         loop
         Send_Socket <== try to send until all content of write sent ?
           (Stream.Socket,
            Item (First .. Max),
            Index,
            Stream.To);

         --  Exit when all or zero data sent. Zero means that the
         --  socket has been closed by peer.

         exit when Index < First or else Index = Max;

         First := Index + 1;
      end loop;

      if Index /= Max then
         raise Socket_Error;
      end if;
   end write;
   
end udp_sockets;
