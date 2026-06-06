library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

use work.vc_queue_pkg.vc_msg_t;
use work.vc_queue_pkg.push_msg;
use work.vc_queue_pkg.pop_msg;

entity wbs2q is
  generic (
    g_request   : queue_t;
    g_response  : queue_t;
    g_dat_width : natural := 16;
    g_adr_width : natural := 10
  );
  port (
    CLK       :  in std_logic;
    WBS_ADR   :  in std_logic_vector(g_adr_width-1 downto 0);
    WBS_D     :  in std_logic_vector(g_dat_width-1 downto 0);
    WBS_Q     : out std_logic_vector(g_dat_width-1 downto 0);
    WBS_SEL   :  in std_logic_vector(g_dat_width/8 -1 downto 0);
    WBS_CYC   :  in std_logic;
    WBS_STB   :  in std_logic;
    WBS_WE    :  in std_logic;
    WBS_STALL : out std_logic;
    WBS_ACK   : out std_logic
  );
end wbs2q;

architecture arch of wbs2q is

  constant wbs_ack_actor: actor_t := new_actor;
  constant wr_msg : msg_type_t := new_msg_type("wb slave write");
  constant rd_msg : msg_type_t := new_msg_type("wb slave read");

begin

  request : process
    variable req_msg : msg_t;
    variable adr : integer;
  begin
    wait until (WBS_CYC and WBS_STB) = '1' and WBS_STALL = '0' and rising_edge(CLK);
    adr := to_integer(unsigned(WBS_ADR));
    if WBS_WE then
      req_msg := new_msg(wr_msg);
      push_integer(req_msg, adr);
      push_integer(req_msg, to_integer(signed(WBS_D)));
    else
      req_msg := new_msg(rd_msg);
      push_integer(req_msg, adr);
    end if;
    send(net, wbs_ack_actor, req_msg);
  end process;

  acknowledge : process

    variable adr, dat : integer;

    procedure request_through_queue is
--      function grpc_request(adr : integer; dat : integer) return integer is
--      begin report "VHPIDIRECT grpc_request" severity failure; end;
--      attribute foreign of grpc_request : function is "VHPIDIRECT hdl_request";
--      variable q : integer;
      variable resp : vc_msg_t;
    begin
--      q := grpc_request(config(x), dat);
--      assert dat = q report "Q mismatch!" severity failure;
      push_msg(g_request, (
        adr => adr,
        dat => dat
      ));
      while is_empty(g_response) loop
        wait for 50 ns;
      end loop;
      resp := pop_msg(g_response);
      check_equal(resp.adr, adr);
      if adr < 0 then
        check_equal(resp.dat, dat);
      end if;
      dat := resp.dat;
    end;

    variable req_msg : msg_t;
    variable msg_type : msg_type_t;

  begin

    WBS_ACK <= '0';
    receive(net, wbs_ack_actor, req_msg);
    msg_type := message_type(req_msg);
    if (msg_type /= wr_msg) and (msg_type /= rd_msg) then
      unexpected_msg_type(msg_type);
    else
      adr := pop_integer(req_msg)+1;
      if msg_type = wr_msg then
        dat := pop_integer(req_msg);
        adr := -adr;
        request_through_queue;
      elsif msg_type = rd_msg then
        dat := 0;
        request_through_queue;
        WBS_Q <= std_logic_vector(to_signed(dat, WBS_Q'length));
      end if;
      WBS_ACK <= '1';
      wait until rising_edge(CLK);
      WBS_ACK <= '0';
    end if;

  end process;

  WBS_STALL <= '0';

end;
