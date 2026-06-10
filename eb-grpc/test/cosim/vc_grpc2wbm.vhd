library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

entity grpc2wbm is
  generic (
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
    WBM_ACK   :  in std_logic;
    DONE      : out std_logic
  );
end grpc2wbm;

architecture arch of grpc2wbm is

  constant bus_handle : bus_master_t := new_bus(
    data_length => g_dat_width,
    address_length => g_adr_width
  );

begin

  process
    type request_t is array(0 to 1) of integer;

    function grpc_request (arr: request_t) return boolean is
    begin report "VHPIDIRECT grpc_request" severity failure; end;
    attribute foreign of grpc_request : function is "VHPIDIRECT hdl_request";

    variable req : request_t;
    variable radr, rdat : integer;

    procedure grpc_response(adr : integer; dat : integer) is
    begin report "VHPIDIRECT grpc_response" severity failure; end;
    attribute foreign of grpc_response : procedure is "VHPIDIRECT hdl_response";

    variable adr : std_logic_vector(WBM_ADR'range) := (others=>'0');
    variable dat : std_logic_vector(WBM_Q'range) := (others=>'0');
    variable empty : boolean := true;

  begin

    DONE <= '0';
    info("grpc2wbm!");

    while radr /= 0 or empty loop
      empty := grpc_request(req);
      radr := req(0);
      rdat := req(1);
      if empty then
        wait for 50 ns;
      else
        info(to_string(radr) & " " & to_string(rdat));
        adr := std_logic_vector(to_signed(abs(radr)-1, g_adr_width)) when radr/=0 else (others=>'0');
        dat := std_logic_vector(to_signed(rdat, g_dat_width));
        if radr < 0 then
          write_bus(net, bus_handle, adr, dat);
        else
          read_bus(net, bus_handle, adr, dat);
        end if;
        info("0x"&to_hstring(adr) & " 0x"&to_hstring(dat));
        grpc_response(radr, to_integer(signed(dat)));
      end if;
    end loop;

    info("grpc2wbm done");
    DONE <= '1';
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
