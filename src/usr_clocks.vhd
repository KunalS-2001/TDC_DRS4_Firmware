--#############################################################
-- Author   : Boris Keil, Stefan Ritt
-- Contents : Use external 33 MHz to generate internal clocks 
--            via DCMs
-- $Id: usr_clocks.vhd 8369 2007-07-06 14:47:25Z ritt@PSI.CH $
--#############################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- synopsys translate_off
library UNISIM;
use UNISIM.Vcomponents.all;
-- synopsys translate_on

entity usr_clocks is
  port (   
    P_I_CLK33         : in std_logic;
    P_I_CLK66         : in std_logic;
    O_CLK33           : out std_logic;
    O_CLK33_NODLL     : out std_logic;
    O_CLK66           : out std_logic;
    O_CLK132          : out std_logic;
    O_CLK264          : out std_logic;
    I_PS_VALUE        : in std_logic_vector(7 downto 0);
    O_CLK_PS          : out std_logic;
    O_LOCKED          : out std_logic;
    O_DEBUG1          : out std_logic;
    O_DEBUG2          : out std_logic
  );
end usr_clocks;

architecture arch of usr_clocks is
  attribute BOX_TYPE : STRING ;

-- xilinx cores

  component IBUFGDS_LVDS_25
    port(
      O  : out std_ulogic;
      I  : in  std_ulogic;
      IB : in  std_ulogic
      );
  end component;
  attribute BOX_TYPE of IBUFGDS_LVDS_25 : component is "PRIMITIVE";

  component BUFG
    port(
      O : out std_ulogic;
      I : in  std_ulogic
      );
  end component;
  attribute BOX_TYPE of BUFG : component is "PRIMITIVE";

  -- !!! WARNING !!! : The Virtex2Pro has a bug in the DCM
  -- (a silicon bug, i.e. real hardware), the PLL does not
  -- lock properly if the CLK2x output is used for
  -- feedback -> always use CLK1x !!! (Call from Memec,
  -- C. Grivet, 17.12.03)

  component DCM
    generic (
      CLKDV_DIVIDE            : real    := 2.0;
      CLKFX_DIVIDE            : integer := 1;
      CLKFX_MULTIPLY          : integer := 4;
      CLKIN_DIVIDE_BY_2       : boolean := false;
      CLKIN_PERIOD            : real    := 0.0;  --non-simulatable, in nanoseconds
      CLKOUT_PHASE_SHIFT      : string  := "NONE";
      CLK_FEEDBACK            : string  := "1X";
      DESKEW_ADJUST           : string  := "SYSTEM_SYNCHRONOUS";  --non-simulatable
      DFS_FREQUENCY_MODE      : string  := "LOW";
      DLL_FREQUENCY_MODE      : string  := "LOW";
      DSS_MODE                : string  := "NONE";  --non-simulatable
      DUTY_CYCLE_CORRECTION   : boolean := true;
      -- MAXPERCLKIN             : time    := 1000000 ps;  --simulation parameter
      -- MAXPERPSCLK             : time    := 100000000 ps;  --simulation parameter
      PHASE_SHIFT             : integer := 0;
      -- SIM_CLKIN_CYCLE_JITTER  : time    := 300 ps;  --simulation parameter
      -- SIM_CLKIN_PERIOD_JITTER : time    := 1000 ps;  --simulation parameter
      STARTUP_WAIT            : boolean := false  --non-simulatable
      );
    port (
      CLK0     : out std_ulogic                   := '0';
      CLK180   : out std_ulogic                   := '0';
      CLK270   : out std_ulogic                   := '0';
      CLK2X    : out std_ulogic                   := '0';
      CLK2X180 : out std_ulogic                   := '0';
      CLK90    : out std_ulogic                   := '0';
      CLKDV    : out std_ulogic                   := '0';
      CLKFX    : out std_ulogic                   := '0';
      CLKFX180 : out std_ulogic                   := '0';
      LOCKED   : out std_ulogic                   := '0';
      PSDONE   : out std_ulogic                   := '0';
      STATUS   : out std_logic_vector(7 downto 0) := "00000000";

      CLKFB    : in std_ulogic := '0';
      CLKIN    : in std_ulogic := '0';
      DSSEN    : in std_ulogic := '0';
      PSCLK    : in std_ulogic := '0';
      PSEN     : in std_ulogic := '0';
      PSINCDEC : in std_ulogic := '0';
      RST      : in std_ulogic := '0'
    );
  end component;
  attribute BOX_TYPE of DCM : component is "PRIMITIVE";

  signal clk33_i, clk33, clk66_dcm1, clk66_dcm2, clk132, clk_ps : std_logic;
  signal clk33_tmp, clk66_dcm1_tmp, clk66_dcm2_tmp, clk132_tmp, clk_ps_tmp : std_logic;
  signal locked_dcm1, locked_dcm2, locked_dcm3: std_logic;
  signal dcm2_reset, dcm2_reset_n: std_logic;
  signal dcm2_reset_delay_n: std_logic_vector(4 downto 0);

  type type_ps_state is (idle, incdec);
  signal ps_state : type_ps_state;
  signal ps_enable, ps_incdec, ps_done: std_logic;
  signal ps_shadow: std_logic_vector(7 downto 0);

  signal GND: std_logic;
  signal VCC: std_logic;

