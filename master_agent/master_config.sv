`ifndef MASTER_CONFIG_SV
`define MASTER_CONFIG_SV

class master_config extends uvm_object;

    `uvm_object_utils(master_config)

    //=========================================================
    // Virtual Interface
    //=========================================================

    virtual ahb_if vif;

    //=========================================================
    // Configuration Parameters
    //=========================================================

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    bit has_driver    = 1;
    bit has_monitor   = 1;
    bit has_sequencer = 1;

    //=========================================================
    // Constructor
    //=========================================================

    function new(string name = "master_config");
        super.new(name);
    endfunction

endclass

`endif