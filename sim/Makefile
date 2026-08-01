#=========================================================
# Makefile for AHB UVM VIP
#=========================================================

# SIMULATOR = Questa for Mentor's Questasim
# SIMULATOR = VCS for Synopsys's VCS

SIMULATOR = Questa

FSDB_PATH=/home/cad/eda/SYNOPSYS/VERDI_2022/verdi/T-2022.06-SP1/share/PLI/VCS/LINUX64

work = work
INC = +incdir+../ahb_top+../master_agent+../slave_agent+../tb+../test
SV_IF = ../ahb_top/ahb_if.sv
SV_PKG = ../ahb_top/ahb_pkg.sv ../test/test_pkg.sv
SV_TOP = ../tb/tb_top.sv

VSIMOPT= -vopt -voptargs=+acc
VSIMCOV= -coverage -sva

# Batch command definitions for all 18 tests
VSIMBATCH1= -c -do "log -r /* ;coverage save -onexit ahb_cov1;run -all; exit"
VSIMBATCH2= -c -do "log -r /* ;coverage save -onexit ahb_cov2;run -all; exit"
VSIMBATCH3= -c -do "log -r /* ;coverage save -onexit ahb_cov3;run -all; exit"
VSIMBATCH4= -c -do "log -r /* ;coverage save -onexit ahb_cov4;run -all; exit"
VSIMBATCH5= -c -do "log -r /* ;coverage save -onexit ahb_cov5;run -all; exit"
VSIMBATCH6= -c -do "log -r /* ;coverage save -onexit ahb_cov6;run -all; exit"
VSIMBATCH7= -c -do "log -r /* ;coverage save -onexit ahb_cov7;run -all; exit"
VSIMBATCH8= -c -do "log -r /* ;coverage save -onexit ahb_cov8;run -all; exit"
VSIMBATCH9= -c -do "log -r /* ;coverage save -onexit ahb_cov9;run -all; exit"
VSIMBATCH10= -c -do "log -r /* ;coverage save -onexit ahb_cov10;run -all; exit"
VSIMBATCH11= -c -do "log -r /* ;coverage save -onexit ahb_cov11;run -all; exit"
VSIMBATCH12= -c -do "log -r /* ;coverage save -onexit ahb_cov12;run -all; exit"
VSIMBATCH13= -c -do "log -r /* ;coverage save -onexit ahb_cov13;run -all; exit"
VSIMBATCH14= -c -do "log -r /* ;coverage save -onexit ahb_cov14;run -all; exit"
VSIMBATCH15= -c -do "log -r /* ;coverage save -onexit ahb_cov15;run -all; exit"
VSIMBATCH16= -c -do "log -r /* ;coverage save -onexit ahb_cov16;run -all; exit"
VSIMBATCH17= -c -do "log -r /* ;coverage save -onexit ahb_cov17;run -all; exit"
VSIMBATCH18= -c -do "log -r /* ;coverage save -onexit ahb_cov18;run -all; exit"

help:
        @echo =============================================================================================================
        @echo "! USAGE          --  make target                                                                                 !"
        @echo "! clean          =>  clean the earlier log and intermediate files.                                               !"
        @echo "! sv_cmp         =>  Create library and compile the code.                                                        !"
        @echo "! run_test       =>  run single_write_test                                                                   !"
        @echo "! run_test1      =>  run single_read_test                                                                    !"
        @echo "! run_test2      =>  run incr16_test                                                                         !"
        @echo "! run_test3      =>  run random_constrained_test                                                             !"
        @echo "! run_test4      =>  run back_to_back_write_test                                                             !"
        @echo "! run_test5      =>  run back_to_back_read_test                                                              !"
        @echo "! run_test6      =>  run mixed_read_write_test                                                               !"
        @echo "! run_test7      =>  run incr_test                                                                           !"
        @echo "! run_test8      =>  run incr4_test                                                                          !"
        @echo "! run_test9      =>  run incr8_test                                                                          !"
        @echo "! run_test10     =>  run wrap4_test                                                                          !"
        @echo "! run_test11     =>  run wrap8_test                                                                          !"
        @echo "! run_test12     =>  run wrap16_test                                                                         !"
        @echo "! run_test13     =>  run invalid_address_test                                                                !"
        @echo "! run_test14     =>  run busy_transfer_test                                                                  !"
        @echo "! run_test15     =>  run idle_transfer_test                                                                  !"
        @echo "! run_test16     =>  run wait_state_test                                                                     !"
        @echo "! run_test17     =>  run error_response_test                                                                 !"
        @echo "! regress        =>  clean, compile and run all testcases in batch mode.                                     !"
        @echo "! report         =>  To merge coverage reports for all testcases and convert to html format.                 !"
        @echo "! cov            =>  To open merged coverage report in html format.                                          !"
        @echo ====================================================================================================================

