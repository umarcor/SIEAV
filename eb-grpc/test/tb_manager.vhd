library ieee;
context ieee.ieee_std_context;

entity tb_manager is
end tb_manager;

architecture arch of tb_manager is

begin

  process
    function grpc_request(adr : integer; dat : integer) return integer is
    begin report "VHPIDIRECT grpc_request" severity failure; end;
    attribute foreign of grpc_request : function is "VHPIDIRECT hdl_request";

    type config_t is array (natural range <>) of integer;
    constant config : config_t := (10, 20, 30, 40, 50);
    variable dat, q : integer;
  begin
    report "VHDL MANAGER" severity note;
    for x in config'range loop
      dat := (x+1)*11;
      q := grpc_request(config(x), dat);
      assert dat = q report "Q mismatch!" severity failure;
    end loop;
    wait;
  end process;

--  GoInt32 config[] = {10, 20, 30, 40, 50};
--  char k = sizeof(config)/sizeof(config[0]);
--
--  for (int x=0; x<k ; x++) {
--    int32_t adr = config[x];
--    int32_t dat = (x+1)*11;
--    assert(dat == hdl_request(adr, dat));
--  }

end;
