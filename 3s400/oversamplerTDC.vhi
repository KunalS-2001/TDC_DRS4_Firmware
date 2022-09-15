
-- VHDL Instantiation Created from source file oversamplerTDC.vhd -- 21:51:10 09/14/2022
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT oversamplerTDC
	PORT(
		CLK_IN : IN std_logic;
		ENABLE_IN : IN std_logic;
		START_IN : IN std_logic;
		STOP_IN : IN std_logic;
		RESET_IN : IN std_logic;          
		DATA_VALID : OUT std_logic;
		TDC_OUTPUT : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	Inst_oversamplerTDC: oversamplerTDC PORT MAP(
		CLK_IN => ,
		ENABLE_IN => ,
		START_IN => ,
		STOP_IN => ,
		RESET_IN => ,
		DATA_VALID => ,
		TDC_OUTPUT => 
	);


