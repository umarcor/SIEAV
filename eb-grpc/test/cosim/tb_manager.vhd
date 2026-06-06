library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_manager is
  generic (
    runner_cfg : string
  );
end tb_manager;

architecture arch of tb_manager is

  constant clk_period : time := 10 ns;

  signal clk : std_logic := '0';

begin

  clk <= not clk after clk_period/2;

  process
    function grpc_request(adr : integer; dat : integer) return integer is
    begin report "VHPIDIRECT grpc_request" severity failure; end;
    attribute foreign of grpc_request : function is "VHPIDIRECT hdl_request";

    type config_t is array (natural range <>) of integer;
    constant config : config_t := (10, 20, 30, 40, 50);
    variable dat, q : integer;
  begin
    test_runner_setup(runner, runner_cfg);
    info("VHDL MANAGER");
    for x in config'range loop
      dat := (x+1)*11;
      q := grpc_request(config(x), dat);
      assert dat = q report "Q mismatch!" severity failure;
    end loop;
    q := grpc_request(0, 0);
    test_runner_cleanup(runner);
    wait;
  end process;
  test_runner_watchdog(runner, 1 ms);

--  GoInt32 config[] = {10, 20, 30, 40, 50};
--  char k = sizeof(config)/sizeof(config[0]);
--
--  for (int x=0; x<k ; x++) {
--    int32_t adr = config[x];
--    int32_t dat = (x+1)*11;
--    assert(dat == hdl_request(adr, dat));
--  }

end;
