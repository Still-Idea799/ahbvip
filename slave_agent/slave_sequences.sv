`ifndef SLAVE_SEQUENCES_SV
`define SLAVE_SEQUENCES_SV

//=========================================================
// Base Slave Sequence
//=========================================================

class slave_base_sequence extends uvm_sequence #(slave_transaction);

    `uvm_object_utils(slave_base_sequence)

    slave_transaction req;

    function new(string name = "slave_base_sequence");
        super.new(name);
    endfunction

    virtual task pre_body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
    endtask

    virtual task post_body();
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask

endclass


//=========================================================
// Default Slave Response Sequence
//=========================================================

class slave_default_sequence extends slave_base_sequence;

    `uvm_object_utils(slave_default_sequence)

    function new(string name = "slave_default_sequence");
        super.new(name);
    endfunction

    virtual task body();

        forever begin

            req = slave_transaction::type_id::create("req");

            start_item(req);

            assert(req.randomize() with {

                HREADY == 1'b1;
                HRESP  == 2'b00;

            });

            finish_item(req);

        end

    endtask

endclass


//=========================================================
// Wait State Response Sequence
//=========================================================

class slave_wait_state_sequence extends slave_base_sequence;

    `uvm_object_utils(slave_wait_state_sequence)

    function new(string name = "slave_wait_state_sequence");
        super.new(name);
    endfunction

    virtual task body();

        req = slave_transaction::type_id::create("req");

        start_item(req);

        assert(req.randomize() with {

            HREADY == 1'b0;
            HRESP  == 2'b00;

        });

        finish_item(req);

    endtask

endclass


//=========================================================
// Error Response Sequence
//=========================================================

class slave_error_response_sequence extends slave_base_sequence;

    `uvm_object_utils(slave_error_response_sequence)

    function new(string name = "slave_error_response_sequence");
        super.new(name);
    endfunction

    virtual task body();

        req = slave_transaction::type_id::create("req");

        start_item(req);

        assert(req.randomize() with {

            HREADY == 1'b1;
            HRESP  == 2'b01;

        });

        finish_item(req);

    endtask

endclass


//=========================================================
// Random Slave Response Sequence
//=========================================================

class slave_random_sequence extends slave_base_sequence;

    `uvm_object_utils(slave_random_sequence)

    function new(string name = "slave_random_sequence");
        super.new(name);
    endfunction

    virtual task body();

        repeat (20) begin

            req = slave_transaction::type_id::create("req");

            start_item(req);

            assert(req.randomize() with {

                HREADY dist {
                    1'b1 := 80,
                    1'b0 := 20
                };

                HRESP dist {
                    2'b00 := 90,
                    2'b01 := 10
                };

            });

            finish_item(req);

        end

    endtask

endclass

`endif