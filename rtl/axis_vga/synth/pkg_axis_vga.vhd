library ieee;
use ieee.std_logic_1164.all;

package axis_vga is

  component axis_vga is
    generic( NUM_LEDS : integer := 4);
    port( clk : in std_logic;
          rsn : in std_logic;
          led : out std_logic_vector(3 downto 0));
  end component;

end package;