clean : clean_$(SIMULATOR)
sv_cmp : sv_cmp_$(SIMULATOR)
run_test : run_test_$(SIMULATOR)
run_test1 : run_test1_$(SIMULATOR)
run_test2 : run_test2_$(SIMULATOR)
run_test3 : run_test3_$(SIMULATOR)
run_test4 : run_test4_$(SIMULATOR)
run_test5 : run_test5_$(SIMULATOR)
run_test6 : run_test6_$(SIMULATOR)
run_test7 : run_test7_$(SIMULATOR)
run_test8 : run_test8_$(SIMULATOR)
run_test9 : run_test9_$(SIMULATOR)
run_test10 : run_test10_$(SIMULATOR)
run_test11 : run_test11_$(SIMULATOR)
run_test12 : run_test12_$(SIMULATOR)
run_test13 : run_test13_$(SIMULATOR)
run_test14 : run_test14_$(SIMULATOR)
run_test15 : run_test15_$(SIMULATOR)
run_test16 : run_test16_$(SIMULATOR)
run_test17 : run_test17_$(SIMULATOR)
regress : regress_$(SIMULATOR)
report : report_$(SIMULATOR)
cov : cov_$(SIMULATOR)

# ----------------------------- Start of Definitions for Mentor's Questa Specific Targets -------------------------------#

sv_cmp_Questa:
        vlib $(work)
        vmap work $(work)
        vlog -work $(work) $(SV_IF)
        vlog -work $(work) $(INC) $(SV_PKG)
        vlog -work $(work) $(INC) $(SV_TOP)

run_test_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1) -wlf wave_file1.wlf -l test1.log -sv_seed random work.tb_top +UVM_TESTNAME=single_write_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov1

run_test1_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2) -wlf wave_file2.wlf -l test2.log -sv_seed random work.tb_top +UVM_TESTNAME=single_read_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov2

run_test2_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH3) -wlf wave_file3.wlf -l test3.log -sv_seed random work.tb_top +UVM_TESTNAME=incr16_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov3

run_test3_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH4) -wlf wave_file4.wlf -l test4.log -sv_seed random work.tb_top +UVM_TESTNAME=random_constrained_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov4

run_test4_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH5) -wlf wave_file5.wlf -l test5.log -sv_seed random work.tb_top +UVM_TESTNAME=back_to_back_write_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov5

run_test5_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH6) -wlf wave_file6.wlf -l test6.log -sv_seed random work.tb_top +UVM_TESTNAME=back_to_back_read_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov6

run_test6_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH7) -wlf wave_file7.wlf -l test7.log -sv_seed random work.tb_top +UVM_TESTNAME=mixed_read_write_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov7

run_test7_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH8) -wlf wave_file8.wlf -l test8.log -sv_seed random work.tb_top +UVM_TESTNAME=incr_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov8

run_test8_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH9) -wlf wave_file9.wlf -l test9.log -sv_seed random work.tb_top +UVM_TESTNAME=incr4_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov9

run_test9_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH10) -wlf wave_file10.wlf -l test10.log -sv_seed random work.tb_top +UVM_TESTNAME=incr8_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov10

run_test10_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH11) -wlf wave_file11.wlf -l test11.log -sv_seed random work.tb_top +UVM_TESTNAME=wrap4_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov11

run_test11_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH12) -wlf wave_file12.wlf -l test12.log -sv_seed random work.tb_top +UVM_TESTNAME=wrap8_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov12

