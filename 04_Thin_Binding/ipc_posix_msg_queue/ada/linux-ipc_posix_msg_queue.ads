with Linux;
with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with Ada.Strings;
with Ada.Strings.Bounded;

package Linux.Ipc_Posix_Msg_Queue is
  pragma Preelaborate;
  type Ipc_Posix_Msg_Queue_Type is tagged limited private;
  type Ipc_Posix_Msg_Queue_Class is access Ipc_Posix_Msg_Queue_Type'Class;

  type Mode_Type is (Read_Only, Read_Write);

  type Message_Type is record
    State : Interfaces.C.int;
    Timestamp : Interfaces.C.long;
  end record
    with Convention => C;

  function Open (This : in out Ipc_Posix_Msg_Queue_Type; Name : String; Mode : Mode_Type) return Interfaces.C.int;

  function Write
   (This : in Ipc_Posix_Msg_Queue_Type; Value : in Message_Type) return Interfaces.C.int;

  function Read (This : in Ipc_Posix_Msg_Queue_Type; Value : out Message_Type) return Interfaces.C.int;

  procedure Close (This : in Ipc_Posix_Msg_Queue_Type);

private
  package Message_Name_Type is new Ada.Strings.Bounded.Generic_Bounded_Length
   (Max => 256);

  function Create_Writer_Mq
   (name : in Interfaces.C.Strings.chars_ptr) return Linux.File_Descriptor with
   Import => True, Convention => C, External_Name => "create_writer_mq";

  procedure Close_Write_Mq
   (mqd : Linux.File_Descriptor; name : in Interfaces.C.Strings.chars_ptr) with
   Import => True, Convention => C, External_Name => "close_write_mq";

  function Create_Reader_Mq
   (name : in Interfaces.C.Strings.chars_ptr) return Linux.File_Descriptor with
   Import => True, Convention => C, External_Name => "create_reader_mq";

  procedure Close_Reader_Mq (mqd : Linux.File_Descriptor) with
   Import => True, Convention => C, External_Name => "close_reader_mq";

  function Writer_Mq (mqd : Linux.File_Descriptor; val : in Message_Type) return Interfaces.C.int with
   Import => True, Convention => C, External_Name => "writer_mq";

  function Reader_Mq (mqd : Linux.File_Descriptor; val : out Message_Type) return Interfaces.C.int with
   Import => True, Convention => C, External_Name => "reader_mq";

  type Ipc_Posix_Msg_Queue_Type is tagged limited record
    Fd : Linux.File_Descriptor;
    Name : Message_Name_Type.Bounded_String;
    Mode : Mode_Type;
  end record;

end Linux.Ipc_Posix_Msg_Queue;
