--     Xilinx Testbench Template produced by program netgen J.39
--             
--------------------------------------------------------------------------------

library IEEE;
library WORK;
library SIMPRIM;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.ALL;
use SIMPRIM.VCOMPONENTS.ALL;
use SIMPRIM.VPACKAGE.ALL;

entity TBX_drs4_mezz1 is
end TBX_drs4_mezz1;

architecture TBX_ARCH of TBX_drs4_mezz1 is
  component drs4_mezz1
    port (
      P_IO_UC_SLWR : inout STD_LOGIC;
      P_IO_UC_PKTEND : inout STD_LOGIC;
      P_IO_UC_FLAGA : inout STD_LOGIC;
      P_IO_UC_FLAGB : inout STD_LOGIC;
      P_IO_UC_FLAGC : inout STD_LOGIC;
      P_IO_UC_PA0 : in STD_LOGIC;
      P_IO_UC_SLCS : inout STD_LOGIC;
      P_IO_UC_FIFOADR0 : inout STD_LOGIC;
      P_IO_UC_FIFOADR1 : inout STD_LOGIC;
      P_IO_UC_SLOE : inout STD_LOGIC;
      P_IO_UC_SLRD : inout STD_LOGIC;
      P_I_CLK33 : in STD_LOGIC := 'X';
      P_I_CLK66 : in STD_LOGIC := 'X';
      P_I_LEMO1 : in STD_LOGIC;
      P_O_LED1 : out STD_LOGIC;
      P_O_LED2 : out STD_LOGIC;
      P_IO_PMC_USR : inout STD_LOGIC_VECTOR ( 63 downto 0 );
      P_IO_UC_FD : inout STD_LOGIC_VECTOR ( 15 downto 0 )
    );
  end component;

  signal P_IO_UC_SLWR : STD_LOGIC;
  signal P_IO_UC_PKTEND : STD_LOGIC;
  signal P_IO_UC_FLAGA : STD_LOGIC;
  signal P_IO_UC_FLAGB : STD_LOGIC;
  signal P_IO_UC_FLAGC : STD_LOGIC;
  signal P_IO_UC_PA0 : STD_LOGIC;
  signal P_IO_UC_SLCS : STD_LOGIC;
  signal P_IO_UC_FIFOADR0 : STD_LOGIC;
  signal P_IO_UC_FIFOADR1 : STD_LOGIC;
  signal P_IO_UC_SLOE : STD_LOGIC;
  signal P_IO_UC_SLRD : STD_LOGIC;
  signal P_I_CLK33 : STD_LOGIC;
  signal P_I_CLK66 : STD_LOGIC;
  signal P_O_LED1 : STD_LOGIC;
  signal P_O_LED2 : STD_LOGIC;
  signal P_I_LEMO1 : STD_LOGIC;
  signal P_IO_PMC_USR : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal P_IO_UC_FD : STD_LOGIC_VECTOR ( 15 downto 0 );

  begin
    UUT : drs4_mezz1
      port map (
        P_IO_UC_SLWR => P_IO_UC_SLWR,
        P_IO_UC_PKTEND => P_IO_UC_PKTEND,
        P_IO_UC_FLAGA => P_IO_UC_FLAGA,
        P_IO_UC_FLAGB => P_IO_UC_FLAGB,
        P_IO_UC_FLAGC => P_IO_UC_FLAGC,
        P_IO_UC_PA0 => P_IO_UC_PA0,
        P_IO_UC_SLCS => P_IO_UC_SLCS,
        P_IO_UC_FIFOADR0 => P_IO_UC_FIFOADR0,
        P_IO_UC_FIFOADR1 => P_IO_UC_FIFOADR1,
        P_IO_UC_SLOE => P_IO_UC_SLOE,
        P_IO_UC_SLRD => P_IO_UC_SLRD,
        P_I_CLK33 => P_I_CLK33,
        P_I_CLK66 => P_I_CLK66,
        P_I_LEMO1 => P_I_LEMO1,
        P_O_LED1 => P_O_LED1,
        P_O_LED2 => P_O_LED2,
        P_IO_PMC_USR(63) => P_IO_PMC_USR(63),
        P_IO_PMC_USR(62) => P_IO_PMC_USR(62),
        P_IO_PMC_USR(61) => P_IO_PMC_USR(61),
        P_IO_PMC_USR(60) => P_IO_PMC_USR(60),
        P_IO_PMC_USR(59) => P_IO_PMC_USR(59),
        P_IO_PMC_USR(58) => P_IO_PMC_USR(58),
        P_IO_PMC_USR(57) => P_IO_PMC_USR(57),
        P_IO_PMC_USR(56) => P_IO_PMC_USR(56),
        P_IO_PMC_USR(55) => P_IO_PMC_USR(55),
        P_IO_PMC_USR(54) => P_IO_PMC_USR(54),
        P_IO_PMC_USR(53) => P_IO_PMC_USR(53),
        P_IO_PMC_USR(52) => P_IO_PMC_USR(52),
        P_IO_PMC_USR(51) => P_IO_PMC_USR(51),
        P_IO_PMC_USR(50) => P_IO_PMC_USR(50),
        P_IO_PMC_USR(49) => P_IO_PMC_USR(49),
        P_IO_PMC_USR(48) => P_IO_PMC_USR(48),
        P_IO_PMC_USR(47) => P_IO_PMC_USR(47),
        P_IO_PMC_USR(46) => P_IO_PMC_USR(46),
        P_IO_PMC_USR(45) => P_IO_PMC_USR(45),
        P_IO_PMC_USR(44) => P_IO_PMC_USR(44),
        P_IO_PMC_USR(43) => P_IO_PMC_USR(43),
        P_IO_PMC_USR(42) => P_IO_PMC_USR(42),
        P_IO_PMC_USR(41) => P_IO_PMC_USR(41),
        P_IO_PMC_USR(40) => P_IO_PMC_USR(40),
        P_IO_PMC_USR(39) => P_IO_PMC_USR(39),
        P_IO_PMC_USR(38) => P_IO_PMC_USR(38),
        P_IO_PMC_USR(37) => P_IO_PMC_USR(37),
        P_IO_PMC_USR(36) => P_IO_PMC_USR(36),
        P_IO_PMC_USR(35) => P_IO_PMC_USR(35),
        P_IO_PMC_USR(34) => P_IO_PMC_USR(34),
        P_IO_PMC_USR(33) => P_IO_PMC_USR(33),
        P_IO_PMC_USR(32) => P_IO_PMC_USR(32),
        P_IO_PMC_USR(31) => P_IO_PMC_USR(31),
        P_IO_PMC_USR(30) => P_IO_PMC_USR(30),
        P_IO_PMC_USR(29) => P_IO_PMC_USR(29),
        P_IO_PMC_USR(28) => P_IO_PMC_USR(28),
        P_IO_PMC_USR(27) => P_IO_PMC_USR(27),
        P_IO_PMC_USR(26) => P_IO_PMC_USR(26),
        P_IO_PMC_USR(25) => P_IO_PMC_USR(25),
        P_IO_PMC_USR(24) => P_IO_PMC_USR(24),
        P_IO_PMC_USR(23) => P_IO_PMC_USR(23),
        P_IO_PMC_USR(22) => P_IO_PMC_USR(22),
        P_IO_PMC_USR(21) => P_IO_PMC_USR(21),
        P_IO_PMC_USR(20) => P_IO_PMC_USR(20),
        P_IO_PMC_USR(19) => P_IO_PMC_USR(19),
        P_IO_PMC_USR(18) => P_IO_PMC_USR(18),
        P_IO_PMC_USR(17) => P_IO_PMC_USR(17),
        P_IO_PMC_USR(16) => P_IO_PMC_USR(16),
        P_IO_PMC_USR(15) => P_IO_PMC_USR(15),
        P_IO_PMC_USR(14) => P_IO_PMC_USR(14),
        P_IO_PMC_USR(13) => P_IO_PMC_USR(13),
        P_IO_PMC_USR(12) => P_IO_PMC_USR(12),
        P_IO_PMC_USR(11) => P_IO_PMC_USR(11),
        P_IO_PMC_USR(10) => P_IO_PMC_USR(10),
        P_IO_PMC_USR(9) => P_IO_PMC_USR(9),
        P_IO_PMC_USR(8) => P_IO_PMC_USR(8),
        P_IO_PMC_USR(7) => P_IO_PMC_USR(7),
        P_IO_PMC_USR(6) => P_IO_PMC_USR(6),
        P_IO_PMC_USR(5) => P_IO_PMC_USR(5),
        P_IO_PMC_USR(4) => P_IO_PMC_USR(4),
        P_IO_PMC_USR(3) => P_IO_PMC_USR(3),
        P_IO_PMC_USR(2) => P_IO_PMC_USR(2),
        P_IO_PMC_USR(1) => P_IO_PMC_USR(1),
        P_IO_PMC_USR(0) => P_IO_PMC_USR(0),
        P_IO_UC_FD(15) => P_IO_UC_FD(15),
        P_IO_UC_FD(14) => P_IO_UC_FD(14),
        P_IO_UC_FD(13) => P_IO_UC_FD(13),
        P_IO_UC_FD(12) => P_IO_UC_FD(12),
        P_IO_UC_FD(11) => P_IO_UC_FD(11),
        P_IO_UC_FD(10) => P_IO_UC_FD(10),
        P_IO_UC_FD(9) => P_IO_UC_FD(9),
        P_IO_UC_FD(8) => P_IO_UC_FD(8),
        P_IO_UC_FD(7) => P_IO_UC_FD(7),
        P_IO_UC_FD(6) => P_IO_UC_FD(6),
        P_IO_UC_FD(5) => P_IO_UC_FD(5),
        P_IO_UC_FD(4) => P_IO_UC_FD(4),
        P_IO_UC_FD(3) => P_IO_UC_FD(3),
        P_IO_UC_FD(2) => P_IO_UC_FD(2),
        P_IO_UC_FD(1) => P_IO_UC_FD(1),
        P_IO_UC_FD(0) => P_IO_UC_FD(0)
      );
    -- User: Put your stimulus here.
    
    -- Clock generation
    proc_p_i_clk33_generator : process
    begin
      clock_loop             : loop
        P_I_CLK33 <= '1';
        wait for 15 ns;
        P_I_CLK33 <= '0';
        wait for 15 ns;
      end loop;
    end process;

    proc_p_i_clk66_generator : process
    begin
      clock_loop             : loop
        P_I_CLK66 <= '1';
        wait for 7.5 ns;
        P_I_CLK66 <= '0';
        wait for 7.5 ns;
      end loop;
    end process;
    
    -- Static signals
    P_I_LEMO1 <= '0';

    P_IO_UC_FLAGA  <= '1';
    P_IO_UC_FLAGB  <= '1';
    P_IO_UC_PKTEND <= 'Z';
    P_IO_UC_PA0    <= '1';

    -- Dynamic signals
    proc_p_io_dynamic: process
    
      -- Write cycle
      -- -----------
      procedure proc_wr_cycle(
        constant I_A : in std_logic_vector(15 downto 0);
        constant I_D : in std_logic_vector(15 downto 0)
      ) is
      begin
        P_IO_UC_FLAGC <= '1';
        P_IO_UC_FD    <= X"0002"; -- USB2_CMD_WRITE
        wait until P_IO_UC_SLOE = '0';
        
        wait until P_I_CLK33 = '0';
        wait until P_I_CLK33 = '1';
        wait for 4 ns;
        
        P_IO_UC_FD    <= I_A;             -- low word
        wait until P_I_CLK33 = '0';
        wait until P_I_CLK33 = '1';
        wait for 4 ns;
        
        P_IO_UC_FD    <= (others => '0'); -- high word
        wait until P_I_CLK33 = '0';
        wait until P_I_CLK33 = '1';
        wait for 4 ns;

        P_IO_UC_FD    <= X"0002";         -- low word
        wait until P_I_CLK33 = '0';
        wait until P_I_CLK33 = '1';
        wait for 4 ns;
        
        P_IO_UC_FD    <= (others => '0'); -- high word
        wait until P_I_CLK33 = '0';
        wait until P_I_CLK33 = '1';
        wait for 4 ns;

        P_IO_UC_FD    <= I_D;
        wait until P_I_CLK33 = '0';
        wait until P_I_CLK33 = '1';
        wait for 4 ns;
        
        P_IO_UC_FLAGC <= '0';
        P_IO_UC_FD <= "ZZZZZZZZZZZZZZZZ"; -- tri state

      end proc_wr_cycle;

    begin
    
      P_IO_UC_FLAGC <= '0';
      P_IO_UC_FD <= (others => '1');
        
      wait for 990 ns; -- Until DLLs locked
      wait for 9.5 ns; -- Clock-to-FLAGs delay of uC
    
      proc_wr_cycle(X"0016", X"0008"); -- trigger phase shift change
      
      wait for 300 us;
      
      -- stop simulation
      assert false
        report "Simulation Complete (this is not a failure)"
        severity failure;
    
    end process;
    
    
end TBX_ARCH;

configuration TBX_CFG_drs4_mezz1_TBX_ARCH of TBX_drs4_mezz1 is
  for TBX_ARCH
  end for;
end TBX_CFG_drs4_mezz1_TBX_ARCH;
