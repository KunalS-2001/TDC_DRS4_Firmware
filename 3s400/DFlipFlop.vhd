----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.12.2020 12:37:28
-- Design Name: 
-- Module Name: DFlipFlop - Behavioral
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

entity DFlipFlop is
 Port ( D : in STD_LOGIC := '0';
        Q : out STD_LOGIC ;
        reset : in STD_LOGIC :='0';
        CLK : in STD_LOGIC 
       );
end DFlipFlop;

architecture Behavioral of DFlipFlop is
begin
flipflopLoop : process (CLK,reset) begin
                    if reset='1' then
                        Q <= '0';
                    elsif rising_edge(CLK) then
                        Q <= D;
                    end if;
               end process;  
               
               
end Behavioral;
