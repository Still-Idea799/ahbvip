`ifndef MASTER_DRIVER_SV
`define MASTER_DRIVER_SV

class master_driver extends uvm_driver #(master_transaction);

    `uvm_component_utils(master_driver)

    //=========================================================
    // Virtual Interface
    //=========================================================

    virtual ahb_if.MASTER_DRIVER_MP vif;

    //=========================================================
    // Configuration Handle
    //=========================================================

    master_config m_cfg;

    //=========================================================
    // Constructor
    //=========================================================

    function new(string name = "master_driver",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    //=========================================================
    // Build Phase
    //=========================================================

    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db#(master_config)::get(this,
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

        wait_for_reset();

        forever begin

            seq_item_port.get_next_item(req);

            drive_transfer(req);

            seq_item_port.item_done();

        end

    endtask

    //=========================================================
    // Wait for Reset De-assertion
    //=========================================================

    task wait_for_reset();

        // Drive Idle Bus During Reset
        vif.master_driver_cb.HADDR    <= '0;
        vif.master_driver_cb.HWDATA   <= '0;
        vif.master_driver_cb.HWRITE   <= 1'b0;
        vif.master_driver_cb.HTRANS   <= 2'b00;
        vif.master_driver_cb.HSIZE    <= '0;
        vif.master_driver_cb.HBURST   <= '0;
        vif.master_driver_cb.HLENGTH  <= '0;

        wait(vif.HRESETn);

        @(vif.master_driver_cb);

    endtask

    //=========================================================
    // Drive Transfer
    //=========================================================

    task drive_transfer(master_transaction tr);

        case(tr.HTRANS)

            //---------------------------------------------
            // IDLE
            //---------------------------------------------

            2'b00:
                drive_idle();

            //---------------------------------------------
            // BUSY
            //---------------------------------------------

            2'b01:
                drive_busy(tr);

            //---------------------------------------------
            // NONSEQ / SEQ
            //---------------------------------------------

            2'b10,
            2'b11:
                drive_data_transfer(tr);

            default:
                drive_idle();

        endcase

    endtask

    //=========================================================
    // Drive Idle Transfer
    //=========================================================

    task drive_idle();

        @(vif.master_driver_cb);

        vif.master_driver_cb.HTRANS <= 2'b00;

    endtask

    //=========================================================
    // Drive Busy Transfer
    //=========================================================

    task drive_busy(master_transaction tr);

        @(vif.master_driver_cb);

        vif.master_driver_cb.HTRANS <= 2'b01;

    endtask

    //=========================================================
    // Drive Read / Write Transfer
    //=========================================================

    task drive_data_transfer(master_transaction tr);
        
        // 1. Address Phase
        @(vif.master_driver_cb);
        vif.master_driver_cb.HADDR    <= tr.HADDR;
        vif.master_driver_cb.HWRITE   <= tr.HWRITE;
        vif.master_driver_cb.HTRANS   <= tr.HTRANS;
        vif.master_driver_cb.HSIZE    <= tr.HSIZE;
        vif.master_driver_cb.HBURST   <= tr.HBURST;
        vif.master_driver_cb.HLENGTH  <= tr.HLENGTH;

        // 2. Data Phase (Begins on next clock edge)
        @(vif.master_driver_cb);
        
        // Drive write data if applicable
        if(tr.HWRITE) begin
            vif.master_driver_cb.HWDATA <= tr.HWDATA;
        end

        // Wait for Slave to drop Wait States
        while(vif.master_driver_cb.HREADY == 1'b0) begin
            @(vif.master_driver_cb);
        end

        // Capture read data and response
        if(!tr.HWRITE) begin
            tr.HRDATA = vif.master_driver_cb.HRDATA;
        end
        tr.HREADY = vif.master_driver_cb.HREADY;
        tr.HRESP  = vif.master_driver_cb.HRESP;

        `uvm_info(get_type_name(), $sformatf("MASTER DRIVER\n%s", tr.convert2string()), UVM_MEDIUM)
    endtask

endclass

`endif