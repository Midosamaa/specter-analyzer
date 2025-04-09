library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity axis_vga is 
    port(
        -- AXI-Stream Interface
        aclk    : in std_logic;
        aresetn : in std_logic;
        tvalid  : in std_logic;
        tready  : out std_logic;
        tdata   : in std_logic_vector(31 downto 0);
        tlast   : out std_logic;

        -- VGA Output
        vga_clk   : in std_logic;
        vga_reset : out std_logic;
        rgb_data  : out std_logic_vector(11 downto 0);
        hsync     : out std_logic;
        vsync     : out std_logic
    );
end entity;

architecture RTL of axis_vga is

    -- **Définition des timings VGA     **
    constant H_ACTIVE     : integer := 1024;
    constant H_FRONT_PORCH: integer := 24;
    constant H_SYNC_PULSE : integer := 136;
    constant H_BACK_PORCH : integer := 160;
    constant H_TOTAL      : integer := H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH; -- 1344

    constant V_ACTIVE     : integer := 768;
    constant V_FRONT_PORCH: integer := 3;
    constant V_SYNC_PULSE : integer := 6;
    constant V_BACK_PORCH : integer := 29;
    constant V_TOTAL      : integer := V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH; -- 806

    -- **Compteurs VGA**
    signal h_count : integer range 0 to H_TOTAL - 1 := 0;
    signal v_count : integer range 0 to V_TOTAL - 1 := 0;
    
    -- **Signaux internes**
    signal video_on   : std_logic;
    signal tready_int : std_logic := '0';

    -- **Registre de synchronisation pour h_count**
    signal h_count_sync : integer range 0 to H_TOTAL - 1 := 0;

begin

    -- **Génération des signaux VGA**
    process(vga_clk)
    begin
        if rising_edge(vga_clk) then
            -- **Gestion du balayage horizontal**
            if h_count = H_TOTAL - 1 then
                h_count <= 0;
                -- **Gestion du balayage vertical**
                if v_count = V_TOTAL - 1 then
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
                end if;
            else
                h_count <= h_count + 1;
            end if;

            -- **Génération des signaux de synchronisation**
            if (h_count >= (H_ACTIVE + H_FRONT_PORCH) and h_count < (H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE)) then
              hsync <= '0';
            else
              hsync <= '1';
            end if;

            if (v_count >= (V_ACTIVE + V_FRONT_PORCH) and v_count < (V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE)) then
              vsync <= '0';
            else
              vsync <= '1';
            end if;

            -- **Vérification si le pixel est dans la zone active**
            if (h_count < H_ACTIVE and v_count < V_ACTIVE) then
              video_on <= '1';
            else
              video_on <= '0';
            end if;
        end if;
    end process;

    -- **Synchronisation de h_count sur aclk**
    process(aclk)
    begin
        if rising_edge(aclk) then
            h_count_sync <= h_count; -- Capture la valeur de h_count pour éviter les problèmes de domaine d'horloge
        end if;
    end process;

    -- **Gestion de l'interface AXI-Stream**
    process(aclk)
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                tready_int <= '0';
                rgb_data   <= (others => '0');
                tlast      <= '0';
            else
                -- Mise à jour de tready uniquement en zone active
                if video_on = '1' then
                    tready_int <= '1';
                else
                    tready_int <= '0';
                end if;

                -- Transmission du pixel uniquement si AXI-Stream est actif
                if tvalid = '1' and tready_int = '1' then
                    rgb_data <= tdata(11 downto 0);
                end if;

                -- Détection de la fin de ligne (avec le h_count synchronisé)
                if h_count_sync = H_ACTIVE - 1 then
                    tlast <= '1';
                else
                    tlast <= '0';
                end if;
            end if;
        end if;
    end process;

    -- **Affectation finale des sorties**
    tready <= tready_int;
    vga_reset <= not aresetn;

end architecture;
