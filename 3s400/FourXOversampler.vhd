----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2020 11:17:04
-- Design Name: 
-- Module Name: FourXOversampler - Behavioral
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
--use IEEE.numeric_std_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FourXOversampler is
    Port ( 
           CLK_4x : in STD_LOGIC;
           SIG_4x : in STD_LOGIC;
           RESET_4x : in STD_LOGIC;
           ENABLE_4x : inout std_logic; 
           DATA_READY_4x : out STD_LOGIC:='0';
           OUTPUT_4x : out std_logic_vector(3 downto 0)
           );
           
end FourXOversampler;

architecture Behavioral of FourXOversampler is

component design_1 is
--  generic (
--        clkF : integer := 1000000   ;  --clock freq in kHz
--        pulseWidth : integer := 40 ;  --pulse width in ns 
--        PulseCount: integer := 1  ; --pulse width in ns
--        offset: integer := 0 
--    );


    Port (         
        SIG : in STD_LOGIC;
        CLK : in STD_LOGIC;
        out1: out STD_LOGIC; 
        out2 : out STD_LOGIC; 
        out3 : out STD_LOGIC; 
        out4 : out STD_LOGIC; 
       RESET : in STD_LOGIC
       );
end component;

signal overSamplerOuts : std_logic_vector(3 downto 0) := "0000";
signal counterToDataReady : std_logic_vector(3 downto 0) := "0000"; 
signal IS_COUNTING : std_logic := '0';
signal outputBits : std_logic_vector(3 downto 0);
--signal clk : std_logic := '0';
--signal sig : std_logic := '0';

begin

fourXOverSampler : design_1
   port map (
        SIG => SIG_4x ,
        CLK  => CLK_4x ,
        out1 => outputBits(0),
        out2 => outputBits(1),
        out3 => outputBits(2),
        out4 => outputBits(3),
       RESET => RESET_4x
   );

process (SIG_4x, RESET_4x, CLK_4x,Enable_4x)
    variable outputBits : std_logic_vector(3 downto 0);
begin 

    if Enable_4x  = '1' then 
        if RESET_4x = '1' then
            DATA_READY_4x <= '0';
        end if;    
        
      --  if rising_edge(SIG_4x) then TODO
        if SIG_4x = '1' then
            DATA_READY_4x <= '0';
            IS_COUNTING  <= '1';
				counterToDataReady <= counterToDataReady + x"1";
				outputBits:= overSamplerOuts(3 downto 0);
					 
				end if;
				 --
        --end if;
        
        if IS_COUNTING = '1' then
               if (counterToDataReady = "0011") then
                    DATA_READY_4x <= '1';
                    OUTPUT_4x  <= outputBits;
                    counterToDataReady <= "0000";
                end if;
                
          end if;
     else 
        outputBits := "0000";
     end if;    
       OUTPUT_4x  <= outputBits;
    
        
end process;
           
end Behavioral;


