-- Libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_VGA_Generator_test is
end entity tb_VGA_Generator_test;

-- Architecture
architecture Test of tb_VGA_Generator_test is
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

    signal vga_clk   : std_logic := '0';
    signal vga_reset : std_logic;
    signal rgb_data  : std_logic_vector(11 downto 0);
    signal hsync     : std_logic;
    signal vsync     : std_logic;

begin

    ACLK <= '0' when DONE else not ACLK after Period / 2;
    ARESETn <= '1', '0' after Period;
    DONE <= true after 1000 ns;

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

    -- **Instanciation du module axis_vga**
    uut: entity work.axis_vga(rtl)
        port map (
            aclk      => ACLK,
            aresetn   => ARESETn,
            tvalid    => TVALID,
            tready    => TREADY,
            tdata     => TDATA,
            tlast     => TLAST,
            vga_clk   => vga_clk,
            vga_reset => vga_reset,
            rgb_data  => rgb_data,
            hsync     => hsync,
            vsync     => vsync
        );

end Test;
