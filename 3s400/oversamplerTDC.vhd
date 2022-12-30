----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2020 11:17:04
-- Design Name: 
-- Module Name: oversamplerTDC - Behavioral
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

entity oversamplerTDC is
    Port ( 
           CLK_IN : in STD_LOGIC;
--           ENABLE_IN : inout STD_LOGIC;
           START_IN : in STD_LOGIC;
           STOP_IN : in STD_LOGIC;
           RESET_IN : in STD_LOGIC;
           DATA_VALID : out STD_LOGIC;
           TDC_OUTPUT : out std_logic_vector(15 downto 0)
--           TDC_DBG : out std_logic_vector(15 downto 0)
           );
end oversamplerTDC;

architecture Behavioral of oversamplerTDC is

--component FourXOversampler is
--    Port ( 
--           CLK_4x : in STD_LOGIC;
--           SIG_4x : in STD_LOGIC;
--           RESET_4x : in STD_LOGIC;
--           ENABLE_4x : in std_logic; 
--           DATA_READY_4x : out STD_LOGIC:='0';
--           OUTPUT_4x : out std_logic_vector(3 downto 0)
--           );
--end component;

component CoarseCounter is
Port (
        clk_CC             : in std_logic;
        start_CC           : in std_logic;
        stop_CC           : in std_logic;
        reset_CC           : in std_logic;
--        Enable_CC       : in std_logic;
        Valid_CC        : out std_logic;
        CountOutCC      : out std_logic_vector(11 downto 0)
         );
end component;

--component monoshot is
--     generic 
--    ( 
--        clkF : integer := 1000000   ;  --clock freq in kHz
--        pulseWidth : integer := 40 ;  --pulse width in ns 
--        PulseCount: integer := 1  ; --pulse width in ns
--        offset: integer := 0 
--    );
--    Port ( clk : in STD_LOGIC;
--           trig : in STD_LOGIC;
--           pulseOut : out STD_LOGIC:='0');
--end component;

signal overSamplerAVals : std_logic_vector(3 downto 0) := "0000";
signal overSamplerBVals : std_logic_vector(3 downto 0) := "0000";
--signal CCVals : std_logic_vector(3 downto 0) := "0000";
signal clk : std_logic:='0';
signal dataReadyCC : std_logic:='0';
signal dataReadyF1 : std_logic:='0';
signal dataReadyF2 : std_logic:='0';
signal dataVld : std_logic:='0';
signal tdcOut : std_logic_vector(15 downto 0) := "0000000000000000";

begin

TDC_OUTPUT <= tdcOut;

clk<=CLK_IN;
dataVld <= dataReadyCC; --and dataReadyF1 and dataReadyF2 ;
coraseCounter : CoarseCounter
port map (
        clk_CC       => CLK_IN,
        start_CC     => START_IN,
        stop_CC      => STOP_IN,
        reset_CC     => RESET_IN,
--        Enable_CC     => ENABLE_IN,
        Valid_CC       => dataReadyCC,
        CountOutCC => tdcOut(15 downto 4)
         );
         
--overSamplerA : FourXOversampler
--    port map ( 
--           CLK_4x => CLK_IN,
--           SIG_4x => START_IN,
--           RESET_4x =>  RESET_IN,
--           OUTPUT_4x => overSamplerAVals,
--           ENABLE_4x => ENABLE_IN , 
--           DATA_READY_4x => dataReadyF1 
--           );
--           
--overSamplerB : FourXOversampler
--    port map ( 
--           CLK_4x     =>  CLK_IN,
--           SIG_4x     =>  STOP_IN,
--           RESET_4x   =>  RESET_IN,
--           OUTPUT_4x  =>  overSamplerBVals,
--           ENABLE_4x => ENABLE_IN , 
--           DATA_READY_4x => dataReadyF2 
--           );

   
--process (dataVld)
--begin
--    if rising_edge(dataVld) then
--        
--        TDC_DBG(15 downto 0) <= (others=>'0');
--        
--        if overSamplerAVals = "0111" then
--            tdcOut(3 downto 2) <= "00";
--        elsif overSamplerAVals = "0011" then
--            tdcOut(3 downto 2) <= "01";
--        elsif overSamplerAVals = "0001" then
--            tdcOut(3 downto 2)<="10";
--        elsif overSamplerAVals = "0000" then
--            tdcOut(3 downto 2) <= "11";
--        else 
--            tdcOut(3 downto 2) <= "00";
--            TDC_DBG(0) <= '1';
--        end if;
--        
--        if overSamplerBVals = "0111" then
--            tdcOut(1 downto 0)<="00";
--        elsif overSamplerBVals = "0011" then
--            tdcOut(1 downto 0)<="01";
--        elsif overSamplerBVals = "0001" then
--            tdcOut(1 downto 0)<="10";
--        elsif overSamplerBVals = "0000" then
--            tdcOut(1 downto 0)<="11";
--        else 
--            tdcOut(1 downto 0)<="00";
--            TDC_DBG(1) <= '1';
--        end if;
--        
--    end if;
--        
--end process;
DATA_VALID  <= dataVld;     
end Behavioral;




