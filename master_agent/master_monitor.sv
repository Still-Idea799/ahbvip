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

        forever begin

            @(vif.master_monitor_cb);

            //---------------------------------------------
            // Ignore anything sampled before/during reset -
            // interface signals are X at this point, and
            // assigning X into 2-state latch variables below
            // silently coerces to 0, producing a phantom
            // all-zero "transaction" that isn't real.
            //---------------------------------------------

            if(!vif.HRESETn)
                continue;

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

                analysis_port.write(tr);

                `uvm_info(get_type_name(),
                          $sformatf("MASTER MONITOR\n%s",
                          tr.convert2string()),
                          UVM_MEDIUM)

                continue;

            end

            //---------------------------------------------
            // NONSEQ/SEQ: this edge is the address phase.
            // Latch the address-phase fields now, then
            // mirror the driver's own timing - it always
            // takes one further, unconditional clock edge
            // (the data phase) before driving HWDATA or
            // checking HREADY - so HWDATA/HRDATA are not
            // yet valid on this same edge. Advance one edge
            // first, THEN poll HREADY for any wait states,
            // and only capture once the transfer completes.
            //---------------------------------------------

            begin

                bit [31:0] addr_l   = vif.master_monitor_cb.HADDR;
                bit        write_l  = vif.master_monitor_cb.HWRITE;
                bit [1:0]  trans_l  = vif.master_monitor_cb.HTRANS;
                bit [2:0]  size_l   = vif.master_monitor_cb.HSIZE;
                bit [2:0]  burst_l  = vif.master_monitor_cb.HBURST;
                bit [4:0]  length_l = vif.master_monitor_cb.HLENGTH;

                // Mandatory data-phase edge (mirrors the driver)
                @(vif.master_monitor_cb);

                // Wait out any additional slave wait states
                while(vif.master_monitor_cb.HREADY !== 1'b1)
                    @(vif.master_monitor_cb);

                tr = master_transaction::type_id::create("tr");

                tr.HADDR    = addr_l;
                tr.HWRITE   = write_l;
                tr.HTRANS   = trans_l;
                tr.HSIZE    = size_l;
                tr.HBURST   = burst_l;
                tr.HLENGTH  = length_l;

                tr.HWDATA   = vif.master_monitor_cb.HWDATA;
                tr.HRDATA   = vif.master_monitor_cb.HRDATA;
                tr.HREADY   = vif.master_monitor_cb.HREADY;
                tr.HRESP    = vif.master_monitor_cb.HRESP;

                analysis_port.write(tr);

                `uvm_info(get_type_name(),
                          $sformatf("MASTER MONITOR\n%s",
                          tr.convert2string()),
                          UVM_MEDIUM)

            end

        end

    endtask

endclass

`endif