`ifndef TEST_PKG_SV
`define TEST_PKG_SV

package test_pkg;

    //=========================================================
    // UVM Package
    //=========================================================

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    //=========================================================
    // AHB Package
    //=========================================================

    import ahb_pkg::*;

    //=========================================================
    // Base Test
    //=========================================================

    `include "base_test.sv"

    //=========================================================
    // Individual Tests
    //=========================================================

    class single_write_test extends base_test;
        `uvm_component_utils(single_write_test)

        function new(string name = "single_write_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            single_write_sequence  m_seq;
            slave_default_sequence s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = single_write_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class single_read_test extends base_test;
        `uvm_component_utils(single_read_test)

        function new(string name = "single_read_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            single_read_sequence   m_seq;
            slave_default_sequence s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = single_read_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class back_to_back_write_test extends base_test;
        `uvm_component_utils(back_to_back_write_test)

        function new(string name = "back_to_back_write_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            back_to_back_write_sequence m_seq;
            slave_default_sequence      s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = back_to_back_write_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class back_to_back_read_test extends base_test;
        `uvm_component_utils(back_to_back_read_test)

        function new(string name = "back_to_back_read_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            back_to_back_read_sequence m_seq;
            slave_default_sequence     s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = back_to_back_read_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class mixed_read_write_test extends base_test;
        `uvm_component_utils(mixed_read_write_test)

        function new(string name = "mixed_read_write_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            mixed_read_write_sequence m_seq;
            slave_default_sequence    s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = mixed_read_write_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class incr_test extends base_test;
        `uvm_component_utils(incr_test)

        function new(string name = "incr_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            incr_sequence          m_seq;
            slave_default_sequence s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = incr_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class incr4_test extends base_test;
        `uvm_component_utils(incr4_test)

        function new(string name = "incr4_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            incr4_sequence         m_seq;
            slave_default_sequence s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = incr4_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class incr8_test extends base_test;
        `uvm_component_utils(incr8_test)

        function new(string name = "incr8_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            incr8_sequence         m_seq;
            slave_default_sequence s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = incr8_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class incr16_test extends base_test;
        `uvm_component_utils(incr16_test)

        function new(string name = "incr16_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            incr16_sequence        m_seq;
            slave_default_sequence s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = incr16_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class wrap4_test extends base_test;
        `uvm_component_utils(wrap4_test)

        function new(string name = "wrap4_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            wrap4_sequence         m_seq;
            slave_default_sequence s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = wrap4_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class wrap8_test extends base_test;
        `uvm_component_utils(wrap8_test)

        function new(string name = "wrap8_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            wrap8_sequence         m_seq;
            slave_default_sequence s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = wrap8_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class wrap16_test extends base_test;
        `uvm_component_utils(wrap16_test)

        function new(string name = "wrap16_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            wrap16_sequence        m_seq;
            slave_default_sequence s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = wrap16_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class invalid_address_test extends base_test;
        `uvm_component_utils(invalid_address_test)

        function new(string name = "invalid_address_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            invalid_address_sequence m_seq;
            slave_default_sequence   s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = invalid_address_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class busy_transfer_test extends base_test;
        `uvm_component_utils(busy_transfer_test)

        function new(string name = "busy_transfer_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            busy_transfer_sequence m_seq;
            slave_default_sequence s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = busy_transfer_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class idle_transfer_test extends base_test;
        `uvm_component_utils(idle_transfer_test)

        function new(string name = "idle_transfer_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            idle_transfer_sequence m_seq;
            slave_default_sequence s_seq;
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = idle_transfer_sequence::type_id::create("m_seq");
            s_seq = slave_default_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class wait_state_test extends base_test;
        `uvm_component_utils(wait_state_test)

        function new(string name = "wait_state_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            wait_state_sequence       m_seq;
            slave_wait_state_sequence s_seq; // Slave correctly drives wait states here
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = wait_state_sequence::type_id::create("m_seq");
            s_seq = slave_wait_state_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class error_response_test extends base_test;
        `uvm_component_utils(error_response_test)

        function new(string name = "error_response_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            error_response_sequence       m_seq;
            slave_error_response_sequence s_seq; // Slave correctly drives error response here
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = error_response_sequence::type_id::create("m_seq");
            s_seq = slave_error_response_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass


    class random_constrained_test extends base_test;
        `uvm_component_utils(random_constrained_test)

        function new(string name = "random_constrained_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
            random_constrained_sequence m_seq;
            slave_random_sequence       s_seq; // Slave responds randomly
            
            phase.raise_objection(this);
            phase.phase_done.set_drain_time(this, 20ns);
            
            m_seq = random_constrained_sequence::type_id::create("m_seq");
            s_seq = slave_random_sequence::type_id::create("s_seq");

            fork
                s_seq.start(env.s_agent.sequencer);
            join_none

            m_seq.start(env.m_agent.sequencer);
            
            phase.drop_objection(this);
        endtask
    endclass
endpackage

`endif