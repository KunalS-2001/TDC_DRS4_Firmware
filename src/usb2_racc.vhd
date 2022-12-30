--#############################################################
-- Author   : Stefan Ritt
-- Contents : Register & FIFO Access through Cy7C68013A uC
-- $Id: usb2_racc.vhd 6983 2007-03-12 09:26:06Z ritt $
--#############################################################

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.drs4_pack.all;

entity usb2_racc is
  port (
    I_RESET                 : in std_logic;
    I_CLK33                 : in std_logic;
	 
	 -- Triggers from comparators
    -- -----------------------------------
	 TRIG1 						: in std_logic; 
	 TRIG2 						: in std_logic; 
	 TRIG3 						: in std_logic; 
	 TRIG4 						: in std_logic;

		-- global trigger
		 -- -----------------------------------
		 global_trigger 			: in std_logic;	 

    -- Lines to from C8051 microcontroller
    -- -----------------------------------
    P_IO_UC_SLOE            : inout std_logic; 
    P_IO_UC_SLRD            : inout std_logic; 
    P_IO_UC_SLWR            : inout std_logic; 
    P_IO_UC_SLCS            : inout std_logic; 
    P_IO_UC_PKTEND          : inout std_logic;
    P_IO_UC_FIFOADR0        : inout std_logic;
    P_IO_UC_FIFOADR1        : inout std_logic;
    P_IO_UC_FLAGA           : inout std_logic;
    P_IO_UC_FLAGB           : inout std_logic;
    P_IO_UC_FLAGC           : inout std_logic;
    P_IO_UC_FD              : inout std_logic_vector(15 downto 0);
  
    -- Simple bus interface to on-chip RAM
    -- --------------------------------------------------
    O_LOCBUS_ADDR           : out std_logic_vector(31 downto 0);
    I_LOCBUS_D_RD           : in  std_logic_vector(31 downto 0);
    O_LOCBUS_D_WR           : out std_logic_vector(31 downto 0);
    O_LOCBUS_WE             : out std_logic;

    -- Status & control registers
    -- --------------------------
    O_CONTROL_REG_ARR       : out type_control_reg_arr;
    I_STATUS_REG_ARR        : in  type_status_reg_arr;

    O_CONTROL_TRIG_ARR      : out type_control_trig_arr;
    O_CONTROL0_BIT_TRIG_ARR : out std_logic_vector(31 downto 0);

    -- Debug signal
    -- ------------
    O_DEBUG                 : out std_logic
  );
end usb2_racc;

