library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;

package vc_queue_pkg is
  type vc_msg_t is record
    adr : integer;
    dat : integer;
  end record;

  procedure push_msg (
    queue : queue_t;
    msg : vc_msg_t
  );

  impure function pop_msg (
    queue : queue_t
  ) return vc_msg_t;
end package;

package body vc_queue_pkg is

  procedure push_msg (
    queue : queue_t;
    msg : vc_msg_t
  ) is
  begin
    push(queue, msg.adr);
    push(queue, msg.dat);
  end;

  impure function pop_msg (
    queue : queue_t
  ) return vc_msg_t is
    variable msg : vc_msg_t;
  begin
    msg.adr := pop(queue);
    msg.dat := pop(queue);
    return msg;
  end;

end;
