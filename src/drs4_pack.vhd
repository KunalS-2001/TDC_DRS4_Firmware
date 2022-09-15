--#############################################################
-- Author   : Boris Keil, Stefan Ritt
-- Contents : Status and control register definition for drs2_cmc2
-- $Id$
--#############################################################

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package drs4_pack is

-- Constant definitions
-- ####################
  constant const_no_of_control_reg_addr_bits : integer := 4;
  constant const_no_of_status_reg_addr_bits  : integer := 4;
  constant const_pmc1_pmc2_diff_bit: integer := 19;
  
  -- number of control registers
  constant const_no_of_control_regs: integer := (2**(const_no_of_control_reg_addr_bits));
  -- number of status registers
  constant const_no_of_status_regs: integer := (2**(const_no_of_status_reg_addr_bits));
  -- Register width. Do not modify.
  constant const_reg_width: integer := 32;
  
  -- reinit bit in control register #0
  constant const_reinit_bit: integer := 1;
  
  -- size of DPRAM per PMC minus 4
  constant const_dpram_size_m4: std_logic_vector(31 downto 0) := X"0000_9FFC"; -- 10 channels @ 1024 samples @ 2x12bits
  --constant const_dpram_size_m4: std_logic_vector(31 downto 0) := X"0000_0008"; -- for simulation

-- Type definitions
-- ################
  subtype type_reg is std_logic_vector(31 downto 0);
  type type_control_reg_arr is array (const_no_of_control_regs - 1 downto 0) of type_reg;
  type type_status_reg_arr is array (const_no_of_status_regs - 1 downto 0) of type_reg;
  subtype type_control_reg_no is integer range 0 to (const_no_of_control_regs - 1);
  subtype type_status_reg_no is integer range 0 to (const_no_of_status_regs - 1);
  type type_control_trig_arr is array (const_no_of_control_regs - 1 downto 0) of std_logic_vector(3 downto 0);

end drs4_pack;
