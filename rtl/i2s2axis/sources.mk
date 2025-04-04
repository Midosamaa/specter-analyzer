ifndef (${i2s2axis_INCLUDED})

  include rtl/sim_utils/sources.mk

  i2s2axis_INCLUDED = 1
  i2s2axis_DIR    = ${PWD}/rtl/i2s2axis

  i2s2axis_SYNTH_SRC += ${i2s2axis_DIR}/synth/i2s2axis.vhd
  # i2s2axis_SYNTH_SRC += ${led_blink_DIR}/synth/i2s2axis.vhd

  i2s2axis_SIM_SRC += ${i2s2axis_DIR}/sim/tb_i2s2axis.vhd
  i2s2axis_SIM_TB += tb_i2s2axis

  SYNTH_SRC += ${i2s2axis_SYNTH_SRC}
  SIM_SRC   += ${i2s2axis_SIM_SRC}
  SIM_TB    += ${i2s2axis_SIM_TB}

  RTL_MODULES_DEF += ${i2s2axis_DIR}/sources.mk
  RTL_MODULES     += i2s2axis
endif
