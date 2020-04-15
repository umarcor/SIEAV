entity tb is
  generic (
    REF_WIDTH : natural := 8
  );
end entity;

library ieee;
context ieee.ieee_std_context;

architecture arch of tb is

 constant t : time:= 10 ns;
 signal done : boolean := false;
 signal clk, rst : std_logic := '0';
 signal ref : integer range 0 to 2**REF_WIDTH-1;
 signal ref_stdv : std_logic_vector(REF_WIDTH-1 downto 0);

begin

  clk <= not clk after t/2;

  p_main: process begin
    report "start simulation";
    rst <= '1';
    wait for 10*t;
    rst <= '0';

    ref <= 0;   wait for 1 us;
    ref <= 40;  wait for 1 ms;
    ref <= 100; wait for 1 ms;

    report "end of test";
    std.env.finish(0);
  end process;

  ref_stdv <= std_logic_vector(to_signed(ref, REF_WIDTH));

  uut: entity work.sys
  port map (
    CLK => clk,
    RST => rst,
    REF => ref_stdv
  );

end arch;
