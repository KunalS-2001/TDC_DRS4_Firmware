----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.12.2020 13:25:49
-- Design Name: 
-- Module Name: CLK_GEN - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CLK_GEN is
port
 (-- Clock in ports
  -- Clock out ports
  clkOut0          : out    std_logic;
  clkOut90         : out    std_logic;
  clkOut180        : out    std_logic;
  clkOut270        : out    std_logic;
  -- Status and control signals
  rset             : in     std_logic;
  status           : out    std_logic;
  CLK_IN           : in     std_logic
 );
end CLK_GEN;

architecture Behavioral of CLK_GEN is

component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  clk_out2          : out    std_logic;
  clk_out3          : out    std_logic;
  clk_out4          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;
begin
FourXPhaseShifedClk : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => clkOut0,
   clk_out2 => clkOut90,
   clk_out3 => clkOut180,
   clk_out4 => clkOut270,
   
  -- Status and control signals                
   reset => rset,
   locked => status,
   -- Clock in ports
   clk_in1 => CLK_IN
 );


end Behavioral;
