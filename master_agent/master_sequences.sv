`ifndef MASTER_SEQUENCES_SV
`define MASTER_SEQUENCES_SV

//=========================================================
// Base Master Sequence
//=========================================================

class master_base_sequence extends uvm_sequence #(master_transaction);

    `uvm_object_utils(master_base_sequence)

    master_transaction req;

    function new(string name = "master_base_sequence");
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
// Single Write Sequence
//=========================================================

class single_write_sequence extends master_base_sequence;

    `uvm_object_utils(single_write_sequence)

    function new(string name = "single_write_sequence");
        super.new(name);
    endfunction

    virtual task body();

        req = master_transaction::type_id::create("req");

        start_item(req);

        assert(req.randomize() with {

            HWRITE  == 1'b1;

            HTRANS  == 2'b10;      // NONSEQ

            HBURST  == 3'b000;     // SINGLE

            HSIZE   == 3'b010;     // 32-bit

            HLENGTH == 1;

        });

        finish_item(req);

    endtask

endclass


//=========================================================
// Single Read Sequence
//=========================================================

class single_read_sequence extends master_base_sequence;

    `uvm_object_utils(single_read_sequence)

    function new(string name = "single_read_sequence");
        super.new(name);
    endfunction

    virtual task body();

        req = master_transaction::type_id::create("req");

        start_item(req);

        assert(req.randomize() with {

            HWRITE  == 1'b0;

            HTRANS  == 2'b10;      // NONSEQ

            HBURST  == 3'b000;     // SINGLE

            HSIZE   == 3'b010;     // 32-bit

            HLENGTH == 1;

        });

        finish_item(req);

    endtask

endclass
//=========================================================
// Back-to-Back Write Sequence
//=========================================================

class back_to_back_write_sequence extends master_base_sequence;

    `uvm_object_utils(back_to_back_write_sequence)

    function new(string name = "back_to_back_write_sequence");
        super.new(name);
    endfunction

    virtual task body();

        repeat (2) begin

            req = master_transaction::type_id::create("req");

            start_item(req);

            assert(req.randomize() with {

                HWRITE  == 1'b1;

                HTRANS  == 2'b10;      // NONSEQ

                HBURST  == 3'b000;     // SINGLE

                HSIZE   == 3'b010;     // 32-bit

                HLENGTH == 1;

            });

            finish_item(req);

        end

    endtask

endclass


//=========================================================
// Back-to-Back Read Sequence
//=========================================================

class back_to_back_read_sequence extends master_base_sequence;

    `uvm_object_utils(back_to_back_read_sequence)

    function new(string name = "back_to_back_read_sequence");
        super.new(name);
    endfunction

    virtual task body();

        repeat (2) begin

            req = master_transaction::type_id::create("req");

            start_item(req);

            assert(req.randomize() with {

                HWRITE  == 1'b0;

                HTRANS  == 2'b10;      // NONSEQ

                HBURST  == 3'b000;     // SINGLE

                HSIZE   == 3'b010;     // 32-bit

                HLENGTH == 1;

            });

            finish_item(req);

        end

    endtask

endclass


//=========================================================
// Mixed Read / Write Sequence
//=========================================================

class mixed_read_write_sequence extends master_base_sequence;

    `uvm_object_utils(mixed_read_write_sequence)

    function new(string name = "mixed_read_write_sequence");
        super.new(name);
    endfunction

    virtual task body();

        // Write Transaction
        req = master_transaction::type_id::create("write_req");

        start_item(req);

        assert(req.randomize() with {

            HWRITE  == 1'b1;

            HTRANS  == 2'b10;

            HBURST  == 3'b000;

            HSIZE   == 3'b010;

            HLENGTH == 1;

        });

        finish_item(req);


        // Read Transaction
        req = master_transaction::type_id::create("read_req");

        start_item(req);

        assert(req.randomize() with {

            HWRITE  == 1'b0;

            HTRANS  == 2'b10;

            HBURST  == 3'b000;

            HSIZE   == 3'b010;

            HLENGTH == 1;

        });

        finish_item(req);

    endtask

endclass
//=========================================================
// INCR Burst Sequence
//=========================================================

