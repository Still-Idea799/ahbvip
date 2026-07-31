`ifndef BASE_TEST_SV
`define BASE_TEST_SV

class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    //=========================================================
    // Environment
    //=========================================================

    ahb_env env;

    //=========================================================
    // Configuration Objects
    //=========================================================

    env_config    e_cfg;
    master_config m_cfg;
    slave_config  s_cfg;

    //=========================================================
    // Constructor
    //=========================================================

    function new(string name = "base_test",
                 uvm_component parent = null);

        super.new(name, parent);

    endfunction

    //=========================================================
    // Build Phase
    //=========================================================

    virtual function void build_phase(uvm_phase phase);

        virtual ahb_if vif;

        super.build_phase(phase);

        //---------------------------------------------
        // Create Configuration Objects
        //---------------------------------------------

        e_cfg = env_config   ::type_id::create("e_cfg");
        m_cfg = master_config::type_id::create("m_cfg");
        s_cfg = slave_config ::type_id::create("s_cfg");

        //---------------------------------------------
        // Retrieve Virtual Interface (set by tb_top) and
        // thread it into both agent configs
        //---------------------------------------------

        if(!uvm_config_db #(virtual ahb_if)::get(this,
                                                  "",
                                                  "vif",
                                                  vif))
        begin
            `uvm_fatal(get_type_name(),
                       "Failed to get vif from config_db")
        end

        m_cfg.vif = vif;
        s_cfg.vif = vif;

        //---------------------------------------------
        // Configure Environment
        //---------------------------------------------

        e_cfg.m_cfg = m_cfg;
        e_cfg.s_cfg = s_cfg;

        //---------------------------------------------
        // Set Configuration
        //---------------------------------------------

        uvm_config_db #(env_config)::set(this,
                                         "*",
                                         "env_config",
                                         e_cfg);

        //---------------------------------------------
        // Create Environment
        //---------------------------------------------

        env = ahb_env::type_id::create("env", this);

    endfunction

    //=========================================================
    // End of Elaboration Phase
    //=========================================================

    virtual function void end_of_elaboration_phase(uvm_phase phase);

        super.end_of_elaboration_phase(phase);

        //---------------------------------------------
        // Print UVM Topology
        //---------------------------------------------

        uvm_top.print_topology();

    endfunction

    //=========================================================
    // Run Phase
    //=========================================================

    virtual task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        `uvm_info(get_type_name(),
                  "Starting Base Test",
                  UVM_LOW)

        #100ns;

        phase.drop_objection(this);

    endtask

    //=========================================================
    // Report Phase
    //=========================================================

    virtual function void report_phase(uvm_phase phase);

        super.report_phase(phase);

        `uvm_info(get_type_name(),
                  "Base Test Completed",
                  UVM_NONE)

    endfunction

endclass

`endif