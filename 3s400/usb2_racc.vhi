
-- VHDL Instantiation Created from source file usb2_racc.vhd -- 22:19:41 09/14/2022
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT usb2_racc
	PORT(
		I_RESET : IN std_logic;
		I_CLK33 : IN std_logic;
		TRIG1 : IN std_logic;
		TRIG2 : IN std_logic;
		TRIG3 : IN std_logic;
		TRIG4 : IN std_logic;
		I_LOCBUS_D_RD : IN std_logic_vector(31 downto 0);
		I_STATUS_REG_ARR : IN std_logic_vector(15 downto 0);    
		P_IO_UC_SLOE : INOUT std_logic;
		P_IO_UC_SLRD : INOUT std_logic;
		P_IO_UC_SLWR : INOUT std_logic;
		P_IO_UC_SLCS : INOUT std_logic;
		P_IO_UC_PKTEND : INOUT std_logic;
		P_IO_UC_FIFOADR0 : INOUT std_logic;
		P_IO_UC_FIFOADR1 : INOUT std_logic;
		P_IO_UC_FLAGA : INOUT std_logic;
		P_IO_UC_FLAGB : INOUT std_logic;
		P_IO_UC_FLAGC : INOUT std_logic;
		P_IO_UC_FD : INOUT std_logic_vector(15 downto 0);      
		O_LOCBUS_ADDR : OUT std_logic_vector(31 downto 0);
		O_LOCBUS_D_WR : OUT std_logic_vector(31 downto 0);
		O_LOCBUS_WE : OUT std_logic;
		O_CONTROL_REG_ARR : OUT std_logic_vector(15 downto 0);
		O_CONTROL_TRIG_ARR : OUT std_logic_vector(15 downto 0);
		O_CONTROL0_BIT_TRIG_ARR : OUT std_logic_vector(31 downto 0);
		O_DEBUG : OUT std_logic
		);
	END COMPONENT;

	Inst_usb2_racc: usb2_racc PORT MAP(
		I_RESET => ,
		I_CLK33 => ,
		TRIG1 => ,
		TRIG2 => ,
		TRIG3 => ,
		TRIG4 => ,
		P_IO_UC_SLOE => ,
		P_IO_UC_SLRD => ,
		P_IO_UC_SLWR => ,
		P_IO_UC_SLCS => ,
		P_IO_UC_PKTEND => ,
		P_IO_UC_FIFOADR0 => ,
		P_IO_UC_FIFOADR1 => ,
		P_IO_UC_FLAGA => ,
		P_IO_UC_FLAGB => ,
		P_IO_UC_FLAGC => ,
		P_IO_UC_FD => ,
		O_LOCBUS_ADDR => ,
		I_LOCBUS_D_RD => ,
		O_LOCBUS_D_WR => ,
		O_LOCBUS_WE => ,
		O_CONTROL_REG_ARR => ,
		I_STATUS_REG_ARR => ,
		O_CONTROL_TRIG_ARR => ,
		O_CONTROL0_BIT_TRIG_ARR => ,
		O_DEBUG => 
	);


