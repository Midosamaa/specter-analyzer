library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package i2s2axis_pkg is
    component i2s2axis is
        generic(
            TDATA_WIDTH : integer := 24
        );
        port(
            SCLK : in std_logic;
            LRCK : in std_logic;
            SDATA : in std_logic;

            ARESETn : in std_logic;
            TREADY : in std_logic;

            TVALID : out std_logic;
            TDATA : out std_logic_vector(TDATA_WIDTH-1 downto 0);
            TLAST : out std_logic

        );
    end component; 
end package;

