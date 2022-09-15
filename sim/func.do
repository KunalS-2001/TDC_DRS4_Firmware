vlib work
vcom -93 -explicit ../src/drs4_pack.vhd
vcom -93 -explicit ../src/usr_lib.vhd
vcom -93 -explicit ../src/drs4_mezz1_app.vhd
vcom -93 -explicit ../src/usr_fpga.vhd
vcom -93 -explicit ../src/usr_racc.vhd
vcom -93 -explicit ../src/usr_dpram.vhd
vcom -93 -explicit ../src/usr_clocks.vhd
vcom -93 -explicit ../sim/usr_fpga_tb.vhd
vsim  TBX_usr_fpga -t ps 
source wave.do
run 120 us

