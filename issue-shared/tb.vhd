entity tb is
  --generic (
  --  SHAREDLIB : string := "libcaux.so"
  --);
end tb;

architecture arch of tb is

  function get_rand return integer is
  begin report "VHPIDIRECT: get_rand" severity failure; end;
  attribute foreign of get_rand: function is "VHPIDIRECT " & SHAREDLIB & " get_rand";

  -- GHDL complains because:
  -- tb.vhd:11:72: value of FOREIGN attribute must be locally static
  --
  -- Using a constant instead of a generic makes no difference.

begin

  process
    variable v : integer;
  begin
    for i in 1 to 10 loop
      v := get_rand;
      report integer'image(i) & ": " & integer'image(v) severity note;
    end loop;
    wait;
  end process;

end;
