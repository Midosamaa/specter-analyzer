vlib work
vcom -93 AXI_Stream_Generator.vhd
vcom -93 tb_AXI_Stream_Generator.vhd
vsim -novopt tb_AXI_Stream_Generator
add wave *
add wave \
{sim:/tb_AXI_Stream_Generator/AXI_Stream_Generator_U/TDATA_Temp } \
{sim:/tb_AXI_Stream_Generator/AXI_Stream_Generator_U/TVALID_Temp } \
{sim:/tb_AXI_Stream_Generator/AXI_Stream_Generator_U/TLAST_Temp } \
{sim:/tb_AXI_Stream_Generator/AXI_Stream_Generator_U/compt } 
run -all
