`ifndef MASTER_SEQUENCER_SV
`define MASTER_SEQUENCER_SV

class master_sequencer extends uvm_sequencer #(master_transaction);

    `uvm_component_utils(master_sequencer)

    //=========================================================
    // Constructor
    //=========================================================

    function new(string name = "master_sequencer",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    //=========================================================
    // Build Phase
    //=========================================================

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    //=========================================================
    // Connect Phase
    //=========================================================

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    //=========================================================
    // End of Elaboration Phase
    //=========================================================

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction

endclass

`endif