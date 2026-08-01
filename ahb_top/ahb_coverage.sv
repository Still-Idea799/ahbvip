`ifndef AHB_COVERAGE_SV
`define AHB_COVERAGE_SV

class ahb_coverage extends uvm_subscriber #(master_transaction);

    `uvm_component_utils(ahb_coverage)

    //=========================================================
    // Transaction Handle
    //=========================================================

    master_transaction tr;

    //=========================================================
    // Covergroup
    //=========================================================

    covergroup ahb_cg;

        option.per_instance = 1;

        //---------------------------------------------
        // Transfer Type
        //---------------------------------------------

        cp_htrans : coverpoint tr.HTRANS {

            bins IDLE   = {2'b00};
            bins BUSY   = {2'b01};
            bins NONSEQ = {2'b10};
            bins SEQ    = {2'b11};

        }

        //---------------------------------------------
        // Read / Write
        //---------------------------------------------

        cp_hwrite : coverpoint tr.HWRITE {

            bins READ  = {1'b0};
            bins WRITE = {1'b1};

        }

        //---------------------------------------------
        // Transfer Size
        //---------------------------------------------

        cp_hsize : coverpoint tr.HSIZE {

            bins BYTE     = {3'b000};
            bins HALFWORD = {3'b001};
            bins WORD     = {3'b010};

        }

        //---------------------------------------------
        // Burst Type
        //---------------------------------------------

        cp_hburst : coverpoint tr.HBURST {

            bins SINGLE = {3'b000};
            bins INCR   = {3'b001};
            bins WRAP4  = {3'b010};
            bins INCR4  = {3'b011};
            bins WRAP8  = {3'b100};
            bins INCR8  = {3'b101};
            bins WRAP16 = {3'b110};
            bins INCR16 = {3'b111};

        }

        //---------------------------------------------
        // Response
        //---------------------------------------------

        cp_hresp : coverpoint tr.HRESP {

            bins OKAY  = {2'b00};
            bins ERROR = {2'b01};

        }

        //---------------------------------------------
        // Ready
        //---------------------------------------------

        cp_hready : coverpoint tr.HREADY {

            bins READY = {1'b1};
            bins WAIT  = {1'b0};

        }

        //---------------------------------------------
        // Burst Length
        //---------------------------------------------

        cp_hlength : coverpoint tr.HLENGTH {

            bins SINGLE = {1};

            bins SHORT  = {[2:4]};

            bins MEDIUM = {[5:8]};

            bins LONG   = {[9:16]};

        }

        //---------------------------------------------
        // Cross Coverage
        //---------------------------------------------

        cross_rw_burst  : cross cp_hwrite, cp_hburst;

        cross_rw_size   : cross cp_hwrite, cp_hsize;

        cross_resp_rw   : cross cp_hresp, cp_hwrite;

        cross_trans_rsp : cross cp_htrans, cp_hresp {

            // IDLE/BUSY cycles don't carry a meaningful "response" -
            // HRESP only has real significance for the data phase of
            // a completed NONSEQ/SEQ transfer. Forcing these bins would
            // mean artificially pairing an ERROR response with a cycle
            // that isn't actually being responded to.
            ignore_bins non_meaningful =
                binsof(cp_htrans) intersect {2'b00, 2'b01} &&
                binsof(cp_hresp)  intersect {2'b01};

        }

    endgroup

    //=========================================================
    // Constructor
    //=========================================================

    function new(string name = "ahb_coverage",
                 uvm_component parent = null);

        super.new(name, parent);

        ahb_cg = new();

    endfunction

    //=========================================================
    // Write Method
    //=========================================================

    virtual function void write(master_transaction t);

        tr = t;

        ahb_cg.sample();

    endfunction

    //=========================================================
    // Report Phase
    //=========================================================

virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), $sformatf("\n=========================================\nAHB FUNCTIONAL COVERAGE\n=========================================\nCoverage = %0.2f %%\n=========================================", ahb_cg.get_coverage()), UVM_NONE)
    endfunction

endclass

`endif
