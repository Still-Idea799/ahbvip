`ifndef SLAVE_AGENT_SV
`define SLAVE_AGENT_SV

class slave_agent extends uvm_agent;

    `uvm_component_utils(slave_agent)

    //=========================================================
    // Components
    //=========================================================

    slave_sequencer sequencer;
    slave_driver    driver;
    slave_monitor   monitor;

    //=========================================================
    // Configuration Handle
    //=========================================================

    slave_config s_cfg;

    //=========================================================
    // Constructor
    //=========================================================

    function new(string name = "slave_agent",
                 uvm_component parent = null);
        super.new(name, parent);
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

        //---------------------------------------------
        // Monitor
        //---------------------------------------------

        if(s_cfg.has_monitor)
        begin
            monitor = slave_monitor::type_id::create(
                        "monitor", this);
        end

        //---------------------------------------------
        // Driver & Sequencer
        //---------------------------------------------

        if(s_cfg.is_active == UVM_ACTIVE)
        begin

            if(s_cfg.has_sequencer)
            begin
                sequencer = slave_sequencer::type_id::create(
                              "sequencer", this);
            end

            if(s_cfg.has_driver)
            begin
                driver = slave_driver::type_id::create(
                           "driver", this);
            end

        end

    endfunction

    //=========================================================
    // Connect Phase
    //=========================================================

    virtual function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        if(s_cfg.is_active == UVM_ACTIVE)
        begin

            if(driver != null && sequencer != null)
            begin
                driver.seq_item_port.connect(
                    sequencer.seq_item_export);
            end

        end

    endfunction

endclass

`endif