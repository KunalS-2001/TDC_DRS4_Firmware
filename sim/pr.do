vlib work
vmap work work

vcom -93 -explicit ../2vp30/usr_fpga_timesim.vhd
vcom -93 -explicit ../sim/usr_fpga_tb.vhd
vsim -sdfmax /uut/=../2vp30/usr_fpga_timesim.sdf -t ps TBX_usr_fpga

view wave
source wave.do
run 4.5 us