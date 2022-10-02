package po_states is

   protected type Bounded_Buffer is
      function Get_Start return Boolean;
      procedure Put_Start (State : in Boolean);
      function Get_Error return Boolean;
      procedure Put_Error (State : in Boolean);
      function Get_Ready return Boolean;
      procedure Put_Ready (State : in Boolean);
   private
      Start     : Boolean := False;
      Error     : Boolean := False;
      Ready     : Boolean := False;
   end Bounded_Buffer;

end po_states;