run_test12_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH13) -wlf wave_file13.wlf -l test13.log -sv_seed random work.tb_top +UVM_TESTNAME=wrap16_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov13

run_test13_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH14) -wlf wave_file14.wlf -l test14.log -sv_seed random work.tb_top +UVM_TESTNAME=invalid_address_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov14

run_test14_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH15) -wlf wave_file15.wlf -l test15.log -sv_seed random work.tb_top +UVM_TESTNAME=busy_transfer_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov15

run_test15_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH16) -wlf wave_file16.wlf -l test16.log -sv_seed random work.tb_top +UVM_TESTNAME=idle_transfer_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov16

run_test16_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH17) -wlf wave_file17.wlf -l test17.log -sv_seed random work.tb_top +UVM_TESTNAME=wait_state_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov17

run_test17_Questa: sv_cmp
        vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH18) -wlf wave_file18.wlf -l test18.log -sv_seed random work.tb_top +UVM_TESTNAME=error_response_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov18

report_Questa:
        vcover merge ahb_cov ahb_cov1 ahb_cov2 ahb_cov3 ahb_cov4 ahb_cov5 ahb_cov6 ahb_cov7 ahb_cov8 ahb_cov9 ahb_cov10 ahb_cov11 ahb_cov12 ahb_cov13 ahb_cov14 ahb_cov15 ahb_cov16 ahb_cov17 ahb_cov18
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html ahb_cov

regress_Questa: clean_Questa run_test_Questa run_test1_Questa run_test2_Questa run_test3_Questa run_test4_Questa run_test5_Questa run_test6_Questa run_test7_Questa run_test8_Questa run_test9_Questa run_test10_Questa run_test11_Questa run_test12_Questa run_test13_Questa run_test14_Questa run_test15_Questa run_test16_Questa run_test17_Questa report_Questa cov_Questa

cov_Questa:
        firefox covhtmlreport/index.html&

clean_Questa:
        rm -rf transcript* *log* fcover* covhtml* ahb_cov* *.wlf modelsim.ini work
        clear

# ----------------------------- End of Definitions for Mentor's Questa Specific Targets -------------------------------#

# ----------------------------- Start of Definitions for Synopsys's VCS Specific Targets -------------------------------#

sv_cmp_VCS:
        vcs -l vcs.log -timescale=1ns/1ps -sverilog -ntb_opts uvm -debug_access+all -full64 -kdb -lca -P $(FSDB_PATH)/novas.tab $(FSDB_PATH)/pli.a $(INC) $(SV_IF) $(SV_PKG) $(SV_TOP)

run_test_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave1.fsdb -cm_dir ./ahb_cov1 +ntb_random_seed_automatic +UVM_TESTNAME=single_write_test
        urg -dir ahb_cov1.vdb -format both -report urgReport1

run_test1_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave2.fsdb -cm_dir ./ahb_cov2 +ntb_random_seed_automatic +UVM_TESTNAME=single_read_test
        urg -dir ahb_cov2.vdb -format both -report urgReport2

run_test2_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave3.fsdb -cm_dir ./ahb_cov3 +ntb_random_seed_automatic +UVM_TESTNAME=incr16_test
        urg -dir ahb_cov3.vdb -format both -report urgReport3

run_test3_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave4.fsdb -cm_dir ./ahb_cov4 +ntb_random_seed_automatic +UVM_TESTNAME=random_constrained_test
        urg -dir ahb_cov4.vdb -format both -report urgReport4

run_test4_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave5.fsdb -cm_dir ./ahb_cov5 +ntb_random_seed_automatic +UVM_TESTNAME=back_to_back_write_test
        urg -dir ahb_cov5.vdb -format both -report urgReport5

run_test5_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave6.fsdb -cm_dir ./ahb_cov6 +ntb_random_seed_automatic +UVM_TESTNAME=back_to_back_read_test
        urg -dir ahb_cov6.vdb -format both -report urgReport6

