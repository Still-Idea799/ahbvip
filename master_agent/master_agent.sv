`ifndef MASTER_AGENT_SV
`define MASTER_AGENT_SV

class master_agent extends uvm_agent;

    `uvm_component_utils(master_agent)

    //=========================================================
    // Components
    //=========================================================

    master_sequencer sequencer;
    master_driver    driver;
    master_monitor   monitor;

    //=========================================================
    // Configuration Handle
    //=========================================================

    master_config m_cfg;

    //=========================================================
    // Constructor
    //=========================================================

    function new(string name = "master_agent",
                 uvm_component parent = null);
        super.new(name, parent);
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

        //---------------------------------------------
        // Monitor
        //---------------------------------------------

        if(m_cfg.has_monitor)
        begin
            monitor = master_monitor::type_id::create(
                        "monitor", this);
        end

        //---------------------------------------------
        // Driver & Sequencer
        //---------------------------------------------

        if(m_cfg.is_active == UVM_ACTIVE)
        begin

            if(m_cfg.has_sequencer)
            begin
                sequencer = master_sequencer::type_id::create(
                              "sequencer", this);
            end

            if(m_cfg.has_driver)
            begin
                driver = master_driver::type_id::create(
                           "driver", this);
            end

        end

    endfunction

    //=========================================================
    // Connect Phase
    //=========================================================

    virtual function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        if(m_cfg.is_active == UVM_ACTIVE)
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