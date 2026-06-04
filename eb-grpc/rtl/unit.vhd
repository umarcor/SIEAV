library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vc_context;

entity unit is
  generic (
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
end unit;

architecture arch of unit is

  constant memory : memory_t := new_memory;
  constant buf : buffer_t := allocate(memory, 2**g_adr_width);
  constant wbs : wishbone_slave_t := new_wishbone_slave(
    memory => memory,
    ack_high_probability => 1.0,
    stall_high_probability => 0.0
  );

begin

  wbs_vc : entity vunit_lib.wishbone_slave
  generic map (
    wishbone_slave => wbs
  )
  port map (
    clk   => clk,
    adr   => WBS_ADR,
    dat_i => WBS_D,
    dat_o => WBS_Q,
    sel   => WBS_SEL,
    cyc   => WBS_CYC,
    stb   => WBS_STB,
    we    => WBS_WE,
    stall => WBS_STALL,
    ack   => WBS_ACK
  );


--  process
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
--  begin
--    report "VHDL UNIT" severity note;
--    while true loop
--      empty := grpc_request(req);
--      radr := req(0);
--      rdat := req(1);
--      if empty then
--        wait for 50*clk_period;
--      else
--        report "READ " & to_string(radr) & " " & to_string(rdat) severity note;
--        grpc_response(radr, rdat);
--      end if;
--    end loop;
--    wait;
--  end process;

--  while (1) {
--    request_t req = hdl_request();
--    if (req.empty) {
--      printf("[UNIT] Empty! Waiting...\n");
--      sleep(1);
--    } else {
--      printf("[UNIT] READ %d %d\n", req.adr, req.dat);
--      hdl_response(req.adr, req.dat);
--    }
--  }

end;