architecture arch of usb2_racc is

	-- Component oversamplerTDC in usb2_racc
	COMPONENT oversamplerTDC
		PORT(
			CLK_IN : IN std_logic;
--			ENABLE_IN : IN std_logic;
			START_IN : IN std_logic;
			STOP_IN : IN std_logic;
			RESET_IN : IN std_logic;          
			DATA_VALID : OUT std_logic;
			TDC_OUTPUT : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

  -- I/O pad tri-state flip-flops
  component USR_LIB_VEC_IOFD_CPE_NALL
    generic (
      width             :     integer := 1;
      init_val_to_pad   :     string  := "0";
      init_val_from_pad :     string  := "0"
      );
    port (
      O_C   : in  std_logic_vector (width-1 downto 0);
      O_CE  : in  std_logic_vector (width-1 downto 0);
      O_CLR : in  std_logic_vector (width-1 downto 0);
      O_PRE : in  std_logic_vector (width-1 downto 0);
      O     : out std_logic_vector (width-1 downto 0);

      I_C   : in std_logic_vector (width-1 downto 0);
      I_CE  : in std_logic_vector (width-1 downto 0);
      I_CLR : in std_logic_vector (width-1 downto 0);
      I_PRE : in std_logic_vector (width-1 downto 0);
      I     : in std_logic_vector (width-1 downto 0);

      IO : inout std_logic_vector (width-1 downto 0);
      T  : in    std_logic_vector (width-1 downto 0)
      );
  end component;
  
  -- TDC Signals
--  signal en : std_logic := '1'; -- tdc enable signal set to 1 always
  signal datavld : std_logic; -- data valid signal
  signal start : std_logic; -- start signal
  signal stop : std_logic; -- stop signal
  signal tdc_data : std_logic_vector(15 downto 0); -- TDC data
  signal counter_up: std_logic_vector(14 downto 0); -- 15 bit counter
  

  -- UC I/O pin control signals
  signal uc_o     : std_logic_vector(25 downto 0);  -- output FF data
  signal uc_i     : std_logic_vector(25 downto 0);  -- input FF data
  signal uc_clk_i : std_logic_vector(25 downto 0);  -- input FF clock
  signal uc_clr_i : std_logic_vector(25 downto 0);  -- input FF async clear
  signal uc_ce_i  : std_logic_vector(25 downto 0);  -- input FF clock enable
  signal uc_pre_i : std_logic_vector(25 downto 0);  -- input FF async preset
  signal uc_clk_o : std_logic_vector(25 downto 0);  -- output FF clock
  signal uc_ce_o  : std_logic_vector(25 downto 0);  -- output FF clock enable
  signal uc_clr_o : std_logic_vector(25 downto 0);  -- output FF async clear
  signal uc_pre_o : std_logic_vector(25 downto 0);  -- output FF async preset
  signal uc_ts    : std_logic_vector(25 downto 0);  -- output FF 3state

  -- internal control/status registers
  subtype type_byte_sel is integer range 0 to 3;
  subtype type_pkt_size is integer range 0 to 256;
  signal control_reg_arr       : type_control_reg_arr;
  signal status_reg_arr        : type_status_reg_arr;
  signal control_reg_no        : type_control_reg_no;
  signal status_reg_no         : type_status_reg_no;
  signal usrbus_byte_sel       : type_byte_sel;
  signal usrbus_pkt_size       : type_pkt_size;
  signal usrbus_status_sel     : std_logic;
  signal usrbus_ram_sel        : std_logic;
  signal usrbus_size           : std_logic_vector(31 downto 0);
  signal locbus_addr           : std_logic_vector(31 downto 0);

  -- microcontroller interface signals
  type type_uc_state is (idle, oe1, oe2, cmd, adr0, adr1, size0, size1,
                         write_word, read_word, read_ram,
                         read_pause1, read_pause2, read_pause3, read_pause4,
                         read_end1, read_end2, read_end3);
  type type_uc_cmd is (cmd_read, cmd_write);
  
  signal uc_state              : type_uc_state;
  signal uc_cmd                : type_uc_cmd;
  signal uc_data_i             : std_logic_vector(15 downto 0);
  signal uc_data_o             : std_logic_vector(15 downto 0);
  signal uc_pktend             : std_logic;
  signal uc_flaga              : std_logic;
  signal uc_flagb              : std_logic;
  signal uc_flagc              : std_logic;
  signal uc_fdts               : std_logic;
  signal uc_fdts_pl            : std_logic;
  signal uc_slcs               : std_logic;
  signal uc_fifoadr0           : std_logic;
  signal uc_fifoadr1           : std_logic;
  signal uc_sloe               : std_logic;
  signal uc_slrd               : std_logic;
  signal uc_slwr               : std_logic;

  signal debug                 : std_logic;

begin
	-- start signal for tdc anding trigger 1, trigger 2, trigger 4
	start <= not TRIG3; --and TRIG2 and TRIG4;
	
	-- direct stop signal from trigger 3
	stop <= global_trigger;
	
  O_CONTROL_REG_ARR       <= control_reg_arr;
  status_reg_arr          <= I_STATUS_REG_ARR;
  O_DEBUG                 <= debug;
  
 
 --- Instantiation for TDC in usb2_racc
  Inst_oversamplerTDC: oversamplerTDC PORT MAP(
		CLK_IN => I_CLK33, -- 33 Mhz clock
--		ENABLE_IN => en, -- enable signal
		START_IN => start, -- start signal
		STOP_IN => stop, -- stop signal
		RESET_IN => I_RESET, -- global reset signal
		DATA_VALID => datavld, -- data valid signal
		TDC_OUTPUT => tdc_data -- TDC data signal of 16 bits
	);
	
  uc_iofds_inst : USR_LIB_VEC_IOFD_CPE_NALL
    generic map (
      width             => 26,
      init_val_to_pad   => "1",
      init_val_from_pad => "1"
    )
    port map (
      O_C    => uc_clk_i(25 downto 0),
      O_CE   => uc_ce_i(25 downto 0),
      O_CLR  => uc_clr_i(25 downto 0),
      O_PRE  => uc_pre_i(25 downto 0),
      O      => uc_i(25 downto 0),
      I_C    => uc_clk_o(25 downto 0),
      I_CE   => uc_ce_o(25 downto 0),
      I_CLR  => uc_clr_o(25 downto 0),
      I_PRE  => uc_pre_o(25 downto 0),
      I      => uc_o(25 downto 0),
      IO(15 downto 0) => P_IO_UC_FD(15 downto 0),
      IO(16) => P_IO_UC_PKTEND,
      IO(17) => P_IO_UC_SLOE,
      IO(18) => P_IO_UC_SLRD,
      IO(19) => P_IO_UC_SLWR,
      IO(20) => P_IO_UC_SLCS,
      IO(21) => P_IO_UC_FIFOADR0,
      IO(22) => P_IO_UC_FIFOADR1,
      IO(23) => P_IO_UC_FLAGA,
      IO(24) => P_IO_UC_FLAGB,
      IO(25) => P_IO_UC_FLAGC,
      T      => uc_ts(25 downto 0)
    );
    
  -- Connection for I/O pad flipflops
  -- --------------------------------
  
  -- control signals
  uc_clk_i                <= (others => I_CLK33);   
  uc_ce_i                 <= (others => '1');
  uc_clr_i(24 downto 0)   <= (others => '0');
  uc_clr_i(25)            <= I_RESET;
  uc_pre_i(24 downto 0)   <= (others => I_RESET) ;
  uc_pre_i(25)            <= '0';
  uc_clk_o                <= (others => I_CLK33);   
  uc_ce_o                 <= (others => '1') ;
  uc_clr_o                <= (others => '0') ;
  uc_pre_o                <= (others => I_RESET) ;

  -- port direction
  uc_ts(15 downto 0)      <= (others => uc_fdts);
  uc_ts(22 downto 16)     <= (others => '0'); -- fixed output
  uc_ts(25 downto 23)     <= (others => '1'); -- fixed input

  -- FF connection
  uc_data_i               <= uc_i(15 downto 0);
  uc_flaga                <= uc_i(23);
  uc_flagb                <= uc_i(24);
  uc_flagc                <= uc_i(25);
  
  uc_o(15 downto 0)       <= uc_data_o;
  uc_o(16)                <= uc_pktend;
  uc_o(17)                <= uc_sloe;
  uc_o(18)                <= uc_slrd;
  uc_o(19)                <= uc_slwr;
  uc_o(20)                <= uc_slcs;
  uc_o(21)                <= uc_fifoadr0;
  uc_o(22)                <= uc_fifoadr1;

  debug                   <= '0';
  
--------------------------------------------------------------------------------------------------------------
------------------ process to output tdc bits to control register (no.9) -------------------------------------
------------------ valid only if datavld is high or '1' 						 -------------------------------------
--------------------------------------------------------------------------------------------------------------

  process(I_RESET, I_CLK33, datavld)
  begin
	
    if (I_RESET = '1') then

      control_reg_arr   <= (others => X"00000000");

      control_reg_no    <= 0;
      status_reg_no     <= 0;
      locbus_addr       <= (others => '0');

      usrbus_byte_sel   <= 0;
      usrbus_pkt_size   <= 0;
      usrbus_status_sel <= '0';
      usrbus_ram_sel    <= '0';
      usrbus_size       <= (others => '0');

      locbus_addr       <= (others => '0');
      O_LOCBUS_ADDR     <= (others => '0');
      O_LOCBUS_D_WR     <= (others => '0');
      O_LOCBUS_WE       <= '0';

      O_CONTROL_TRIG_ARR      <= (others => "0000");
      O_CONTROL0_BIT_TRIG_ARR <= (others => '0');
     
      -- CY7C68013 configuration
      -- -----------------------
      uc_slcs           <= '0';              -- FIFO interface always on
      uc_fifoadr0       <= '1';              -- Select EP 4
      uc_fifoadr1       <= '0';
        
      uc_fdts_pl        <= '1';              -- Tri-state data lines driven by uC
      uc_fdts           <= '1';              -- Tri-state data lines driven by uC
      
      uc_pktend         <= '1';
      uc_sloe           <= '1';
      uc_slrd           <= '1';
      uc_slwr           <= '1';

      uc_data_o         <= (others => '0');
      uc_state          <= idle;

    elsif rising_edge(I_CLK33) then
	 
	 --counter_up <= counter_up + x"1"; -- 15 bit counter
--	 if (counter_up = ''
	 --en <= control_reg_arr(9)(31);
--------------------------------------------------------------------------------------------------
-- check whether datavld is high and then write bits to the control reg no. 9 (offset 0x24) ----
--------------------------------------------------------------------------------------------------
			if (datavld = '1') then
				control_reg_arr(9)(31 downto 17) <= "111111111111111"; -- 15 bits as counter				
				control_reg_arr(9)(16) <= datavld; -- 17th bit as data valid
				control_reg_arr(9)(15 downto 0) <= tdc_data; -- TDC data bits
			end if;
--------------------------------------------------------------------------------------------------
			
      -- pipeline for syncronization with I/O-FFs
      uc_fdts          <= uc_fdts_pl;
      
      -- reset trigger signals
      O_CONTROL_TRIG_ARR      <= (others => "0000");
      O_CONTROL0_BIT_TRIG_ARR <= (others => '0');

      -- default values for RAM access
      O_LOCBUS_WE <= '0';

      -- put ram address on bus on each clock cycle
      O_LOCBUS_ADDR <= locbus_addr;
		
      -- Transfer buffers:
      --   1. buffer:
      --     fd(0)     : USB2_CMD_READ
      --     fd(1)     : USB2_CMD_WRITE
      --   2. buffer:
      --     fd(15:0)  : addreess LSB
      --   3. buffer:
      --     fd(15:0)  : addreess MSB
      --   4. buffer:
      --     fd(15:0)  : byte size LSB
      --   5. buffer:
      --     fd(15:0)  : bytes size MSB
      --
      -- Address offsets:
      --   0x00000     : CTRL
      --   0x10000     : STATUS
      --   0x20000     : FIFO
      --   0x40000     : RAM BUF1
      --   0x50000     : RAM BUF2
      -- ----------------
      case (uc_state) is

        when idle =>
          uc_fifoadr0       <= '1'; -- Select EP 4
          uc_fifoadr1       <= '0';
        
          uc_sloe           <= '1';
          uc_slrd           <= '1';
          uc_slwr           <= '1';
          uc_fdts_pl        <= '1';
          uc_pktend         <= '1';
          
          if (uc_flagc = '1') then
            uc_sloe         <= '0';
            uc_slrd         <= '0';
            uc_state        <= oe1;
          end if;
          
        -- wait until sloe signal propagates to pin and uc_data_i propagates in  
        when oe1 =>
          uc_state          <= oe2;
        when oe2 =>
          uc_state          <= cmd;
            
        when cmd =>
          if (uc_data_i(0) = '1') then
            uc_cmd <= cmd_read;
          else
            uc_cmd <= cmd_write;          
          end if;
          uc_state          <= adr0;
          
        when adr0 =>
          locbus_addr(15 downto 0)  <= uc_data_i;
          uc_state                  <= adr1;
        when adr1 =>  
          locbus_addr(31 downto 16) <= uc_data_i;
          uc_state                  <= size0;
        when size0 =>
          usrbus_size(15 downto 0)  <= uc_data_i;
          uc_state                  <= size1;
        when size1 =>  
          usrbus_size(31 downto 16) <= uc_data_i;
          
          usrbus_status_sel <= locbus_addr(16);
          usrbus_ram_sel    <= locbus_addr(18);
          usrbus_pkt_size   <= 0;
 
          if (uc_cmd = cmd_read) then
            if (locbus_addr(18) = '1') then
              uc_state      <= read_ram;
            else
              uc_state      <= read_word;
            end if;  
            uc_fifoadr0     <= '1'; -- Select EP 8
            uc_fifoadr1     <= '1';
            uc_sloe         <= '1';
            uc_slrd         <= '1';
          else
            uc_state        <= write_word;
          end if;

          usrbus_byte_sel   <= conv_integer(locbus_addr(1))*2; -- only word boundary access
          control_reg_no    <= conv_integer(locbus_addr(const_no_of_control_reg_addr_bits + 1 downto 2));
          status_reg_no     <= conv_integer(locbus_addr(const_no_of_status_reg_addr_bits + 1 downto 2));

        when read_ram =>
          -- one wait state until RAM data is available
          uc_state          <= read_word;
          locbus_addr       <= locbus_addr + "10"; -- increment 2 bytes
          
        when read_word =>
          uc_slwr           <= '0'; -- assert write line
          uc_fdts_pl        <= '0'; -- remove tri-state for FD lines

          if (usrbus_ram_sel = '0') then
            -- Register access
            if (usrbus_status_sel = '0') then
              -- Control register
              if (usrbus_byte_sel = 0) then
                uc_data_o <= control_reg_arr(control_reg_no)(15 downto 0);
              else
                uc_data_o <= control_reg_arr(control_reg_no)(31 downto 16);
              end if;  
            else
              -- Status register
              if (usrbus_byte_sel = 0) then
                uc_data_o <= status_reg_arr(status_reg_no)(15 downto 0);
              else
                uc_data_o <= status_reg_arr(status_reg_no)(31 downto 16);
              end if;
            end if;
          else
            -- RAM access
            if (locbus_addr(1) = '1') then -- locbus_addr already got incremented!
              -- first 16-bit word
              uc_data_o(15 downto 0)  <= I_LOCBUS_D_RD(15 downto 0);
            else
              -- second 16-bit word           
              uc_data_o(15 downto 0)  <= I_LOCBUS_D_RD(31 downto 16); 
            end if;  
            
          end if;

          -- auto increment register
          if (usrbus_ram_sel = '0') then
            if (usrbus_byte_sel = 0) then
              usrbus_byte_sel <= 2;
            else
              usrbus_byte_sel <= 0;
              status_reg_no   <= status_reg_no + 1;
              control_reg_no  <= control_reg_no + 1;
            end if;
          end if;
          
          -- increment packet size, pause after 256 packets
          usrbus_pkt_size     <= usrbus_pkt_size + 1;
          if (usrbus_pkt_size = 255) then
            uc_state          <= read_pause1;
          else
            if (usrbus_ram_sel = '1') then
              locbus_addr     <= locbus_addr + "10"; -- increment 2 bytes
            end if;
            usrbus_size       <= usrbus_size - 2;
          end if;

          -- finish when all words are written
          if (usrbus_size = X"00000002") then
            uc_pktend         <= '0';
            uc_state          <= read_end1;
          end if; 
          
        when read_pause1 =>
          uc_slwr             <= '1'; -- de-assert write line
          -- one wait state until flagb is available
          uc_state            <= read_pause2;
        when read_pause2 =>
          uc_state            <= read_pause3;
        when read_pause3 =>
          uc_state            <= read_pause4;
        when read_pause4 =>
          -- wait until full flag is de-asserted
          if (uc_flagb = '1') then
            uc_state          <= read_word;
            usrbus_pkt_size   <= 0;
            locbus_addr       <= locbus_addr + "10"; -- increment 2 bytes
            usrbus_size       <= usrbus_size - 2;
          end if;
          
        when read_end1 =>
          uc_fifoadr0         <= '1'; -- Select EP 4
          uc_fifoadr1         <= '0';
          uc_slwr             <= '1';
          uc_fdts_pl          <= '1';
          uc_pktend           <= '1';
          uc_state            <= read_end2;
        when read_end2 =>
          uc_state            <= read_end3;
        when read_end3 =>
          uc_state            <= idle;  
            
        when write_word =>
          if (usrbus_ram_sel = '0') then
            -- Register access
            if (usrbus_byte_sel = 0) then
              control_reg_arr(control_reg_no)(15 downto 0)  <= uc_data_i;
              O_CONTROL_TRIG_ARR(control_reg_no)(1)         <= '1';
              O_CONTROL_TRIG_ARR(control_reg_no)(0)         <= '1';
              if (control_reg_no = 0) then
                O_CONTROL0_BIT_TRIG_ARR(15 downto 0)        <= uc_data_i;
              end if;
              usrbus_byte_sel                               <= 2;
            else
              control_reg_arr(control_reg_no)(31 downto 16) <= uc_data_i;
              O_CONTROL_TRIG_ARR(control_reg_no)(3)         <= '1';
              O_CONTROL_TRIG_ARR(control_reg_no)(2)         <= '1';
              if (control_reg_no = 0) then
                O_CONTROL0_BIT_TRIG_ARR(31 downto 16)       <= uc_data_i;
              end if;
              usrbus_byte_sel                               <= 0;
              control_reg_no                                <= control_reg_no + 1;
            end if;
          else
            -- RAM access
            
            if (locbus_addr(1) = '0') then
              -- first 16-bit word
              O_LOCBUS_D_WR(15 downto 0)  <= uc_data_i;
            else
              -- second 16-bit word
              O_LOCBUS_D_WR(31 downto 16) <= uc_data_i;
              O_LOCBUS_WE                 <= '1'; -- writes require multiples of 4
            end if;  

            if (uc_flagc = '1') then
              locbus_addr <= locbus_addr + "10"; -- increment 2 bytes
            end if;  
          end if;
          
          -- continue until all words are written
          if (usrbus_size = X"00000002") then
            uc_state <= idle;
          end if;

          if (uc_flagc = '1') then
            usrbus_size      <= usrbus_size - 2;
          end if;

        when others =>
          uc_state <= idle;
          
      end case;
    end if;
  end process;

end arch;
