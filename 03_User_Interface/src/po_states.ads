package po_states is

   protected type Protected_States is
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
   end Protected_States;

   type Protected_States_Pointer is access Protected_States;

end po_states;