run_test6_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave7.fsdb -cm_dir ./ahb_cov7 +ntb_random_seed_automatic +UVM_TESTNAME=mixed_read_write_test
        urg -dir ahb_cov7.vdb -format both -report urgReport7

run_test7_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave8.fsdb -cm_dir ./ahb_cov8 +ntb_random_seed_automatic +UVM_TESTNAME=incr_test
        urg -dir ahb_cov8.vdb -format both -report urgReport8

run_test8_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave9.fsdb -cm_dir ./ahb_cov9 +ntb_random_seed_automatic +UVM_TESTNAME=incr4_test
        urg -dir ahb_cov9.vdb -format both -report urgReport9

run_test9_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave10.fsdb -cm_dir ./ahb_cov10 +ntb_random_seed_automatic +UVM_TESTNAME=incr8_test
        urg -dir ahb_cov10.vdb -format both -report urgReport10

run_test10_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave11.fsdb -cm_dir ./ahb_cov11 +ntb_random_seed_automatic +UVM_TESTNAME=wrap4_test
        urg -dir ahb_cov11.vdb -format both -report urgReport11

run_test11_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave12.fsdb -cm_dir ./ahb_cov12 +ntb_random_seed_automatic +UVM_TESTNAME=wrap8_test
        urg -dir ahb_cov12.vdb -format both -report urgReport12

run_test12_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave13.fsdb -cm_dir ./ahb_cov13 +ntb_random_seed_automatic +UVM_TESTNAME=wrap16_test
        urg -dir ahb_cov13.vdb -format both -report urgReport13

run_test13_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave14.fsdb -cm_dir ./ahb_cov14 +ntb_random_seed_automatic +UVM_TESTNAME=invalid_address_test
        urg -dir ahb_cov14.vdb -format both -report urgReport14

run_test14_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave15.fsdb -cm_dir ./ahb_cov15 +ntb_random_seed_automatic +UVM_TESTNAME=busy_transfer_test
        urg -dir ahb_cov15.vdb -format both -report urgReport15

run_test15_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave16.fsdb -cm_dir ./ahb_cov16 +ntb_random_seed_automatic +UVM_TESTNAME=idle_transfer_test
        urg -dir ahb_cov16.vdb -format both -report urgReport16

run_test16_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave17.fsdb -cm_dir ./ahb_cov17 +ntb_random_seed_automatic +UVM_TESTNAME=wait_state_test
        urg -dir ahb_cov17.vdb -format both -report urgReport17

run_test17_VCS: clean sv_cmp_VCS
        ./simv -a vcs.log +fsdbfile+wave18.fsdb -cm_dir ./ahb_cov18 +ntb_random_seed_automatic +UVM_TESTNAME=error_response_test
        urg -dir ahb_cov18.vdb -format both -report urgReport18

report_VCS:
        urg -dir ahb_cov1.vdb ahb_cov2.vdb ahb_cov3.vdb ahb_cov4.vdb ahb_cov5.vdb ahb_cov6.vdb ahb_cov7.vdb ahb_cov8.vdb ahb_cov9.vdb ahb_cov10.vdb ahb_cov11.vdb ahb_cov12.vdb ahb_cov13.vdb ahb_cov14.vdb ahb_cov15.vdb ahb_cov16.vdb ahb_cov17.vdb ahb_cov18.vdb -dbname merged_dir/merged_test -format both -report urgReport

regress_VCS: clean_VCS sv_cmp_VCS run_test_VCS run_test1_VCS run_test2_VCS run_test3_VCS run_test4_VCS run_test5_VCS run_test6_VCS run_test7_VCS run_test8_VCS run_test9_VCS run_test10_VCS run_test11_VCS run_test12_VCS run_test13_VCS run_test14_VCS run_test15_VCS run_test16_VCS run_test17_VCS report_VCS

cov_VCS:
        verdi -cov -covdir merged_dir.vdb

clean_VCS:
        rm -rf simv* csrc* *.tmp *.vpd *.vdb *.key *.log *hdrs.h urgReport* *.fsdb novas* verdi*
        clear

# ----------------------------- END of Definitions for Synopsys's VCS Specific Targets -------------------------------#
