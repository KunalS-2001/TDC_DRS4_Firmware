--##################################################################
-- Author   : Boris Keil, Stefan Ritt
-- Contents : User FPGA library with various components
-- $Id: usr_lib.vhd 6908 2007-03-06 07:15:16Z ritt $
--##################################################################

--------------------------------------------------------------------
------------------------ USR_LIB_VEC_IOFD_CPE_NALL -----------------
--------------------------------------------------------------------

-- FFs with CE & asynchr. clear (precedence, act. high), preset
-- (active high) and threestate (act. high)

library ieee;
use ieee.std_logic_1164.ALL;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.ALL;
-- synopsys translate_off
library UNISIM;
use UNISIM.Vcomponents.ALL;
-- synopsys translate_on

entity USR_LIB_VEC_IOFD_CPE_NALL is
  generic (
    width   : integer := 1;
    init_val_to_pad : string := "0";
    init_val_from_pad : string := "0"
  );
  port (
    O_C   : in  std_logic_vector (width-1 downto 0);
    O_CE  : in  std_logic_vector (width-1 downto 0);
    O_CLR : in  std_logic_vector (width-1 downto 0);
    O_PRE : in  std_logic_vector (width-1 downto 0);
    O     : out std_logic_vector (width-1 downto 0);

    I_C   : in std_logic_vector (width-1 downto 0);
    I_CE  : in std_logic_vector (width-1 downto 0);
    I_CLR : in std_logic_vector (width-1 downto 0);
    I_PRE : in std_logic_vector (width-1 downto 0);
    I     : in std_logic_vector (width-1 downto 0);

    IO : inout std_logic_vector (width-1 downto 0);
    T  : in    std_logic_vector (width-1 downto 0)
  );
end USR_LIB_VEC_IOFD_CPE_NALL;

architecture arch of USR_LIB_VEC_IOFD_CPE_NALL is
  attribute BOX_TYPE : STRING ;
  attribute INIT : STRING ;
  attribute IOB : STRING ;

  component IOBUF
    port(
      O  : out   std_logic;
      IO : inout std_logic;
      I  : in    std_logic;
      T  : in    std_logic
    );
  end component;
  attribute BOX_TYPE of IOBUF : component is "PRIMITIVE";

  component FDCPE  -- FF with CE & asynchronous clear (precedence) and preset
    generic(
      INIT : bit := '0' 
    );
    port(
      Q   : out std_logic;
      C   : in  std_logic;
      CE  : in  std_logic;
      D   : in  std_logic;
      CLR : in  std_logic;
      PRE : in  std_logic
    );
  end component;
  attribute BOX_TYPE of FDCPE : component is "PRIMITIVE";

  signal data_to_pad: std_logic_vector (width-1 downto 0);
  signal data_from_pad: std_logic_vector (width-1 downto 0);
begin
  gen : for count in 0 to width-1 generate
    attribute INIT of FF1 : label is init_val_to_pad;
    attribute IOB of FF1 : label is "true";
    attribute INIT of FF2 : label is init_val_from_pad;
    attribute IOB of FF2 : label is "true";
  begin
    U1 : IOBUF
      port map (
        I  => data_to_pad(count),
        O  => data_from_pad(count),
        IO => IO(count),
        T  => T(count)
      );
    FF1 : FDCPE
      port map (
        C   => I_C(count),
        CE  => I_CE(count),
        D   => I(count),
        CLR => I_CLR(count),
        PRE => I_PRE(count),
        Q   => data_to_pad(count)
      );
    FF2 : FDCPE
      port map (
        C   => O_C(count),
        CE  => O_CE(count),
        D   => data_from_pad(count),
        CLR => O_CLR(count),
        PRE => O_PRE(count),
        Q   => O(count)
      );
  end generate;
end arch;

--------------------------------------------------------------------
------------------------ USR_LIB_VEC_FDC ---------------------------
--------------------------------------------------------------------

-- Input FFs with asynchr. clear (precedence, act. high)

library ieee;
use ieee.std_logic_1164.ALL;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.ALL;
-- synopsys translate_off
library UNISIM;
use UNISIM.Vcomponents.ALL;
-- synopsys translate_on

entity USR_LIB_VEC_FDC is
  generic (
    width   : integer := 1
  );
  port (
    I_CLK  : in std_logic_vector (width-1 downto 0);
    I_CLR  : in std_logic_vector (width-1 downto 0);
    I      : in std_logic_vector (width-1 downto 0);
    O      : out std_logic_vector (width-1 downto 0)
  );
end USR_LIB_VEC_FDC;

architecture arch of USR_LIB_VEC_FDC is
  attribute IOB : STRING ;
  attribute BOX_TYPE : STRING ;

  component FDC  -- FF with asynchronous clear (precedence)
    generic(
      INIT : bit := '0' 
    );
    port(
      C   : in  std_logic;
      CLR : in  std_logic;
      D   : in  std_logic;
      Q   : out std_logic
    );
  end component;
  attribute BOX_TYPE of FDC : component is "PRIMITIVE";

begin
  gen : for count in 0 to width-1 generate
    attribute IOB of FF : label is "true";
  begin
    FF : FDC
      port map (
        C   => I_CLK(count),
        CLR => I_CLR(count),
        D   => I(count),
        Q   => O(count)
      );
  end generate;
end arch;
