`ifndef SLAVE_DRIVER_SV
`define SLAVE_DRIVER_SV

class slave_driver extends uvm_driver #(slave_transaction);

    `uvm_component_utils(slave_driver)

    //=========================================================
    // Virtual Interface
    //=========================================================

    virtual ahb_if.SLAVE_DRIVER_MP vif;

    //=========================================================
    // Configuration Handle
    //=========================================================

    slave_config s_cfg;

    //=========================================================
    // Constructor
    //=========================================================

    function new(string name = "slave_driver",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    //=========================================================
    // Build Phase
    //=========================================================

    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db#(slave_config)::get(this,
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

        wait_for_reset();

        forever begin

            seq_item_port.get_next_item(req);

            drive_response(req);

            seq_item_port.item_done();

        end

    endtask

    //=========================================================
    // Wait for Reset De-assertion
    //=========================================================

    task wait_for_reset();

        // Default Slave Response During Reset
        vif.slave_driver_cb.HREADY <= 1'b1;
        vif.slave_driver_cb.HRESP  <= 2'b00;
        vif.slave_driver_cb.HRDATA <= '0;

        wait(vif.HRESETn);

        @(vif.slave_driver_cb);

    endtask

    //=========================================================
    // Drive Slave Response
    //=========================================================

    task drive_response(slave_transaction tr);

        //---------------------------------------------
        // Wait until Master starts a valid transfer
        //---------------------------------------------

        do begin
            @(vif.slave_driver_cb);
        end
        while(vif.slave_driver_cb.HTRANS inside {2'b00,2'b01});

        //---------------------------------------------
        // Wait State Generation
        //---------------------------------------------

        vif.slave_driver_cb.HREADY <= tr.HREADY;

        if(tr.HREADY == 1'b0) begin

            @(vif.slave_driver_cb);

            // Release Wait State
            vif.slave_driver_cb.HREADY <= 1'b1;

        end

        //---------------------------------------------
        // Response Generation
        //---------------------------------------------

        vif.slave_driver_cb.HRESP <= tr.HRESP;

        //---------------------------------------------
        // Read Data Generation
        //---------------------------------------------

        if(vif.slave_driver_cb.HWRITE == 1'b0)
            vif.slave_driver_cb.HRDATA <= tr.HRDATA;

        //---------------------------------------------
        // Driver Log
        //---------------------------------------------

        `uvm_info(get_type_name(),
                  $sformatf("SLAVE DRIVER\n%s",
                  tr.convert2string()),
                  UVM_MEDIUM)

    endtask

endclass

`endif