class incr_sequence extends master_base_sequence;

    `uvm_object_utils(incr_sequence)

    function new(string name = "incr_sequence");
        super.new(name);
    endfunction

    virtual task body();

        int burst_length;

        burst_length = $urandom_range(2,16);

        repeat (burst_length) begin

            req = master_transaction::type_id::create("req");

            start_item(req);

            assert(req.randomize() with {

                HWRITE  == 1'b1;

                HTRANS  == ((req == null) ? 2'b10 : 2'b11);

                HBURST  == 3'b001;     // INCR

                HSIZE   == 3'b010;

                HLENGTH == burst_length;

            });

            finish_item(req);

        end

    endtask

endclass


//=========================================================
// INCR4 Burst Sequence
//=========================================================

class incr4_sequence extends master_base_sequence;

    `uvm_object_utils(incr4_sequence)

    function new(string name = "incr4_sequence");
        super.new(name);
    endfunction

    virtual task body();

        for(int i = 0; i < 4; i++) begin

            req = master_transaction::type_id::create($sformatf("req_%0d",i));

            start_item(req);

            assert(req.randomize() with {

                HWRITE  == 1'b1;

                HTRANS  == (i == 0) ? 2'b10 : 2'b11;

                HBURST  == 3'b011;     // INCR4

                HSIZE   == 3'b010;

                HLENGTH == 4;

            });

            finish_item(req);

        end

    endtask

endclass


//=========================================================
// INCR8 Burst Sequence
//=========================================================

class incr8_sequence extends master_base_sequence;

    `uvm_object_utils(incr8_sequence)

    function new(string name = "incr8_sequence");
        super.new(name);
    endfunction

    virtual task body();

        for(int i = 0; i < 8; i++) begin

            req = master_transaction::type_id::create($sformatf("req_%0d",i));

            start_item(req);

            assert(req.randomize() with {

                HWRITE  == 1'b1;

                HTRANS  == (i == 0) ? 2'b10 : 2'b11;

                HBURST  == 3'b101;     // INCR8

                HSIZE   == 3'b010;

                HLENGTH == 8;

            });

            finish_item(req);

        end

    endtask

endclass


//=========================================================
// INCR16 Burst Sequence
//=========================================================

class incr16_sequence extends master_base_sequence;

    `uvm_object_utils(incr16_sequence)

    function new(string name = "incr16_sequence");
        super.new(name);
    endfunction

    virtual task body();

        for(int i = 0; i < 16; i++) begin

            req = master_transaction::type_id::create($sformatf("req_%0d",i));

            start_item(req);

            assert(req.randomize() with {

                HWRITE  == 1'b1;

                HTRANS  == (i == 0) ? 2'b10 : 2'b11;

                HBURST  == 3'b111;     // INCR16

                HSIZE   == 3'b010;

                HLENGTH == 16;

            });

            finish_item(req);

        end

    endtask

endclass

//=========================================================
// WRAP4 Burst Sequence
//=========================================================

class wrap4_sequence extends master_base_sequence;

    `uvm_object_utils(wrap4_sequence)

    function new(string name = "wrap4_sequence");
        super.new(name);
    endfunction

    virtual task body();

        for(int i = 0; i < 4; i++) begin

            req = master_transaction::type_id::create($sformatf("req_%0d", i));

            start_item(req);

            assert(req.randomize() with {

                HWRITE  == 1'b1;

                HTRANS  == (i == 0) ? 2'b10 : 2'b11;   // NONSEQ then SEQ

                HBURST  == 3'b010;                     // WRAP4

                HSIZE   == 3'b010;

                HLENGTH == 4;

            });

            finish_item(req);

        end

    endtask

endclass


//=========================================================
// WRAP8 Burst Sequence
//=========================================================

class wrap8_sequence extends master_base_sequence;

    `uvm_object_utils(wrap8_sequence)

    function new(string name = "wrap8_sequence");
        super.new(name);
    endfunction

    virtual task body();

        for(int i = 0; i < 8; i++) begin

            req = master_transaction::type_id::create($sformatf("req_%0d", i));

            start_item(req);

            assert(req.randomize() with {

                HWRITE  == 1'b1;

                HTRANS  == (i == 0) ? 2'b10 : 2'b11;

                HBURST  == 3'b100;                     // WRAP8

                HSIZE   == 3'b010;

                HLENGTH == 8;

            });

            finish_item(req);

        end

    endtask

endclass


//=========================================================
// WRAP16 Burst Sequence
//=========================================================

class wrap16_sequence extends master_base_sequence;

    `uvm_object_utils(wrap16_sequence)

    function new(string name = "wrap16_sequence");
        super.new(name);
    endfunction

    virtual task body();

        for(int i = 0; i < 16; i++) begin

            req = master_transaction::type_id::create($sformatf("req_%0d", i));

            start_item(req);

            assert(req.randomize() with {

                HWRITE  == 1'b1;

                HTRANS  == (i == 0) ? 2'b10 : 2'b11;

                HBURST  == 3'b110;                     // WRAP16

                HSIZE   == 3'b010;

                HLENGTH == 16;

            });

            finish_item(req);

        end

    endtask

endclass
//=========================================================
// Invalid Address Sequence
//=========================================================

class invalid_address_sequence extends master_base_sequence;

    `uvm_object_utils(invalid_address_sequence)

    function new(string name = "invalid_address_sequence");
        super.new(name);
    endfunction

    virtual task body();

        req = master_transaction::type_id::create("req");

        start_item(req);

        assert(req.randomize() with {

            HWRITE  == 1'b1;

            HTRANS  == 2'b10;          // NONSEQ

            HBURST  == 3'b000;         // SINGLE

            HSIZE   == 3'b010;

            HLENGTH == 1;

            // Deliberately violate word alignment
            HADDR[1:0] != 2'b00;

        });

        finish_item(req);

    endtask

