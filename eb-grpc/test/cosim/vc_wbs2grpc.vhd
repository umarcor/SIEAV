library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

entity wbs2grpc is
  generic (
    g_header    : natural := 0;
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
    WBS_ACK   : out std_logic;
    DONE      : out std_logic
  );
end wbs2grpc;

architecture arch of wbs2grpc is

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

    procedure request_through_grpc is
      function grpc_request(radr : integer; rdat : integer) return integer is
      begin report "VHPIDIRECT grpc_request" severity failure; end;
      attribute foreign of grpc_request : function is "VHPIDIRECT hdl_request";
      variable q : integer;
    begin
      q := grpc_request(adr, dat);
      if adr < 0 then check_equal(q, dat); end if;
      dat := q;
    end;

    variable req_msg : msg_t;
    variable msg_type : msg_type_t;

  begin

    DONE <= '0';
    WBS_ACK <= '0';
    receive(net, wbs_ack_actor, req_msg);
    msg_type := message_type(req_msg);
    if (msg_type /= wr_msg) and (msg_type /= rd_msg) then
      unexpected_msg_type(msg_type);
    else
      dat := 0;
      adr := pop_integer(req_msg);
      if adr < g_header then
        case adr is
          when 0 =>
            -- Tell grpc2wbm to raise DONE by passing address 0 through the request channel.
            request_through_grpc;
            DONE <= '1';
          when others => error("Unknown wbs2grpc header address " & to_string(adr));
        end case;
      else
        -- Substract the header offset and add one to encode writes as negatives and reads as positives.
        adr := adr-g_header + 1;
        if msg_type = wr_msg then
          dat := pop_integer(req_msg);
          adr := -adr;
          request_through_grpc;
        elsif msg_type = rd_msg then
          request_through_grpc;
          WBS_Q <= std_logic_vector(to_signed(dat, WBS_Q'length));
        end if;
      end if;
      WBS_ACK <= '1';
      wait until rising_edge(CLK);
      WBS_ACK <= '0';
    end if;

  end process;

  WBS_STALL <= '0';

end;
