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

library ieee;
package fixed_pkg is new ieee.fixed_generic_pkg;

library ieee;
use ieee.math_real.trunc;

use work.fixed_pkg.all;
use work.fixed_pkg.to_sfixed;
use work.fixed_pkg.to_real;

architecture p_fixed of controller is
  signal e: signed(8 downto 0);

  signal d : sfixed(4 downto -4);

  subtype c_t is sfixed(2 downto 0);
  constant c : c_t := to_sfixed(2, c_t'left, c_t'right);

  signal p : sfixed(d'left+c'left+1 downto d'right+c'right);
begin

  e <= resize(signed(R),e)-signed(I);
  d <= to_sfixed(std_logic_vector(e), d);

  p <= c * d;

  process(CLK)
  begin
    if rising_edge(CLK) then
      if rst then
        O <= (others=>'0');
      elsif EN then
        O <= to_slv(p(d'left+c'right downto d'left+c'right-O'length+1));
      end if;
    end if;
  end process;

end p_fixed;

