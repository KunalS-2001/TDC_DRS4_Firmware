----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.09.2020 18:10:34
-- Design Name: 
-- Module Name: CoarseCounter - Behavioral
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
--  For stop pulse 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.numeric_std_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FineCounter2 is
Port (
        clk         : in std_logic;
        start       : in std_logic;
        stop        : in std_logic;
        reset       : in std_logic;
        counter_enable2: out std_logic;
        CountOutFC  : out std_logic_vector(11 downto 0)
         );
end FineCounter2;

architecture Behavioral of FineCounter2 is

----------signal declaration-----------
signal Counter_enable : std_logic:='0';

signal count          : std_logic_vector(11 downto 0):=(others=>'0'); 

---------------------------------------
begin




process (clk,reset,Counter_enable,count) --,start,stop)
begin
 

   
   if (stop ='0' and start='0') then
        Counter_enable <= '0';
   elsif (start ='0' and stop ='1') then 
        Counter_enable <= '0';
   elsif (start ='1' and stop ='0') then
        Counter_enable <= '1';
    else
        Counter_enable <= '0';    --both 1
   end if;    
    
    
    if (reset='1') then --Make signals zero
                count<=(others=>'0');    
                Counter_enable<='0';
    elsif rising_edge (clk) then
       if (counter_enable='1') then
               count<=count+1;
       end if;
    end if;
    
    CountOutFC<=count;
    counter_enable2 <= counter_enable;
end process;
end Behavioral;
