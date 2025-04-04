-- Libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity
entity AXI_Stream_Generator is
  Port (
    -- Clock & Reset
    ACLK     : in  std_logic; 
    ARESETn  : in  std_logic;

    -- AXI Stream Basic Signals
    TREADY  : in std_logic;
    TVALID  : out std_logic;
    TDATA   : out std_logic_vector(31 downto 0);
    TLAST   : out std_logic
  );
end AXI_Stream_Generator;

-- Architecture
architecture Test of AXI_Stream_Generator is
  --Intern Signals
  signal TDATA_Temp : std_logic_vector(31 downto 0);
  signal TVALID_Temp : std_logic;
  signal TLAST_Temp : std_logic;
  signal compt : integer;

begin
  --Processes
  TLAST <= TLAST_Temp;
  TDATA <= TDATA_Temp;
  TVALID <= TVALID_Temp;

  AXIS_process : process(ARESETn,ACLK) is
  begin

    if ARESETn = '1' then
      TVALID_Temp <= '0';
      TDATA_Temp (31 downto 0) <= (others => '0');
      TLAST_Temp <= '0';
      compt <= 0;

    elsif rising_edge(ACLK) then
      if TVALID_Temp ='0' then
        TVALID_Temp <= '1';
      end if;

      if TREADY = '1' and TVALID_Temp = '1' then
        compt <= compt + 1;
        TDATA_Temp <= std_logic_vector(to_signed(compt+1,32));

        -- On compte jusqu'à 20
        if compt = 19 then
          TLAST_Temp <= '1';
          TVALID_Temp <='0';
        end if;

        -- On attend 1 cycle et on reset tout
        if TLAST_Temp = '1' then
          TLAST_Temp <= '0';
          TDATA_Temp (31 downto 0) <= (others => '0');
          compt <= 0;
        end if;
      end if;
    end if;
  end process AXIS_process;
end architecture Test;
