with Ada.Text_IO;

procedure helloworld;
function checkGender(x : in character) return string;

function checkGender(x : in character) return string is
    begin
        if (x = 'M') then
            return "Men";
        elsif (x = 'W') then
            return "Woman";
        else
            return "Divers";
        end if;
end checkGender;

procedure helloworld is
    --declaration
    gender : character := 'M';

begin
    --use
    Ada.Text_IO.Put_Line (checkGender(gender));
end helloworld;
