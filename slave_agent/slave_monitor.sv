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

        forever begin

            @(vif.slave_monitor_cb);

            //---------------------------------------------
            // Ignore IDLE Transfers
            //---------------------------------------------

            if(vif.slave_monitor_cb.HTRANS == 2'b00)
                continue;

            //---------------------------------------------
            // BUSY cycles are asserted for exactly one
            // clock edge by the driver (no wait-state hold),
            // so capture them immediately.
            //---------------------------------------------

            if(vif.slave_monitor_cb.HTRANS == 2'b01) begin

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

                analysis_port.write(tr);

                `uvm_info(get_type_name(),
                          $sformatf("SLAVE MONITOR\n%s",
                          tr.convert2string()),
                          UVM_MEDIUM)

                continue;

            end

            //---------------------------------------------
            // NONSEQ/SEQ: this edge is the address phase.
            // Latch the address-phase fields now, then
            // mirror the driver's own timing - it always
            // takes one further, unconditional clock edge
            // (the data phase) before HWDATA/HRESP/HREADY
            // are valid for this beat. Advance one edge
            // first, THEN poll HREADY for any wait states,
            // and only capture once the transfer completes.
            //---------------------------------------------

            begin

                bit [31:0] addr_l   = vif.slave_monitor_cb.HADDR;
                bit        write_l  = vif.slave_monitor_cb.HWRITE;
                bit [1:0]  trans_l  = vif.slave_monitor_cb.HTRANS;
                bit [2:0]  size_l   = vif.slave_monitor_cb.HSIZE;
                bit [2:0]  burst_l  = vif.slave_monitor_cb.HBURST;
                bit [4:0]  length_l = vif.slave_monitor_cb.HLENGTH;

                // Mandatory data-phase edge (mirrors the driver)
                @(vif.slave_monitor_cb);

                // Wait out any additional slave wait states
                while(vif.slave_monitor_cb.HREADY !== 1'b1)
                    @(vif.slave_monitor_cb);

                tr = slave_transaction::type_id::create("tr");

                tr.HADDR    = addr_l;
                tr.HWRITE   = write_l;
                tr.HTRANS   = trans_l;
                tr.HSIZE    = size_l;
                tr.HBURST   = burst_l;
                tr.HLENGTH  = length_l;

                tr.HWDATA   = vif.slave_monitor_cb.HWDATA;
                tr.HRDATA   = vif.slave_monitor_cb.HRDATA;
                tr.HREADY   = vif.slave_monitor_cb.HREADY;
                tr.HRESP    = vif.slave_monitor_cb.HRESP;

                analysis_port.write(tr);

                `uvm_info(get_type_name(),
                          $sformatf("SLAVE MONITOR\n%s",
                          tr.convert2string()),
                          UVM_MEDIUM)

            end

        end

    endtask

endclass

`endif