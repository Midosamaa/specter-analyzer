library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_i2s2axis is
    -- generic(
    --     TDATA_WIDTH : integer := 24;
    --     -- TID_WIDTH : integer := 8;
    --     -- TDEST_WIDTH : integer := 8;
    --     -- TUSER_WIDTH : integer := 8
    -- );
    -- port(
    --     -- MCLK : out std_logic;
    --     SCLK : in std_logic;
    --     LRCK : in std_logic;
    --     SDATA : in std_logic;

    --     ACLK : in std_logic;
    --     ARESETn : in std_logic;
    --     TREADY : in std_logic;

    --     TVALID : out std_logic;
    --     TDATA : out std_logic_vector(TDATA_WIDTH-1 downto 0);
    --     TLAST : out std_logic

    --     -- TSTRB : out std_logic_vector((TDATA_WIDTH/8)-1 downto 0);
    --     -- TKEEP : out std_logic_vector((TDATA_WIDTH/8)-1 downto 0);
    --     -- TID : out std_logic_vector(TID_WIDTH-1 downto 0);
    --     -- TDEST : out std_logic_vector(TDEST_WIDTH-1 downto 0); 
    --     -- TUSER : out std_logic_vector(TUSER_WIDTH-1 downto 0);
    --     -- TWAKEUP : out std_logic
    -- );
end entity; 

architecture tb of tb_i2s2axis is

    constant TDATA_WIDTH : integer := 24;

    signal DONE : boolean := false;
	constant Period_I2S: time :=  500 ns; -- 20MHz clock

    -- MCLK : out std_logic;
    signal SCLK : std_logic := '0';
    signal LRCK : std_logic; 
    signal SDATA : std_logic := '0';

    -- signal ACLK : std_logic := '0';
    signal ARESETn : std_logic;
    signal TREADY : std_logic;

    signal TVALID : std_logic;
    signal TDATA : std_logic_vector(TDATA_WIDTH-1 downto 0);
    signal TLAST : std_logic;


begin
	SCLK <= '0' when DONE else not SCLK after Period_I2S / 2; 
    ARESETn <= '0', '1' after Period_AXIS;
    
    -- ACLK <= '0' when DONE else not ACLK after Period_AXIS / 2;
    
    SDATA <= '0' when DONE else not SDATA after Period_I2S;
    
    -- TREADY <= '0';

    process(TVALID, TLAST)
    begin
        if(TVALID = '1') then 
            TREADY <= '1';
        elsif(TLAST = '1') then
            TREADY <= '0';
        else
            TREADY <= '0';
        end if;
    end process;


    process
    begin
        wait for 2*Period_AXIS;
        
        LRCK <= '0';
        wait for 30*Period_I2S;
        LRCK <= '1';

        wait for 30*Period_I2S;
        LRCK <= '0';
        wait for 30 *Period_I2S;
        LRCK <= '1';


        DONE <= true;
        wait;
    end process;

    UUT : entity work.i2s2axis(RTL)
    port map(SCLK => SCLK, LRCK => LRCK, SDATA => SDATA, ARESETn => ARESETn, TREADY => TREADY, TVALID => TVALID, TDATA => TDATA, TLAST => TLAST);

end architecture;
