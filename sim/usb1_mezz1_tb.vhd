-- Xilinx Testbench Template produced by program netgen G.38

-- ATTENTION: This file was created by netgen and may therefore be overwritten
-- by subsequent runs of netgen. Xilinx recommends that you copy this file to
-- a new name, or 'paste' this text into another file, to avoid accidental loss
-- of data.

library IEEE;
library WORK;
library SIMPRIM;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.ALL;
use SIMPRIM.VCOMPONENTS.ALL;
use SIMPRIM.VPACKAGE.ALL;

entity TBX_usb1_mezz1 is
end TBX_usb1_mezz1;

architecture TBX_ARCH of TBX_usb1_mezz1 is
  component usb1_mezz1
    port (
      P_I_CLK33    : in STD_LOGIC := 'X';
      P_I_UC_RD_N  : in STD_LOGIC := 'X';
      P_I_UC_WR_N  : in STD_LOGIC := 'X';
      P_I_UC_ALE_N : in STD_LOGIC := 'X';
      P_O_LEMO0    : out STD_LOGIC;
      P_O_LEMO1    : out STD_LOGIC;
      P_I_LEMO2    : in STD_LOGIC := 'X';
      P_I_LEMO3    : in STD_LOGIC := 'X';
      P_IO_PMC_USR : inout STD_LOGIC_VECTOR ( 63 downto 0 );
      P_IO_UC_DATA : inout STD_LOGIC_VECTOR ( 11 downto 0 )
    );
  end component;

  signal P_I_CLK33 : STD_LOGIC;
  signal P_I_UC_RD_N : STD_LOGIC;
  signal P_I_UC_WR_N : STD_LOGIC;
  signal P_I_UC_ALE_N : STD_LOGIC;
  signal P_O_LEMO0 : STD_LOGIC;
  signal P_O_LEMO1 : STD_LOGIC;
  signal P_I_LEMO2 : STD_LOGIC;
  signal P_I_LEMO3 : STD_LOGIC;
  signal P_IO_PMC_USR : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal P_IO_UC_DATA : STD_LOGIC_VECTOR ( 11 downto 0 );

  begin
    UUT : usb1_mezz1
      port map (
        P_I_CLK33 => P_I_CLK33,
        P_I_UC_RD_N => P_I_UC_RD_N,
        P_I_UC_WR_N => P_I_UC_WR_N,
        P_I_UC_ALE_N => P_I_UC_ALE_N,
        P_O_LEMO0 => P_O_LEMO0,
        P_O_LEMO1 => P_O_LEMO1,
        P_I_LEMO2 => P_I_LEMO2,
        P_I_LEMO3 => P_I_LEMO3,
        P_IO_PMC_USR => P_IO_PMC_USR,
        P_IO_UC_DATA => P_IO_UC_DATA
      );
    
    -- Clock generation
    -- ----------------
    proc_p_i_clk33_generator : process
    begin
      clock_loop             : loop
        P_I_CLK33 <= '1';
        wait for 15 ns;
        P_I_CLK33 <= '0';
        wait for 15 ns;
      end loop;
    end process;

    -- Dynamic signals
    -- ###############
    proc_p_io_dynamic: process

      -- Address cycle
      -- -------------
      procedure proc_ad_cycle(
        constant I_A : in std_logic_vector(7 downto 0)
      ) is
      begin
        P_IO_UC_DATA(7 downto 0) <= I_A;
        P_I_UC_ALE_N   <= '0';
        P_I_UC_WR_N    <= '0';
        wait for 200 ns;
        P_IO_UC_DATA <= (others => '0');
        P_I_UC_ALE_N   <= '1';
        P_I_UC_WR_N    <= '1';
        wait for 100 ns;
      end proc_ad_cycle;

      -- Data write cycle
      -- ----------------
      procedure proc_wr_cycle
        (
          constant I_DATA : in std_logic_vector(11 downto 0)
        ) is
      begin
        P_IO_UC_DATA <= I_DATA;
        P_I_UC_ALE_N   <= '1';
        P_I_UC_WR_N    <= '0';
        wait for 200 ns;
        P_IO_UC_DATA <= (others => '0');
        P_I_UC_ALE_N   <= '1';
        P_I_UC_WR_N    <= '1';
        wait for 100 ns;
      end proc_wr_cycle;

      -- Data read cycle
      -- ---------------
      procedure proc_rd_cycle is
      begin
        P_IO_UC_DATA   <= (others => 'Z');
        P_I_UC_ALE_N   <= '1';
        P_I_UC_RD_N    <= '0';
        wait for 200 ns;
        P_I_UC_RD_N    <= '1';
        wait for 300 ns;
      end proc_rd_cycle;

    begin
      -- Initialize signals
      P_IO_UC_DATA <= (others => '0');
      P_I_UC_RD_N  <= '1';
      P_I_UC_WR_N  <= '1';
      P_I_UC_ALE_N <= '1';

      P_I_LEMO2    <= '0';
      P_I_LEMO3    <= '0';

      P_IO_PMC_USR(41)  <= '0'; -- digital trigger
      P_IO_PMC_USR(43)  <= '0'; -- analog trigger

      -- Wait for DLL lock
      -- -----------------
      wait for 32 us; -- initialization of RSR

      -- Set-up write shift register
      --proc_ad_cycle(I_A => X"16"); -- write to 0x14 (byte swapping!)
      --proc_wr_cycle(I_DATA => X"000");
      --proc_wr_cycle(I_DATA => X"008");

      -- Enable TCALIB
      --proc_ad_cycle(I_A => X"02");
      --proc_wr_cycle(I_DATA => X"008");
      --wait for 1000 ns;

      -- Write DAC
      --proc_ad_cycle(I_A => X"04");
      --proc_wr_cycle(I_DATA => X"034");
      --proc_wr_cycle(I_DATA => X"012");

      -- Set demand frequency
      --proc_ad_cycle(I_A => X"14");
      --proc_wr_cycle(I_DATA => X"03E");
      --proc_wr_cycle(I_DATA => X"001");

      -- Set readout channels
      proc_ad_cycle(I_A => X"14");
      proc_wr_cycle(I_DATA => X"008");

      -- Start Domino
      proc_ad_cycle(I_A => X"00");
      proc_wr_cycle(I_DATA => X"001");
      wait for 3 us;

      -- Select long start pulse
      --proc_ad_cycle(I_A => X"02");
      --proc_wr_cycle(I_DATA => X"080");

      -- Enable external trigger
      --proc_ad_cycle(I_A => X"02");
      --proc_wr_cycle(I_DATA => X"040");

      -- Start Domino
      --proc_ad_cycle(I_A => X"00");
      --proc_wr_cycle(I_DATA => X"001");
      --wait for 100 ns;

      -- Supply external trigger
      --wait for 2 us;
      --P_I_LEMO2 <= '1';
      --wait for 100 ns;
      --P_I_LEMO2 <= '0';

      --wait for 3 us; -- wait for readout

      -- Disable external trigger
      --proc_ad_cycle(I_A => X"02");
      --proc_wr_cycle(I_DATA => X"000");

      -- Start Domino
      --proc_ad_cycle(I_A => X"00");
      --proc_wr_cycle(I_DATA => X"001");
      --wait for 100 ns;

      -- Supply external trigger
      --wait for 2100 ns;
      --P_I_LEMO2 <= '1';
      --wait for 100 ns;
      --P_I_LEMO2 <= '0';
      
      -- Reinit
      --proc_ad_cycle(I_A => X"00");
      --proc_wr_cycle(I_DATA => X"002");
      --wait for 1000 ns;

      -- Start Readout
      proc_ad_cycle(I_A => X"00");
      proc_wr_cycle(I_DATA => X"004");

      -- Trigger flash write
      --proc_ad_cycle(I_A => X"00");
      --proc_wr_cycle(I_DATA => X"008");

      -- Write DAC
      --proc_ad_cycle(I_A => X"06");
      --proc_wr_cycle(I_DATA => X"0FF");
      --proc_wr_cycle(I_DATA => X"0FF");

      -- Access registers/RAM
      -----------------------
      --proc_ad_cycle(I_A => "10000000");
      --proc_wr_cycle(I_DATA => "000100010001");
      --proc_wr_cycle(I_DATA => "001000100010");
      --proc_wr_cycle(I_DATA => "010001000100");
      --proc_wr_cycle(I_DATA => "100010001000");

      --proc_ad_cycle(I_A => "10000000");
      --proc_rd_cycle;
      --proc_rd_cycle;
      --proc_rd_cycle;
      --proc_rd_cycle;

      wait for 400 us;
      -- stop simulation
      assert false
        report "Simulation Complete (this is not a failure)"
        severity failure;

    end process;

end TBX_ARCH;

configuration TBX_CFG_usb1_mezz1_TBX_ARCH of TBX_usb1_mezz1 is
  for TBX_ARCH
  end for;
end TBX_CFG_usb1_mezz1_TBX_ARCH;