endclass


//=========================================================
// Busy Transfer Sequence
//=========================================================

class busy_transfer_sequence extends master_base_sequence;

    `uvm_object_utils(busy_transfer_sequence)

    function new(string name = "busy_transfer_sequence");
        super.new(name);
    endfunction

    virtual task body();

        // First Transfer (NONSEQ)
        req = master_transaction::type_id::create("req_nonseq");

        start_item(req);

        assert(req.randomize() with {

            HWRITE  == 1'b1;

            HTRANS  == 2'b10;          // NONSEQ

            HBURST  == 3'b001;         // INCR

            HSIZE   == 3'b010;

            HLENGTH == 3;

        });

        finish_item(req);


        // BUSY Cycle
        req = master_transaction::type_id::create("req_busy");

        start_item(req);

        assert(req.randomize() with {

            HTRANS == 2'b01;           // BUSY

        });

        finish_item(req);


        // Continue Burst
        req = master_transaction::type_id::create("req_seq");

        start_item(req);

        assert(req.randomize() with {

            HWRITE  == 1'b1;

            HTRANS  == 2'b11;          // SEQ

            HBURST  == 3'b001;

            HSIZE   == 3'b010;

            HLENGTH == 3;

        });

        finish_item(req);

    endtask

endclass


//=========================================================
// Idle Transfer Sequence
//=========================================================

class idle_transfer_sequence extends master_base_sequence;

    `uvm_object_utils(idle_transfer_sequence)

    function new(string name = "idle_transfer_sequence");
        super.new(name);
    endfunction

    virtual task body();

        req = master_transaction::type_id::create("req");

        start_item(req);

        assert(req.randomize() with {

            HTRANS == 2'b00;           // IDLE

        });

        finish_item(req);

    endtask

endclass


//=========================================================
// Wait State Sequence
//=========================================================

class wait_state_sequence extends master_base_sequence;

    `uvm_object_utils(wait_state_sequence)

    function new(string name = "wait_state_sequence");
        super.new(name);
    endfunction

    virtual task body();

        req = master_transaction::type_id::create("req");

        start_item(req);

        assert(req.randomize() with {

            HWRITE  == 1'b1;

            HTRANS  == 2'b10;          // NONSEQ

            HBURST  == 3'b000;

            HSIZE   == 3'b010;

            HLENGTH == 1;

            HREADY  == 1'b0;           // Insert Wait State

        });

        finish_item(req);

    endtask

endclass


//=========================================================
// Error Response Sequence
//=========================================================

class error_response_sequence extends master_base_sequence;

    `uvm_object_utils(error_response_sequence)

    function new(string name = "error_response_sequence");
        super.new(name);
    endfunction

    virtual task body();

        req = master_transaction::type_id::create("req");

        start_item(req);

        assert(req.randomize() with {

            HWRITE  == 1'b1;

            HTRANS  == 2'b10;

            HBURST  == 3'b000;

            HSIZE   == 3'b010;

            HLENGTH == 1;

            HRESP   == 2'b01;          // ERROR Response

        });

        finish_item(req);

    endtask

endclass
//=========================================================
// Random Constrained Sequence
//=========================================================

class random_constrained_sequence extends master_base_sequence;

    `uvm_object_utils(random_constrained_sequence)

    function new(string name = "random_constrained_sequence");
        super.new(name);
    endfunction

    virtual task body();

        int num_transactions;

        num_transactions = $urandom_range(10,20);

        repeat(num_transactions) begin

            req = master_transaction::type_id::create("req");

            start_item(req);

            assert(req.randomize() with {

                // Valid AHB Transfer Types
                HTRANS inside {2'b10, 2'b11};

                // Random Read / Write
                HWRITE dist {
                    1'b1 := 50,
                    1'b0 := 50
                };

                // Random Transfer Size
                HSIZE inside {[0:2]};

                // Random Burst Type
                HBURST inside {[0:7]};

                // Random Burst Length
                HLENGTH inside {[1:16]};

                // Word Aligned Address
                HADDR[1:0] == 2'b00;

            });

            finish_item(req);

        end

    endtask

endclass


`endif