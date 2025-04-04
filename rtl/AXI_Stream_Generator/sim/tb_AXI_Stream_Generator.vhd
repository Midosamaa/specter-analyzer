-- Libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_AXI_Stream_Generator is
end tb_AXI_Stream_Generator;

-- Architecture
architecture Test of tb_AXI_Stream_Generator is
    -- Clock & Reset
    signal ACLK     : std_logic := '0';
    signal ARESETn  : std_logic;
    constant Period : time := 1 ns;
    signal DONE : boolean;

    -- AXI Stream Basic Signals
    signal TREADY  : std_logic;
    signal TVALID  : std_logic;
    signal TDATA   : std_logic_vector(31 downto 0);
    signal TLAST   : std_logic;

begin

    ACLK <= '0' when DONE else not ACLK after Period / 2;
    ARESETn <= '1', '0' after Period;
    DONE <= true after 70 ns;

    process
    begin
        
        ARESETn <= '1';
        TREADY <= '0';
        wait for 1 ns;

        ARESETn <= '0';
        TREADY <= '1';
        wait for 10 ns;
        
        TREADY <= '0';
        wait for 10 ns;

        TREADY <= '1';
        wait for 25 ns;

        TREADY <= '0';
        wait for 15 ns;

        TREADY <= '1';
        wait;

    end process;

    AXI_Stream_Generator_U : entity work.AXI_Stream_Generator(Test)
    port map (ACLK=>ACLK, ARESETn=>ARESETn, TREADY=>TREADY, TVALID=>TVALID, TDATA=>TDATA, TLAST=>TLAST);

end Test;
