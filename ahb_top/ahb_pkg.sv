`ifndef AHB_PKG_SV
`define AHB_PKG_SV

package ahb_pkg;

    //=========================================================
    // 1. UVM Package (MUST BE FIRST)
    //=========================================================

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    //=========================================================
    // 2. Configuration Classes
    //=========================================================

    `include "master_config.sv"
    `include "slave_config.sv"
    `include "env_config.sv"

    //=========================================================
    // 3. Transaction Classes
    //=========================================================

    `include "master_transaction.sv"
    `include "slave_transaction.sv"

    //=========================================================
    // 4. Sequencers
    //=========================================================

    `include "master_sequencer.sv"
    `include "slave_sequencer.sv"

    //=========================================================
    // 5. Sequences
    //=========================================================

    `include "master_sequences.sv"
    `include "slave_sequences.sv"

    //=========================================================
    // 6. Drivers
    //=========================================================

    `include "master_driver.sv"
    `include "slave_driver.sv"

    //=========================================================
    // 7. Monitors
    //=========================================================

    `include "master_monitor.sv"
    `include "slave_monitor.sv"

    //=========================================================
    // 8. Agents
    //=========================================================

    `include "master_agent.sv"
    `include "slave_agent.sv"

    //=========================================================
    // 9. Environment Components
    //=========================================================

    `include "ahb_scoreboard.sv"
    `include "ahb_coverage.sv"
    `include "ahb_env.sv"

endpackage

`endif
