library ieee;
context ieee.ieee_std_context;

-- A SISO (PID) controller with inputs for Ref, Kp, Ki, Kd
entity ControllerWithExtParams is
  port (
    CLK : in  std_logic;
    RST : in  std_logic;
    EN  : in  std_logic;
    R   : in  std_logic_vector(7 downto 0);
    KP  : in  std_logic_vector(15 downto 0);
    KI  : in  std_logic_vector(15 downto 0);
    KD  : in  std_logic_vector(15 downto 0);
    I   : in  std_logic_vector(7 downto 0);
    O   : out std_logic_vector(7 downto 0)
  );
end entity;

---

use work.fixed_pkg.all;

-- Architecture of a proportional controller
-- The facade for Ki and Kd is provided, but are not used
architecture arch of ControllerWithExtParams is

  signal e: signed(8 downto 0);

  signal K_p : sfixed(2 downto -13);
  signal K_i : sfixed(2 downto -13);
  signal K_d : sfixed(2 downto -13);

  signal p : sfixed(K_p'left+e'length downto K_p'right);

  subtype o_t is sfixed(3 downto -4);

begin

  K_p <= to_sfixed(KP, K_p);
  K_i <= to_sfixed(KP, K_i);
  K_d <= to_sfixed(KP, K_d);

  e <= resize(signed(R),e)-signed(I);

  -- Proportional ONLY (K_i and K_d unused)
  -- Note the optional interpretation of the error signal as a fixed-point value
  p <= K_p * to_sfixed(std_logic_vector(e), 4, -4);

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

end arch;
