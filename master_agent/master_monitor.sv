`ifndef MASTER_MONITOR_SV
`define MASTER_MONITOR_SV

class master_monitor extends uvm_monitor;

    `uvm_component_utils(master_monitor)

    //=========================================================
    // Virtual Interface
    //=========================================================

    virtual ahb_if.MASTER_MONITOR_MP vif;

    //=========================================================
    // Configuration Handle
    //=========================================================

    master_config m_cfg;

    //=========================================================
    // Analysis Port
    //=========================================================

    uvm_analysis_port #(master_transaction) analysis_port;

    //=========================================================
    // Constructor
    //=========================================================

    function new(string name = "master_monitor",
                 uvm_component parent = null);

        super.new(name, parent);

        analysis_port = new("analysis_port", this);

    endfunction

    //=========================================================
    // Build Phase
    //=========================================================

    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db #(master_config)::get(this,
                                               "",
                                               "master_config",
                                               m_cfg))
        begin
            `uvm_fatal(get_type_name(),
                       "Failed to get master_config")
        end

        vif = m_cfg.vif;

    endfunction

    //=========================================================
    // Run Phase
    //=========================================================

    virtual task run_phase(uvm_phase phase);

        master_transaction tr;

        bit        have_prev;
        bit [31:0] prev_addr;
        bit [1:0]  prev_trans;
        bit        prev_write;

        forever begin

            @(vif.master_monitor_cb);

            //---------------------------------------------
            // Ignore IDLE Transfers
            //---------------------------------------------

            if(vif.master_monitor_cb.HTRANS == 2'b00)
                continue;

            //---------------------------------------------
            // BUSY cycles are asserted for exactly one
            // clock edge by the driver (no wait-state hold),
            // so capture them immediately - they carry no
            // address-phase data to de-duplicate against.
            //---------------------------------------------

            if(vif.master_monitor_cb.HTRANS == 2'b01) begin
                have_prev = 1'b0;  // next NONSEQ/SEQ is a fresh beat
            end
            else begin

                //-----------------------------------------
                // NONSEQ/SEQ: only capture once the transfer
                // actually completes (HREADY = 1). The driver
                // may hold HADDR/HTRANS asserted across more
                // than one clock edge (address phase + data/
                // wait-state phase), so sampling on every edge
                // here would record the same logical transfer
                // more than once.
                //-----------------------------------------

                if(vif.master_monitor_cb.HREADY !== 1'b1)
                    continue;

                //-----------------------------------------
                // De-duplicate: skip if this is the same beat
                // (same HADDR/HTRANS/HWRITE) we already
                // captured and published last time
                //-----------------------------------------

                if(have_prev &&
                   vif.master_monitor_cb.HADDR  == prev_addr  &&
                   vif.master_monitor_cb.HTRANS == prev_trans &&
                   vif.master_monitor_cb.HWRITE == prev_write)
                    continue;

                prev_addr  = vif.master_monitor_cb.HADDR;
                prev_trans = vif.master_monitor_cb.HTRANS;
                prev_write = vif.master_monitor_cb.HWRITE;
                have_prev  = 1'b1;

            end

            //---------------------------------------------
            // Capture Transaction
            //---------------------------------------------

            tr = master_transaction::type_id::create("tr");

            tr.HADDR    = vif.master_monitor_cb.HADDR;
            tr.HWRITE   = vif.master_monitor_cb.HWRITE;
            tr.HTRANS   = vif.master_monitor_cb.HTRANS;
            tr.HSIZE    = vif.master_monitor_cb.HSIZE;
            tr.HBURST   = vif.master_monitor_cb.HBURST;
            tr.HLENGTH  = vif.master_monitor_cb.HLENGTH;

            tr.HWDATA   = vif.master_monitor_cb.HWDATA;
            tr.HRDATA   = vif.master_monitor_cb.HRDATA;

            tr.HREADY   = vif.master_monitor_cb.HREADY;
            tr.HRESP    = vif.master_monitor_cb.HRESP;

            //---------------------------------------------
            // Publish Transaction
            //---------------------------------------------

            analysis_port.write(tr);

            //---------------------------------------------
            // Monitor Log
            //---------------------------------------------

            `uvm_info(get_type_name(),
                      $sformatf("MASTER MONITOR\n%s",
                      tr.convert2string()),
                      UVM_MEDIUM)

        end

    endtask

endclass

`endif