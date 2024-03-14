with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time;
with GNAT.Sockets;
with Ada.Streams;
package body tasking is

   protected body Obj is
      procedure Set is
         use GNAT.Sockets;
         Server : Socket_Type;
         Address, From : Sock_Addr_Type;
         Data : Ada.Streams.Stream_Element_Array(1 .. 512);
         Last : Ada.Streams.Stream_Element_Offset;
         Watchdog : Natural := 0;
         --https://stackoverflow.com/questions/40760503/stream-read-blocking-udp-gnat
      begin
         Create_Socket (Server, Family_Inet, Socket_Datagram);

         Set_Socket_Option
         (Server,
            Socket_Level,
            (Reuse_Address, True));

         Set_Socket_Option
         (Server,
            Socket_Level,
            (Receive_Timeout,
            Timeout => 1.0));

         Address.Addr := Inet_Addr ("127.0.0.1");
         Address.Port := 50001;

         Bind_Socket (Server, Address);
         Ada.Text_IO.Put_Line ("Ready");
         loop
            begin
               GNAT.Sockets.Receive_Socket (Server, Data, Last, From);
               for I in 1 .. Last loop
                  Ada.Text_IO.Put (Character'Val (Data (I)));
               end loop;
               Ada.Text_IO.Put_Line ("last : " & Last'Img);
               Ada.Text_IO.Put_Line ("from : " & Image (From.Addr));
            exception
               when Socket_Error =>
                  Watchdog := Watchdog + 1;
                  exit when Watchdog = 10;
            end;
         end loop;
         
         Is_Set := True;
      end Set;

      entry Get
         when Is_Set is
      begin
         null;
         --Is_Set := False;
      end Get;
   end Obj;

   task body blub is

   begin
      delay 5.0;
      Obj.Set;
   end blub;

    task body run_type is
            use Ada.Real_Time; -- for the "-" and "+" operations on Time
    begin
         Put_Line ("Hello World!");
         Obj.Get;
         Put_Line ("Current time: " & Duration'Image(To_Duration(Clock - Time_Of(0, Time_Span_Zero))));
        accept play (trigger: Boolean) do
         --if trigger then
            null;
         --end if;
         
        end play;
    end run_type;

end tasking;