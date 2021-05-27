library ieee;
context ieee.ieee_std_context;

architecture p_int of controller is
  signal e: signed(8 downto 0);
begin

  e <= resize(signed(R),e)-signed(I);

  process(CLK)
  begin
    if rising_edge(CLK) then
      if rst then
        O <= (others=>'0');
      elsif EN then
        O <= std_logic_vector(resize(shift_right(e, 3), signed(O)));
      end if;
    end if;
  end process;

end p_int;

---

use work.fixed_pkg.all;

architecture p_fixed of controller is

  signal e: signed(8 downto 0);

  subtype c_t is sfixed(2 downto 0);
  constant c : c_t := to_sfixed(2, c_t'left, c_t'right);

  subtype o_t is sfixed(3 downto -4);

  signal p : sfixed(c'left+e'length downto c'right);

begin

  e <= resize(signed(R),e)-signed(I);

  p <= c * to_sfixed(std_logic_vector(e), 4, -4);

  process(CLK)
  begin
    if rising_edge(CLK) then
      if rst then
        O <= (others=>'0');
      elsif EN then
        O <= to_slv(resize(p, o_t'left, o_t'right));
      end if;
    end if;
  end process;

end p_fixed;
