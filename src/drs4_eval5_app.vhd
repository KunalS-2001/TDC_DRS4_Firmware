--*************************************************************
-- Author   : Boris Keil, Stefan Ritt
-- Contents : Main file for DRS4 control and readout
-- $Id: drs4_eval5_app.vhd 21844 2015-10-14 12:19:42Z ritt $
-- $Revision: 15159 $
--*************************************************************

library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- synopsys translate_off
library UNISIM;
use UNISIM.Vcomponents.ALL;
-- synopsys translate_on
use work.drs4_pack.all;

entity drs4_eval5_app is
  port (
    -- clocks
    I_CLK33                 : in std_logic;
    I_CLK66                 : in std_logic;
    I_CLK132                : in std_logic;
    I_CLK264                : in std_logic;
    O_CLK_PS_VALUE          : out std_logic_vector(7 downto 0);
    I_CLK_PS                : in std_logic;
    I_RESET                 : in std_logic; -- active high power-up reset

    -- calibration
    O_CAL                   : out std_logic;
    O_TCA_CTRL              : out std_logic;

    -- analog triggers
    I_ANA_TRG               : in std_logic_vector(3 downto 0);
    
    -- external trigger
    IO_ETRG_IN              : inout std_logic;
    O_ETRG_IND              : out std_logic;

    IO_ETRG_OUT             : inout std_logic;
    O_ETRG_OUTD             : out std_logic;

    -- external (MMCX clock) clock
    IO_ECLK_OUT             : inout std_logic;
    IO_ECLK_IN              : inout std_logic;

    -- J44 pin configuration
    I_CONFIG_PIN            : in std_logic;

    -- PMC
    P_IO_PMC_USR            : inout std_logic_vector(63 downto 0);

    -- Simple bus interface to DPRAM
    O_DPRAM_CLK             : out std_logic;
    O_DPRAM_ADDR            : out std_logic_vector(31 downto 0);
    O_DPRAM_D_WR            : out std_logic_vector(31 downto 0);
    O_DPRAM_WE              : out std_logic;
    I_DPRAM_D_RD            : in std_logic_vector(31 downto 0);

    -- Control & status registers from system FPGA interface
    I_CONTROL_REG_ARR       : in  type_control_reg_arr;
    O_STATUS_REG_ARR        : out type_status_reg_arr;
    I_CONTROL_TRIG_ARR      : in  type_control_trig_arr;
    I_CONTROL0_BIT_TRIG_ARR : in  std_logic_vector(31 downto 0);

    -- LEDs signals
    O_LED_GREEN             : out std_logic;
    O_LED_YELLOW            : out std_logic;
    
    -- Debug signals
    O_DEBUG1                : out std_logic;
    O_DEBUG2                : out std_logic
  );
end drs4_eval5_app;

--*************************************************************

