#=========================================================
# Makefile for AHB UVM VIP
#=========================================================

#---------------------------------------------------------
# Simulator
#---------------------------------------------------------

VSIM = vsim

#---------------------------------------------------------
# Default Test
#---------------------------------------------------------

TEST ?= base_test

#=========================================================
# Targets
#=========================================================

.PHONY: all run clean help

all: run

#---------------------------------------------------------
# Compile & Run
#---------------------------------------------------------

run:
	$(VSIM) -c -do "do run.do $(TEST)"

#---------------------------------------------------------
# Clean Generated Files
#---------------------------------------------------------

clean:
	@echo "Cleaning simulation files..."
	-rm -rf work
	-rm -f transcript
	-rm -f vsim.wlf
	-rm -f modelsim.ini

#---------------------------------------------------------
# Help
#---------------------------------------------------------

help:
	@echo ""
	@echo "AHB UVM VIP Makefile"
	@echo "===================="
	@echo ""
	@echo "Usage:"
	@echo "  make run"
	@echo "  make run TEST=single_write_test"
	@echo "  make run TEST=single_read_test"
	@echo "  make run TEST=incr4_test"
	@echo "  make run TEST=wrap16_test"
	@echo "  make clean"
	@echo ""