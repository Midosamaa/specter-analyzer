ifndef (${axis_vga_INCLUDED})

  include rtl/sim_utils/sources.mk

  axis_vga_INCLUDED = 1
  axis_vga_DIR      = ${PWD}/rtl/axis_vga

  axis_vga_SYNTH_SRC += ${axis_vga_DIR}/synth/axis_vga.vhd

  axis_vga_SIM_SRC   += ${axis_vga_DIR}/sim/axis_vga_tb.vhd
	axis_vga_SIM_TB    += axis_vga_tb

  SYNTH_SRC += ${axis_vga_SYNTH_SRC}
  SIM_SRC   += ${axis_vga_SIM_SRC}

  SIM_TB    += ${axis_vga_SIM_TB}

  RTL_MODULES_DEF += ${axis_vga_DIR}/sources.mk
  RTL_MODULES     += axis_vga
endif