begin
  GND <= '0';
  VCC <= '1';

  -- Drive clock buffer with input pad oscillator signal

  inst_bufg_clk33_i: BUFG
    port map (
      I => P_I_CLK33,
      O => clk33_i
    );

  O_CLK33_NODLL <= clk33_i;
  
  -- Use clock buffers for DCM outputs
  
  inst_bufg_clk33_dcm1: BUFG
    port map (
      I => clk33_tmp,
      O => clk33
    );
  
  inst_bufg_clk66_dcm1: BUFG
    port map (
      I => clk66_dcm1_tmp,
      O => clk66_dcm1
    );
  
  inst_bufg_clk66_dcm2: BUFG
    port map (
      I => clk66_dcm2_tmp,
      O => clk66_dcm2
    );
  
  inst_bufg_clk132: BUFG
    port map (
      I => clk132_tmp,
      O => clk132
    );
  
  inst_bufg_clk_ps: BUFG
    port map (
      I => clk_ps_tmp,
      O => clk_ps
    );

  Inst_dcm1_clk132: DCM
    generic map (
      CLKDV_DIVIDE            => 2.0,
      CLKFX_DIVIDE            => 1,
      CLKFX_MULTIPLY          => 4,
      CLKIN_DIVIDE_BY_2       => false,
      CLKIN_PERIOD            =>  30.0,                -- in nanoseconds
      CLKOUT_PHASE_SHIFT      => "NONE",
      CLK_FEEDBACK            => "1X",                 -- 2X has a silicon bug ...
      DESKEW_ADJUST           => "SYSTEM_SYNCHRONOUS", -- OK ?? non-simulatable
      DFS_FREQUENCY_MODE      => "LOW",
      DLL_FREQUENCY_MODE      => "LOW",
      DSS_MODE                => "NONE",               --non-simulatable
      DUTY_CYCLE_CORRECTION   => true,
      -- MAXPERCLKIN             => 1000000 ps,           --simulation parameter
      -- MAXPERPSCLK             => 100000000 ps,         --simulation parameter
      PHASE_SHIFT             => 0,
      -- SIM_CLKIN_CYCLE_JITTER  => 300 ps,               --simulation parameter
      -- SIM_CLKIN_PERIOD_JITTER => 1000 ps,              --simulation parameter
      STARTUP_WAIT            => true                  --non-simulatable
      )
    port map (
      -- inputs
      CLKFB    => clk33,
      CLKIN    => clk33_i,
      DSSEN    => GND,
      PSCLK    => GND,
      PSEN     => GND,
      PSINCDEC => GND,
      RST      => GND,
      -- outputs
      CLK0     => clk33_tmp,
      CLK180   => open,
      CLK270   => open,
      CLK2X    => clk66_dcm1_tmp,
      CLK2X180 => open,
      CLK90    => open,
      CLKDV    => open,
      CLKFX    => open,
      CLKFX180 => open,
      LOCKED   => locked_dcm1,
      PSDONE   => open,
      STATUS   => open

    );

  Inst_dcm2_clk132: DCM
    generic map (
      CLKDV_DIVIDE            => 2.0,
      CLKFX_DIVIDE            => 1,
      CLKFX_MULTIPLY          => 2,
      CLKIN_DIVIDE_BY_2       => false,
      CLKIN_PERIOD            => 15.0,                 -- in nanoseconds
      CLKOUT_PHASE_SHIFT      => "NONE",
      CLK_FEEDBACK            => "1X",                 -- 2X has a silicon bug ...
      DESKEW_ADJUST           => "SYSTEM_SYNCHRONOUS", -- OK ?? non-simulatable
      DFS_FREQUENCY_MODE      => "LOW",
      DLL_FREQUENCY_MODE      => "HIGH",
      DSS_MODE                => "NONE",               --non-simulatable
      DUTY_CYCLE_CORRECTION   => true,
      -- MAXPERCLKIN             => 1000000 ps,           --simulation parameter
      -- MAXPERPSCLK             => 100000000 ps,         --simulation parameter
      PHASE_SHIFT             => 0,
      -- SIM_CLKIN_CYCLE_JITTER  => 300 ps,               --simulation parameter
      -- SIM_CLKIN_PERIOD_JITTER => 1000 ps,              --simulation parameter
      STARTUP_WAIT            => false                 --non-simulatable
      )
    port map (
      -- inputs
      CLKFB    => clk66_dcm2,
      CLKIN    => P_I_CLK66,
      DSSEN    => GND,
      PSCLK    => GND,
      PSEN     => GND,
      PSINCDEC => GND,
      RST      => dcm2_reset,
      -- outputs
      CLK0     => clk66_dcm2_tmp,
      CLK180   => open,
      CLK270   => open,
      CLK2X    => open,
      CLK2X180 => open,
      CLK90    => open,
      CLKDV    => open,
      CLKFX    => clk132_tmp,
      CLKFX180 => open,
      LOCKED   => locked_dcm2,
      PSDONE   => open,
      STATUS   => open

    );

  Inst_dcm3_clk_ps: DCM
    generic map (
      CLKDV_DIVIDE            => 2.0,
      CLKFX_DIVIDE            => 1,
      CLKFX_MULTIPLY          => 2,
      CLKIN_DIVIDE_BY_2       => false,
      CLKIN_PERIOD            =>  30.0,                -- in nanoseconds
      CLKOUT_PHASE_SHIFT      => "VARIABLE",           -- turn on phase shifting
      CLK_FEEDBACK            => "1X",
      DESKEW_ADJUST           => "SYSTEM_SYNCHRONOUS",
      DFS_FREQUENCY_MODE      => "LOW",
      DLL_FREQUENCY_MODE      => "LOW",
      DSS_MODE                => "NONE",
      DUTY_CYCLE_CORRECTION   => true,
      PHASE_SHIFT             => 0,
      STARTUP_WAIT            => true
      )
    port map (
      -- inputs
      CLKFB    => clk_ps,
      CLKIN    => clk33_i,
      DSSEN    => GND,
      PSCLK    => P_I_CLK33,
      PSEN     => ps_enable,
      PSINCDEC => ps_incdec,
      RST      => GND,
      -- outputs
      CLK0     => clk_ps_tmp,
      CLK180   => open,
      CLK270   => open,
      CLK2X    => open,
      CLK2X180 => open,
      CLK90    => open,
      CLKDV    => open,
      CLKFX    => open,
      CLKFX180 => open,
      LOCKED   => locked_dcm3,
      PSDONE   => ps_done,
      STATUS   => open

    );

  -- DCM2 is reset while DCM1 is not locked, because DCM1 feeds DCM2.
  -- A shift register guarantees a decent (i.e. long) reset pulse.
  proc_delayed_reset: process (P_I_CLK33)
  begin
    if rising_edge(P_I_CLK33) then
      if (locked_dcm1 = '0') then
        dcm2_reset_delay_n     <= (others => '0');
        dcm2_reset_n           <= '0';
      else
        dcm2_reset_delay_n     <= dcm2_reset_delay_n(dcm2_reset_delay_n'high-1 downto 0) & '1';
        dcm2_reset_n           <= dcm2_reset_delay_n(dcm2_reset_delay_n'high);
        dcm2_reset             <= not dcm2_reset_n;
      end if;
    end if;
  end process;
  
  proc_phase_shift: process (P_I_CLK33)
  begin
    if (locked_dcm1 = '0') then
      ps_state                 <= idle;
      ps_enable                <= '0';
      ps_shadow                <= (others => '0');
    elsif rising_edge(P_I_CLK33) then
      case (ps_state) is
        when idle =>
          if (TO_SIGNED(CONV_INTEGER(I_PS_VALUE), 8) > TO_SIGNED(CONV_INTEGER(ps_shadow), 8)) then
            ps_enable          <= '1';
            ps_incdec          <= '1';
            ps_state           <= incdec;
            ps_shadow          <= ps_shadow + 1;
          elsif (TO_SIGNED(CONV_INTEGER(I_PS_VALUE), 8) < TO_SIGNED(CONV_INTEGER(ps_shadow), 8)) then
            ps_enable          <= '1';
            ps_incdec          <= '0';
            ps_state           <= incdec;
            ps_shadow          <= ps_shadow - 1;
          end if;  
        when incdec =>
          ps_enable            <= '0';
          if (ps_done = '1') then
            ps_state           <= idle;
          end if;
      end case;
    end if;
  end process;

  -- Debug outputs
  O_DEBUG1     <= clk66_dcm1;
  O_DEBUG2     <= clk132;
  
  -- DCM outputs
  O_CLK33      <= clk33;
  O_CLK66      <= clk66_dcm1;
  O_CLK132     <= clk132;
  O_CLK264     <= '0';
  O_CLK_PS     <= clk_ps;
  O_LOCKED     <= locked_dcm1 and locked_dcm3;
end arch;
