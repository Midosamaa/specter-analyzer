library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ACLK 	Clock 	1 	ACLK is a global clock signal. All signals are sampled on the rising edge of ACLK.
-- ARESETn 	Reset 	1 	ARESETn is a global reset signal.
-- TVALID 	Transmitter 	1 	TVALID indicates the Transmitter is driving a valid transfer. A transfer takes place when both TVALID and TREADY are asserted.
-- TREADY 	Receiver 	1 	TREADY indicates that a Receiver can accept a transfer.
-- TDATA 	Transmitter 	TDATA_WIDTH 	TDATA is the primary payload used to provide the data that is passing across the interface. TDATA_WIDTH must be an integer number of bytes and is recommended to be 8, 16, 32, 64, 128, 256, 512 or 1024-bits.
-- TSTRB 	Transmitter 	TDATA_WIDTH/8 	TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
-- TKEEP 	Transmitter 	TDATA_WIDTH/8 	TKEEP is the byte qualifier that indicates whether content of the associated byte of TDATA is processed as part of the data stream.
-- TLAST 	Transmitter 	1 	TLAST indicates the boundary of a packet.
-- TID 	Transmitter 	TID_WIDTH 	TID is a data stream identifier. TID_WIDTH is recommended to be no more than 8.
-- TDEST 	Transmitter 	TDEST_WIDTH 	TDEST provides routing information for the data stream. TDEST_WIDTH is recommended to be no more than 8.
-- TUSER 	Transmitter 	TUSER_WIDTH 	TUSER is a user-defined sideband information that can be transmitted along the data stream. TUSER_WIDTH is recommended to be an integer multiple of TDATA_WIDTH/8.
-- TWAKEUP 	Transmitter 	1 	TWAKEUP identifies any activity associated with AXI-Stream interface. 

entity i2s2axis is
    generic(
        TDATA_WIDTH : integer := 24
        -- TID_WIDTH : integer := 8;
        -- TDEST_WIDTH : integer := 8;
        -- TUSER_WIDTH : integer := 8
    );
    port(
        -- MCLK : out std_logic;
        SCLK : in std_logic;
        LRCK : in std_logic;
        SDATA : in std_logic;

        -- ACLK : in std_logic;
        ARESETn : in std_logic;
        TREADY : in std_logic;

        TVALID : out std_logic;
        TDATA : out std_logic_vector(TDATA_WIDTH-1 downto 0);
        TLAST : out std_logic

        -- TSTRB : out std_logic_vector((TDATA_WIDTH/8)-1 downto 0);
        -- TKEEP : out std_logic_vector((TDATA_WIDTH/8)-1 downto 0);
        -- TID : out std_logic_vector(TID_WIDTH-1 downto 0);
        -- TDEST : out std_logic_vector(TDEST_WIDTH-1 downto 0); 
        -- TUSER : out std_logic_vector(TUSER_WIDTH-1 downto 0);
        -- TWAKEUP : out std_logic
    );
end entity; 

architecture RTL of i2s2axis is
    type State_I2S is (Wait_R, Wait_L, Rec_L, Rec_R);
    type State_AXIS is (Wait_Valid, Wait_Ready, Last);

    signal i2s_state : State_I2S;
    signal cpt_i2s : integer := TDATA_WIDTH;

    signal tvalid_int : std_logic;
    signal axis_state : State_AXIS;

begin

    process(SCLK, ARESETn)
    begin
    if(ARESETn = '0') then
        i2s_state <= Wait_L;
        TDATA <= (others => '0');
        cpt_i2s <= TDATA_WIDTH;
        
        tvalid_int <= '0';

        TVALID <= '0';
        TLAST <= '0';
        axis_state <= Wait_Valid;

    elsif(rising_edge(SCLK)) then

        case i2s_state is
            when Wait_L =>
                if(LRCK = '0') then
                    i2s_state <= Rec_L;
                end if;
            when Wait_R =>
                if(LRCK = '1') then
                    i2s_state <= Rec_R;
                end if;
            
            when Rec_L =>
                if(cpt_i2s = 1) then
                    TDATA(cpt_i2s-1) <= '0';
                    cpt_i2s <= TDATA_WIDTH;
                    i2s_state <= Wait_R;
                    tvalid_int <= '1';
                else
                    cpt_i2s <= cpt_i2s - 1;
                    TDATA(cpt_i2s-1) <= SDATA;
                end if;

            when Rec_R => 
                if(cpt_i2s = 1) then
                    TDATA(cpt_i2s-1) <= '1';
                    cpt_i2s <= TDATA_WIDTH;
                    i2s_state <= Wait_L;
                    tvalid_int <= '1';
                else
                    cpt_i2s <= cpt_i2s - 1;
                    TDATA(cpt_i2s-1) <= SDATA;
                end if;

        end case;


        case axis_state is
            when Wait_Valid =>
                if(tvalid_int = '1') then
                    TVALID <= '1';
                    axis_state <= Wait_Ready;
                end if;
            when Wait_Ready =>
                if(TREADY = '1') then
                    TVALID <= '1';
                    TLAST <= '1';
                    axis_state <= Last;
                end if;
            when Last => 
                TLAST <= '0';
                
                tvalid_int <= '0'; 

                TVALID <= '0';
                axis_state <= Wait_Valid;   
        end case;


    end if;
    end process;

end architecture;
