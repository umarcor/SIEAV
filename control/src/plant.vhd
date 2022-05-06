library ieee;
context ieee.ieee_std_context;

entity plant is
  port (
    CLK: in  std_logic;
    RST: in  std_logic;
    EN:  in  std_logic;
    I:   in  std_logic_vector(7 downto 0);
    O:   out std_logic_vector(7 downto 0)
  );
end entity;

---

architecture arch of plant is

  signal s: std_logic_vector(7 downto 0);

  constant c : real_vector(0 to 1) := (0.35003, 0.062554);
  constant d : real_vector(0 to 1) := (-0.84659, 0.00183);

begin

  process(CLK)
    variable v : real_vector(0 to 1) := (others=>0.0);
    variable th : real_vector(0 to 1) := (others=>0.0);
    variable vk, thk : real;
  begin
    if rising_edge(CLK) then
      if RST then
        s <= (others=>'0');
      elsif EN then

        --s <= std_logic_vector(signed(s)+1) when signed(I)>0 else
        --     std_logic_vector(signed(s)-1) when signed(I)<0 else s;

--        vk := to_real(to_sfixed(I, 1, -6));
--
--        thk := (c(0)*v(0)) + (c(1)*v(1)) - (d(0)*th(0)) - (d(1)*th(1)); -- abiadura ardatzean rad/sec
--
--        v(1)  := v(0);
--        v(0)  := vk;
--        th(1) := th(0);
--        th(0) := thk;
--        O <= to_stdv(to_sfixed(thk*9.549297, 5, -2))
      end if;
    end if;
  end process;

  O <= s;

end arch;