ifndef (${AXI_Stream_Generator_INCLUDED})

  include rtl/sim_utils/sources.mk

  AXI_Stream_Generator_INCLUDED = 1
  AXI_Stream_Generator_DIR      = ${PWD}/rtl/AXI_Stream_Generator

  AXI_Stream_Generator_SYNTH_SRC += ${AXI_Stream_Generator_DIR}/synth/AXI_Stream_Generator.vhd
  # AXI_Stream_Generator_SYNTH_SRC += ${AXI_Stream_Generator_DIR}/synth/AXI_Stream_Generator_pkg.vhd

  AXI_Stream_Generator_SIM_SRC   += ${AXI_Stream_Generator_DIR}/sim/tb_AXI_Stream_Generator.vhd
	AXI_Stream_Generator_SIM_TB    += tb_AXI_Stream_Generator

  SYNTH_SRC += ${AXI_Stream_Generator_SYNTH_SRC}
  SIM_SRC   += ${AXI_Stream_Generator_SIM_SRC}

  SIM_TB    += ${AXI_Stream_Generator_SIM_TB}

  RTL_MODULES_DEF += ${AXI_Stream_Generator_DIR}/sources.mk
  RTL_MODULES     += AXI_Stream_Generator
endif

