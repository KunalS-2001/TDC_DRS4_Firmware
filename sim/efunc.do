vlib work
vcom -93 -explicit ../src/drs4_pack.vhd
vcom -93 -explicit ../src/usr_lib.vhd
vcom -93 -explicit ../src/drs4_eval1.vhd
vcom -93 -explicit ../src/drs4_eval1_app.vhd
vcom -93 -explicit ../src/usb2_racc.vhd
vcom -93 -explicit ../src/usb_dpram.vhd
vcom -93 -explicit ../src/usr_clocks.vhd
vcom -93 -explicit ../sim/drs4_eval1_tb.vhd
vsim  TBX_drs4_eval1 -t ps 
view wave
source wave.do
run 2 us

