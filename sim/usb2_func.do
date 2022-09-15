vlib work
vcom -93 -explicit ../src/drs3_pack.vhd
vcom -93 -explicit ../src/usr_lib.vhd
vcom -93 -explicit ../src/drs3_cmc3.vhd
vcom -93 -explicit ../src/usb_racc.vhd
vcom -93 -explicit ../src/usb_dpram.vhd
vcom -93 -explicit ../src/usr_clocks.vhd
vcom -93 -explicit ../src/usb_mezz3.vhd
vcom -93 -explicit ../sim/usb_mezz3_tb.vhd
vsim  TBX_usb_mezz3 -t ps 
view wave
source wave.do
run 20 us

