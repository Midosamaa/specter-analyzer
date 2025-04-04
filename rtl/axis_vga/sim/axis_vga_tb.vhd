library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity axis_vga_tb is
end entity;

architecture TB of axis_vga_tb is

    -- **Signaux du DUT (Device Under Test)**
    signal aclk      : std_logic := '0';
    signal aresetn   : std_logic := '0';
    signal tvalid    : std_logic := '0';
    signal tready    : std_logic;
    signal tdata     : std_logic_vector(31 downto 0) := (others => '0');
    signal tlast     : std_logic := '0';

    signal vga_clk   : std_logic := '0';
    signal vga_reset : std_logic;
    signal rgb_data  : std_logic_vector(11 downto 0);
    signal hsync     : std_logic;
    signal vsync     : std_logic;

    -- **Constantes de simulation**
    constant CLK_PERIOD  : time := 10 ns;  -- 100 MHz (10 ns par cycle)
    constant VGA_H_PERIOD: time := 15.38 ns; -- ≈ 65 MHz pour VGA
    constant VGA_V_PERIOD: time := 16.67 ms / 60.0; -- 60 Hz -> 16.67 ms par frame

    -- **Timings VGA**
    constant VGA_H_ACTIVE : integer := 1024; -- 1024 pixels actifs par ligne
    constant VGA_H_TOTAL  : integer := 1344; -- Total pixels par ligne (incluant synchronisation)
    constant VGA_V_ACTIVE : integer := 768;  -- 768 lignes actives
    constant VGA_V_TOTAL  : integer := 806;  -- Total lignes (incluant synchronisation)

begin

    -- **Instanciation du module axis_vga**
    uut: entity work.axis_vga
        port map (
            aclk      => aclk,
            aresetn   => aresetn,
            tvalid    => tvalid,
            tready    => tready,
            tdata     => tdata,
            tlast     => tlast,
            vga_clk   => vga_clk,
            vga_reset => vga_reset,
            rgb_data  => rgb_data,
            hsync     => hsync,
            vsync     => vsync
        );

    -- **Génération d'horloge AXI (100 MHz)**
    process
    begin
        while now < 10 ms loop
            aclk <= '0';
            wait for CLK_PERIOD / 2;
            aclk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- **Génération d'horloge VGA (65 MHz)**
    process
    begin
        while now < 10 ms loop
            vga_clk <= '0';
            wait for VGA_H_PERIOD / 2;
            vga_clk <= '1';
            wait for VGA_H_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- **Processus de test**
    process
    begin
        -- **Réinitialisation du module**
        aresetn <= '0';
        wait for 100 ns;
        aresetn <= '1';
        wait for 100 ns;

        -- **Simulation de l'envoi de lignes de pixels**
        for ligne in 0 to VGA_V_TOTAL - 1 loop  -- Simuler toutes les lignes (806)
            for i in 0 to VGA_H_TOTAL - 1 loop  -- Simuler tous les pixels (1344 par ligne)
                wait until rising_edge(aclk);
                
                if tready = '1' then
                    tvalid <= '1';
                    if i < VGA_H_ACTIVE then
                        tdata  <= std_logic_vector(to_unsigned(i mod 4096, 32)); -- RVB 12 bits
                    else
                        tdata  <= (others => '0');  -- Pixels de la zone de synchronisation
                    end if;
                    
                    if i = VGA_H_ACTIVE - 1 then
                        tlast <= '1'; -- Fin de la ligne active
                    else
                        tlast <= '0';
                    end if;
                else
                    tvalid <= '0';
                end if;
            end loop;

            -- Fin de la ligne : attendre avant de commencer la suivante
            wait until rising_edge(aclk);
            tvalid <= '0';
            tlast <= '0';
            wait for 100 ns; -- Pause entre les lignes
        end loop;

        -- **Attendre quelques millisecondes pour voir les signaux VGA**
        wait for 5 ms;

        -- **Fin de simulation**
        report "Simulation terminée avec succès !" severity note;
        wait;
    end process;

end architecture;
