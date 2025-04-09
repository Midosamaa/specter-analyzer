ifndef (${VGA_Generator_test_INCLUDED})

  include rtl/sim_utils/sources.mk

  VGA_Generator_test_INCLUDED = 1
  VGA_Generator_test_DIR      = ${PWD}/rtl/VGA_Generator_test

  VGA_Generator_test_SYNTH_SRC += ${VGA_Generator_test_DIR}/synth/AXI_Stream_Generator.vhd
  VGA_Generator_test_SYNTH_SRC += ${VGA_Generator_test_DIR}/synth/axis_vga.vhd

  VGA_Generator_test_SIM_SRC   += ${VGA_Generator_test_DIR}/sim/tb_VGA_Generator_test.vhd
	VGA_Generator_test_SIM_TB    += tb_VGA_Generator_test

  SYNTH_SRC += ${VGA_Generator_test_SYNTH_SRC}
  SIM_SRC   += ${VGA_Generator_test_SIM_SRC}

  SIM_TB    += ${VGA_Generator_test_SIM_TB}

  RTL_MODULES_DEF += ${VGA_Generator_test_DIR}/sources.mk
  RTL_MODULES     += VGA_Generator_test
endif

