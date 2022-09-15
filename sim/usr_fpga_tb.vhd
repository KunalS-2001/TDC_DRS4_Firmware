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

entity TBX_usr_fpga is
end TBX_usr_fpga;

architecture TBX_ARCH of TBX_usr_fpga is
  component usr_fpga
    port (
      P_O_ZBT1_CE2 : out STD_LOGIC;
      P_O_ZBT2_BWSD_N : out STD_LOGIC;
      P_O_ZBT1_ADV : out STD_LOGIC;
      P_O_ZBT2_BWSC_N : out STD_LOGIC;
      P_O_ZBT2_BWSB_N : out STD_LOGIC;
      P_O_ULED_FRONT_GREEN_N : out STD_LOGIC;
      P_O_ZBT2_BWSA_N : out STD_LOGIC;
      P_O_ZBT2_CE2 : out STD_LOGIC;
      P_O_ZBT2_ADV : out STD_LOGIC;
      P_O_ZBT2_ZZ : out STD_LOGIC;
      P_O_ULED_FRONT_RED_N : out STD_LOGIC;
      P_O_ZBT2_WE_N : out STD_LOGIC;
      P_O_ZBT1_WE_N : out STD_LOGIC;
      P_O_ZBT1_ZZ : out STD_LOGIC;
      P_O_ZBT2_CEN_N : out STD_LOGIC;
      P_O_ZBT1_BWSD_N : out STD_LOGIC;
      P_O_ZBT1_BWSC_N : out STD_LOGIC;
      P_O_ZBT2_OE_N : out STD_LOGIC;
      P_O_ZBT1_BWSB_N : out STD_LOGIC;
      P_O_SER_UEEPROM_CLK : out STD_LOGIC;
      P_O_ZBT1_BWSA_N : out STD_LOGIC;
      P_O_ZBT1_OE_N : out STD_LOGIC;
      P_O_ZBT2_MODE : out STD_LOGIC;
      P_O_ZBT1_CEN_N : out STD_LOGIC;
      P_O_ZBT1_MODE : out STD_LOGIC;
      P_O_ZBT_CLK : out STD_LOGIC;
      P_IO_UTPORT_TS2E : inout STD_LOGIC;
      P_IO_UTPORT_TS1E : inout STD_LOGIC;
      P_IO_UTPORT_TS20 : inout STD_LOGIC;
      P_IO_UTPORT_TS10 : inout STD_LOGIC;
      P_IO_UFLASH_CE_N : inout STD_LOGIC;
      P_IO_UFLASH_OE_N : inout STD_LOGIC;
      P_IO_UTPORT_CPU_HALT : inout STD_LOGIC;
      P_IO_SER_UEEPROM_D : inout STD_LOGIC;
      P_IO_UTPORT_CPU_TRST : inout STD_LOGIC;
      P_IO_UTPORT_CLK : inout STD_LOGIC;
      P_IO_UTPORT_CPU_TMS : inout STD_LOGIC;
      P_IO_UFLASH_WE_N : inout STD_LOGIC;
      P_IO_UTPORT_CPU_TDO : inout STD_LOGIC;
      P_IO_UTPORT_CPU_TDI : inout STD_LOGIC;
      P_IO_UTPORT_CPU_TCK : inout STD_LOGIC;
      P_IO_UTPORT_CPU_HRESET : inout STD_LOGIC;
      P_I_UFLASH_ACC_WP_N : in STD_LOGIC := 'X';
      P_I_UFLASH_RESET_N : in STD_LOGIC := 'X';
      P_I_UFLASH_BYTE_N : in STD_LOGIC := 'X';
      P_I_UFLASH_RY_BY_N : in STD_LOGIC := 'X';
      P_I_CLK33 : in STD_LOGIC := 'X';
      P_I_ZBT_CLK_FB : in STD_LOGIC := 'X';
      P_O_ZBT2_A : out STD_LOGIC_VECTOR ( 20 downto 0 );
      P_O_ZBT1_A : out STD_LOGIC_VECTOR ( 20 downto 0 );
      P_IO_PMC1_USR : inout STD_LOGIC_VECTOR ( 63 downto 0 );
      P_IO_UFLASH_D : inout STD_LOGIC_VECTOR ( 15 downto 0 );
      P_IO_VME_P2_Z : inout STD_LOGIC_VECTOR ( 13 downto 0 );
      P_IO_ZBT1_D : inout STD_LOGIC_VECTOR ( 35 downto 0 );
      P_IO_VME_P2_A : inout STD_LOGIC_VECTOR ( 30 downto 0 );
      P_IO_PMC2_USR : inout STD_LOGIC_VECTOR ( 63 downto 0 );
      P_IO_VME_P2_D : inout STD_LOGIC_VECTOR ( 27 downto 0 );
      P_IO_FRONTP_J8_P : inout STD_LOGIC_VECTOR ( 4 downto 1 );
      P_IO_UTPORT_ATDD_A : inout STD_LOGIC_VECTOR ( 14 downto 8 );
      P_IO_SYSFPGA : inout STD_LOGIC_VECTOR ( 6 downto 0 );
      P_IO_UFLASH_A : inout STD_LOGIC_VECTOR ( 22 downto 0 );
      P_IO_FRONTP_J8_N : inout STD_LOGIC_VECTOR ( 4 downto 1 );
      P_IO_ZBT2_D : inout STD_LOGIC_VECTOR ( 35 downto 0 );
      P_IO_UTPORT_TS : inout STD_LOGIC_VECTOR ( 6 downto 3 );
      P_IO_UTPORT_DEBUG : inout STD_LOGIC_VECTOR ( 9 downto 0 );
      P_IO_VME_P0_USR : inout STD_LOGIC_VECTOR ( 75 downto 0 );
      P_IO_VME_P2_C : inout STD_LOGIC_VECTOR ( 28 downto 0 );
      P_IO_UTPORT_ATDD_B : inout STD_LOGIC_VECTOR ( 19 downto 16 );
      P_I_DIPSW1 : in STD_LOGIC_VECTOR ( 7 downto 0 );
      P_I_HW_ID : in STD_LOGIC_VECTOR ( 4 downto 0 )
    );
  end component;

  signal P_O_ZBT1_CE2 : STD_LOGIC;
  signal P_O_ZBT2_BWSD_N : STD_LOGIC;
  signal P_O_ZBT1_ADV : STD_LOGIC;
  signal P_O_ZBT2_BWSC_N : STD_LOGIC;
  signal P_O_ZBT2_BWSB_N : STD_LOGIC;
  signal P_O_ULED_FRONT_GREEN_N : STD_LOGIC;
  signal P_O_ZBT2_BWSA_N : STD_LOGIC;
  signal P_O_ZBT2_CE2 : STD_LOGIC;
  signal P_O_ZBT2_ADV : STD_LOGIC;
  signal P_O_ZBT2_ZZ : STD_LOGIC;
  signal P_O_ULED_FRONT_RED_N : STD_LOGIC;
  signal P_O_ZBT2_WE_N : STD_LOGIC;
  signal P_O_ZBT1_WE_N : STD_LOGIC;
  signal P_O_ZBT1_ZZ : STD_LOGIC;
  signal P_O_ZBT2_CEN_N : STD_LOGIC;
  signal P_O_ZBT1_BWSD_N : STD_LOGIC;
  signal P_O_ZBT1_BWSC_N : STD_LOGIC;
  signal P_O_ZBT2_OE_N : STD_LOGIC;
  signal P_O_ZBT1_BWSB_N : STD_LOGIC;
  signal P_O_SER_UEEPROM_CLK : STD_LOGIC;
  signal P_O_ZBT1_BWSA_N : STD_LOGIC;
  signal P_O_ZBT1_OE_N : STD_LOGIC;
  signal P_O_ZBT2_MODE : STD_LOGIC;
  signal P_O_ZBT1_CEN_N : STD_LOGIC;
  signal P_O_ZBT1_MODE : STD_LOGIC;
  signal P_O_ZBT_CLK : STD_LOGIC;
  signal P_IO_UTPORT_TS2E : STD_LOGIC;
  signal P_IO_UTPORT_TS1E : STD_LOGIC;
  signal P_IO_UTPORT_TS20 : STD_LOGIC;
  signal P_IO_UTPORT_TS10 : STD_LOGIC;
  signal P_IO_UFLASH_CE_N : STD_LOGIC;
  signal P_IO_UFLASH_OE_N : STD_LOGIC;
  signal P_IO_UTPORT_CPU_HALT : STD_LOGIC;
  signal P_IO_SER_UEEPROM_D : STD_LOGIC;
  signal P_IO_UTPORT_CPU_TRST : STD_LOGIC;
  signal P_IO_UTPORT_CLK : STD_LOGIC;
  signal P_IO_UTPORT_CPU_TMS : STD_LOGIC;
  signal P_IO_UFLASH_WE_N : STD_LOGIC;
  signal P_IO_UTPORT_CPU_TDO : STD_LOGIC;
  signal P_IO_UTPORT_CPU_TDI : STD_LOGIC;
  signal P_IO_UTPORT_CPU_TCK : STD_LOGIC;
  signal P_IO_UTPORT_CPU_HRESET : STD_LOGIC;
  signal P_I_UFLASH_ACC_WP_N : STD_LOGIC;
  signal P_I_UFLASH_RESET_N : STD_LOGIC;
  signal P_I_UFLASH_BYTE_N : STD_LOGIC;
  signal P_I_UFLASH_RY_BY_N : STD_LOGIC;
  signal P_I_CLK33 : STD_LOGIC;
  signal P_I_ZBT_CLK_FB : STD_LOGIC;
  signal P_O_ZBT2_A : STD_LOGIC_VECTOR ( 20 downto 0 );
  signal P_O_ZBT1_A : STD_LOGIC_VECTOR ( 20 downto 0 );
  signal P_IO_PMC1_USR : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal P_IO_UFLASH_D : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal P_IO_VME_P2_Z : STD_LOGIC_VECTOR ( 13 downto 0 );
  signal P_IO_ZBT1_D : STD_LOGIC_VECTOR ( 35 downto 0 );
  signal P_IO_VME_P2_A : STD_LOGIC_VECTOR ( 30 downto 0 );
  signal P_IO_PMC2_USR : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal P_IO_VME_P2_D : STD_LOGIC_VECTOR ( 27 downto 0 );
  signal P_IO_FRONTP_J8_P : STD_LOGIC_VECTOR ( 4 downto 1 );
  signal P_IO_UTPORT_ATDD_A : STD_LOGIC_VECTOR ( 14 downto 8 );
  signal P_IO_SYSFPGA : STD_LOGIC_VECTOR ( 6 downto 0 );
  signal P_IO_UFLASH_A : STD_LOGIC_VECTOR ( 22 downto 0 );
  signal P_IO_FRONTP_J8_N : STD_LOGIC_VECTOR ( 4 downto 1 );
  signal P_IO_ZBT2_D : STD_LOGIC_VECTOR ( 35 downto 0 );
  signal P_IO_UTPORT_TS : STD_LOGIC_VECTOR ( 6 downto 3 );
  signal P_IO_UTPORT_DEBUG : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal P_IO_VME_P0_USR : STD_LOGIC_VECTOR ( 75 downto 0 );
  signal P_IO_VME_P2_C : STD_LOGIC_VECTOR ( 28 downto 0 );
  signal P_IO_UTPORT_ATDD_B : STD_LOGIC_VECTOR ( 19 downto 16 );
  signal P_I_DIPSW1 : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal P_I_HW_ID : STD_LOGIC_VECTOR ( 4 downto 0 );

  -- signal shortcuts
  signal o_cycle_n   : std_logic;
  signal i_cycle_n   : std_logic;
  signal i_req_n     : std_logic;
  signal o_gnt_n     : std_logic;
  signal io_ack_n    : std_logic;
  signal io_err_n    : std_logic;
  signal i_alive     : std_logic;
  
  signal io_as_n     : std_logic;
  signal io_ds_n     : std_logic;
  signal io_write_n  : std_logic;

  signal o_ad        : std_logic_vector(31 downto 0);
  signal i_ad        : std_logic_vector(31 downto 0);
  signal o_sel       : std_logic_vector(3 downto 0);
  
  signal i_data      : std_logic_vector(31 downto 0);
  
  -- 66 MHz clock
  signal CLK66       : std_logic;
  
  begin
    UUT : usr_fpga
      port map (
        P_O_ZBT1_CE2 => P_O_ZBT1_CE2,
        P_O_ZBT2_BWSD_N => P_O_ZBT2_BWSD_N,
        P_O_ZBT1_ADV => P_O_ZBT1_ADV,
        P_O_ZBT2_BWSC_N => P_O_ZBT2_BWSC_N,
        P_O_ZBT2_BWSB_N => P_O_ZBT2_BWSB_N,
        P_O_ULED_FRONT_GREEN_N => P_O_ULED_FRONT_GREEN_N,
        P_O_ZBT2_BWSA_N => P_O_ZBT2_BWSA_N,
        P_O_ZBT2_CE2 => P_O_ZBT2_CE2,
        P_O_ZBT2_ADV => P_O_ZBT2_ADV,
        P_O_ZBT2_ZZ => P_O_ZBT2_ZZ,
        P_O_ULED_FRONT_RED_N => P_O_ULED_FRONT_RED_N,
        P_O_ZBT2_WE_N => P_O_ZBT2_WE_N,
        P_O_ZBT1_WE_N => P_O_ZBT1_WE_N,
        P_O_ZBT1_ZZ => P_O_ZBT1_ZZ,
        P_O_ZBT2_CEN_N => P_O_ZBT2_CEN_N,
        P_O_ZBT1_BWSD_N => P_O_ZBT1_BWSD_N,
        P_O_ZBT1_BWSC_N => P_O_ZBT1_BWSC_N,
        P_O_ZBT2_OE_N => P_O_ZBT2_OE_N,
        P_O_ZBT1_BWSB_N => P_O_ZBT1_BWSB_N,
        P_O_SER_UEEPROM_CLK => P_O_SER_UEEPROM_CLK,
        P_O_ZBT1_BWSA_N => P_O_ZBT1_BWSA_N,
        P_O_ZBT1_OE_N => P_O_ZBT1_OE_N,
        P_O_ZBT2_MODE => P_O_ZBT2_MODE,
        P_O_ZBT1_CEN_N => P_O_ZBT1_CEN_N,
        P_O_ZBT1_MODE => P_O_ZBT1_MODE,
        P_O_ZBT_CLK => P_O_ZBT_CLK,
        P_IO_UTPORT_TS2E => P_IO_UTPORT_TS2E,
        P_IO_UTPORT_TS1E => P_IO_UTPORT_TS1E,
        P_IO_UTPORT_TS20 => P_IO_UTPORT_TS20,
        P_IO_UTPORT_TS10 => P_IO_UTPORT_TS10,
        P_IO_UFLASH_CE_N => P_IO_UFLASH_CE_N,
        P_IO_UFLASH_OE_N => P_IO_UFLASH_OE_N,
        P_IO_UTPORT_CPU_HALT => P_IO_UTPORT_CPU_HALT,
        P_IO_SER_UEEPROM_D => P_IO_SER_UEEPROM_D,
        P_IO_UTPORT_CPU_TRST => P_IO_UTPORT_CPU_TRST,
        P_IO_UTPORT_CLK => P_IO_UTPORT_CLK,
        P_IO_UTPORT_CPU_TMS => P_IO_UTPORT_CPU_TMS,
        P_IO_UFLASH_WE_N => P_IO_UFLASH_WE_N,
        P_IO_UTPORT_CPU_TDO => P_IO_UTPORT_CPU_TDO,
        P_IO_UTPORT_CPU_TDI => P_IO_UTPORT_CPU_TDI,
        P_IO_UTPORT_CPU_TCK => P_IO_UTPORT_CPU_TCK,
        P_IO_UTPORT_CPU_HRESET => P_IO_UTPORT_CPU_HRESET,
        P_I_UFLASH_ACC_WP_N => P_I_UFLASH_ACC_WP_N,
        P_I_UFLASH_RESET_N => P_I_UFLASH_RESET_N,
        P_I_UFLASH_BYTE_N => P_I_UFLASH_BYTE_N,
        P_I_UFLASH_RY_BY_N => P_I_UFLASH_RY_BY_N,
        P_I_CLK33 => P_I_CLK33,
        P_I_ZBT_CLK_FB => P_I_ZBT_CLK_FB,
        P_O_ZBT2_A(20) => P_O_ZBT2_A(20),
        P_O_ZBT2_A(19) => P_O_ZBT2_A(19),
        P_O_ZBT2_A(18) => P_O_ZBT2_A(18),
        P_O_ZBT2_A(17) => P_O_ZBT2_A(17),
        P_O_ZBT2_A(16) => P_O_ZBT2_A(16),
        P_O_ZBT2_A(15) => P_O_ZBT2_A(15),
        P_O_ZBT2_A(14) => P_O_ZBT2_A(14),
        P_O_ZBT2_A(13) => P_O_ZBT2_A(13),
        P_O_ZBT2_A(12) => P_O_ZBT2_A(12),
        P_O_ZBT2_A(11) => P_O_ZBT2_A(11),
        P_O_ZBT2_A(10) => P_O_ZBT2_A(10),
        P_O_ZBT2_A(9) => P_O_ZBT2_A(9),
        P_O_ZBT2_A(8) => P_O_ZBT2_A(8),
        P_O_ZBT2_A(7) => P_O_ZBT2_A(7),
        P_O_ZBT2_A(6) => P_O_ZBT2_A(6),
        P_O_ZBT2_A(5) => P_O_ZBT2_A(5),
        P_O_ZBT2_A(4) => P_O_ZBT2_A(4),
        P_O_ZBT2_A(3) => P_O_ZBT2_A(3),
        P_O_ZBT2_A(2) => P_O_ZBT2_A(2),
        P_O_ZBT2_A(1) => P_O_ZBT2_A(1),
        P_O_ZBT2_A(0) => P_O_ZBT2_A(0),
        P_O_ZBT1_A(20) => P_O_ZBT1_A(20),
        P_O_ZBT1_A(19) => P_O_ZBT1_A(19),
        P_O_ZBT1_A(18) => P_O_ZBT1_A(18),
        P_O_ZBT1_A(17) => P_O_ZBT1_A(17),
        P_O_ZBT1_A(16) => P_O_ZBT1_A(16),
        P_O_ZBT1_A(15) => P_O_ZBT1_A(15),
        P_O_ZBT1_A(14) => P_O_ZBT1_A(14),
        P_O_ZBT1_A(13) => P_O_ZBT1_A(13),
        P_O_ZBT1_A(12) => P_O_ZBT1_A(12),
        P_O_ZBT1_A(11) => P_O_ZBT1_A(11),
        P_O_ZBT1_A(10) => P_O_ZBT1_A(10),
        P_O_ZBT1_A(9) => P_O_ZBT1_A(9),
        P_O_ZBT1_A(8) => P_O_ZBT1_A(8),
        P_O_ZBT1_A(7) => P_O_ZBT1_A(7),
        P_O_ZBT1_A(6) => P_O_ZBT1_A(6),
        P_O_ZBT1_A(5) => P_O_ZBT1_A(5),
        P_O_ZBT1_A(4) => P_O_ZBT1_A(4),
        P_O_ZBT1_A(3) => P_O_ZBT1_A(3),
        P_O_ZBT1_A(2) => P_O_ZBT1_A(2),
        P_O_ZBT1_A(1) => P_O_ZBT1_A(1),
        P_O_ZBT1_A(0) => P_O_ZBT1_A(0),
        P_IO_PMC1_USR(63) => P_IO_PMC1_USR(63),
        P_IO_PMC1_USR(62) => P_IO_PMC1_USR(62),
        P_IO_PMC1_USR(61) => P_IO_PMC1_USR(61),
        P_IO_PMC1_USR(60) => P_IO_PMC1_USR(60),
        P_IO_PMC1_USR(59) => P_IO_PMC1_USR(59),
        P_IO_PMC1_USR(58) => P_IO_PMC1_USR(58),
        P_IO_PMC1_USR(57) => P_IO_PMC1_USR(57),
        P_IO_PMC1_USR(56) => P_IO_PMC1_USR(56),
        P_IO_PMC1_USR(55) => P_IO_PMC1_USR(55),
        P_IO_PMC1_USR(54) => P_IO_PMC1_USR(54),
        P_IO_PMC1_USR(53) => P_IO_PMC1_USR(53),
        P_IO_PMC1_USR(52) => P_IO_PMC1_USR(52),
        P_IO_PMC1_USR(51) => P_IO_PMC1_USR(51),
        P_IO_PMC1_USR(50) => P_IO_PMC1_USR(50),
        P_IO_PMC1_USR(49) => P_IO_PMC1_USR(49),
        P_IO_PMC1_USR(48) => P_IO_PMC1_USR(48),
        P_IO_PMC1_USR(47) => P_IO_PMC1_USR(47),
        P_IO_PMC1_USR(46) => P_IO_PMC1_USR(46),
        P_IO_PMC1_USR(45) => P_IO_PMC1_USR(45),
        P_IO_PMC1_USR(44) => P_IO_PMC1_USR(44),
        P_IO_PMC1_USR(43) => P_IO_PMC1_USR(43),
        P_IO_PMC1_USR(42) => P_IO_PMC1_USR(42),
        P_IO_PMC1_USR(41) => P_IO_PMC1_USR(41),
        P_IO_PMC1_USR(40) => P_IO_PMC1_USR(40),
        P_IO_PMC1_USR(39) => P_IO_PMC1_USR(39),
        P_IO_PMC1_USR(38) => P_IO_PMC1_USR(38),
        P_IO_PMC1_USR(37) => P_IO_PMC1_USR(37),
        P_IO_PMC1_USR(36) => P_IO_PMC1_USR(36),
        P_IO_PMC1_USR(35) => P_IO_PMC1_USR(35),
        P_IO_PMC1_USR(34) => P_IO_PMC1_USR(34),
        P_IO_PMC1_USR(33) => P_IO_PMC1_USR(33),
        P_IO_PMC1_USR(32) => P_IO_PMC1_USR(32),
        P_IO_PMC1_USR(31) => P_IO_PMC1_USR(31),
        P_IO_PMC1_USR(30) => P_IO_PMC1_USR(30),
        P_IO_PMC1_USR(29) => P_IO_PMC1_USR(29),
        P_IO_PMC1_USR(28) => P_IO_PMC1_USR(28),
        P_IO_PMC1_USR(27) => P_IO_PMC1_USR(27),
        P_IO_PMC1_USR(26) => P_IO_PMC1_USR(26),
        P_IO_PMC1_USR(25) => P_IO_PMC1_USR(25),
        P_IO_PMC1_USR(24) => P_IO_PMC1_USR(24),
        P_IO_PMC1_USR(23) => P_IO_PMC1_USR(23),
        P_IO_PMC1_USR(22) => P_IO_PMC1_USR(22),
        P_IO_PMC1_USR(21) => P_IO_PMC1_USR(21),
        P_IO_PMC1_USR(20) => P_IO_PMC1_USR(20),
        P_IO_PMC1_USR(19) => P_IO_PMC1_USR(19),
        P_IO_PMC1_USR(18) => P_IO_PMC1_USR(18),
        P_IO_PMC1_USR(17) => P_IO_PMC1_USR(17),
        P_IO_PMC1_USR(16) => P_IO_PMC1_USR(16),
        P_IO_PMC1_USR(15) => P_IO_PMC1_USR(15),
        P_IO_PMC1_USR(14) => P_IO_PMC1_USR(14),
        P_IO_PMC1_USR(13) => P_IO_PMC1_USR(13),
        P_IO_PMC1_USR(12) => P_IO_PMC1_USR(12),
        P_IO_PMC1_USR(11) => P_IO_PMC1_USR(11),
        P_IO_PMC1_USR(10) => P_IO_PMC1_USR(10),
        P_IO_PMC1_USR(9) => P_IO_PMC1_USR(9),
        P_IO_PMC1_USR(8) => P_IO_PMC1_USR(8),
        P_IO_PMC1_USR(7) => P_IO_PMC1_USR(7),
        P_IO_PMC1_USR(6) => P_IO_PMC1_USR(6),
        P_IO_PMC1_USR(5) => P_IO_PMC1_USR(5),
        P_IO_PMC1_USR(4) => P_IO_PMC1_USR(4),
        P_IO_PMC1_USR(3) => P_IO_PMC1_USR(3),
        P_IO_PMC1_USR(2) => P_IO_PMC1_USR(2),
        P_IO_PMC1_USR(1) => P_IO_PMC1_USR(1),
        P_IO_PMC1_USR(0) => P_IO_PMC1_USR(0),
        P_IO_UFLASH_D(15) => P_IO_UFLASH_D(15),
        P_IO_UFLASH_D(14) => P_IO_UFLASH_D(14),
        P_IO_UFLASH_D(13) => P_IO_UFLASH_D(13),
        P_IO_UFLASH_D(12) => P_IO_UFLASH_D(12),
        P_IO_UFLASH_D(11) => P_IO_UFLASH_D(11),
        P_IO_UFLASH_D(10) => P_IO_UFLASH_D(10),
        P_IO_UFLASH_D(9) => P_IO_UFLASH_D(9),
        P_IO_UFLASH_D(8) => P_IO_UFLASH_D(8),
        P_IO_UFLASH_D(7) => P_IO_UFLASH_D(7),
        P_IO_UFLASH_D(6) => P_IO_UFLASH_D(6),
        P_IO_UFLASH_D(5) => P_IO_UFLASH_D(5),
        P_IO_UFLASH_D(4) => P_IO_UFLASH_D(4),
        P_IO_UFLASH_D(3) => P_IO_UFLASH_D(3),
        P_IO_UFLASH_D(2) => P_IO_UFLASH_D(2),
        P_IO_UFLASH_D(1) => P_IO_UFLASH_D(1),
        P_IO_UFLASH_D(0) => P_IO_UFLASH_D(0),
        P_IO_VME_P2_Z(13) => P_IO_VME_P2_Z(13),
        P_IO_VME_P2_Z(12) => P_IO_VME_P2_Z(12),
        P_IO_VME_P2_Z(11) => P_IO_VME_P2_Z(11),
        P_IO_VME_P2_Z(10) => P_IO_VME_P2_Z(10),
        P_IO_VME_P2_Z(9) => P_IO_VME_P2_Z(9),
        P_IO_VME_P2_Z(8) => P_IO_VME_P2_Z(8),
        P_IO_VME_P2_Z(7) => P_IO_VME_P2_Z(7),
        P_IO_VME_P2_Z(6) => P_IO_VME_P2_Z(6),
        P_IO_VME_P2_Z(5) => P_IO_VME_P2_Z(5),
        P_IO_VME_P2_Z(4) => P_IO_VME_P2_Z(4),
        P_IO_VME_P2_Z(3) => P_IO_VME_P2_Z(3),
        P_IO_VME_P2_Z(2) => P_IO_VME_P2_Z(2),
        P_IO_VME_P2_Z(1) => P_IO_VME_P2_Z(1),
        P_IO_VME_P2_Z(0) => P_IO_VME_P2_Z(0),
        P_IO_ZBT1_D(35) => P_IO_ZBT1_D(35),
        P_IO_ZBT1_D(34) => P_IO_ZBT1_D(34),
        P_IO_ZBT1_D(33) => P_IO_ZBT1_D(33),
        P_IO_ZBT1_D(32) => P_IO_ZBT1_D(32),
        P_IO_ZBT1_D(31) => P_IO_ZBT1_D(31),
        P_IO_ZBT1_D(30) => P_IO_ZBT1_D(30),
        P_IO_ZBT1_D(29) => P_IO_ZBT1_D(29),
        P_IO_ZBT1_D(28) => P_IO_ZBT1_D(28),
        P_IO_ZBT1_D(27) => P_IO_ZBT1_D(27),
        P_IO_ZBT1_D(26) => P_IO_ZBT1_D(26),
        P_IO_ZBT1_D(25) => P_IO_ZBT1_D(25),
        P_IO_ZBT1_D(24) => P_IO_ZBT1_D(24),
        P_IO_ZBT1_D(23) => P_IO_ZBT1_D(23),
        P_IO_ZBT1_D(22) => P_IO_ZBT1_D(22),
        P_IO_ZBT1_D(21) => P_IO_ZBT1_D(21),
        P_IO_ZBT1_D(20) => P_IO_ZBT1_D(20),
        P_IO_ZBT1_D(19) => P_IO_ZBT1_D(19),
        P_IO_ZBT1_D(18) => P_IO_ZBT1_D(18),
        P_IO_ZBT1_D(17) => P_IO_ZBT1_D(17),
        P_IO_ZBT1_D(16) => P_IO_ZBT1_D(16),
        P_IO_ZBT1_D(15) => P_IO_ZBT1_D(15),
        P_IO_ZBT1_D(14) => P_IO_ZBT1_D(14),
        P_IO_ZBT1_D(13) => P_IO_ZBT1_D(13),
        P_IO_ZBT1_D(12) => P_IO_ZBT1_D(12),
        P_IO_ZBT1_D(11) => P_IO_ZBT1_D(11),
        P_IO_ZBT1_D(10) => P_IO_ZBT1_D(10),
        P_IO_ZBT1_D(9) => P_IO_ZBT1_D(9),
        P_IO_ZBT1_D(8) => P_IO_ZBT1_D(8),
        P_IO_ZBT1_D(7) => P_IO_ZBT1_D(7),
        P_IO_ZBT1_D(6) => P_IO_ZBT1_D(6),
        P_IO_ZBT1_D(5) => P_IO_ZBT1_D(5),
        P_IO_ZBT1_D(4) => P_IO_ZBT1_D(4),
        P_IO_ZBT1_D(3) => P_IO_ZBT1_D(3),
        P_IO_ZBT1_D(2) => P_IO_ZBT1_D(2),
        P_IO_ZBT1_D(1) => P_IO_ZBT1_D(1),
        P_IO_ZBT1_D(0) => P_IO_ZBT1_D(0),
        P_IO_VME_P2_A(30) => P_IO_VME_P2_A(30),
        P_IO_VME_P2_A(29) => P_IO_VME_P2_A(29),
        P_IO_VME_P2_A(28) => P_IO_VME_P2_A(28),
        P_IO_VME_P2_A(27) => P_IO_VME_P2_A(27),
        P_IO_VME_P2_A(26) => P_IO_VME_P2_A(26),
        P_IO_VME_P2_A(25) => P_IO_VME_P2_A(25),
        P_IO_VME_P2_A(24) => P_IO_VME_P2_A(24),
        P_IO_VME_P2_A(23) => P_IO_VME_P2_A(23),
        P_IO_VME_P2_A(22) => P_IO_VME_P2_A(22),
        P_IO_VME_P2_A(21) => P_IO_VME_P2_A(21),
        P_IO_VME_P2_A(20) => P_IO_VME_P2_A(20),
        P_IO_VME_P2_A(19) => P_IO_VME_P2_A(19),
        P_IO_VME_P2_A(18) => P_IO_VME_P2_A(18),
        P_IO_VME_P2_A(17) => P_IO_VME_P2_A(17),
        P_IO_VME_P2_A(16) => P_IO_VME_P2_A(16),
        P_IO_VME_P2_A(15) => P_IO_VME_P2_A(15),
        P_IO_VME_P2_A(14) => P_IO_VME_P2_A(14),
        P_IO_VME_P2_A(13) => P_IO_VME_P2_A(13),
        P_IO_VME_P2_A(12) => P_IO_VME_P2_A(12),
        P_IO_VME_P2_A(11) => P_IO_VME_P2_A(11),
        P_IO_VME_P2_A(10) => P_IO_VME_P2_A(10),
        P_IO_VME_P2_A(9) => P_IO_VME_P2_A(9),
        P_IO_VME_P2_A(8) => P_IO_VME_P2_A(8),
        P_IO_VME_P2_A(7) => P_IO_VME_P2_A(7),
        P_IO_VME_P2_A(6) => P_IO_VME_P2_A(6),
        P_IO_VME_P2_A(5) => P_IO_VME_P2_A(5),
        P_IO_VME_P2_A(4) => P_IO_VME_P2_A(4),
        P_IO_VME_P2_A(3) => P_IO_VME_P2_A(3),
        P_IO_VME_P2_A(2) => P_IO_VME_P2_A(2),
        P_IO_VME_P2_A(1) => P_IO_VME_P2_A(1),
        P_IO_VME_P2_A(0) => P_IO_VME_P2_A(0),
        P_IO_PMC2_USR(63) => P_IO_PMC2_USR(63),
        P_IO_PMC2_USR(62) => P_IO_PMC2_USR(62),
        P_IO_PMC2_USR(61) => P_IO_PMC2_USR(61),
        P_IO_PMC2_USR(60) => P_IO_PMC2_USR(60),
        P_IO_PMC2_USR(59) => P_IO_PMC2_USR(59),
        P_IO_PMC2_USR(58) => P_IO_PMC2_USR(58),
        P_IO_PMC2_USR(57) => P_IO_PMC2_USR(57),
        P_IO_PMC2_USR(56) => P_IO_PMC2_USR(56),
        P_IO_PMC2_USR(55) => P_IO_PMC2_USR(55),
        P_IO_PMC2_USR(54) => P_IO_PMC2_USR(54),
        P_IO_PMC2_USR(53) => P_IO_PMC2_USR(53),
        P_IO_PMC2_USR(52) => P_IO_PMC2_USR(52),
        P_IO_PMC2_USR(51) => P_IO_PMC2_USR(51),
        P_IO_PMC2_USR(50) => P_IO_PMC2_USR(50),
        P_IO_PMC2_USR(49) => P_IO_PMC2_USR(49),
        P_IO_PMC2_USR(48) => P_IO_PMC2_USR(48),
        P_IO_PMC2_USR(47) => P_IO_PMC2_USR(47),
        P_IO_PMC2_USR(46) => P_IO_PMC2_USR(46),
        P_IO_PMC2_USR(45) => P_IO_PMC2_USR(45),
        P_IO_PMC2_USR(44) => P_IO_PMC2_USR(44),
        P_IO_PMC2_USR(43) => P_IO_PMC2_USR(43),
        P_IO_PMC2_USR(42) => P_IO_PMC2_USR(42),
        P_IO_PMC2_USR(41) => P_IO_PMC2_USR(41),
        P_IO_PMC2_USR(40) => P_IO_PMC2_USR(40),
        P_IO_PMC2_USR(39) => P_IO_PMC2_USR(39),
        P_IO_PMC2_USR(38) => P_IO_PMC2_USR(38),
        P_IO_PMC2_USR(37) => P_IO_PMC2_USR(37),
        P_IO_PMC2_USR(36) => P_IO_PMC2_USR(36),
        P_IO_PMC2_USR(35) => P_IO_PMC2_USR(35),
        P_IO_PMC2_USR(34) => P_IO_PMC2_USR(34),
        P_IO_PMC2_USR(33) => P_IO_PMC2_USR(33),
        P_IO_PMC2_USR(32) => P_IO_PMC2_USR(32),
        P_IO_PMC2_USR(31) => P_IO_PMC2_USR(31),
        P_IO_PMC2_USR(30) => P_IO_PMC2_USR(30),
        P_IO_PMC2_USR(29) => P_IO_PMC2_USR(29),
        P_IO_PMC2_USR(28) => P_IO_PMC2_USR(28),
        P_IO_PMC2_USR(27) => P_IO_PMC2_USR(27),
        P_IO_PMC2_USR(26) => P_IO_PMC2_USR(26),
        P_IO_PMC2_USR(25) => P_IO_PMC2_USR(25),
        P_IO_PMC2_USR(24) => P_IO_PMC2_USR(24),
        P_IO_PMC2_USR(23) => P_IO_PMC2_USR(23),
        P_IO_PMC2_USR(22) => P_IO_PMC2_USR(22),
        P_IO_PMC2_USR(21) => P_IO_PMC2_USR(21),
        P_IO_PMC2_USR(20) => P_IO_PMC2_USR(20),
        P_IO_PMC2_USR(19) => P_IO_PMC2_USR(19),
        P_IO_PMC2_USR(18) => P_IO_PMC2_USR(18),
        P_IO_PMC2_USR(17) => P_IO_PMC2_USR(17),
        P_IO_PMC2_USR(16) => P_IO_PMC2_USR(16),
        P_IO_PMC2_USR(15) => P_IO_PMC2_USR(15),
        P_IO_PMC2_USR(14) => P_IO_PMC2_USR(14),
        P_IO_PMC2_USR(13) => P_IO_PMC2_USR(13),
        P_IO_PMC2_USR(12) => P_IO_PMC2_USR(12),
        P_IO_PMC2_USR(11) => P_IO_PMC2_USR(11),
        P_IO_PMC2_USR(10) => P_IO_PMC2_USR(10),
        P_IO_PMC2_USR(9) => P_IO_PMC2_USR(9),
        P_IO_PMC2_USR(8) => P_IO_PMC2_USR(8),
        P_IO_PMC2_USR(7) => P_IO_PMC2_USR(7),
        P_IO_PMC2_USR(6) => P_IO_PMC2_USR(6),
        P_IO_PMC2_USR(5) => P_IO_PMC2_USR(5),
        P_IO_PMC2_USR(4) => P_IO_PMC2_USR(4),
        P_IO_PMC2_USR(3) => P_IO_PMC2_USR(3),
        P_IO_PMC2_USR(2) => P_IO_PMC2_USR(2),
        P_IO_PMC2_USR(1) => P_IO_PMC2_USR(1),
        P_IO_PMC2_USR(0) => P_IO_PMC2_USR(0),
        P_IO_VME_P2_D(27) => P_IO_VME_P2_D(27),
        P_IO_VME_P2_D(26) => P_IO_VME_P2_D(26),
        P_IO_VME_P2_D(25) => P_IO_VME_P2_D(25),
        P_IO_VME_P2_D(24) => P_IO_VME_P2_D(24),
        P_IO_VME_P2_D(23) => P_IO_VME_P2_D(23),
        P_IO_VME_P2_D(22) => P_IO_VME_P2_D(22),
        P_IO_VME_P2_D(21) => P_IO_VME_P2_D(21),
        P_IO_VME_P2_D(20) => P_IO_VME_P2_D(20),
        P_IO_VME_P2_D(19) => P_IO_VME_P2_D(19),
        P_IO_VME_P2_D(18) => P_IO_VME_P2_D(18),
        P_IO_VME_P2_D(17) => P_IO_VME_P2_D(17),
        P_IO_VME_P2_D(16) => P_IO_VME_P2_D(16),
        P_IO_VME_P2_D(15) => P_IO_VME_P2_D(15),
        P_IO_VME_P2_D(14) => P_IO_VME_P2_D(14),
        P_IO_VME_P2_D(13) => P_IO_VME_P2_D(13),
        P_IO_VME_P2_D(12) => P_IO_VME_P2_D(12),
        P_IO_VME_P2_D(11) => P_IO_VME_P2_D(11),
        P_IO_VME_P2_D(10) => P_IO_VME_P2_D(10),
        P_IO_VME_P2_D(9) => P_IO_VME_P2_D(9),
        P_IO_VME_P2_D(8) => P_IO_VME_P2_D(8),
        P_IO_VME_P2_D(7) => P_IO_VME_P2_D(7),
        P_IO_VME_P2_D(6) => P_IO_VME_P2_D(6),
        P_IO_VME_P2_D(5) => P_IO_VME_P2_D(5),
        P_IO_VME_P2_D(4) => P_IO_VME_P2_D(4),
        P_IO_VME_P2_D(3) => P_IO_VME_P2_D(3),
        P_IO_VME_P2_D(2) => P_IO_VME_P2_D(2),
        P_IO_VME_P2_D(1) => P_IO_VME_P2_D(1),
        P_IO_VME_P2_D(0) => P_IO_VME_P2_D(0),
        P_IO_FRONTP_J8_P(4) => P_IO_FRONTP_J8_P(4),
        P_IO_FRONTP_J8_P(3) => P_IO_FRONTP_J8_P(3),
        P_IO_FRONTP_J8_P(2) => P_IO_FRONTP_J8_P(2),
        P_IO_FRONTP_J8_P(1) => P_IO_FRONTP_J8_P(1),
        P_IO_UTPORT_ATDD_A(14) => P_IO_UTPORT_ATDD_A(14),
        P_IO_UTPORT_ATDD_A(13) => P_IO_UTPORT_ATDD_A(13),
        P_IO_UTPORT_ATDD_A(12) => P_IO_UTPORT_ATDD_A(12),
        P_IO_UTPORT_ATDD_A(11) => P_IO_UTPORT_ATDD_A(11),
        P_IO_UTPORT_ATDD_A(10) => P_IO_UTPORT_ATDD_A(10),
        P_IO_UTPORT_ATDD_A(9) => P_IO_UTPORT_ATDD_A(9),
        P_IO_UTPORT_ATDD_A(8) => P_IO_UTPORT_ATDD_A(8),
        P_IO_SYSFPGA(6) => P_IO_SYSFPGA(6),
        P_IO_SYSFPGA(5) => P_IO_SYSFPGA(5),
        P_IO_SYSFPGA(4) => P_IO_SYSFPGA(4),
        P_IO_SYSFPGA(3) => P_IO_SYSFPGA(3),
        P_IO_SYSFPGA(2) => P_IO_SYSFPGA(2),
        P_IO_SYSFPGA(1) => P_IO_SYSFPGA(1),
        P_IO_SYSFPGA(0) => P_IO_SYSFPGA(0),
        P_IO_UFLASH_A(22) => P_IO_UFLASH_A(22),
        P_IO_UFLASH_A(21) => P_IO_UFLASH_A(21),
        P_IO_UFLASH_A(20) => P_IO_UFLASH_A(20),
        P_IO_UFLASH_A(19) => P_IO_UFLASH_A(19),
        P_IO_UFLASH_A(18) => P_IO_UFLASH_A(18),
        P_IO_UFLASH_A(17) => P_IO_UFLASH_A(17),
        P_IO_UFLASH_A(16) => P_IO_UFLASH_A(16),
        P_IO_UFLASH_A(15) => P_IO_UFLASH_A(15),
        P_IO_UFLASH_A(14) => P_IO_UFLASH_A(14),
        P_IO_UFLASH_A(13) => P_IO_UFLASH_A(13),
        P_IO_UFLASH_A(12) => P_IO_UFLASH_A(12),
        P_IO_UFLASH_A(11) => P_IO_UFLASH_A(11),
        P_IO_UFLASH_A(10) => P_IO_UFLASH_A(10),
        P_IO_UFLASH_A(9) => P_IO_UFLASH_A(9),
        P_IO_UFLASH_A(8) => P_IO_UFLASH_A(8),
        P_IO_UFLASH_A(7) => P_IO_UFLASH_A(7),
        P_IO_UFLASH_A(6) => P_IO_UFLASH_A(6),
        P_IO_UFLASH_A(5) => P_IO_UFLASH_A(5),
        P_IO_UFLASH_A(4) => P_IO_UFLASH_A(4),
        P_IO_UFLASH_A(3) => P_IO_UFLASH_A(3),
        P_IO_UFLASH_A(2) => P_IO_UFLASH_A(2),
        P_IO_UFLASH_A(1) => P_IO_UFLASH_A(1),
        P_IO_UFLASH_A(0) => P_IO_UFLASH_A(0),
        P_IO_FRONTP_J8_N(4) => P_IO_FRONTP_J8_N(4),
        P_IO_FRONTP_J8_N(3) => P_IO_FRONTP_J8_N(3),
        P_IO_FRONTP_J8_N(2) => P_IO_FRONTP_J8_N(2),
        P_IO_FRONTP_J8_N(1) => P_IO_FRONTP_J8_N(1),
        P_IO_ZBT2_D(35) => P_IO_ZBT2_D(35),
        P_IO_ZBT2_D(34) => P_IO_ZBT2_D(34),
        P_IO_ZBT2_D(33) => P_IO_ZBT2_D(33),
        P_IO_ZBT2_D(32) => P_IO_ZBT2_D(32),
        P_IO_ZBT2_D(31) => P_IO_ZBT2_D(31),
        P_IO_ZBT2_D(30) => P_IO_ZBT2_D(30),
        P_IO_ZBT2_D(29) => P_IO_ZBT2_D(29),
        P_IO_ZBT2_D(28) => P_IO_ZBT2_D(28),
        P_IO_ZBT2_D(27) => P_IO_ZBT2_D(27),
        P_IO_ZBT2_D(26) => P_IO_ZBT2_D(26),
        P_IO_ZBT2_D(25) => P_IO_ZBT2_D(25),
        P_IO_ZBT2_D(24) => P_IO_ZBT2_D(24),
        P_IO_ZBT2_D(23) => P_IO_ZBT2_D(23),
        P_IO_ZBT2_D(22) => P_IO_ZBT2_D(22),
        P_IO_ZBT2_D(21) => P_IO_ZBT2_D(21),
        P_IO_ZBT2_D(20) => P_IO_ZBT2_D(20),
        P_IO_ZBT2_D(19) => P_IO_ZBT2_D(19),
        P_IO_ZBT2_D(18) => P_IO_ZBT2_D(18),
        P_IO_ZBT2_D(17) => P_IO_ZBT2_D(17),
        P_IO_ZBT2_D(16) => P_IO_ZBT2_D(16),
        P_IO_ZBT2_D(15) => P_IO_ZBT2_D(15),
        P_IO_ZBT2_D(14) => P_IO_ZBT2_D(14),
        P_IO_ZBT2_D(13) => P_IO_ZBT2_D(13),
        P_IO_ZBT2_D(12) => P_IO_ZBT2_D(12),
        P_IO_ZBT2_D(11) => P_IO_ZBT2_D(11),
        P_IO_ZBT2_D(10) => P_IO_ZBT2_D(10),
        P_IO_ZBT2_D(9) => P_IO_ZBT2_D(9),
        P_IO_ZBT2_D(8) => P_IO_ZBT2_D(8),
        P_IO_ZBT2_D(7) => P_IO_ZBT2_D(7),
        P_IO_ZBT2_D(6) => P_IO_ZBT2_D(6),
        P_IO_ZBT2_D(5) => P_IO_ZBT2_D(5),
        P_IO_ZBT2_D(4) => P_IO_ZBT2_D(4),
        P_IO_ZBT2_D(3) => P_IO_ZBT2_D(3),
        P_IO_ZBT2_D(2) => P_IO_ZBT2_D(2),
        P_IO_ZBT2_D(1) => P_IO_ZBT2_D(1),
        P_IO_ZBT2_D(0) => P_IO_ZBT2_D(0),
        P_IO_UTPORT_TS(6) => P_IO_UTPORT_TS(6),
        P_IO_UTPORT_TS(5) => P_IO_UTPORT_TS(5),
        P_IO_UTPORT_TS(4) => P_IO_UTPORT_TS(4),
        P_IO_UTPORT_TS(3) => P_IO_UTPORT_TS(3),
        P_IO_UTPORT_DEBUG(9) => P_IO_UTPORT_DEBUG(9),
        P_IO_UTPORT_DEBUG(8) => P_IO_UTPORT_DEBUG(8),
        P_IO_UTPORT_DEBUG(7) => P_IO_UTPORT_DEBUG(7),
        P_IO_UTPORT_DEBUG(6) => P_IO_UTPORT_DEBUG(6),
        P_IO_UTPORT_DEBUG(5) => P_IO_UTPORT_DEBUG(5),
        P_IO_UTPORT_DEBUG(4) => P_IO_UTPORT_DEBUG(4),
        P_IO_UTPORT_DEBUG(3) => P_IO_UTPORT_DEBUG(3),
        P_IO_UTPORT_DEBUG(2) => P_IO_UTPORT_DEBUG(2),
        P_IO_UTPORT_DEBUG(1) => P_IO_UTPORT_DEBUG(1),
        P_IO_UTPORT_DEBUG(0) => P_IO_UTPORT_DEBUG(0),
        P_IO_VME_P0_USR(75) => P_IO_VME_P0_USR(75),
        P_IO_VME_P0_USR(74) => P_IO_VME_P0_USR(74),
        P_IO_VME_P0_USR(73) => P_IO_VME_P0_USR(73),
        P_IO_VME_P0_USR(72) => P_IO_VME_P0_USR(72),
        P_IO_VME_P0_USR(71) => P_IO_VME_P0_USR(71),
        P_IO_VME_P0_USR(70) => P_IO_VME_P0_USR(70),
        P_IO_VME_P0_USR(69) => P_IO_VME_P0_USR(69),
        P_IO_VME_P0_USR(68) => P_IO_VME_P0_USR(68),
        P_IO_VME_P0_USR(67) => P_IO_VME_P0_USR(67),
        P_IO_VME_P0_USR(66) => P_IO_VME_P0_USR(66),
        P_IO_VME_P0_USR(65) => P_IO_VME_P0_USR(65),
        P_IO_VME_P0_USR(64) => P_IO_VME_P0_USR(64),
        P_IO_VME_P0_USR(63) => P_IO_VME_P0_USR(63),
        P_IO_VME_P0_USR(62) => P_IO_VME_P0_USR(62),
        P_IO_VME_P0_USR(61) => P_IO_VME_P0_USR(61),
        P_IO_VME_P0_USR(60) => P_IO_VME_P0_USR(60),
        P_IO_VME_P0_USR(59) => P_IO_VME_P0_USR(59),
        P_IO_VME_P0_USR(58) => P_IO_VME_P0_USR(58),
        P_IO_VME_P0_USR(57) => P_IO_VME_P0_USR(57),
        P_IO_VME_P0_USR(56) => P_IO_VME_P0_USR(56),
        P_IO_VME_P0_USR(55) => P_IO_VME_P0_USR(55),
        P_IO_VME_P0_USR(54) => P_IO_VME_P0_USR(54),
        P_IO_VME_P0_USR(53) => P_IO_VME_P0_USR(53),
        P_IO_VME_P0_USR(52) => P_IO_VME_P0_USR(52),
        P_IO_VME_P0_USR(51) => P_IO_VME_P0_USR(51),
        P_IO_VME_P0_USR(50) => P_IO_VME_P0_USR(50),
        P_IO_VME_P0_USR(49) => P_IO_VME_P0_USR(49),
        P_IO_VME_P0_USR(48) => P_IO_VME_P0_USR(48),
        P_IO_VME_P0_USR(47) => P_IO_VME_P0_USR(47),
        P_IO_VME_P0_USR(46) => P_IO_VME_P0_USR(46),
        P_IO_VME_P0_USR(45) => P_IO_VME_P0_USR(45),
        P_IO_VME_P0_USR(44) => P_IO_VME_P0_USR(44),
        P_IO_VME_P0_USR(43) => P_IO_VME_P0_USR(43),
        P_IO_VME_P0_USR(42) => P_IO_VME_P0_USR(42),
        P_IO_VME_P0_USR(41) => P_IO_VME_P0_USR(41),
        P_IO_VME_P0_USR(40) => P_IO_VME_P0_USR(40),
        P_IO_VME_P0_USR(39) => P_IO_VME_P0_USR(39),
        P_IO_VME_P0_USR(38) => P_IO_VME_P0_USR(38),
        P_IO_VME_P0_USR(37) => P_IO_VME_P0_USR(37),
        P_IO_VME_P0_USR(36) => P_IO_VME_P0_USR(36),
        P_IO_VME_P0_USR(35) => P_IO_VME_P0_USR(35),
        P_IO_VME_P0_USR(34) => P_IO_VME_P0_USR(34),
        P_IO_VME_P0_USR(33) => P_IO_VME_P0_USR(33),
        P_IO_VME_P0_USR(32) => P_IO_VME_P0_USR(32),
        P_IO_VME_P0_USR(31) => P_IO_VME_P0_USR(31),
        P_IO_VME_P0_USR(30) => P_IO_VME_P0_USR(30),
        P_IO_VME_P0_USR(29) => P_IO_VME_P0_USR(29),
        P_IO_VME_P0_USR(28) => P_IO_VME_P0_USR(28),
        P_IO_VME_P0_USR(27) => P_IO_VME_P0_USR(27),
        P_IO_VME_P0_USR(26) => P_IO_VME_P0_USR(26),
        P_IO_VME_P0_USR(25) => P_IO_VME_P0_USR(25),
        P_IO_VME_P0_USR(24) => P_IO_VME_P0_USR(24),
        P_IO_VME_P0_USR(23) => P_IO_VME_P0_USR(23),
        P_IO_VME_P0_USR(22) => P_IO_VME_P0_USR(22),
        P_IO_VME_P0_USR(21) => P_IO_VME_P0_USR(21),
        P_IO_VME_P0_USR(20) => P_IO_VME_P0_USR(20),
        P_IO_VME_P0_USR(19) => P_IO_VME_P0_USR(19),
        P_IO_VME_P0_USR(18) => P_IO_VME_P0_USR(18),
        P_IO_VME_P0_USR(17) => P_IO_VME_P0_USR(17),
        P_IO_VME_P0_USR(16) => P_IO_VME_P0_USR(16),
        P_IO_VME_P0_USR(15) => P_IO_VME_P0_USR(15),
        P_IO_VME_P0_USR(14) => P_IO_VME_P0_USR(14),
        P_IO_VME_P0_USR(13) => P_IO_VME_P0_USR(13),
        P_IO_VME_P0_USR(12) => P_IO_VME_P0_USR(12),
        P_IO_VME_P0_USR(11) => P_IO_VME_P0_USR(11),
        P_IO_VME_P0_USR(10) => P_IO_VME_P0_USR(10),
        P_IO_VME_P0_USR(9) => P_IO_VME_P0_USR(9),
        P_IO_VME_P0_USR(8) => P_IO_VME_P0_USR(8),
        P_IO_VME_P0_USR(7) => P_IO_VME_P0_USR(7),
        P_IO_VME_P0_USR(6) => P_IO_VME_P0_USR(6),
        P_IO_VME_P0_USR(5) => P_IO_VME_P0_USR(5),
        P_IO_VME_P0_USR(4) => P_IO_VME_P0_USR(4),
        P_IO_VME_P0_USR(3) => P_IO_VME_P0_USR(3),
        P_IO_VME_P0_USR(2) => P_IO_VME_P0_USR(2),
        P_IO_VME_P0_USR(1) => P_IO_VME_P0_USR(1),
        P_IO_VME_P0_USR(0) => P_IO_VME_P0_USR(0),
        P_IO_VME_P2_C(28) => P_IO_VME_P2_C(28),
        P_IO_VME_P2_C(27) => P_IO_VME_P2_C(27),
        P_IO_VME_P2_C(26) => P_IO_VME_P2_C(26),
        P_IO_VME_P2_C(25) => P_IO_VME_P2_C(25),
        P_IO_VME_P2_C(24) => P_IO_VME_P2_C(24),
        P_IO_VME_P2_C(23) => P_IO_VME_P2_C(23),
        P_IO_VME_P2_C(22) => P_IO_VME_P2_C(22),
        P_IO_VME_P2_C(21) => P_IO_VME_P2_C(21),
        P_IO_VME_P2_C(20) => P_IO_VME_P2_C(20),
        P_IO_VME_P2_C(19) => P_IO_VME_P2_C(19),
        P_IO_VME_P2_C(18) => P_IO_VME_P2_C(18),
        P_IO_VME_P2_C(17) => P_IO_VME_P2_C(17),
        P_IO_VME_P2_C(16) => P_IO_VME_P2_C(16),
        P_IO_VME_P2_C(15) => P_IO_VME_P2_C(15),
        P_IO_VME_P2_C(14) => P_IO_VME_P2_C(14),
        P_IO_VME_P2_C(13) => P_IO_VME_P2_C(13),
        P_IO_VME_P2_C(12) => P_IO_VME_P2_C(12),
        P_IO_VME_P2_C(11) => P_IO_VME_P2_C(11),
        P_IO_VME_P2_C(10) => P_IO_VME_P2_C(10),
        P_IO_VME_P2_C(9) => P_IO_VME_P2_C(9),
        P_IO_VME_P2_C(8) => P_IO_VME_P2_C(8),
        P_IO_VME_P2_C(7) => P_IO_VME_P2_C(7),
        P_IO_VME_P2_C(6) => P_IO_VME_P2_C(6),
        P_IO_VME_P2_C(5) => P_IO_VME_P2_C(5),
        P_IO_VME_P2_C(4) => P_IO_VME_P2_C(4),
        P_IO_VME_P2_C(3) => P_IO_VME_P2_C(3),
        P_IO_VME_P2_C(2) => P_IO_VME_P2_C(2),
        P_IO_VME_P2_C(1) => P_IO_VME_P2_C(1),
        P_IO_VME_P2_C(0) => P_IO_VME_P2_C(0),
        P_IO_UTPORT_ATDD_B(19) => P_IO_UTPORT_ATDD_B(19),
        P_IO_UTPORT_ATDD_B(18) => P_IO_UTPORT_ATDD_B(18),
        P_IO_UTPORT_ATDD_B(17) => P_IO_UTPORT_ATDD_B(17),
        P_IO_UTPORT_ATDD_B(16) => P_IO_UTPORT_ATDD_B(16),
        P_I_DIPSW1(7) => P_I_DIPSW1(7),
        P_I_DIPSW1(6) => P_I_DIPSW1(6),
        P_I_DIPSW1(5) => P_I_DIPSW1(5),
        P_I_DIPSW1(4) => P_I_DIPSW1(4),
        P_I_DIPSW1(3) => P_I_DIPSW1(3),
        P_I_DIPSW1(2) => P_I_DIPSW1(2),
        P_I_DIPSW1(1) => P_I_DIPSW1(1),
        P_I_DIPSW1(0) => P_I_DIPSW1(0),
        P_I_HW_ID(4) => P_I_HW_ID(4),
        P_I_HW_ID(3) => P_I_HW_ID(3),
        P_I_HW_ID(2) => P_I_HW_ID(2),
        P_I_HW_ID(1) => P_I_HW_ID(1),
        P_I_HW_ID(0) => P_I_HW_ID(0)
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
        CLK66 <= '1';
        wait for 7.5 ns;
        CLK66 <= '0';
        wait for 7.5 ns;
      end loop;
    end process;
    
    -- Signal mapping
    P_IO_SYSFPGA(0)    <= o_cycle_n;
    i_cycle_n          <= P_IO_SYSFPGA(1);
    i_req_n            <= P_IO_SYSFPGA(2);
    P_IO_SYSFPGA(3)    <= o_gnt_n;
    io_ack_n           <= P_IO_SYSFPGA(4);
    io_err_n           <= P_IO_SYSFPGA(5);
    i_alive            <= P_IO_SYSFPGA(6);
            
                                   
    P_IO_UFLASH_A(20)  <= io_as_n;
    P_IO_UFLASH_A(21)  <= io_ds_n;
    P_IO_UFLASH_A(22)  <= io_write_n;
    
    P_IO_UFLASH_A(15 downto 0)  <= o_ad(31 downto 16);
    P_IO_UFLASH_D(15 downto 0)  <= o_ad(15 downto 0);
    P_IO_UFLASH_A(19 downto 16) <= o_sel(3 downto 0);

    i_ad(31 downto 16)          <= P_IO_UFLASH_A(15 downto 0);
    i_ad(15 downto 0)           <= P_IO_UFLASH_D(15 downto 0);

    -- Dynamic signals

    proc_p_io_dynamic: process
    
      procedure proc_w32_cycle
        (
          constant I_ADDR: in std_logic_vector(31 downto 0);
          constant I_DATA: in std_logic_vector(31 downto 0)
        ) is
      begin
        wait until rising_edge(CLK66);
        
        -- strobe address
        o_cycle_n   <= '0';   -- SysFPGA master cycle
        io_write_n  <= '0';   -- write cycle
        io_as_n     <= '0';   -- address strobe
        io_ds_n     <= '1'; 
        o_ad        <= I_ADDR;
        o_sel       <= (others => '1'); -- write all four bytes
        
        wait until rising_edge(CLK66);
        
        -- strobe data
        o_cycle_n   <= '0';   -- SysFPGA master cycle
        io_write_n  <= '0';   -- write cycle
        io_as_n     <= '1';   
        io_ds_n     <= '0';   -- data strobe
        o_ad        <= I_DATA;

        wait until rising_edge(CLK66);
        
        io_ds_n     <= '1';
        o_ad        <= (others => 'Z');
        
        -- wait until io_ack_n = '0'; does not work, sincd io_ack_n goes low immediately
        wait until rising_edge(CLK66);

        o_cycle_n   <= '1';
        io_write_n  <= 'Z';
        io_as_n     <= 'Z';
        io_ds_n     <= 'Z'; 
        o_ad        <= (others => 'Z');
        o_sel       <= (others => 'Z');
        
      end proc_w32_cycle;
    
      procedure proc_w16_cycle
        (
          constant I_ADDR: in std_logic_vector(31 downto 0);
          constant I_DATA: in std_logic_vector(15 downto 0)
        ) is
      begin
        wait until rising_edge(CLK66);
        
        -- strobe address
        o_cycle_n   <= '0';   -- SysFPGA master cycle
        io_write_n  <= '0';   -- write cycle
        io_as_n     <= '0';   -- address strobe
        io_ds_n     <= '1'; 
        o_ad        <= I_ADDR;

        if (I_ADDR(1) = '0') then
          o_sel       <= "1100"; -- write upper two bytes
        else
          o_sel       <= "0011"; -- write lower two bytes
        end if;
        
        wait until rising_edge(CLK66);
        
        -- strobe data
        o_cycle_n   <= '0';   -- SysFPGA master cycle
        io_write_n  <= '0';   -- write cycle
        io_as_n     <= '1';   
        io_ds_n     <= '0';   -- data strobe
        
        if (I_ADDR(1) = '0') then
          o_ad(31 downto 16) <= I_DATA;
          o_ad(15 downto 0)  <= (others => '0');
        else
          o_ad(31 downto 16) <= (others => '0');
          o_ad(15 downto 0)  <= I_DATA;
        end if;
        
        wait until rising_edge(CLK66);
        
        io_ds_n     <= '1';
        o_ad        <= (others => 'Z');
        
        -- wait until io_ack_n = '0'; does not work, sincd io_ack_n goes low immediately
        wait until rising_edge(CLK66);

        o_cycle_n   <= '1';
        io_write_n  <= 'Z';
        io_as_n     <= 'Z';
        io_ds_n     <= 'Z'; 
        o_ad        <= (others => 'Z');
        o_sel       <= (others => 'Z');
        
      end proc_w16_cycle;

      procedure proc_read_cycle
        (
          constant I_ADDR: in std_logic_vector(31 downto 0)
        ) is
      begin
        wait until rising_edge(CLK66);
        
        -- strobe address
        o_cycle_n   <= '0';   -- SysFPGA master cycle
        io_write_n  <= '1';   -- read cycle
        io_as_n     <= '0';   -- address strobe
        io_ds_n     <= '0'; 
        o_ad        <= I_ADDR;
        o_sel       <= (others => '1'); -- read all four bytes
        
        wait until rising_edge(CLK66);
        
        -- 3state data lines ("turnaround period A")
        o_ad        <= (others => 'Z');
        o_sel       <= (others => 'Z');
        io_as_n     <= '1';
        io_ds_n     <= '1'; 
        
        wait until falling_edge(io_ack_n);
        
        -- read data
        i_data      <= i_ad;
        
        wait until rising_edge(CLK66);

        -- "turnaround period B"
                
        wait until rising_edge(CLK66);

        o_cycle_n   <= '1';
        io_write_n  <= 'Z';
        io_as_n     <= 'Z';
        io_ds_n     <= 'Z'; 
        o_ad        <= (others => 'Z');
        
        -- wait three clock cycles until slave stopeed driving io_ad
        wait until rising_edge(CLK66);
        wait until rising_edge(CLK66);
        wait until rising_edge(CLK66);
        
      end proc_read_cycle;

      procedure proc_burstread_cycle
        (
          constant I_ADDR: in std_logic_vector(31 downto 0)
        ) is
      begin
        wait until rising_edge(CLK66);
        
        -- strobe address
        o_cycle_n   <= '0';   -- SysFPGA master cycle
        io_write_n  <= '1';   -- read cycle
        io_as_n     <= '0';   -- address strobe
        io_ds_n     <= '0'; 
        o_ad        <= I_ADDR;
        o_sel       <= (others => '1'); -- read all four bytes
        
        wait until rising_edge(CLK66);
        
        -- 3state data lines ("turnaround period A")
        o_ad        <= (others => 'Z');
        o_sel       <= (others => 'Z');
        io_as_n     <= '1';
        io_ds_n     <= '0';   -- keep low for two cycles
        
        wait until rising_edge(CLK66);
        
        io_ds_n     <= '1';
        
        wait until io_ack_n = '0';
        wait until falling_edge(CLK66);
        
        -- read first data
        i_data      <= i_ad;
        
        wait until rising_edge(CLK66);
        wait until io_ack_n = '0';
        wait until falling_edge(CLK66);

        -- read second data
        i_data      <= i_ad;

        -- "turnaround period B"
                
        wait until rising_edge(CLK66);

        o_cycle_n   <= '1';
        io_write_n  <= 'Z';
        io_as_n     <= 'Z';
        io_ds_n     <= 'Z'; 
        o_ad        <= (others => 'Z');
        
        -- wait three clock cycles until slave stopeed driving io_ad
        wait until rising_edge(CLK66);
        wait until rising_edge(CLK66);
        wait until rising_edge(CLK66);
        
      end proc_burstread_cycle;

    begin
      
      -- Unused ports
      P_IO_VME_P2_A(30 downto 12) <= (others => '0');
      P_IO_VME_P2_C(28 downto  0) <= (others => '0');
      P_IO_VME_P2_D(27 downto  0) <= (others => '0');
      P_IO_VME_P2_Z(13 downto  0) <= (others => '0');
      
      -- Initialize signals
      
      P_IO_FRONTP_J8_P(1) <= '0'; -- external trigger
      P_IO_FRONTP_J8_N(1) <= '0';
      P_IO_VME_P2_A(11 downto 0) <= (others => '0');
      P_IO_PMC1_USR(41)   <= '0';
      P_IO_PMC1_USR(43)   <= '0';
      P_IO_PMC2_USR(41)   <= '0';
      P_IO_PMC2_USR(43)   <= '0';
      
      o_gnt_n             <= '1'; -- SysFPGA keeps bus mastership
      o_cycle_n           <= '1';
      io_as_n             <= 'Z';
      io_ds_n             <= 'Z';
      io_write_n          <= 'Z';
      o_ad                <= (others => 'Z');
      
      wait for 1000 ns; -- until DLLs locked

      -- Set Channel mode to 4, DMODE = 1
      proc_w32_cycle(X"0000_0015", X"0100_0004"); 

      wait for 1.5 us;
      
      -- Start Domino wave, enbale external trigger
      --proc_w32_cycle(X"0000_0000", X"0040_0001"); 

      -- Start Domino wave, enbale external trigger, multi-buffer mode
      proc_w32_cycle(X"0000_0000", X"0041_0001"); 

      -- issue trigger
      wait for 2 us;
      P_IO_FRONTP_J8_N(1)  <= '1';
      wait for 100 ns;
      P_IO_FRONTP_J8_N(1)  <= '0';
        
      wait for 10 ms;
      
      -- issue trigger
      wait for 32 us;
      P_IO_FRONTP_J8_N(1)  <= '1';
      wait for 100 ns;
      P_IO_FRONTP_J8_N(1)  <= '0';
            
      -- issue trigger
      wait for 32 us;
      P_IO_FRONTP_J8_N(1)  <= '1';
      wait for 100 ns;
      P_IO_FRONTP_J8_N(1)  <= '0';

      -- increment read pointer
      wait for 40 us;
      proc_w32_cycle(X"0000_0024", X"0000_0001"); 
      

      -- Start Domino wave delayed
      --proc_w32_cycle(X"0000_0000", X"0100_0001"); 

      -- Simulate revolving Domino wave
      --loop_domino1 : for i in 0 to 13 loop
      --  wait for 300 ns;
      --  P_IO_PMC1_USR(30)  <= '0';
      --  wait for 300 ns;
      --  P_IO_PMC1_USR(30)  <= '1';
      --end loop;

      -- Set new DAC for DRS1
      -- proc_w16_cycle(X"0000_0006", X"1234"); 

      -- Set-up write shift register
      --proc_w16_cycle(X"0000_0014", X"0555"); 

      --loop_domino2 : for i in 0 to 30 loop
      --  wait for 300 ns;
      --  P_IO_PMC1_USR(30)  <= '0';
      --  wait for 300 ns;
      --  P_IO_PMC1_USR(30)  <= '1';
      --end loop;


      --proc_w32_cycle(X"0000_0000", X"1234_5678"); 
      --proc_w32_cycle(X"0000_0000", X"0000_0000");
      
      --proc_w16_cycle(X"0000_0000", X"1234"); 
      --proc_w16_cycle(X"0000_0002", X"5678"); 
      
      --proc_w32_cycle(X"0000_0000", X"0004_0000"); -- turn on red LED 1
      --proc_w32_cycle(X"0008_0000", X"0004_0000"); -- turn on red LED 2

      --proc_read_cycle(X"0001_0024"); -- read firmware

      --proc_w32_cycle(X"0000_0000", X"0000_0002"); -- reinit
            
      -- test write and burst read
      --proc_w32_cycle(X"0000_0000", X"1111_1111");
      --proc_w32_cycle(X"0000_0004", X"2222_2222");
      --proc_burstread_cycle(X"0000_0000");
      
      -- write to DPRAM
      --proc_w32_cycle(X"0004_0000", X"1111_1111");
      --proc_w32_cycle(X"0004_0004", X"2222_2222");
      --proc_w32_cycle(X"0004_0008", X"3333_3333");
      --proc_w32_cycle(X"0004_000C", X"4444_4444");

      -- read back data
      --proc_burstread_cycle(X"0002_0000");
      --proc_burstread_cycle(X"0002_0000");
      
      wait for 100 us;
      
      -- stop simulation
      assert false
        report "Simulation Complete (this is not a failure)"
        severity failure;

    end process;
    
end TBX_ARCH;

configuration TBX_CFG_usr_fpga_TBX_ARCH of TBX_usr_fpga is
  for TBX_ARCH
  end for;
end TBX_CFG_usr_fpga_TBX_ARCH;
