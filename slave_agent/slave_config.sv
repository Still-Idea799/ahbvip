`ifndef SLAVE_CONFIG_SV
`define SLAVE_CONFIG_SV

class slave_config extends uvm_object;

    `uvm_object_utils(slave_config)

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

    function new(string name = "slave_config");
        super.new(name);
    endfunction

endclass

`endif