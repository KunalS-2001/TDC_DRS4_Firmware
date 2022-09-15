--Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
--Date        : Tue Apr  5 01:09:49 2022
--Host        : mkpc running 64-bit major release  (build 9200)
--Command     : generate_target design_1.bd
--Design      : design_1
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1 is
  port (
    CLK : in STD_LOGIC;
    RESET : in STD_LOGIC;
    SIG : in STD_LOGIC;
    out1 : out STD_LOGIC;
    out2 : out STD_LOGIC;
    out3 : out STD_LOGIC;
    out4 : out STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of design_1 : entity is "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=17,numReposBlks=17,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=16,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of design_1 : entity is "design_1.hwdef";
end design_1;

architecture STRUCTURE of design_1 is
  component design_1_DFlipFlop_0_0 is
  port (
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC;
    CLK : in STD_LOGIC
  );
  end component design_1_DFlipFlop_0_0;
  component design_1_DFlipFlop_1_0 is
  port (
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC;
    CLK : in STD_LOGIC
  );
  end component design_1_DFlipFlop_1_0;
  component design_1_DFlipFlop_2_0 is
  port (
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC;
    CLK : in STD_LOGIC
  );
  end component design_1_DFlipFlop_2_0;
  component design_1_DFlipFlop_3_0 is
  port (
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC;
    CLK : in STD_LOGIC
  );
  end component design_1_DFlipFlop_3_0;
  component design_1_DFlipFlop_4_0 is
  port (
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC;
    CLK : in STD_LOGIC
  );
  end component design_1_DFlipFlop_4_0;
  component design_1_DFlipFlop_5_0 is
  port (
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC;
    CLK : in STD_LOGIC
  );
  end component design_1_DFlipFlop_5_0;
  component design_1_DFlipFlop_6_0 is
  port (
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC;
    CLK : in STD_LOGIC
  );
  end component design_1_DFlipFlop_6_0;
  component design_1_DFlipFlop_7_0 is
  port (
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC;
    CLK : in STD_LOGIC
  );
  end component design_1_DFlipFlop_7_0;
  component design_1_DFlipFlop_8_0 is
  port (
    CLK : in STD_LOGIC;
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC
  );
  end component design_1_DFlipFlop_8_0;
  component design_1_DFlipFlop_9_0 is
  port (
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC;
    CLK : in STD_LOGIC
  );
  end component design_1_DFlipFlop_9_0;
  component design_1_DFlipFlop_10_0 is
  port (
    CLK : in STD_LOGIC;
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC
  );
  end component design_1_DFlipFlop_10_0;
  component design_1_DFlipFlop_11_0 is
  port (
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC;
    CLK : in STD_LOGIC
  );
  end component design_1_DFlipFlop_11_0;
  component design_1_DFlipFlop_12_0 is
  port (
    CLK : in STD_LOGIC;
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC
  );
  end component design_1_DFlipFlop_12_0;
  component design_1_DFlipFlop_13_0 is
  port (
    CLK : in STD_LOGIC;
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC
  );
  end component design_1_DFlipFlop_13_0;
  component design_1_DFlipFlop_14_0 is
  port (
    CLK : in STD_LOGIC;
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC
  );
  end component design_1_DFlipFlop_14_0;
  component design_1_DFlipFlop_15_0 is
  port (
    D : in STD_LOGIC;
    Q : out STD_LOGIC;
    reset : in STD_LOGIC;
    CLK : in STD_LOGIC
  );
  end component design_1_DFlipFlop_15_0;
  component clk_wiz_0 is
  port (
    RST_IN : in STD_LOGIC;
    CLKIN_IN : in STD_LOGIC;
    CLK0_OUT : out STD_LOGIC;
    LOCKED_OUT: out STD_LOGIC;
    CLK90_OUT : out STD_LOGIC;
    CLK180_OUT: out STD_LOGIC;
    CLK270_OUT : out STD_LOGIC
  );
  end component clk_wiz_0;
  signal CLK_1 : STD_LOGIC;
  signal DFlipFlop_0_Q : STD_LOGIC;
  signal DFlipFlop_10_Q : STD_LOGIC;
  signal DFlipFlop_11_Q : STD_LOGIC;
  signal DFlipFlop_12_Q : STD_LOGIC;
  signal DFlipFlop_13_Q : STD_LOGIC;
  signal DFlipFlop_14_Q : STD_LOGIC;
  signal DFlipFlop_15_Q : STD_LOGIC;
  signal DFlipFlop_1_Q : STD_LOGIC;
  signal DFlipFlop_2_Q : STD_LOGIC;
  signal DFlipFlop_3_Q : STD_LOGIC;
  signal DFlipFlop_4_Q : STD_LOGIC;
  signal DFlipFlop_5_Q : STD_LOGIC;
  signal DFlipFlop_6_Q : STD_LOGIC;
  signal DFlipFlop_7_Q : STD_LOGIC;
  signal DFlipFlop_8_Q : STD_LOGIC;
  signal DFlipFlop_9_Q : STD_LOGIC;
  signal Net1 : STD_LOGIC;
  signal clk_wiz_here_clkOut0 : STD_LOGIC;
  signal clk_wiz_here_clkOut180 : STD_LOGIC;
  signal clk_wiz_here_clkOut90 : STD_LOGIC;
  signal clk_wiz_here_clk_out4 : STD_LOGIC;
  signal reset_0_1 : STD_LOGIC;
  signal NLW_clk_wiz_here_locked_UNCONNECTED : STD_LOGIC;
begin
  CLK_1 <= CLK;
  Net1 <= SIG;
  out1 <= DFlipFlop_12_Q;
  out2 <= DFlipFlop_13_Q;
  out3 <= DFlipFlop_14_Q;
  out4 <= DFlipFlop_15_Q;
  reset_0_1 <= RESET;
DFlipFlop_0: component design_1_DFlipFlop_0_0
     port map (
      CLK => clk_wiz_here_clkOut0,
      D => Net1,
      Q => DFlipFlop_0_Q,
      reset => reset_0_1
    );
DFlipFlop_1: component design_1_DFlipFlop_1_0
     port map (
      CLK => clk_wiz_here_clkOut90,
      D => Net1,
      Q => DFlipFlop_1_Q,
      reset => reset_0_1
    );
DFlipFlop_10: component design_1_DFlipFlop_10_0
     port map (
      CLK => clk_wiz_here_clkOut0,
      D => DFlipFlop_6_Q,
      Q => DFlipFlop_10_Q,
      reset => reset_0_1
    );
DFlipFlop_11: component design_1_DFlipFlop_11_0
     port map (
      CLK => clk_wiz_here_clkOut90,
      D => DFlipFlop_7_Q,
      Q => DFlipFlop_11_Q,
      reset => reset_0_1
    );
DFlipFlop_12: component design_1_DFlipFlop_12_0
     port map (
      CLK => clk_wiz_here_clkOut0,
      D => DFlipFlop_8_Q,
      Q => DFlipFlop_12_Q,
      reset => reset_0_1
    );
DFlipFlop_13: component design_1_DFlipFlop_13_0
     port map (
      CLK => clk_wiz_here_clkOut0,
      D => DFlipFlop_9_Q,
      Q => DFlipFlop_13_Q,
      reset => reset_0_1
    );
DFlipFlop_14: component design_1_DFlipFlop_14_0
     port map (
      CLK => clk_wiz_here_clkOut0,
      D => DFlipFlop_10_Q,
      Q => DFlipFlop_14_Q,
      reset => reset_0_1
    );
DFlipFlop_15: component design_1_DFlipFlop_15_0
     port map (
      CLK => clk_wiz_here_clkOut0,
      D => DFlipFlop_11_Q,
      Q => DFlipFlop_15_Q,
      reset => reset_0_1
    );
DFlipFlop_2: component design_1_DFlipFlop_2_0
     port map (
      CLK => clk_wiz_here_clkOut180,
      D => Net1,
      Q => DFlipFlop_2_Q,
      reset => reset_0_1
    );
DFlipFlop_3: component design_1_DFlipFlop_3_0
     port map (
      CLK => clk_wiz_here_clk_out4,
      D => Net1,
      Q => DFlipFlop_3_Q,
      reset => reset_0_1
    );
DFlipFlop_4: component design_1_DFlipFlop_4_0
     port map (
      CLK => clk_wiz_here_clkOut0,
      D => DFlipFlop_0_Q,
      Q => DFlipFlop_4_Q,
      reset => reset_0_1
    );
DFlipFlop_5: component design_1_DFlipFlop_5_0
     port map (
      CLK => clk_wiz_here_clkOut0,
      D => DFlipFlop_1_Q,
      Q => DFlipFlop_5_Q,
      reset => reset_0_1
    );
DFlipFlop_6: component design_1_DFlipFlop_6_0
     port map (
      CLK => clk_wiz_here_clkOut90,
      D => DFlipFlop_2_Q,
      Q => DFlipFlop_6_Q,
      reset => reset_0_1
    );
DFlipFlop_7: component design_1_DFlipFlop_7_0
     port map (
      CLK => clk_wiz_here_clkOut180,
      D => DFlipFlop_3_Q,
      Q => DFlipFlop_7_Q,
      reset => reset_0_1
    );
DFlipFlop_8: component design_1_DFlipFlop_8_0
     port map (
      CLK => clk_wiz_here_clkOut0,
      D => DFlipFlop_4_Q,
      Q => DFlipFlop_8_Q,
      reset => reset_0_1
    );
DFlipFlop_9: component design_1_DFlipFlop_9_0
     port map (
      CLK => clk_wiz_here_clkOut0,
      D => DFlipFlop_5_Q,
      Q => DFlipFlop_9_Q,
      reset => reset_0_1
    );
clk_wiz_here: component clk_wiz_0
     port map (
      CLKIN_IN => CLK_1,
      CLK0_OUT => clk_wiz_here_clkOut0,
      CLK90_OUT => clk_wiz_here_clkOut90,
      CLK180_OUT=> clk_wiz_here_clkOut180,
      CLK270_OUT => clk_wiz_here_clk_out4,
      LOCKED_OUT=> NLW_clk_wiz_here_locked_UNCONNECTED,
      RST_IN => reset_0_1
    );
end STRUCTURE;
