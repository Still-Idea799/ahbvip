`ifndef ENV_CONFIG_SV
`define ENV_CONFIG_SV

class env_config extends uvm_object;

    `uvm_object_utils(env_config)

    //=========================================================
    // Agent Configurations
    //=========================================================

    master_config m_cfg;
    slave_config  s_cfg;

    //=========================================================
    // Environment Configuration Parameters
    //=========================================================

    bit has_scoreboard = 1;
    bit has_coverage   = 1;

    //=========================================================
    // Constructor
    //=========================================================

    function new(string name = "env_config");
        super.new(name);

        m_cfg = master_config::type_id::create("m_cfg");
        s_cfg = slave_config::type_id::create("s_cfg");
    endfunction

endclass

`endif