architecture arch of drs4_eval5_app is

  attribute BOX_TYPE : string;

  component USR_LIB_VEC_FDC
    generic (
      width :     integer := 1
      );
    port (
      I_CLK  : in std_logic_vector (width-1 downto 0);
      I_CLR  : in std_logic_vector (width-1 downto 0);
      I      : in std_logic_vector (width-1 downto 0);
      O      : out std_logic_vector (width-1 downto 0)
      );
  end component;

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

  component OFDDRTCPE
    port (
      O : out STD_ULOGIC;
      C0 : in STD_ULOGIC;
      C1 : in STD_ULOGIC;
      CE : in STD_ULOGIC;
      CLR : in STD_ULOGIC;
      D0 : in STD_ULOGIC;
      D1 : in STD_ULOGIC;
      PRE : in STD_ULOGIC;
      T : in STD_ULOGIC
    );
  end component;
  attribute BOX_TYPE of OFDDRTCPE : component is "PRIMITIVE";

  component IOBUFDS
    port (
      O : out STD_ULOGIC;
      IO : inout STD_ULOGIC;
      IOB : inout STD_ULOGIC;
      I : in STD_ULOGIC;
      T : in STD_ULOGIC
    );
  end component;
  
  component LUT1
    generic (
      INIT : bit_vector
    );
    port(
      O : out STD_ULOGIC;
      I0 : in STD_ULOGIC
    );
  end component;  
  
  signal GND  : std_logic;
  signal VCC  : std_logic;

  -- ADC
  signal i_drs_adc               : std_logic_vector(13 downto 0);
  signal o_drs_adc_clk           : std_logic;
  signal adc_clk_sr              : std_logic_vector(15 downto 0);
  -- Serial interface for DAC, EEPROM and Temp. Sensor
  signal o_drs_serial_data       : std_logic;
  signal o_drs_serial_clk        : std_logic;
  signal i_drs_serial_data       : std_logic;
  signal i_drs_eeprom_data       : std_logic;
  signal o_drs_dac_cs_n          : std_logic;
  signal o_drs_eeprom_cs_n       : std_logic;
  signal o_drs_tempsens_cs_n     : std_logic;
  -- Status LED
  signal drs_led_green           : std_logic;
  signal drs_led_trigger         : std_logic;
  signal drs_led_counter         : std_logic_vector(20 downto 0);
  type type_drs_led_state is (led_idle, led_on, led_off);
  signal drs_led_state           : type_drs_led_state;
  -- DRS Start/enable
  signal o_drs_enable            : std_logic;
  signal o_drs_write             : std_logic;
  -- Internal DRS shift registers
  signal o_drs_srin              : std_logic;
  signal o_drs_srclk             : std_logic;
  signal o_drs_rsrload           : std_logic;
  signal i_drs_srout             : std_logic;
  signal i_drs_wsrout            : std_logic;
  subtype type_sr_count is integer range 0 to 1024;
  signal drs_sr_count            : type_sr_count;
  signal drs_sr_reg              : std_logic_vector(7 downto 0);
  -- DRS address
  signal o_drs_addr              : std_logic_vector(3 downto 0);
  -- PLL refence clock signal
  signal drs_refclk              : std_logic;
  signal o_drs_refclk            : std_logic;
  signal drs_refclk_counter      : std_logic_vector(16 downto 0);
  signal i_drs_plllck            : std_logic;
  signal i_drs_dtap              : std_logic;
  -- 132/264 MHz calibration signal output
  signal o_drs_tcalib_sig        : std_logic;
  -- power signal for chip test board
  signal o_drs_on                : std_logic;
  -- config pin
  signal i_cfg_pin               : std_logic;
  
  -- Control registers
  signal drs_ctl_start_trig      : std_logic;
  signal drs_ctl_reinit_trig     : std_logic;  -- 1 sets drs_reinit_reqest to '1'
  signal drs_ctl_soft_trig       : std_logic;
  signal drs_ctl_eeprom_write_trig: std_logic;
  signal drs_ctl_eeprom_read_trig: std_logic;
  signal drs_ctl_autostart       : std_logic;
  signal drs_ctl_dmode           : std_logic;
  signal drs_ctl_dactive         : std_logic;
  signal drs_ctl_adc_active      : std_logic;
  signal drs_ctl_acalib          : std_logic;
  signal drs_ctl_led_yellow      : std_logic;
  signal drs_ctl_tca_ctrl        : std_logic;
  signal drs_ctl_refclk_source   : std_logic;
  type type_drs_dac_val_arr is array (7 downto 0) of std_logic_vector(15 downto 0);
  signal drs_ctl_dac_arr         : type_drs_dac_val_arr;
  signal drs_ctl_first_chn       : std_logic_vector(3 downto 0);
  signal drs_ctl_last_chn        : std_logic_vector(3 downto 0);
  signal drs_ctl_config          : std_logic_vector(7 downto 0);
  signal drs_ctl_chn_config      : std_logic_vector(7 downto 0);
  signal drs_ctl_sampling_freq   : std_logic_vector(15 downto 0);
  signal drs_ctl_transp_mode     : std_logic;
  signal drs_ctl_standby_mode    : std_logic;
  signal drs_ctl_enable_trigger  : std_logic;
  signal drs_ctl_trigger_config  : std_logic_vector(15 downto 0);
  signal drs_ctl_neg_trigger     : std_logic;
  signal drs_ctl_readout_mode    : std_logic;
  signal drs_ctl_delay_sel       : std_logic_vector(7 downto 0);
  signal drs_ctl_trigger_transp  : std_logic;
  signal drs_ctl_readout_delay   : std_logic_vector(31 downto 0);

  -- Status registers
  signal drs_stat_busy           : std_logic;
  signal drs_eeprom_busy         : std_logic;
  signal drs_stat_stop_cell      : std_logic_vector(9 downto 0);
  signal drs_stat_stop_wsr       : std_logic_vector(7 downto 0);
  signal drs_temperature         : std_logic_vector(15 downto 0);
  signal drs_trigger_bus         : std_logic_vector(15 downto 0);
  signal drs_serial_number       : std_logic_vector(15 downto 0);
  signal svn_revision            : std_logic_vector(15 downto 0);

  -- Misc. internal signals
  signal drs_reinit_request      : std_logic;
  signal drs_old_readout_mode    : std_logic;

  -- Trigger signals
  signal drs_trigger             : std_logic;
  signal drs_soft_trig           : std_logic;
  signal drs_trigger_syn         : std_logic;
  signal drs_write_set           : std_logic;
  signal drs_trig_ff             : std_logic;
  signal drs_write_ff            : std_logic;
  signal drs_hard_inp            : std_logic_vector(4 downto 0);
  signal drs_hard_or             : std_logic;
  signal drs_hard_and            : std_logic;
  signal drs_hard_trig           : std_logic;
  signal drs_global_trig         : std_logic;
  signal drs_trig_ff_reset       : std_logic;
  signal drs_trg_delay           : std_logic_vector(2047 downto 0);
  -- Tell P&R to not optimize away the drs_trg_delay array
  attribute keep : string;
  attribute keep of drs_trg_delay : signal is "true";

  -- Serial bus internal signals
  type type_serial_bus_state is (idle, wait_serdes, eeprom_read, eeprom_write, done);
  signal serial_bus_state        : type_serial_bus_state;
  subtype type_serial_count is integer range 0 to 200;
  signal serial_count            : type_serial_count;
  signal serial_ret_addr         : type_serial_count;
  signal serial_start_flag1      : std_logic;
  signal serial_start_flag2      : std_logic;

  type type_serdes_state is (idle, busy, busy_temp);
  signal serdes_state            : type_serdes_state;
  subtype type_serdes_clk is integer range 0 to 10;
  signal serdes_clk              : type_serdes_clk;
  signal serdes_speed            : type_serdes_clk;
  subtype type_serdes_count is integer range 0 to 100;
  signal serdes_count            : type_serdes_count;
  subtype type_serdes_bit_count_m1 is integer range 0 to 32;
  signal serdes_bit_count_m1        : type_serdes_bit_count_m1;
  signal serdes_bit_no           : type_serdes_bit_count_m1;
  signal serdes_trig             : std_logic;
  signal serdes_trig_temp        : std_logic;
  signal serdes_wdata            : std_logic_vector(31 downto 0);
  signal serdes_rdata            : std_logic_vector(31 downto 0);

  type   type_drs_dac_reg is array (7 downto 0) of std_logic_vector(15 downto 0);
  signal drs_dac_reg             : type_drs_dac_reg;
  signal drs_dac_newval_flag     : std_logic_vector(7 downto 0);
  subtype type_dac_bit_count is integer range 0 to 31;

  signal temp                    : std_logic_vector(15 downto 0);
  signal temp_timer              : std_logic_vector(25 downto 0); -- once per second
  signal temp_cmd                : std_logic_vector(7 downto 0);

  subtype type_eeprom_count is integer range 0 to 100;
  signal drs_eeprom_write_trig   : std_logic;
  signal drs_eeprom_read_trig    : std_logic;
  signal drs_ctl_eeprom_sector   : std_logic_vector(15 downto 0);
  signal drs_eeprom_sector       : std_logic_vector(7 downto 0);
  signal drs_eeprom_page         : std_logic_vector(7 downto 0);  
  signal drs_eeprom_byte         : std_logic_vector(7 downto 0);  
  signal drs_eeprom_cmd          : std_logic_vector(59 downto 0);

  -- PMC IO pin control signals
  signal pmc_clk_i : std_logic_vector(P_IO_PMC_USR'range);  -- input FF clock
  signal pmc_ce_i  : std_logic_vector(P_IO_PMC_USR'range);  -- input FF clock enable
  signal pmc_clr_i : std_logic_vector(P_IO_PMC_USR'range);  -- input FF async clear
  signal pmc_pre_i : std_logic_vector(P_IO_PMC_USR'range);  -- input FF async preset
  signal pmc_i     : std_logic_vector(P_IO_PMC_USR'range);  -- input FF data
  signal pmc_clk_o : std_logic_vector(P_IO_PMC_USR'range);  -- output pad FF clock
  signal pmc_ce_o  : std_logic_vector(P_IO_PMC_USR'range);  -- output pad FF clock enable
  signal pmc_clr_o : std_logic_vector(P_IO_PMC_USR'range);  -- output pad FF async clear
  signal pmc_pre_o : std_logic_vector(P_IO_PMC_USR'range);  -- output pad FF async preset
  signal pmc_o     : std_logic_vector(P_IO_PMC_USR'range);  -- output pad FF data
  signal pmc_nt    : std_logic_vector(P_IO_PMC_USR'range);  -- output pad FF 3state

  -- state of DRS readout state machine
  type type_drs_readout_state is (init, idle, done, trailer,
                                  start_running, running, start_readout, readout_wait, adc_sync,
                                  chip_readout, wsr_addr, wsr_setup, wsr_strobe, conf_setup, 
                                  conf_strobe, init_rsr);
  signal drs_readout_state        : type_drs_readout_state;
  -- Localy copy signal to fulfull timing constraings
  signal drs_readout_state_local  : type_drs_readout_state;

  -- Clock signals for freq. meas., DRS data readout and serial bus (see below)
  signal drs_readout_clk          : std_logic;  -- clock for DRS readout state machine
  signal drs_readout_clk_ps       : std_logic;  -- clock for FADC, phase shifted
  signal drs_serial_clk           : std_logic;  -- clock for serial bus

  -- Signals for DRS waveform readout
  subtype type_drs_start_timer is integer range 0 to 255;
  signal drs_start_timer          : type_drs_start_timer; 
  signal drs_sample_count         : std_logic_vector(10 downto 0);
  signal drs_rd_tmp_count         : std_logic_vector(31 downto 0);
  signal drs_stop_cell            : std_logic_vector(9 downto 0);
  signal drs_stop_wsr             : std_logic_vector(7 downto 0);
  signal drs_addr                 : std_logic_vector(3 downto 0);

  -- DPRAM interface signals
  signal drs_dpram_we1            : std_logic;
  signal drs_dpram_we2            : std_logic;
  signal drs_dpram_addr           : std_logic_vector(31 downto 0);
  signal drs_dpram_d_wr1          : std_logic_vector(31 downto 0);
  signal drs_dpram_d_wr2          : std_logic_vector(31 downto 0);
  signal drs_dpram_d_rd           : std_logic_vector(31 downto 0);
  signal drs_dpram_reset1         : std_logic;
  signal drs_dpram_reset2         : std_logic;
  signal drs_dpram_inc            : std_logic;

  -- Frequency counter etc.
  subtype type_32_bit is std_logic_vector(31 downto 0);
  type type_scaler is array (5 downto 0) of type_32_bit;
  
  signal drs_1hz_counter          : std_logic_vector(31 downto 0);
  signal drs_1hz_clock            : std_logic;
  signal drs_1hz_latch1           : std_logic_vector(5 downto 0);
  signal drs_1hz_latch2           : std_logic_vector(5 downto 0);
  signal drs_1hz_latch3           : std_logic_vector(5 downto 0);
 
  signal scaler                   : type_scaler;
  signal scaler_clock             : std_logic_vector(5 downto 0);
  signal scaler_reset             : std_logic_vector(5 downto 0);
  signal scaler_ff                : std_logic_vector(5 downto 0);
  signal scaler_ff_reset          : std_logic_vector(5 downto 0);
  
begin
  GND   <= '0';
  VCC   <= '1';

  -- Clock signals for freq. meas., DRS data readout and DAC control
  drs_readout_clk       <= I_CLK33;
  drs_readout_clk_ps    <= I_CLK33; -- phase shifted clock for FADC
  drs_serial_clk        <= I_CLK33;
  
  -- First part of I/O pad flipflop array
  pmc_iofds_inst_bit_41_0 : USR_LIB_VEC_IOFD_CPE_NALL
    generic map (
      width             => 42,
      init_val_to_pad   => "1",
      init_val_from_pad => "1"
    )
    port map (
      O_C   => pmc_clk_i(41 downto 0),
      O_CE  => pmc_ce_i(41 downto 0),
      O_CLR => pmc_clr_i(41 downto 0),
      O_PRE => pmc_pre_i(41 downto 0),
      O     => pmc_i(41 downto 0),
      I_C   => pmc_clk_o(41 downto 0),
      I_CE  => pmc_ce_o(41 downto 0),
      I_CLR => pmc_clr_o(41 downto 0),
      I_PRE => pmc_pre_o(41 downto 0),
      I     => pmc_o(41 downto 0),
      IO    => P_IO_PMC_USR(41 downto 0),
      T     => pmc_nt(41 downto 0)
    );

  -- bit 42 driven by combinatorinal logic of o_drs_write

  pmc_iofds_inst_bit_43 : USR_LIB_VEC_IOFD_CPE_NALL
    generic map (
      width             => 1,
      init_val_to_pad   => "1",
      init_val_from_pad => "1"
    )
    port map (
      O_C   => pmc_clk_i(43 downto 43),
      O_CE  => pmc_ce_i(43 downto 43),
      O_CLR => pmc_clr_i(43 downto 43),
      O_PRE => pmc_pre_i(43 downto 43),
      O     => pmc_i(43 downto 43),
      I_C   => pmc_clk_o(43 downto 43),
      I_CE  => pmc_ce_o(43 downto 43),
      I_CLR => pmc_clr_o(43 downto 43),
      I_PRE => pmc_pre_o(43 downto 43),
      I     => pmc_o(43 downto 43),
      IO    => P_IO_PMC_USR(43 downto 43),
      T     => pmc_nt(43 downto 43)
    );

  pmc_iofds_inst_bit_53_47 : USR_LIB_VEC_IOFD_CPE_NALL
    generic map (
      width             => 7,
      init_val_to_pad   => "1",
      init_val_from_pad => "1"
    )
    port map (
      O_C   => pmc_clk_i(53 downto 47),
      O_CE  => pmc_ce_i(53 downto 47),
      O_CLR => pmc_clr_i(53 downto 47),
      O_PRE => pmc_pre_i(53 downto 47),
      O     => pmc_i(53 downto 47),
      I_C   => pmc_clk_o(53 downto 47),
      I_CE  => pmc_ce_o(53 downto 47),
      I_CLR => pmc_clr_o(53 downto 47),
      I_PRE => pmc_pre_o(53 downto 47),
      I     => pmc_o(53 downto 47),
      IO    => P_IO_PMC_USR(53 downto 47),
      T     => pmc_nt(53 downto 47)
    );

  -- bit 54/55 is LVDS output
  pmc_obufds_inst_bit_54_55 : IOBUFDS
    port map (
      O     => pmc_i(54),
      IO    => P_IO_PMC_USR(55),
      IOB   => P_IO_PMC_USR(54),
      I     => o_drs_refclk,
      T     => pmc_nt(54)
    );

  pmc_iofds_inst_bit_56 : USR_LIB_VEC_IOFD_CPE_NALL
    generic map (
      width             => 1,
      init_val_to_pad   => "1",
      init_val_from_pad => "1"
    )
    port map (
      O_C   => pmc_clk_i(56 downto 56),
      O_CE  => pmc_ce_i(56 downto 56),
      O_CLR => pmc_clr_i(56 downto 56),
      O_PRE => pmc_pre_i(56 downto 56),
      O     => pmc_i(56 downto 56),
      I_C   => pmc_clk_o(56 downto 56),
      I_CE  => pmc_ce_o(56 downto 56),
      I_CLR => pmc_clr_o(56 downto 56),
      I_PRE => pmc_pre_o(56 downto 56),
      I     => pmc_o(56 downto 56),
      IO    => P_IO_PMC_USR(56 downto 56),
      T     => pmc_nt(56 downto 56)
    );

  pmc_iofds_inst_bit_58 : USR_LIB_VEC_IOFD_CPE_NALL
    generic map (
      width             => 1,
      init_val_to_pad   => "1",
      init_val_from_pad => "1"
    )
    port map (
      O_C   => pmc_clk_i(58 downto 58),
      O_CE  => pmc_ce_i(58 downto 58),
      O_CLR => pmc_clr_i(58 downto 58),
      O_PRE => pmc_pre_i(58 downto 58),
      O     => pmc_i(58 downto 58),
      I_C   => pmc_clk_o(58 downto 58),
      I_CE  => pmc_ce_o(58 downto 58),
      I_CLR => pmc_clr_o(58 downto 58),
      I_PRE => pmc_pre_o(58 downto 58),
      I     => pmc_o(58 downto 58),
      IO    => P_IO_PMC_USR(58 downto 58),
      T     => pmc_nt(58 downto 58)
    );

  pmc_iofds_inst_bit_60 : USR_LIB_VEC_IOFD_CPE_NALL
    generic map (
      width             => 1,
      init_val_to_pad   => "1",
      init_val_from_pad => "1"
    )
    port map (
      O_C   => pmc_clk_i(60 downto 60),
      O_CE  => pmc_ce_i(60 downto 60),
      O_CLR => pmc_clr_i(60 downto 60),
      O_PRE => pmc_pre_i(60 downto 60),
      O     => pmc_i(60 downto 60),
      I_C   => pmc_clk_o(60 downto 60),
      I_CE  => pmc_ce_o(60 downto 60),
      I_CLR => pmc_clr_o(60 downto 60),
      I_PRE => pmc_pre_o(60 downto 60),
      I     => pmc_o(60 downto 60),
      IO    => P_IO_PMC_USR(60 downto 60),
      T     => pmc_nt(60 downto 60)
    );

  pmc_iofds_inst_bit_62 : USR_LIB_VEC_IOFD_CPE_NALL
    generic map (
      width             => 1,
      init_val_to_pad   => "1",
      init_val_from_pad => "1"
    )
    port map (
      O_C   => pmc_clk_i(62 downto 62),
      O_CE  => pmc_ce_i(62 downto 62),
      O_CLR => pmc_clr_i(62 downto 62),
      O_PRE => pmc_pre_i(62 downto 62),
      O     => pmc_i(62 downto 62),
      I_C   => pmc_clk_o(62 downto 62),
      I_CE  => pmc_ce_o(62 downto 62),
      I_CLR => pmc_clr_o(62 downto 62),
      I_PRE => pmc_pre_o(62 downto 62),
      I     => pmc_o(62 downto 62),
      IO    => P_IO_PMC_USR(62 downto 62),
      T     => pmc_nt(62 downto 62)
    );

  -- Clock signals for I/O pad flipflops
  pmc_clk_i(27 downto 0)   <= (others => drs_readout_clk); -- ADCs
  pmc_clk_i(28)            <= drs_readout_clk_ps;          -- ADC CLK
  pmc_clk_i(29)            <= drs_serial_clk;              -- SCLK
  pmc_clk_i(30)            <= drs_readout_clk;             -- DTAP
  pmc_clk_i(31)            <= drs_serial_clk;              -- SDI
  pmc_clk_i(33)            <= drs_serial_clk;              -- SDO
  pmc_clk_i(35)            <= drs_serial_clk;              -- DACCS
  pmc_clk_i(37)            <= drs_serial_clk;              -- EECS
  pmc_clk_i(38)            <= GND;                         -- N/C
  pmc_clk_i(39)            <= drs_serial_clk;              -- TSCS
  pmc_clk_i(40)            <= drs_readout_clk;             -- DENABLE
  pmc_clk_i(41)            <= drs_readout_clk;             -- WSROUT
  pmc_clk_i(42)            <= GND;                         -- DWRITE
  pmc_clk_i(47)            <= drs_readout_clk;             -- DRSON
  pmc_clk_i(48)            <= drs_readout_clk;             -- SRIN
  pmc_clk_i(50)            <= drs_readout_clk;             -- SRCLK
  pmc_clk_i(51)            <= drs_readout_clk;             -- SROUT
  pmc_clk_i(52)            <= drs_readout_clk;             -- RSRLOAD
  pmc_clk_i(53)            <= drs_readout_clk;             -- PLLLCK
  pmc_clk_i(54)            <= drs_readout_clk;             -- REFCLK-
  pmc_clk_i(55)            <= drs_readout_clk;             -- REFCLK+
  pmc_clk_i(56)            <= drs_readout_clk;             -- A0
  pmc_clk_i(58)            <= drs_readout_clk;             -- A1
  pmc_clk_i(60)            <= drs_readout_clk;             -- A2
  pmc_clk_i(62)            <= drs_readout_clk;             -- A3

  pmc_clk_o <= pmc_clk_i;

  -- Default values for preset/clear/...
  pmc_ce_i                 <= (others => VCC) ;
  pmc_clr_i                <= (others => GND) ;
  pmc_pre_i                <= (others => I_RESET) ;
  pmc_ce_o                 <= (others => VCC) ;
  pmc_clr_o                <= (others => GND) ;
  pmc_pre_o                <= (others => I_RESET) ;

  -- I/O pin 3state control: outputs always driven ("0"), inputs never driven ("1")
  pmc_nt(27 downto 0)      <= (others => '1'); -- ADCs
  pmc_nt(28)               <= '0';             -- ADC CLK
  pmc_nt(29)               <= not o_drs_on;    -- SCLK
  pmc_nt(30)               <= '1';             -- DTAP
  pmc_nt(33)               <= '1';             -- SDO
  pmc_nt(35)               <= '0';             -- DACCS
  pmc_nt(37)               <= '0';             -- EECS
  pmc_nt(38)               <= '0';             -- N/C
  pmc_nt(39)               <= '0';             -- TSCS
  pmc_nt(40)               <= not o_drs_on;    -- DENABLE
  pmc_nt(41)               <= '1';             -- WSROUT
  pmc_nt(42)               <= not o_drs_on;    -- DWRITE
  pmc_nt(47)               <= '0';             -- DRSON
  pmc_nt(48)               <= not o_drs_on;    -- SRIN
  pmc_nt(50)               <= not o_drs_on;    -- SRCLK
  pmc_nt(51)               <= '1';             -- SROUT
  pmc_nt(52)               <= not o_drs_on;    -- RSRLOAD
  pmc_nt(53)               <= '1';             -- PLLLCK
  pmc_nt(54)               <= not o_drs_on;    -- REFCLK-
  pmc_nt(55)               <= not o_drs_on;    -- REFCLK+
  pmc_nt(56)               <= not o_drs_on;    -- A0
  pmc_nt(58)               <= not o_drs_on;    -- A1
  pmc_nt(60)               <= not o_drs_on;    -- A2
  pmc_nt(62)               <= not o_drs_on;    -- A3

  -- Mapping of external PMC user signals

  i_drs_adc(0)             <= pmc_i(0);
  i_drs_adc(1)             <= pmc_i(2);
  i_drs_adc(2)             <= pmc_i(4);
  i_drs_adc(3)             <= pmc_i(6);
  i_drs_adc(4)             <= pmc_i(8);
  i_drs_adc(5)             <= pmc_i(10);
  i_drs_adc(6)             <= pmc_i(12);
  i_drs_adc(7)             <= pmc_i(14);
  i_drs_adc(8)             <= pmc_i(16);
  i_drs_adc(9)             <= pmc_i(18);
  i_drs_adc(10)            <= pmc_i(20);
  i_drs_adc(11)            <= pmc_i(22);
  i_drs_adc(12)            <= pmc_i(24);
  i_drs_adc(13)            <= pmc_i(26);

  pmc_o(28)                <= o_drs_adc_clk;
  pmc_o(29)                <= o_drs_serial_clk;
  i_drs_dtap               <= pmc_i(30);
  pmc_o(31)                <= o_drs_serial_data; -- out of TriState
  i_drs_serial_data        <= pmc_i(31);         -- in of TriState
  i_drs_eeprom_data        <= pmc_i(33);
  pmc_o(35)                <= o_drs_dac_cs_n;
  pmc_o(37)                <= o_drs_eeprom_cs_n;
  pmc_o(39)                <= o_drs_tempsens_cs_n;
  pmc_o(40)                <= o_drs_enable;
  i_drs_wsrout             <= pmc_i(41);
  -- pmc_o(42) driven by combinatorial logic of o_drs_write;
  P_IO_PMC_USR(42)         <= o_drs_write;
  pmc_o(47)                <= o_drs_on;
  pmc_o(48)                <= o_drs_srin;
  pmc_o(50)                <= o_drs_srclk;
  i_drs_srout              <= pmc_i(51);
  pmc_o(52)                <= o_drs_rsrload;
  i_drs_plllck             <= pmc_i(53);
  pmc_o(56)                <= o_drs_addr(0);
  pmc_o(58)                <= o_drs_addr(1);
  pmc_o(60)                <= o_drs_addr(2);
  pmc_o(62)                <= o_drs_addr(3);

  -- UsrBus control register mapping (control registers are set/read via
  -- UsrBus/System FPGA). In addition to the normal control register bits
  -- I_CONTROL_REG_ARR(reg_no)(bit_no), control register 0 has a special
  -- feature: a bit in the std_logic_vector I_CONTROL0_BIT_TRIG_ARR(0) is
  -- set for one I_CLK33 cycle (normally it is '0') when the System FPGA
  -- writes a '1' to the respective bit in control register 0. This can
  -- be used to trigger an event with a single UsrBus write cycle (instead
  -- of toggling the control register bit 0->1->0 using two write cycles).
  drs_ctl_start_trig        <= I_CONTROL0_BIT_TRIG_ARR(0);
  drs_ctl_reinit_trig       <= I_CONTROL0_BIT_TRIG_ARR(1);
  drs_ctl_soft_trig         <= I_CONTROL0_BIT_TRIG_ARR(2);
  drs_ctl_eeprom_write_trig <= I_CONTROL0_BIT_TRIG_ARR(3);
  drs_ctl_eeprom_read_trig  <= I_CONTROL0_BIT_TRIG_ARR(4);
  drs_ctl_autostart         <= I_CONTROL_REG_ARR(0)(16);
  drs_ctl_adc_active        <= I_CONTROL_REG_ARR(0)(17);
  drs_ctl_led_yellow        <= I_CONTROL_REG_ARR(0)(18);
  drs_ctl_tca_ctrl          <= I_CONTROL_REG_ARR(0)(19);
  drs_ctl_transp_mode       <= I_CONTROL_REG_ARR(0)(21);
  drs_ctl_enable_trigger    <= I_CONTROL_REG_ARR(0)(22);
  drs_ctl_readout_mode      <= I_CONTROL_REG_ARR(0)(23);
  drs_ctl_neg_trigger       <= I_CONTROL_REG_ARR(0)(24);
  drs_ctl_acalib            <= I_CONTROL_REG_ARR(0)(25);
  drs_ctl_refclk_source     <= I_CONTROL_REG_ARR(0)(26);
  drs_ctl_dactive           <= I_CONTROL_REG_ARR(0)(27);
  drs_ctl_standby_mode      <= I_CONTROL_REG_ARR(0)(28);
  
  drs_ctl_dac_arr(0)        <= I_CONTROL_REG_ARR(1)(31 downto 16);  -- needs trig.
  drs_ctl_dac_arr(1)        <= I_CONTROL_REG_ARR(1)(15 downto 0);   -- needs trig.
  drs_ctl_dac_arr(2)        <= I_CONTROL_REG_ARR(2)(31 downto 16);  -- needs trig.
  drs_ctl_dac_arr(3)        <= I_CONTROL_REG_ARR(2)(15 downto 0);   -- needs trig.
  drs_ctl_dac_arr(4)        <= I_CONTROL_REG_ARR(3)(31 downto 16);  -- needs trig.
  drs_ctl_dac_arr(5)        <= I_CONTROL_REG_ARR(3)(15 downto 0);   -- needs trig.
  drs_ctl_dac_arr(6)        <= I_CONTROL_REG_ARR(4)(31 downto 16);  -- needs trig.
  drs_ctl_dac_arr(7)        <= I_CONTROL_REG_ARR(4)(15 downto 0);   -- needs trig.
  drs_ctl_config            <= I_CONTROL_REG_ARR(5)(31 downto 24);  -- needs trig.
  drs_ctl_chn_config        <= I_CONTROL_REG_ARR(5)(23 downto 16);  -- needs trig.
  O_CLK_PS_VALUE            <= I_CONTROL_REG_ARR(5)(15 downto 8);
  drs_ctl_first_chn         <= I_CONTROL_REG_ARR(5)(7 downto 4);
  drs_ctl_last_chn          <= I_CONTROL_REG_ARR(5)(3 downto 0);
  drs_ctl_sampling_freq     <= I_CONTROL_REG_ARR(6)(15 downto 0);
  drs_ctl_delay_sel         <= I_CONTROL_REG_ARR(6)(23 downto 16);
  drs_ctl_trigger_config    <= I_CONTROL_REG_ARR(7)(31 downto 16);
  drs_ctl_eeprom_sector     <= I_CONTROL_REG_ARR(7)(15 downto 0);
  drs_ctl_readout_delay     <= I_CONTROL_REG_ARR(8)(31 downto 0);
  
  drs_ctl_dmode             <= drs_ctl_config(0);
  drs_ctl_trigger_transp    <= drs_ctl_trigger_config(15);
  
  -- UsrBus status register mapping
  O_STATUS_REG_ARR(0)(31 downto 16) <= X"C0DE";  -- magic number to identify PSI VPC board
  O_STATUS_REG_ARR(0)( 7 downto  0) <= X"04";    -- DRS4
  O_STATUS_REG_ARR(0)(15 downto  8) <= X"09";    -- USB Evaluation Board 5.0
  O_STATUS_REG_ARR(1)(0)            <= drs_stat_busy;
  O_STATUS_REG_ARR(1)(1)            <= i_drs_plllck;
  O_STATUS_REG_ARR(1)(2)            <= i_drs_dtap;   -- avoid optimizing away
  O_STATUS_REG_ARR(1)(3)            <= i_drs_wsrout; -- these signals
  O_STATUS_REG_ARR(1)(4)            <= i_drs_wsrout;
  O_STATUS_REG_ARR(1)(5)            <= drs_eeprom_busy;
  O_STATUS_REG_ARR(1)(6)            <= '0';
  O_STATUS_REG_ARR(1)(7)            <= i_cfg_pin;
  
  O_STATUS_REG_ARR(1)(31 downto 8)  <= (others => '0');
  
  O_STATUS_REG_ARR(2)(31 downto 26) <= (others => '0');
  O_STATUS_REG_ARR(2)(25 downto 16) <= drs_stat_stop_cell;
  
  O_STATUS_REG_ARR(4)(31 downto 24) <= drs_stat_stop_wsr;
  O_STATUS_REG_ARR(4)(23 downto 0)  <= (others => '0');
  
  O_STATUS_REG_ARR(8)(31 downto 16) <= drs_temperature;
  O_STATUS_REG_ARR(8)(15 downto 0)  <= drs_trigger_bus;
  O_STATUS_REG_ARR(9)(31 downto 16) <= drs_serial_number;
  O_STATUS_REG_ARR(9)(15 downto 0)  <= svn_revision;

  -- Firmware version, incremented manually
  svn_revision <= std_logic_vector(to_unsigned(30000, 16));
  
  -- DPRAM for waveform data and EEPROM read/write
  O_DPRAM_CLK    <= drs_readout_clk;
  O_DPRAM_ADDR   <= drs_dpram_addr;
  O_DPRAM_WE     <= drs_dpram_we1 or drs_dpram_we2;
  O_DPRAM_D_WR   <= drs_dpram_d_wr1 when drs_dpram_we1 = '1' else 
                    drs_dpram_d_wr2;
  drs_dpram_d_rd <= I_DPRAM_D_RD;                

  -- Config pin
  i_cfg_pin      <= I_CONFIG_PIN;

  -- State machine for serial bus access. It contains four functions:
  -- 1) Set the 8 DAC channels whenever a write access to
  --    the respective 16-bit word in the respective control register
  --    occurs (via UsrBus/System FPGA, see above for register map)
  -- 2) Read temperature sensor once per second
  -- 3) Read EEPROM serial number on boot
  -- 4) Write EEPROM serial number on request

  proc_serial_io: process(I_RESET, drs_serial_clk)
  begin
    if (I_RESET = '1') then

      serial_bus_state      <= idle;

      drs_dac_newval_flag   <= (others => '0');
      drs_eeprom_write_trig <= '0';
      drs_eeprom_read_trig  <= '0';
      drs_eeprom_busy       <= '1'; -- will be cleard after initial read
      
      temp_timer            <= (others => '0');
      serial_count          <= 0;

      loop_drs_dac_reg_reset : for dac_no in 0 to 7 loop
        drs_dac_reg(dac_no) <= (others => '0');
      end loop;

      serdes_trig           <= '0';
      serdes_trig_temp      <= '0';
      serdes_wdata          <= (others => '0');

      o_drs_dac_cs_n        <= '1';
      o_drs_eeprom_cs_n     <= '1';
      o_drs_tempsens_cs_n   <= '1';
      serial_count          <= 0;
      
      serial_start_flag1    <= '1';
      serial_start_flag2    <= '1';
      
      drs_dpram_we2         <= '0';
      drs_dpram_reset2      <= '0';
      drs_dpram_inc         <= '0';
      
    elsif rising_edge(drs_serial_clk) then

      serial_count          <= serial_count + 1;
      serdes_trig           <= '0';
      serdes_trig_temp      <= '0';

      -- check if DAC control registers were updated (high byte only for 8-bit access)
      gen_dac_newval_flag_set : for count in 0 to 3 loop
        if (I_CONTROL_TRIG_ARR(count + 1)(3) = '1') then
          drs_dac_newval_flag(count*2)      <= '1';
          drs_dac_reg(count*2)              <= drs_ctl_dac_arr(count*2);
        end if;
        if (I_CONTROL_TRIG_ARR(count + 1)(1) = '1') then
          drs_dac_newval_flag(count*2  + 1) <= '1';
          drs_dac_reg(count*2 + 1)          <= drs_ctl_dac_arr(count*2 + 1);
        end if;
      end loop;

      -- check if eeprom write trigger was updated
      if (drs_ctl_eeprom_write_trig = '1') then
        drs_eeprom_write_trig   <= '1';
        drs_eeprom_busy         <= '1';
      end if;

      -- check if eeprom read trigger was updated
      if (drs_ctl_eeprom_read_trig = '1') then
        drs_eeprom_read_trig    <= '1';
        drs_eeprom_busy         <= '1';
      end if;

      case (serial_bus_state) is

        when idle =>
          o_drs_dac_cs_n        <= '1';
          o_drs_eeprom_cs_n     <= '1';
          o_drs_tempsens_cs_n   <= '1';
          serial_count          <= 0;
          drs_dpram_we2         <= '0';
          
          -- need if..elsif chain to get only one flag set
          if (drs_dac_newval_flag(0) = '1') then
            drs_dac_newval_flag(0)    <= '0';
            serdes_wdata(23 downto 0) <= "00110000" & drs_dac_reg(0);
          elsif (drs_dac_newval_flag(1) = '1') then
            drs_dac_newval_flag(1)    <= '0';
            serdes_wdata(23 downto 0) <= "00110001" & drs_dac_reg(1);
          elsif (drs_dac_newval_flag(2) = '1') then
            drs_dac_newval_flag(2)    <= '0';
            serdes_wdata(23 downto 0) <= "00110010" & drs_dac_reg(2);
          elsif (drs_dac_newval_flag(3) = '1') then
            drs_dac_newval_flag(3)    <= '0';
            serdes_wdata(23 downto 0) <= "00110011" & drs_dac_reg(3);
          elsif (drs_dac_newval_flag(4) = '1') then
            drs_dac_newval_flag(4)    <= '0';
            serdes_wdata(23 downto 0) <= "00110100" & drs_dac_reg(4);
          elsif (drs_dac_newval_flag(5) = '1') then
            drs_dac_newval_flag(5)    <= '0';
            serdes_wdata(23 downto 0) <= "00110101" & drs_dac_reg(5);
          elsif (drs_dac_newval_flag(6) = '1') then
            drs_dac_newval_flag(6)    <= '0';
            serdes_wdata(23 downto 0) <= "00110110" & drs_dac_reg(6);
          elsif (drs_dac_newval_flag(7) = '1') then
            drs_dac_newval_flag(7)    <= '0';
            serdes_wdata(23 downto 0) <= "00110111" & drs_dac_reg(7);
          end if;

          -- start serdes process if DAC changed
          if (drs_dac_newval_flag /= "00000000") then
            serial_bus_state         <= wait_serdes;
            o_drs_dac_cs_n           <= '0';
            serdes_bit_count_m1      <= 23;
            serdes_speed             <= 0;
            serdes_trig              <= '1';
          end if;

          -- read eeprom once after startup
          -- need delay such that o_drs_eeprom_cs_n = 1 for long enough time
          if (serial_start_flag1 = '1' and temp_timer(12) = '1') then
            serial_start_flag1       <= '0';
            serial_bus_state         <= eeprom_read;
          end if;

          -- read temperature when timer expired
          if (temp_timer(temp_timer'high) = '1' or serial_start_flag2 = '1') then
            serial_start_flag2       <= '0';
            temp_timer               <= (others => '0');
            serial_bus_state         <= wait_serdes;
            o_drs_tempsens_cs_n      <= '0';
            serdes_trig_temp         <= '1';
          else
            temp_timer               <= temp_timer + "1";
          end if;

          -- write EEPROM when triggered
          if (drs_eeprom_write_trig = '1') then
            drs_eeprom_write_trig    <= '0';
            serial_bus_state         <= eeprom_write;
            drs_eeprom_sector        <= drs_ctl_eeprom_sector(7 downto 0);
          end if;

          -- read EEPROM when triggered
          if (drs_eeprom_read_trig = '1') then
            drs_eeprom_read_trig     <= '0';
            serial_bus_state         <= eeprom_read;
            drs_eeprom_sector        <= drs_ctl_eeprom_sector(7 downto 0);
          end if;

        -- wait for serdes process
        when wait_serdes =>
          if (serial_count /=0) then
            serial_count <= serial_count;
            if (serdes_state = idle) then
              serial_bus_state <= idle;
            end if;
          end if;

        -- read from EEPROM to DPRAM
        when eeprom_read =>
          serdes_speed               <= 0;
          case (serial_count) is
            when 0 =>
              o_drs_eeprom_cs_n      <= '0';
              serdes_wdata(31 downto 0)<= "00000011" & drs_eeprom_sector 
                                                     & X"0000"; -- Read page
              serdes_bit_count_m1    <= 31;
              serdes_trig            <= '1';
              drs_dpram_reset2       <= '1';
            when 2 =>
              if (serdes_state = busy) then
                serial_count <= serial_count;
              end if;
            when 3 =>
              drs_dpram_we2          <= '0';
              drs_dpram_reset2       <= '0';
              serdes_wdata           <= (others => '0'); -- Dummy bits
              serdes_bit_count_m1    <= 31; -- read 32 bits
              serdes_trig            <= '1';
            when 5 =>
              if (serdes_state = busy) then
                serial_count         <= serial_count;
              end if;
            when 6 =>
              -- swap bytes since LSB comes first out of the EEPROM and gets
              -- stored then in rdata(31 downto 24)
              drs_dpram_d_wr2(31 downto 24) <= serdes_rdata( 7 downto  0);
              drs_dpram_d_wr2(23 downto 16) <= serdes_rdata(15 downto  8);
              drs_dpram_d_wr2(15 downto  8) <= serdes_rdata(23 downto 16);
              drs_dpram_d_wr2( 7 downto  0) <= serdes_rdata(31 downto 24);
              drs_dpram_we2          <= '1';

              -- page 0 addr 3 & 7 contains serial number
              if (drs_dpram_addr = X"0000" and drs_eeprom_sector = X"00") then
                 drs_serial_number(7 downto 0)   <= serdes_rdata(31 downto 24);
                 drs_serial_number(15 downto 8)  <= serdes_rdata(23 downto 16);
              end if;
             
              -- loop until 32kb read
              if (drs_dpram_addr = X"00007FFC") then
                 serial_bus_state    <= idle;
                 drs_eeprom_busy     <= '0';
              end if;
              serial_count           <= 3;
            when others =>
              null;
          end case;

        -- write data from DPRAM to EEPROM
        when eeprom_write =>
          serdes_speed               <= 0;
          case (serial_count) is

            -- call enable routine
            when 0 =>
              serial_ret_addr        <= 1;
              serial_count           <= 60;

            -- unprotect blocks, will fail if jumper missing
            when 1 =>
              o_drs_eeprom_cs_n      <= '0';
              serdes_wdata(15 downto 8) <= "00000001";  -- Write status register
              serdes_wdata( 7 downto 0) <= "00000000";  -- no SRWD, no BPx
              serdes_bit_count_m1    <= 15;
              serdes_trig            <= '1';
            when 3 =>
              if (serdes_state = busy) then
                serial_count <= serial_count;
              end if;
            when 4 =>
              o_drs_eeprom_cs_n      <= '1';
              
            -- check status register  
            when 6 =>
              serial_ret_addr        <= 7;
              serial_count           <= 50;  
            
            -- call enable routine
            when 7 =>
              serial_ret_addr        <= 8;
              serial_count           <= 60;

            -- erase 64 kB block
            when 8 =>
              o_drs_eeprom_cs_n      <= '0';
              serdes_wdata(31 downto 0) <= "11011000" & drs_eeprom_sector 
                                                      & X"0000"; -- Erase block
              serdes_bit_count_m1    <= 31;
              serdes_trig            <= '1';
            when 10 =>
              if (serdes_state = busy) then
                serial_count <= serial_count;
              end if;
            when 11 =>
              o_drs_eeprom_cs_n      <= '1';  
              drs_dpram_reset2       <= '1';
             
            -- check status register until erase finished
            when 13 =>
              serial_ret_addr        <= 14;
              serial_count           <= 50;
            
            -- initialize page counter
            when 14 =>
              drs_eeprom_page        <= (others=>'0');
              drs_dpram_reset2       <= '0';

            when 15 =>
              -- call enable routine
              serial_ret_addr        <= 16;
              serial_count           <= 60;

            -- write page (256 bytes)
            when 16 =>
              o_drs_eeprom_cs_n      <= '0';
              -- write page command, use only 1st half of 64 kB sector
              serdes_wdata(31 downto 0) <= "00000010" & drs_eeprom_sector 
                                         & "0" & drs_eeprom_page(6 downto 0) & X"00";
              serdes_bit_count_m1    <= 31;
              serdes_trig            <= '1';
              drs_eeprom_byte        <= (others=>'0');
            when 18 =>
              if (serdes_state = busy) then
                serial_count <= serial_count;
              end if;
            when 19 =>
              -- write byte
              case (drs_eeprom_byte(1 downto 0)) is
                when "00" =>
                  serdes_wdata(7 downto 0) <= drs_dpram_d_rd( 7 downto  0);
                when "01" =>
                  serdes_wdata(7 downto 0) <= drs_dpram_d_rd(15 downto  8);
                when "10" =>
                  serdes_wdata(7 downto 0) <= drs_dpram_d_rd(23 downto 16);
                when "11" =>
                  serdes_wdata(7 downto 0) <= drs_dpram_d_rd(31 downto 24);
                when others =>
                  null;                
              end case;  
              serdes_bit_count_m1    <= 7;
              serdes_trig            <= '1';
              if (drs_eeprom_byte(1 downto 0) = "11") then
                 drs_dpram_inc       <= '1';
              end if;
            when 20 =>
              drs_dpram_inc          <= '0';  
            when 21 =>
              if (serdes_state = busy) then
                serial_count <= serial_count;
              end if;
            when 22 =>
              drs_eeprom_byte         <= drs_eeprom_byte + 1;
              if (drs_eeprom_byte /= X"FF") then
                serial_count         <= 19; -- loop until 256 bytes written
              end if;
            when 23 =>
              o_drs_eeprom_cs_n      <= '1';
              
            -- check status register
            when 25 =>  
              serial_ret_addr        <= 26;
              serial_count           <= 50;
              
            -- loop until 128 pages are written  
            when 26 =>
              drs_eeprom_page        <= drs_eeprom_page + 1;
              if (drs_eeprom_page /= X"7F") then
                serial_count         <= 15;
              end if;

            -- finish write  
            --when 27 =>
				--  drs_eeprom_busy        <= '0';
            --  serial_bus_state       <= idle;

            -- call enable routine
            when 27 =>
              serial_ret_addr        <= 28;
              serial_count           <= 60;
     
            -- remove protection of status register
            when 28 =>
              o_drs_eeprom_cs_n      <= '0';
              serdes_wdata(15 downto 8) <= "00000001";  -- Write status register
              serdes_wdata( 7 downto 0) <= "00011100";  -- remove WPEN
              serdes_bit_count_m1    <= 15;
              serdes_trig            <= '1';
            when 30 =>
              if (serdes_state = busy) then
                serial_count <= serial_count;
              end if;
            when 31 =>
              o_drs_eeprom_cs_n      <= '1';
     
            -- check status register  
            when 33 =>
              serial_ret_addr        <= 34;
              serial_count           <= 50;  
     
            -- call enable routine
            when 34 =>
              serial_ret_addr        <= 35;
              serial_count           <= 60;
     
            -- protect status register and memory
            when 35 =>
              o_drs_eeprom_cs_n      <= '0';
              serdes_wdata(15 downto 8) <= "00000001";  -- Write status register
              serdes_wdata( 7 downto 0) <= "10011100";  -- set WPEN, BP0 - BP2
              serdes_bit_count_m1    <= 15;
              serdes_trig            <= '1';
            when 37 =>
              if (serdes_state = busy) then
                serial_count <= serial_count;
              end if;
            when 38 =>
              o_drs_eeprom_cs_n      <= '1';
     
            -- check status register  
            when 40 =>
              serial_ret_addr        <= 41;
              serial_count           <= 50;  
     
            -- finish write  
            when 41 =>
              drs_eeprom_busy        <= '0';
              serial_bus_state       <= idle;

            -- check status register "subroutine" --------------------------
            when 50 => 
              o_drs_eeprom_cs_n      <= '0';
              serdes_wdata(15 downto 0) <= "00000101" & X"00"; -- Read Status Register
              serdes_bit_count_m1    <= 15;
              serdes_trig            <= '1';
            when 52 =>
              if (serdes_state = busy) then
                serial_count <= serial_count;
              end if;
            when 53 =>
              o_drs_eeprom_cs_n      <= '1';
            when 55 =>
              -- repeat read status until WIP = '0'       
              if (serdes_rdata(0) = '1') then
                serial_count         <= 50; 
              end if;
            when 59 =>
              serial_count           <= serial_ret_addr;       
    
            -- enable erase and write "subroutine" -------------------------
            when 60 =>
              o_drs_eeprom_cs_n      <= '0';
              serdes_wdata(7 downto 0) <= "00000110";  -- WREN
              serdes_bit_count_m1    <= 7;
              serdes_trig            <= '1';
            when 62 =>
              if (serdes_state = busy) then
                serial_count <= serial_count;
              end if;
            when 63 =>
              o_drs_eeprom_cs_n      <= '1';
            when 66 =>
              serial_count           <= serial_ret_addr;
    
            when others =>
              null;
          end case;

        when others =>
          serial_bus_state <= idle;

      end case;

    end if;
  end process;

  -- Serializer/Deserializer for serial bus. Upon a serdes_trig,
  -- output serdes_bit_count_m1 bits of serdes_wdata
  proc_serdes: process(I_RESET, drs_serial_clk)
  begin
    if (I_RESET = '1') then

      o_drs_serial_clk      <= '0';
      o_drs_serial_data     <= '0';
      serdes_bit_no         <= 0;
      serdes_state          <= idle;
      serdes_rdata          <= (others => '0');
      temp                  <= (others => '0');
      drs_temperature       <= (others => '0');
      temp_cmd              <= X"C1"; -- temperature register read

    elsif rising_edge(drs_serial_clk) then
      case (serdes_state) is

        when idle =>
          pmc_nt(31)            <= '0'; -- set pin to output by default
          o_drs_serial_clk      <= '0';
          o_drs_serial_data     <= '0';
          serdes_clk            <= 0;
          serdes_count          <= 0;
          if (serdes_trig = '1') then
            serdes_state          <= busy;
            serdes_bit_no         <= serdes_bit_count_m1;
          end if;
          if (serdes_trig_temp = '1') then
            serdes_state          <= busy_temp;
            serdes_bit_no         <= 7;
          end if;

        when busy =>
          serdes_clk <= serdes_clk + 1;
          if (serdes_clk = serdes_speed) then
            serdes_clk   <= 0;
            serdes_count <= serdes_count + 1;

            case (serdes_count) is
              when 0 =>
                o_drs_serial_clk <= '0';
                o_drs_serial_data <= serdes_wdata(serdes_bit_no);
              when 2 =>
                o_drs_serial_clk <= '1';
              when 3 =>
                serdes_rdata(serdes_bit_no) <= i_drs_eeprom_data;
                serdes_count <= 0;
                if (serdes_bit_no /= 0) then
                  serdes_bit_no <= serdes_bit_no - 1;
                else
                  serdes_state  <= idle;
                end if;
              when others =>
                null;
              end case;
          end if;

        when busy_temp =>
          serdes_clk <= serdes_clk + 1;
          if (serdes_clk = 9) then -- only every 300ns
            serdes_clk <= 0;

            -- wait one clock cycle until first data bit out
            if (serdes_count > 0) then
              o_drs_serial_clk <= not o_drs_serial_clk;
            end if;

            -- output command
            if ((o_drs_serial_clk = '1' or serdes_count = 0) and serdes_count < 8) then
              serdes_count      <= serdes_count + 1;
              o_drs_serial_data <= temp_cmd(7 - serdes_count);
            end if;

            -- input data
            if (o_drs_serial_clk = '0' and serdes_count > 8) then
              serdes_count      <= serdes_count + 1;
              temp              <= temp(temp'high-1 downto 0) & i_drs_serial_data;
            end if;

            -- switch SIO pin to input
            if (o_drs_serial_clk = '1' and serdes_count = 8) then
              pmc_nt(31)        <= '1';
              serdes_count      <= serdes_count + 1;
            end if;

            -- finish up
            if (serdes_count = 25) then
              o_drs_serial_clk  <= '0';
              drs_temperature   <= temp;
              serdes_state      <= idle;
            end if;
          end if;

        when others => -- should never be entered...
          serdes_state <= idle;
      end case;
    end if;
  end process;

  -- Reference clock generation for PLL
  
  o_drs_refclk <= drs_refclk when drs_ctl_refclk_source = '0' else IO_ECLK_IN;
  IO_ECLK_OUT  <= o_drs_refclk when drs_ctl_trigger_transp = '0' else drs_trig_ff;
   
  proc_drs_refclk: process(I_RESET, I_CLK66, drs_ctl_sampling_freq)
  begin
    if (I_RESET = '1') then
      drs_refclk                            <= '0';
      drs_refclk_counter(15 downto 0)       <= drs_ctl_sampling_freq;
      drs_refclk_counter(16)                <= '0';
    elsif rising_edge(I_CLK66) then
      if (drs_ctl_sampling_freq /= X"0000") then 
        drs_refclk_counter                  <= drs_refclk_counter - 1;
      end if;   
      
      -- initialize counter when DENABLE goes high
      if (o_drs_enable = '0') then
        drs_refclk_counter(15 downto 0)     <= drs_ctl_sampling_freq;
        drs_refclk_counter(16)              <= '0';
        drs_refclk                          <= '0';
      end if;

      -- toggle refclk if timer expires      
      if (drs_refclk_counter(16) = '1') then
        drs_refclk                          <= not drs_refclk;
        drs_refclk_counter(15 downto 0)     <= drs_ctl_sampling_freq;
        drs_refclk_counter(16)              <= '0';
      end if;  
    end if;
  end process;

  -- select direction for trigger in/out
  O_ETRG_IND   <= GND;
  O_ETRG_OUTD  <= VCC;

  -- hardware trigger inputs with selectable polarity
  drs_hard_inp(0) <= I_ANA_TRG(0) when drs_ctl_neg_trigger = '0' else not I_ANA_TRG(0);
  drs_hard_inp(1) <= I_ANA_TRG(1) when drs_ctl_neg_trigger = '0' else not I_ANA_TRG(1);
  drs_hard_inp(2) <= I_ANA_TRG(2) when drs_ctl_neg_trigger = '0' else not I_ANA_TRG(2);
  drs_hard_inp(3) <= I_ANA_TRG(3) when drs_ctl_neg_trigger = '0' else not I_ANA_TRG(3);
  drs_hard_inp(4) <= IO_ETRG_IN; -- always positive polarity
  
  -- OR block
  drs_hard_or  <= (drs_hard_inp(0) and drs_ctl_trigger_config(0)) or
                  (drs_hard_inp(1) and drs_ctl_trigger_config(1)) or
                  (drs_hard_inp(2) and drs_ctl_trigger_config(2)) or
                  (drs_hard_inp(3) and drs_ctl_trigger_config(3)) or
                  (drs_hard_inp(4) and drs_ctl_trigger_config(4));
                 
  -- AND block
  drs_hard_and <= '0' when drs_ctl_trigger_config(12 downto 8) = "00000" else
                  ((drs_hard_inp(0) and drs_ctl_trigger_config(8))  or not drs_ctl_trigger_config(8))  and
                  ((drs_hard_inp(1) and drs_ctl_trigger_config(9))  or not drs_ctl_trigger_config(9))  and
                  ((drs_hard_inp(2) and drs_ctl_trigger_config(10)) or not drs_ctl_trigger_config(10)) and
                  ((drs_hard_inp(3) and drs_ctl_trigger_config(11)) or not drs_ctl_trigger_config(11)) and
                  ((drs_hard_inp(4) and drs_ctl_trigger_config(12)) or not drs_ctl_trigger_config(12));
     
  -- global OR  
  drs_global_trig <= drs_hard_or or drs_hard_and when drs_ctl_enable_trigger = '1' else GND;
  
  -- global trigger / external trigger in transparent mode
  drs_hard_trig   <= drs_global_trig when drs_ctl_trigger_transp = '0' else IO_ETRG_IN;
  
  -- flip-flop which toggles with leading edge of hardware trigger
  proc_trg_ff: process(drs_hard_trig, drs_trig_ff_reset)
  begin
    if (drs_trig_ff_reset = '1') then
      drs_trig_ff              <= '0';
    elsif rising_edge(drs_hard_trig) then
      drs_trig_ff              <= '1';
    end if;    
  end process;

  -- output copy of trigger
  IO_ETRG_OUT <= drs_trig_ff when drs_ctl_trigger_transp = '0' else drs_global_trig;
  
  -- buffer chain delay for hardware trigger
  drs_trg_delay(0)             <= drs_trig_ff;
  delayed_trig_gen: for bit_no in 1 to 2047 generate
    LUT1_inst : LUT1
    generic map (
      INIT => "10")
    port map (
      O  => drs_trg_delay(bit_no),
      I0 => drs_trg_delay(bit_no-1)
    );
  end generate;
  
  -- select delayed hardware trigger
  drs_trigger                  <= drs_trg_delay(CONV_INTEGER(drs_ctl_delay_sel)*8);
  
  -- flip-flop for o_drs_write signal: raise with drs_write_set and lower with trigger
  proc_drs_write_ff: process(drs_trigger, drs_write_set, drs_readout_state)
  begin
    if (drs_readout_state = init or
        drs_readout_state = start_readout) then -- remove o_drs_write also if drs_soft_trig received
      drs_write_ff             <= '0';
    elsif (drs_write_set = '1') then
      drs_write_ff             <= '1';
    elsif rising_edge(drs_trigger) then
      drs_write_ff             <= '0';
    end if;
  end process;
  
  -- hardware trigger: remove o_drs_write asynchronously on rising edge of trigger
  o_drs_write <= drs_write_ff;
                 
  -- Domino chip readout
  proc_drs_readout: process(I_RESET, drs_readout_clk)
  begin
    if (I_RESET = '1') then
      drs_dpram_reset1         <= '1';
      drs_dpram_d_wr1          <= (others => '0');
      drs_dpram_we1            <= '0';
      o_drs_enable             <= '0';     -- domino waves disabled
      drs_write_set            <= '0';
      o_drs_srin               <= '1';
      o_drs_addr               <= "1111";  -- standby
      drs_readout_state        <= init;
      drs_stat_busy            <= '0';
      drs_sample_count         <= (others => '0');
      drs_reinit_request       <= '1';
      drs_trig_ff_reset        <= '1';
      drs_trigger_syn          <= '0';
      drs_soft_trig            <= '0';
      drs_old_readout_mode     <= '1';
      o_drs_on                 <= '1';
      o_drs_adc_clk            <= '0';

    elsif rising_edge(drs_readout_clk) then
      drs_dpram_we1            <= '0';
      drs_dpram_reset1         <= '0';
		drs_trig_ff_reset        <= '0';

      -- Memorize a write access to the bit in the control register
      -- that requests a reinitialisation of the DRS readout state
      -- machine (drs_ctl_reinit_trig goes high for only one cycle,
      -- therefore this "trigger" is memorised).
      if (drs_ctl_reinit_trig = '1') then
        drs_reinit_request     <= '1';
      end if;

      -- sample asynchronous trigger
      drs_trigger_syn          <= drs_trigger;
      
      -- remember software trigger
      if (drs_ctl_soft_trig = '1') then
         drs_soft_trig         <= '1';
      end if;

      -- run ADC clock continously
      o_drs_adc_clk            <= not o_drs_adc_clk;
      
      case (drs_readout_state) is

        when init =>
          drs_stat_busy        <= '0';                   
          drs_reinit_request   <= '0';                   
          drs_readout_state    <= idle;
          drs_trigger_bus      <= (others => '0');       
          o_drs_enable         <= '0';                   

        when idle =>                                        
          drs_stat_busy        <= '0';                   
          drs_soft_trig        <= '0';
          
          if (drs_ctl_standby_mode = '1') then
            o_drs_addr         <= "1111";  -- standby mode
            o_drs_on           <= '0';     -- DRS power off (test board)
          else 
            o_drs_on           <= '1';
            if (drs_ctl_transp_mode = '1') then
              o_drs_addr       <= "1010";  -- transparent mode
            else
              o_drs_addr       <= "1011";  -- address read shift register
            end if;      
          end if;  
          o_drs_srin           <= '0';                   
          o_drs_rsrload        <= '0';
          o_drs_srclk          <= '0';
          drs_start_timer      <= 0;
          
          if (drs_ctl_adc_active = '0') then
            o_drs_adc_clk      <= '0';
          end if;
          if (drs_reinit_request = '1') then
            drs_readout_state  <= init;
          elsif (drs_ctl_start_trig = '1') then
            drs_readout_state  <= start_running;
            drs_stat_busy      <= '1';   -- status reg. busy flag
          end if;

          --  check high byte of drs_ctl_config register          
          if (I_CONTROL_TRIG_ARR(5)(3) = '1') then
            drs_readout_state  <= conf_setup;
            o_drs_addr         <= "1100";  -- address config register
          end if;

          -- detect 1 to 0 transition of readout mode
          drs_old_readout_mode <= drs_ctl_readout_mode;
          if (drs_old_readout_mode = '1' and drs_ctl_readout_mode = '0') then
            drs_readout_state  <= init_rsr;
            o_drs_addr         <= "1011";  -- address read shift register
            drs_sr_count       <= 0;
          end if;

        when start_running =>
          o_drs_enable         <= '1';   -- enable and start domino wave
          if (drs_start_timer = 0) then
            drs_write_set      <= '1';   -- set drs_write_ff in proc_drs_write
          else
            drs_write_set      <= '0';
          end if;
        
          if (drs_ctl_adc_active = '0') then
            o_drs_adc_clk      <= '0';
          end if;
          if (drs_reinit_request = '1') then
            drs_readout_state  <= init;
          end if;

          drs_trig_ff_reset    <= '1';
			 
          -- do not go to running until at least 1.5 domino revolutions
          drs_start_timer      <= drs_start_timer + 1;
          if (drs_start_timer = 105) then  -- 105 * 30ns = 3.15us
            drs_readout_state  <= running;
            drs_trig_ff_reset  <= '0';  -- arm trigger
          end if;
          
        when running =>
        
          if (drs_ctl_adc_active = '0') then
            o_drs_adc_clk      <= '0';
          end if;
          if (drs_reinit_request = '1') then
            drs_readout_state  <= init;
          end if;
          if (drs_ctl_standby_mode = '1') then
            drs_readout_state  <= idle;
          end if;

          -- External trigger or software trigger received or DMODE = 0? If so:
          -- stop domino wave & start readout sequence
          if (drs_trigger_syn = '1' or drs_soft_trig = '1' or drs_ctl_dmode = '0') then
            drs_readout_state  <= start_readout;
          end if;

        when start_readout =>
          if (drs_ctl_dactive = '0') then 
            o_drs_enable       <= '0';   -- stop domino wave only if dactive=0
          end if;   

          drs_addr             <= drs_ctl_first_chn;
          o_drs_addr           <= "1101";  -- address write shift register for readout
          drs_sample_count     <= (others => '0');
          drs_rd_tmp_count     <= drs_ctl_readout_delay;
          drs_stop_cell        <= (others => '0');
          drs_stop_wsr         <= (others => '0');

          -- reset FIFO
          drs_dpram_reset1     <= '1';
          
          drs_readout_state    <= readout_wait;
          
        when readout_wait =>  
          if (drs_reinit_request = '1') then
            drs_readout_state  <= init;
          end if;
        
          drs_rd_tmp_count     <= drs_rd_tmp_count - 1;
          
          -- wait ~120 us for VDD to stabilize
          if (drs_rd_tmp_count(drs_rd_tmp_count'high) = '1') then
             drs_rd_tmp_count  <= (others => '0');
             drs_readout_state <= adc_sync;
          end if;
          
        when adc_sync =>
          -- synchronize with free running ADC clock
          if (o_drs_adc_clk = '1') then
             drs_readout_state <= chip_readout;
          end if;
                  
        when chip_readout =>
          if (drs_reinit_request = '1') then
            drs_readout_state  <= init;
          end if;

          o_drs_srclk          <= '0';
          drs_dpram_reset1     <= '0';                   
          
          if (drs_rd_tmp_count(drs_rd_tmp_count'high) = '0') then
            drs_rd_tmp_count   <= drs_rd_tmp_count + 1;
          end if;
          
          if (drs_rd_tmp_count = 0) then
            if (drs_ctl_readout_mode = '1') then
              o_drs_rsrload    <= '1'; -- load read shift register with stop position
            end if;
          end if;  
          
          if (drs_rd_tmp_count = 1) then
            o_drs_rsrload      <= '0';
          end if; 

          if (drs_rd_tmp_count = 2 and drs_addr = drs_ctl_first_chn) then
            drs_stop_wsr(0)    <= i_drs_srout;   -- sample last bit of WSR for first channel
          end if;
          
          if (drs_rd_tmp_count = 2) then
            o_drs_addr         <= drs_addr;      -- select channel for readout
          end if;
          
          if (drs_rd_tmp_count > 13 and drs_sample_count < 1016) then
            o_drs_srclk        <= not o_drs_srclk;
          end if;

          if (drs_rd_tmp_count > 13 and drs_rd_tmp_count < 36) then
            if (o_drs_srclk = '1') then
              drs_stop_cell(0) <= i_drs_srout;
              drs_stop_cell(9 downto 1) <= drs_stop_cell(8 downto 0);
            end if;
          end if;

          -- ADC delivers data at its outputs with 7 clock cycles delay
          -- with respect to its external clock pin
          if (drs_rd_tmp_count > 29 and o_drs_adc_clk = '1') then
            drs_sample_count   <= drs_sample_count + 1;
            
            if (drs_sample_count(0) = '0') then
              -- even cells: WORD0, WORD2, WORD4, ...
              drs_dpram_d_wr1(15 downto 2)  <= i_drs_adc(13 downto 0);  -- sample ADC data
              drs_dpram_d_wr1(1 downto 0)   <= "00";
            else
              -- odd cells: WORD1, WORD3, WORD5, ...
              drs_dpram_d_wr1(31 downto 18) <= i_drs_adc(13 downto 0);  -- sample ADC data
              drs_dpram_d_wr1(17 downto 16) <= "00";
             
              drs_dpram_we1                 <= '1';  -- write 32 bits to DPRAM
            end if;  
          end if;

          if (drs_sample_count = 1024) then
            drs_sample_count   <= (others => '0');
            drs_rd_tmp_count   <= (others => '0');
            o_drs_srclk        <= '0';

            -- write stop cell into register
            drs_stat_stop_cell <= drs_stop_cell;
            drs_stat_stop_wsr  <= drs_stop_wsr;

            -- increment channel address
            drs_addr           <= drs_addr + 1;

            -- re-sync ADC
            drs_readout_state  <= adc_sync;
            
            -- All channels of DRS chips read ?
            if (drs_addr = drs_ctl_last_chn) then
               drs_readout_state <= trailer;
            end if;

          end if;

        when trailer =>
          drs_dpram_d_wr1(31 downto 24)     <= (others => '0');
          drs_dpram_d_wr1(23 downto 16)     <= drs_stop_wsr;
          drs_dpram_d_wr1(15 downto 10)     <= (others => '0');
          drs_dpram_d_wr1( 9 downto  0)     <= drs_stop_cell;
          drs_dpram_we1                     <= '1';
          drs_readout_state                 <= done;
        
        when done =>
          drs_readout_state    <= idle;
          drs_stat_busy        <= '0';
          drs_dpram_we1        <= '0';
          drs_write_set        <= '1';   -- set drs_write_ff in proc_drs_write
                                         -- to keep chip "warm"

        -- set-up of configuration register        
        when conf_setup =>
          o_drs_srclk          <= '1';
          drs_sr_count         <= 0;
          drs_sr_reg           <= drs_ctl_config;
          drs_readout_state    <= conf_strobe;
          o_drs_srin           <= drs_ctl_config(7);
        
        when conf_strobe =>  
          drs_sr_count         <= drs_sr_count + 1;
          o_drs_srclk          <= not o_drs_srclk;

          if (o_drs_srclk = '1') then
             drs_sr_reg(7 downto 1)<= drs_sr_reg(6 downto 0);
          else
             o_drs_srin        <= drs_sr_reg(7);
          end if;
          
          if (drs_sr_count = 14) then
             drs_readout_state <= wsr_addr;
          end if;
          
        -- change address without changing clock  
        when wsr_addr =>
          o_drs_addr           <= "1101";  -- address write shift register
          drs_readout_state    <= wsr_setup;

        -- set-up of write shift register
        when wsr_setup =>
          o_drs_srclk          <= '1';
          drs_sr_count         <= 0;
          drs_sr_reg           <= drs_ctl_chn_config;
          drs_readout_state    <= wsr_strobe;
          o_drs_srin           <= drs_ctl_chn_config(7);
        
        when wsr_strobe =>  
          drs_sr_count         <= drs_sr_count + 1;
          o_drs_srclk          <= not o_drs_srclk;

          if (o_drs_srclk = '1') then
             drs_sr_reg(7 downto 1) <= drs_sr_reg(6 downto 0);
          else
             o_drs_srin        <= drs_sr_reg(7);
          end if;
          
          if (drs_sr_count = 14) then
             drs_readout_state <= idle;
          end if;

        -- initialize read shift register
        when init_rsr =>
          if (o_drs_srclk = '1') then
            drs_sr_count       <= drs_sr_count + 1;
          end if;  
          o_drs_srclk          <= not o_drs_srclk;
        
          if (drs_sr_count = 1023 and o_drs_srclk = '0') then
            o_drs_srin         <= '1';
          end if;
          
          if (drs_sr_count = 1024 and o_drs_srclk = '0') then
            o_drs_srin         <= '0';
            drs_readout_state  <= idle;
            o_drs_srclk        <= '0';
          end if;
          
        when others =>
          drs_readout_state    <= init;

      end case;
    end if;
  end process;

  -- Address counter for cyclic buffer ("FIFO") to store DRS chip readout data
  proc_drs_dpram_addr_count: process(I_RESET, drs_dpram_reset1, drs_dpram_reset2, drs_readout_clk)
  begin
    if (I_RESET = '1' or drs_dpram_reset1 = '1' or drs_dpram_reset2 = '1') then
      drs_dpram_addr           <= (others => '0');
    elsif rising_edge(drs_readout_clk) then
      if (drs_dpram_we1 = '1' or drs_dpram_we2 = '1' or drs_dpram_inc = '1') then
        drs_dpram_addr         <= drs_dpram_addr + "100";
      end if;
    end if;
  end process;

  --drs_led_trigger <= o_drs_write;
  drs_led_trigger <= '1' when drs_readout_state = running else '0';

  -- led pulse stretched
  proc_drs_red_led: process(I_RESET, drs_readout_clk)
  begin
    if (I_RESET = '1') then
      drs_led_green            <= '1';
      drs_led_counter          <= (others => '1');
      drs_led_state            <= led_idle;
    elsif rising_edge(drs_readout_clk) then
      case (drs_led_state) is
        when led_idle =>
          if (drs_led_trigger = '1') then
            drs_led_green      <= '1';
            drs_led_state      <= led_on;
            drs_led_counter(drs_led_counter'high) <= '0';
          end if;
        when led_on =>
          if (drs_led_counter(drs_led_counter'high) = '0') then
            drs_led_counter    <= drs_led_counter - 1; 
          elsif (drs_led_trigger = '0') then
            drs_led_green      <= '0';
            drs_led_state      <= led_off;
            drs_led_counter(drs_led_counter'high) <= '0';
          end if;
        when led_off =>
          drs_led_counter      <= drs_led_counter - 1; 
          if (drs_led_counter(drs_led_counter'high) = '1') then
            drs_led_state      <= led_idle;
          end if;
      end case;
    end if;
  end process;
  

  -- Reference clock used for frequency counter
  
  proc_1hzclk: process(I_RESET, I_CLK33)
  begin
    if (I_RESET = '1') then
      drs_1hz_counter(31 downto 0)          <= (others => '0');
		drs_1hz_clock                         <= '0';
		scaler_reset                          <= (others => '1');
		scaler_ff_reset                       <= (others => '1');
    elsif rising_edge(I_CLK33) then
      drs_1hz_counter                       <= drs_1hz_counter - 1; -- count down
		scaler_reset                          <= (others => '0');
		scaler_ff_reset                       <= (others => '0');
      
      -- toggle refclk if timer expires      
      if (drs_1hz_counter(drs_1hz_counter'high) = '1') then
        drs_1hz_clock                       <= not drs_1hz_clock;
        drs_1hz_counter(31 downto 0)        <= X"0016E35F";     -- 1499999, I_CLK33 is actually a 30 MHz clock
		  
		  scaler_ff_reset                     <= (others => '1'); -- reset scaler_ff once every 100ms cycle
        loop_scaler_reset : for i in 0 to 5 loop
          if (scaler_ff(i) = '0') then                          -- no activity since last cycle?     
		       scaler_reset(i)                <= '1';             -- force clear scaler register
		    end if;
        end loop;

		  if (scaler_ff(0) = '0') then                            -- no activity since last cycle?     
		    scaler_reset(0)                   <= '1';             -- force clear scaler register
		  end if;
		  
      end if;  
    end if;
  end process;
 
  
  -- scalers for channels 1-4 & trigger & ext. clock 
  gen_scaler_ff : for i in 0 to 5 generate
  begin

  -- RS flip-flop to register any scaler activity, needed to clear the scaler for 0 Hz
  proc_scaler_ff: process(scaler_ff_reset(i), scaler_clock(i))
  begin
    if (scaler_ff_reset(i) = '1') then
      scaler_ff(i) <= '0';
    elsif rising_edge(scaler_clock(i)) then
      scaler_ff(i) <= '1';
    end if;		
  end process;
    
  -- scaler process	 
  proc_drs_scaler: process(scaler_reset(i), scaler_clock(i))
  begin
    if (scaler_reset(i) = '1') then
      scaler(i)                             <= (others => '0');
      O_STATUS_REG_ARR(10+i)                <= (others => '0');
	 	drs_1hz_latch1(i)                     <= '0';
	 	drs_1hz_latch2(i)                     <= '0';
	 	drs_1hz_latch3(i)                     <= '0';
    elsif rising_edge(scaler_clock(i)) then
      scaler(i)                             <= scaler(i) + 1;
		drs_1hz_latch1(i)                     <= drs_1hz_clock;      -- sample asynchronous clock
		drs_1hz_latch2(i)                     <= drs_1hz_latch1(i);
		drs_1hz_latch3(i)                     <= drs_1hz_latch2(i);
      
      -- toggle refclk if timer expires      
      if (drs_1hz_latch1(i) = '1' and drs_1hz_latch2(i) = '0' and drs_1hz_latch3(i) = '0') then
		  scaler(i)                           <= scaler(i);
        O_STATUS_REG_ARR(10+i)              <= scaler(i);
      end if;  
      if (drs_1hz_latch1(i) = '1' and drs_1hz_latch2(i) = '1' and drs_1hz_latch3(i) = '0') then
        scaler(i)                           <= X"00000001"; -- we loose one clock cycle, so add it back here
      end if;  
    end if;
  end process;

  end generate gen_scaler_ff;
  
  scaler_clock(0) <= I_ANA_TRG(0);
  scaler_clock(1) <= I_ANA_TRG(1);
  scaler_clock(2) <= I_ANA_TRG(2);
  scaler_clock(3) <= I_ANA_TRG(3);
  scaler_clock(4) <= drs_hard_trig;
  scaler_clock(5) <= IO_ECLK_IN;

  -- debugging
  O_DEBUG1                     <= drs_1hz_clock;
  O_DEBUG2                     <= scaler_reset(0);

  -- timing calibration
  O_TCA_CTRL                   <= drs_ctl_tca_ctrl;
  O_CAL                        <= not drs_ctl_acalib;
  
  -- LED
  O_LED_GREEN                  <= drs_led_green;
  O_LED_YELLOW                 <= drs_ctl_led_yellow;

end arch;
