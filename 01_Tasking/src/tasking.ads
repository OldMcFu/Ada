package tasking is

    protected Obj is
        procedure Set;
        entry Get;
    private
        Is_Set : Boolean := False;
    end Obj;

    task type blub is
    end blub;

    task type run_type is
        entry play (trigger : Boolean);
    end run_type;

    
end tasking;

-- https://en.m.wikibooks.org/wiki/Ada_Programming/Tasking