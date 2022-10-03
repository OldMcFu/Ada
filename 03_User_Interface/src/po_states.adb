package body po_states is

    protected body Protected_States is

        function Get_Start return Boolean is
            
        begin
            return Start;
        end Get_Start;

        function Get_Error return Boolean is
            
        begin
            return Error;
        end Get_Start;   

        function Get_Ready return Boolean is
            
        begin
            return Ready;
        end Get_Start;

        procedure Put_Start (State : in Boolean) is
            
        begin
            Start := State;
        end Put_Start;

        procedure Put_Error (State : in Boolean) is
            
        begin
            Error := State;
        end Put_Error;

        procedure Put_Ready (State : in Boolean) is
            
        begin
            Ready := State;
        end Put_Ready;

    end Protected_States;
   

end po_states;