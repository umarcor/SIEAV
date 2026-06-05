library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

use work.vc_queue_pkg.vc_msg_t;
use work.vc_queue_pkg.pop_msg;
use work.vc_queue_pkg.push_msg;

entity q2wbm is
  generic (
    g_request   : queue_t;
    g_response  : queue_t;
    g_dat_width : natural := 16;
    g_adr_width : natural := 10
  );
  port (
    CLK       :  in std_logic;
    WBM_ADR   : out std_logic_vector(g_adr_width-1 downto 0);
    WBM_D     :  in std_logic_vector(g_dat_width-1 downto 0);
    WBM_Q     : out std_logic_vector(g_dat_width-1 downto 0);
    WBM_SEL   : out std_logic_vector(g_dat_width/8 -1 downto 0);
    WBM_CYC   : out std_logic;
    WBM_STB   : out std_logic;
    WBM_WE    : out std_logic;
    WBM_STALL :  in std_logic;
    WBM_ACK   :  in std_logic
  );
end q2wbm;

architecture arch of q2wbm is

  constant bus_handle : bus_master_t := new_bus(
    data_length => g_dat_width,
    address_length => g_adr_width
  );

begin

  process
--    type request_t is array(0 to 1) of integer;
--
--    function grpc_request (arr: request_t) return boolean is
--    begin report "VHPIDIRECT grpc_request" severity failure; end;
--    attribute foreign of grpc_request : function is "VHPIDIRECT hdl_request";
--
--    variable req : request_t;
--    variable radr, rdat : integer;
--    variable empty : boolean;
--
--    procedure grpc_response(adr : integer; dat : integer) is
--    begin report "VHPIDIRECT grpc_response" severity failure; end;
--    attribute foreign of grpc_response : procedure is "VHPIDIRECT hdl_response";

    variable msg : vc_msg_t;

    variable adr : std_logic_vector(WBM_ADR'range);
    variable dat : std_logic_vector(WBM_Q'range);

  begin

    info("q2wbm!");

    while true loop

--      empty := grpc_request(req);
--      radr := req(0);
--      rdat := req(1);
--      if empty then
      if is_empty(g_request) then
        wait for 50 ns;
      else
        msg := pop_msg(g_request);
        info(to_string(msg.adr) & " " & to_string(msg.dat));
--        info(to_string(radr) & " " & to_string(rdat));

        adr := std_logic_vector(to_signed(abs(msg.adr)-1, g_adr_width));
        dat := std_logic_vector(to_signed(msg.dat, g_dat_width));
        info("0x"&to_hstring(adr) & " 0x"&to_hstring(dat));

        if msg.adr < 0 then
          write_bus(net, bus_handle, adr, dat);
        else
          read_bus(net, bus_handle, adr, dat);
        end if;

        push_msg(g_response, (
          adr => msg.adr,
          dat => to_integer(signed(dat))
        ));
--        grpc_response(radr, rdat);
      end if;

    end loop;

    wait;
  end process;

  wbm_vc : entity vunit_lib.wishbone_master
  generic map (
    bus_handle => bus_handle,
    strobe_high_probability => 1.0
  )
  port map (
    clk   => CLK,
    adr   => WBM_ADR,
    dat_i => WBM_D,
    dat_o => WBM_Q,
    sel   => WBM_SEL,
    cyc   => WBM_CYC,
    stb   => WBM_STB,
    we    => WBM_WE,
    stall => WBM_STALL,
    ack   => WBM_ACK
  );

end;
