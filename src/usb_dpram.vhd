--#############################################################
-- Author   : Stefan Ritt
-- Contents : Waveform memory for DRS4 board
-- $Id: usb_dpram.vhd 7194 2007-04-04 13:08:16Z ritt@PSI.CH $
--#############################################################

library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- synopsys translate_off
library UNISIM;
use UNISIM.Vcomponents.ALL;
-- synopsys translate_on
use work.drs4_pack.all;

-- ##########################################################################################

entity usb_dpram is
  port (
    
    I_RESET          : in std_logic;

    I_CLK_A          : in std_logic;
    I_ADDR_A         : in  std_logic_vector(31 downto 0);
    I_WE_A           : in  std_logic;
    O_D_RD_A         : out std_logic_vector(31 downto 0);
    I_D_WR_A         : in std_logic_vector(31 downto 0); 

    I_CLK_B          : in std_logic;
    I_ADDR_B         : in  std_logic_vector(31 downto 0);
    I_WE_B           : in  std_logic;
    O_D_RD_B         : out std_logic_vector(31 downto 0);
    I_D_WR_B         : in std_logic_vector(31 downto 0)

  );
end usb_dpram;

-- ##########################################################################################

architecture arch of usb_dpram is

  attribute BOX_TYPE : string;

  component RAMB16_S36_S36 
    port(
      DOA   : out std_logic_vector(31 downto 0);
      DOPA  : out std_logic_vector(3 downto 0);
      DOB   : out std_logic_vector(31 downto 0);
      DOPB  : out std_logic_vector(3 downto 0);
      ADDRA : in  std_logic_vector(8 downto 0);
      ADDRB : in  std_logic_vector(8 downto 0);
      CLKA  : in  std_ulogic;
      CLKB  : in  std_ulogic;
      DIA   : in  std_logic_vector(31 downto 0);
      DIPA  : in  std_logic_vector(3 downto 0);
      DIB   : in  std_logic_vector(31 downto 0);
      DIPB  : in  std_logic_vector(3 downto 0);
      ENA   : in  std_ulogic;
      ENB   : in  std_ulogic;
      SSRA  : in  std_ulogic;
      SSRB  : in  std_ulogic;
      WEA   : in  std_ulogic;
      WEB   : in  std_ulogic
    );
  end component; 

  attribute BOX_TYPE of RAMB16_S36_S36: component is "PRIMITIVE";

  signal block_we_a  : std_logic_vector(15 downto 0);
  signal block_we_b  : std_logic_vector(15 downto 0);
  
  type block_do_type is array (15 downto 0) of std_logic_vector(31 downto 0);
  signal block_do_a  : block_do_type;
  signal block_do_b  : block_do_type;
 
begin

  dpram_gen : for block_no in 0 to 15 generate
  
    block_we_a(block_no) <= I_WE_A when I_ADDR_A(14 downto 11) = block_no else '0';
    block_we_b(block_no) <= I_WE_B when I_ADDR_B(14 downto 11) = block_no else '0';
    
    ramb16_s36_s36_inst: RAMB16_S36_S36
      port map (
        CLKA  => I_CLK_A,
        ADDRA => I_ADDR_A(10 downto 2),
        ENA   => '1',
        WEA   => block_we_a(block_no),
        DIA   => I_D_WR_A,
        DIPA  => (others => '0'),
        DOA   => block_do_a(block_no),
        DOPA  => open,
        SSRA  => '0', -- output reset unused
  
        CLKB  => I_CLK_B,
        ADDRB => I_ADDR_B(10 downto 2),
        ENB   => '1',
        WEB   => block_we_b(block_no),
        DIB   => I_D_WR_B,
        DIPB  => (others => '0'),
        DOB   => block_do_b(block_no),
        DOPB  => open,
        SSRB  => '0'
      );
      
  end generate;   

  O_D_RD_A <= block_do_a(conv_integer(I_ADDR_A(14 downto 11)));
  O_D_RD_B <= block_do_b(conv_integer(I_ADDR_B(14 downto 11)));
   
end arch;
