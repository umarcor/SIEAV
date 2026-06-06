library ieee;
context ieee.ieee_std_context;

entity tb_unit is
end tb_unit;

architecture arch of tb_unit is

  constant clk_period : time := 10 ns;
  signal clk : std_logic := '0';

begin

  clk <= not clk after clk_period/2;

  process
    type request_t is array(0 to 1) of integer;

    function grpc_request (arr: request_t) return boolean is
    begin report "VHPIDIRECT grpc_request" severity failure; end;
    attribute foreign of grpc_request : function is "VHPIDIRECT hdl_request";

    variable req : request_t;
    variable radr, rdat : integer;
    variable empty : boolean;

    procedure grpc_response(adr : integer; dat : integer) is
    begin report "VHPIDIRECT grpc_response" severity failure; end;
    attribute foreign of grpc_response : procedure is "VHPIDIRECT hdl_response";
  begin
    report "VHDL UNIT" severity note;
    while true loop
      empty := grpc_request(req);
      radr := req(0);
      rdat := req(1);
      if empty then
        wait for 50*clk_period;
      else
        report "READ " & to_string(radr) & " " & to_string(rdat) severity note;
        grpc_response(radr, rdat);
      end if;
    end loop;
    wait;
  end process;

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
