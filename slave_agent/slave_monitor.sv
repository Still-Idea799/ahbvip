`ifndef SLAVE_MONITOR_SV
`define SLAVE_MONITOR_SV

class slave_monitor extends uvm_monitor;

    `uvm_component_utils(slave_monitor)

    //=========================================================
    // Virtual Interface
    //=========================================================

    virtual ahb_if.SLAVE_MONITOR_MP vif;

    //=========================================================
    // Configuration Handle
    //=========================================================

    slave_config s_cfg;

    //=========================================================
    // Analysis Port
    //=========================================================

    uvm_analysis_port #(slave_transaction) analysis_port;

    //=========================================================
    // Constructor
    //=========================================================

    function new(string name = "slave_monitor",
                 uvm_component parent = null);

        super.new(name, parent);

        analysis_port = new("analysis_port", this);

    endfunction

    //=========================================================
    // Build Phase
    //=========================================================

    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db #(slave_config)::get(this,
                                              "",
                                              "slave_config",
                                              s_cfg))
        begin
            `uvm_fatal(get_type_name(),
                       "Failed to get slave_config")
        end

        vif = s_cfg.vif;

    endfunction

    //=========================================================
    // Run Phase
    //=========================================================

    virtual task run_phase(uvm_phase phase);

        slave_transaction tr;

        bit        have_prev;
        bit [31:0] prev_addr;
        bit [1:0]  prev_trans;
        bit        prev_write;

        forever begin

            @(vif.slave_monitor_cb);

            //---------------------------------------------
            // Ignore IDLE Transfers
            //---------------------------------------------

            if(vif.slave_monitor_cb.HTRANS == 2'b00)
                continue;

            //---------------------------------------------
            // BUSY cycles are asserted for exactly one
            // clock edge (no wait-state hold), so capture
            // them immediately.
            //---------------------------------------------

            if(vif.slave_monitor_cb.HTRANS == 2'b01) begin
                have_prev = 1'b0;  // next NONSEQ/SEQ is a fresh beat
            end
            else begin

                //-----------------------------------------
                // NONSEQ/SEQ: only capture once the transfer
                // actually completes (HREADY = 1), and skip
                // if it's the same beat already captured.
                //-----------------------------------------

                if(vif.slave_monitor_cb.HREADY !== 1'b1)
                    continue;

                if(have_prev &&
                   vif.slave_monitor_cb.HADDR  == prev_addr  &&
                   vif.slave_monitor_cb.HTRANS == prev_trans &&
                   vif.slave_monitor_cb.HWRITE == prev_write)
                    continue;

                prev_addr  = vif.slave_monitor_cb.HADDR;
                prev_trans = vif.slave_monitor_cb.HTRANS;
                prev_write = vif.slave_monitor_cb.HWRITE;
                have_prev  = 1'b1;

            end

            //---------------------------------------------
            // Capture Transaction
            //---------------------------------------------

            tr = slave_transaction::type_id::create("tr");

            tr.HADDR    = vif.slave_monitor_cb.HADDR;
            tr.HWRITE   = vif.slave_monitor_cb.HWRITE;
            tr.HTRANS   = vif.slave_monitor_cb.HTRANS;
            tr.HSIZE    = vif.slave_monitor_cb.HSIZE;
            tr.HBURST   = vif.slave_monitor_cb.HBURST;
            tr.HLENGTH  = vif.slave_monitor_cb.HLENGTH;

            tr.HWDATA   = vif.slave_monitor_cb.HWDATA;
            tr.HRDATA   = vif.slave_monitor_cb.HRDATA;

            tr.HREADY   = vif.slave_monitor_cb.HREADY;
            tr.HRESP    = vif.slave_monitor_cb.HRESP;

            //---------------------------------------------
            // Publish Transaction
            //---------------------------------------------

            analysis_port.write(tr);

            //---------------------------------------------
            // Monitor Log
            //---------------------------------------------

            `uvm_info(get_type_name(),
                      $sformatf("SLAVE MONITOR\n%s",
                      tr.convert2string()),
                      UVM_MEDIUM)

        end

    endtask

endclass

`endif