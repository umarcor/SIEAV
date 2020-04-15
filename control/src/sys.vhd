library ieee;
context ieee.ieee_std_context;

entity sys is
  port (
    CLK: in std_logic;
    RST: in std_logic;
    REF: in std_logic_vector(7 downto 0)
  );
end entity;

---

architecture arch of sys is

  signal y, u, i, o: std_logic_vector(7 downto 0);
  signal cnt_c, cnt_p: unsigned(7 downto 0);
  signal en_c, en_o, en_p, en_i: std_logic;

begin

  i_controller: entity work.controller(p_fixed)
    port map ( CLK, RST, en_c, REF, y, u );

  i_actuator: entity work.actuator
    port map ( CLK, RST, en_o, u, i );

  i_plant: entity work.plant
    port map ( CLK, RST, en_p, i, o );

  i_hold: entity work.hold
    port map ( CLK, RST, en_i, o, y );

  p_clks: process(CLK)
  begin
    if rising_edge(CLK) then
      if RST then
        cnt_c <= (others=>'0');
        cnt_p <= (others=>'0');
      else
        cnt_c <= (others=>'0') when cnt_c?=9 else cnt_c+1;
        cnt_p <= (others=>'0') when cnt_c?=99 else cnt_p+1;
      end if;
    end if;
  end process;

  en_c <= cnt_c?=1;
  en_o <= '1';
  en_p <= cnt_p?=1;
  en_i <= '1';

end arch;