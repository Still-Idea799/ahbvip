#=========================================================
# Create & Map Work Library
#=========================================================

if {[file exists work]} {
    vdel -all
}

vlib work
vmap work work

set INCDIR "+incdir+../ahb_top +incdir+../master_agent +incdir+../slave_agent +incdir+../tb +incdir+../test"

if {[info exists env(UVM_HOME)]} {
    append INCDIR " +incdir+$env(UVM_HOME)/src"
}

vlog ../ahb_top/ahb_if.sv
vlog $INCDIR ../ahb_top/ahb_pkg.sv
vlog $INCDIR ../test/test_pkg.sv
vlog $INCDIR ../tb/tb_top.sv

#=========================================================
# Start Simulation
#=========================================================

if {$argc > 0} {
    set TESTNAME [lindex $argv 0]
} else {
    set TESTNAME "base_test"
}

vsim -voptargs=+acc work.tb_top +UVM_TESTNAME=$TESTNAME

#=========================================================
# Optional Waveform
#=========================================================

add wave -r *

#=========================================================
# Run Simulation
#=========================================================

run -all

#=========================================================
# Exit
#=========================================================

quit -f