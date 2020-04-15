library ieee;
context ieee.ieee_std_context;

entity controller is
  port (
    CLK: in  std_logic;
    RST: in  std_logic;
    EN:  in  std_logic;
    R:   in  std_logic_vector(7 downto 0);
    I:   in  std_logic_vector(7 downto 0);
    O:   out std_logic_vector(7 downto 0)
  );
end entity;
