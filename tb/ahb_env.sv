`ifndef AHB_ENV_SV
`define AHB_ENV_SV

class ahb_env extends uvm_env;

    `uvm_component_utils(ahb_env)

    //=========================================================
    // Environment Components
    //=========================================================

    master_agent      m_agent;
    slave_agent       s_agent;

    ahb_scoreboard    scoreboard;
    ahb_coverage      coverage;

    //=========================================================
    // Configuration
    //=========================================================

    env_config e_cfg;

    //=========================================================
    // Constructor
    //=========================================================

    function new(string name = "ahb_env",
                 uvm_component parent = null);

        super.new(name, parent);

    endfunction

    //=========================================================
    // Build Phase
    //=========================================================

    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        //---------------------------------------------
        // Get Environment Configuration
        //---------------------------------------------

        if(!uvm_config_db #(env_config)::get(this,
                                             "",
                                             "env_config",
                                             e_cfg))
        begin
            `uvm_fatal(get_type_name(),
                       "Failed to get env_config")
        end

        //---------------------------------------------
        // Pass Configurations to Agents
        //---------------------------------------------

        uvm_config_db #(master_config)::set(this,
                                            "m_agent*",
                                            "master_config",
                                            e_cfg.m_cfg);

        uvm_config_db #(slave_config)::set(this,
                                           "s_agent*",
                                           "slave_config",
                                           e_cfg.s_cfg);

        //---------------------------------------------
        // Create Agents
        //---------------------------------------------

        m_agent = master_agent::type_id::create(
                    "m_agent", this);

        s_agent = slave_agent::type_id::create(
                    "s_agent", this);

        //---------------------------------------------
        // Optional Components
        //---------------------------------------------

        if(e_cfg.has_scoreboard)
        begin
            scoreboard = ahb_scoreboard::type_id::create(
                           "scoreboard", this);
        end

        if(e_cfg.has_coverage)
        begin
            coverage = ahb_coverage::type_id::create(
                         "coverage", this);
        end

    endfunction

    //=========================================================
    // Connect Phase
    //=========================================================

    virtual function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        //---------------------------------------------
        // Connect Scoreboard
        //---------------------------------------------

        if(scoreboard != null)
        begin

            if(m_agent.monitor != null)
            begin
                m_agent.monitor.analysis_port.connect(
                    scoreboard.master_fifo.analysis_export);
            end

            if(s_agent.monitor != null)
            begin
                s_agent.monitor.analysis_port.connect(
                    scoreboard.slave_fifo.analysis_export);
            end

        end

        //---------------------------------------------
        // Connect Coverage
        //---------------------------------------------

        if(coverage != null)
        begin

            if(m_agent.monitor != null)
            begin
                m_agent.monitor.analysis_port.connect(
                    coverage.analysis_export);
            end

        end

    endfunction

endclass

`endif