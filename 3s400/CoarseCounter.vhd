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
-- 
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

entity CoarseCounter is
Port (
        clk_CC          : in std_logic;
        start_CC        : in std_logic;
        stop_CC         : in std_logic;
        reset_CC        : in std_logic;
        Enable_CC       : in std_logic;
        Valid_CC        : out std_logic;
        CountOutCC      : out std_logic_vector(11 downto 0)
         );
end CoarseCounter;

architecture Behavioral of CoarseCounter is

----------signal declaration-----------
signal  IS_Counting : std_logic:='0';
signal  count       : std_logic_vector(11 downto 0):=(others=>'0'); 
signal  vldCC       : std_logic:='0';

---------------------------------------
begin




process (clk_CC,reset_CC,start_CC,stop_CC,Enable_CC) --,start,stop)
variable outputBits : std_logic_vector(11 downto 0);
begin
 

   if Enable_CC  = '1' then 
		  if (reset_CC = '1') then --Make signals zero
                count <= (others => '0');    
                IS_Counting  <= '0';
					 outputBits := count;
        else 
				if start_CC='1' then
						IS_Counting  <= '1';
					   vldCC<='0';
            --end if;
			   elsif stop_CC ='1' then 
					IS_Counting  <= '0';
					outputBits := count;
					vldCC<='1';
		     end if; 
				--	    end if;
			  if rising_edge (clk_CC ) and (IS_Counting  = '1')then
						count <= count + 1;
			  end if;
		  end if;
	  else 
			  outputBits := (others=>'0') ;
	  end if;   
  CountOutCC <= outputBits ; 
  Valid_CC <= vldCC;
end process;
end Behavioral;
