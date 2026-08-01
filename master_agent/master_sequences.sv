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

        bit [2:0] sizes[2] = '{3'b000, 3'b001};   // BYTE, then HALFWORD

        foreach (sizes[i]) begin

            req = master_transaction::type_id::create($sformatf("req_%0d", i));

            start_item(req);

            assert(req.randomize() with {

                HWRITE  == 1'b1;

                HTRANS  == 2'b10;      // NONSEQ

                HBURST  == 3'b000;     // SINGLE

                HSIZE   == sizes[i];

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

        bit [2:0] sizes[2] = '{3'b000, 3'b001};   // BYTE, then HALFWORD

        foreach (sizes[i]) begin

            req = master_transaction::type_id::create($sformatf("req_%0d", i));

            start_item(req);

            assert(req.randomize() with {

                HWRITE  == 1'b0;

                HTRANS  == 2'b10;      // NONSEQ

                HBURST  == 3'b000;     // SINGLE

                HSIZE   == sizes[i];

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

        int        burst_length;
        bit [31:0] base_addr;

        burst_length = $urandom_range(2,16);

        for(int i = 0; i < burst_length; i++) begin

            req = master_transaction::type_id::create($sformatf("req_%0d", i));

            start_item(req);

            if (i == 0) begin

                assert(req.randomize() with {

                    HWRITE  == 1'b1;
                    HTRANS  == 2'b10;      // NONSEQ
                    HBURST  == 3'b001;     // INCR
                    HSIZE   == 3'b010;
                    HLENGTH == burst_length;

                });

                base_addr = req.HADDR;

            end else begin

                assert(req.randomize() with {

                    HWRITE  == 1'b1;
                    HTRANS  == 2'b11;      // SEQ
                    HBURST  == 3'b001;     // INCR
                    HSIZE   == 3'b010;
                    HLENGTH == burst_length;
                    HADDR   == base_addr + (i * 4);

                });

            end

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

        bit [31:0] base_addr;

        //---------------------------------------------
        // Write Burst
        //---------------------------------------------

        for(int i = 0; i < 4; i++) begin

            req = master_transaction::type_id::create($sformatf("wr_req_%0d",i));

            start_item(req);

            if (i == 0) begin
                assert(req.randomize() with {
                    HWRITE == 1'b1; HTRANS == 2'b10;
                    HBURST == 3'b011; HSIZE == 3'b010; HLENGTH == 4;
                });
                base_addr = req.HADDR;
            end else begin
                assert(req.randomize() with {
                    HWRITE == 1'b1; HTRANS == 2'b11;
                    HBURST == 3'b011; HSIZE == 3'b010; HLENGTH == 4;
                    HADDR == base_addr + (i * 4);
                });
            end

            finish_item(req);

        end

        //---------------------------------------------
        // Read Burst
        //---------------------------------------------

        for(int i = 0; i < 4; i++) begin

            req = master_transaction::type_id::create($sformatf("rd_req_%0d",i));

            start_item(req);

            if (i == 0) begin
                assert(req.randomize() with {
                    HWRITE == 1'b0; HTRANS == 2'b10;
                    HBURST == 3'b011; HSIZE == 3'b010; HLENGTH == 4;
                });
                base_addr = req.HADDR;
            end else begin
                assert(req.randomize() with {
                    HWRITE == 1'b0; HTRANS == 2'b11;
                    HBURST == 3'b011; HSIZE == 3'b010; HLENGTH == 4;
                    HADDR == base_addr + (i * 4);
                });
            end

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

        bit [31:0] base_addr;

        //---------------------------------------------
        // Write Burst
        //---------------------------------------------

        for(int i = 0; i < 8; i++) begin

            req = master_transaction::type_id::create($sformatf("wr_req_%0d",i));

            start_item(req);

            if (i == 0) begin
                assert(req.randomize() with {
                    HWRITE == 1'b1; HTRANS == 2'b10;
                    HBURST == 3'b101; HSIZE == 3'b010; HLENGTH == 8;
                });
                base_addr = req.HADDR;
            end else begin
                assert(req.randomize() with {
                    HWRITE == 1'b1; HTRANS == 2'b11;
                    HBURST == 3'b101; HSIZE == 3'b010; HLENGTH == 8;
                    HADDR == base_addr + (i * 4);
                });
            end

            finish_item(req);

        end

        //---------------------------------------------
        // Read Burst
        //---------------------------------------------

        for(int i = 0; i < 8; i++) begin

            req = master_transaction::type_id::create($sformatf("rd_req_%0d",i));

            start_item(req);

            if (i == 0) begin
                assert(req.randomize() with {
                    HWRITE == 1'b0; HTRANS == 2'b10;
                    HBURST == 3'b101; HSIZE == 3'b010; HLENGTH == 8;
                });
                base_addr = req.HADDR;
            end else begin
                assert(req.randomize() with {
                    HWRITE == 1'b0; HTRANS == 2'b11;
                    HBURST == 3'b101; HSIZE == 3'b010; HLENGTH == 8;
                    HADDR == base_addr + (i * 4);
                });
            end

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

        bit [31:0] base_addr;

        //---------------------------------------------
        // Write Burst
        //---------------------------------------------

        for(int i = 0; i < 16; i++) begin

            req = master_transaction::type_id::create($sformatf("wr_req_%0d",i));

            start_item(req);

            if (i == 0) begin
                assert(req.randomize() with {
                    HWRITE == 1'b1; HTRANS == 2'b10;
                    HBURST == 3'b111; HSIZE == 3'b010; HLENGTH == 16;
                });
                base_addr = req.HADDR;
            end else begin
                assert(req.randomize() with {
                    HWRITE == 1'b1; HTRANS == 2'b11;
                    HBURST == 3'b111; HSIZE == 3'b010; HLENGTH == 16;
                    HADDR == base_addr + (i * 4);
                });
            end

            finish_item(req);

        end

        //---------------------------------------------
        // Read Burst
        //---------------------------------------------

        for(int i = 0; i < 16; i++) begin

            req = master_transaction::type_id::create($sformatf("rd_req_%0d",i));

            start_item(req);

            if (i == 0) begin
                assert(req.randomize() with {
                    HWRITE == 1'b0; HTRANS == 2'b10;
                    HBURST == 3'b111; HSIZE == 3'b010; HLENGTH == 16;
                });
                base_addr = req.HADDR;
            end else begin
                assert(req.randomize() with {
                    HWRITE == 1'b0; HTRANS == 2'b11;
                    HBURST == 3'b111; HSIZE == 3'b010; HLENGTH == 16;
                    HADDR == base_addr + (i * 4);
                });
            end

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

        bit [31:0] window_base;
        int        start_word;   // which of the 4 word-slots beat 0 starts at

        //---------------------------------------------
        // Write Burst
        //---------------------------------------------

        start_word = $urandom_range(0,3);

        for(int i = 0; i < 4; i++) begin

            req = master_transaction::type_id::create($sformatf("wr_req_%0d", i));

            start_item(req);

            if (i == 0) begin

                assert(req.randomize() with {
                    HWRITE     == 1'b1;
                    HTRANS     == 2'b10;   // NONSEQ
                    HBURST     == 3'b010;  // WRAP4
                    HSIZE      == 3'b010;
                    HLENGTH    == 4;
                    HADDR[3:2] == start_word[1:0];  // starting word slot
                    HADDR[1:0] == 2'b00;
                });

                window_base = {req.HADDR[31:4], 4'b0000};  // 16-byte aligned window

            end else begin

                automatic int word_idx = (start_word + i) % 4;

                assert(req.randomize() with {
                    HWRITE  == 1'b1;
                    HTRANS  == 2'b11;      // SEQ
                    HBURST  == 3'b010;
                    HSIZE   == 3'b010;
                    HLENGTH == 4;
                    HADDR   == window_base + (word_idx * 4);
                });

            end

            finish_item(req);

        end

        //---------------------------------------------
        // Read Burst
        //---------------------------------------------

        start_word = $urandom_range(0,3);

        for(int i = 0; i < 4; i++) begin

            req = master_transaction::type_id::create($sformatf("rd_req_%0d", i));

            start_item(req);

            if (i == 0) begin

                assert(req.randomize() with {
                    HWRITE     == 1'b0;
                    HTRANS     == 2'b10;
                    HBURST     == 3'b010;
                    HSIZE      == 3'b010;
                    HLENGTH    == 4;
                    HADDR[3:2] == start_word[1:0];
                    HADDR[1:0] == 2'b00;
                });

                window_base = {req.HADDR[31:4], 4'b0000};

            end else begin

                automatic int word_idx = (start_word + i) % 4;

                assert(req.randomize() with {
                    HWRITE  == 1'b0;
                    HTRANS  == 2'b11;
                    HBURST  == 3'b010;
                    HSIZE   == 3'b010;
                    HLENGTH == 4;
                    HADDR   == window_base + (word_idx * 4);
                });

            end

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

        bit [31:0] window_base;
        int        start_word;   // which of the 8 word-slots beat 0 starts at

        //---------------------------------------------
        // Write Burst
        //---------------------------------------------

        start_word = $urandom_range(0,7);

        for(int i = 0; i < 8; i++) begin

            req = master_transaction::type_id::create($sformatf("wr_req_%0d", i));

            start_item(req);

            if (i == 0) begin

                assert(req.randomize() with {
                    HWRITE     == 1'b1;
                    HTRANS     == 2'b10;
                    HBURST     == 3'b100;  // WRAP8
                    HSIZE      == 3'b010;
                    HLENGTH    == 8;
                    HADDR[4:2] == start_word[2:0];
                    HADDR[1:0] == 2'b00;
                });

                window_base = {req.HADDR[31:5], 5'b00000};  // 32-byte aligned window

            end else begin

                automatic int word_idx = (start_word + i) % 8;

                assert(req.randomize() with {
                    HWRITE  == 1'b1;
                    HTRANS  == 2'b11;
                    HBURST  == 3'b100;
                    HSIZE   == 3'b010;
                    HLENGTH == 8;
                    HADDR   == window_base + (word_idx * 4);
                });

            end

            finish_item(req);

        end

        //---------------------------------------------
        // Read Burst
        //---------------------------------------------

        start_word = $urandom_range(0,7);

        for(int i = 0; i < 8; i++) begin

            req = master_transaction::type_id::create($sformatf("rd_req_%0d", i));

            start_item(req);

            if (i == 0) begin

                assert(req.randomize() with {
                    HWRITE     == 1'b0;
                    HTRANS     == 2'b10;
                    HBURST     == 3'b100;
                    HSIZE      == 3'b010;
                    HLENGTH    == 8;
                    HADDR[4:2] == start_word[2:0];
                    HADDR[1:0] == 2'b00;
                });

                window_base = {req.HADDR[31:5], 5'b00000};

            end else begin

                automatic int word_idx = (start_word + i) % 8;

                assert(req.randomize() with {
                    HWRITE  == 1'b0;
                    HTRANS  == 2'b11;
                    HBURST  == 3'b100;
                    HSIZE   == 3'b010;
                    HLENGTH == 8;
                    HADDR   == window_base + (word_idx * 4);
                });

            end

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

        bit [31:0] window_base;
        int        start_word;   // which of the 16 word-slots beat 0 starts at

        //---------------------------------------------
        // Write Burst
        //---------------------------------------------

        start_word = $urandom_range(0,15);

        for(int i = 0; i < 16; i++) begin

            req = master_transaction::type_id::create($sformatf("wr_req_%0d", i));

            start_item(req);

            if (i == 0) begin

                assert(req.randomize() with {
                    HWRITE     == 1'b1;
                    HTRANS     == 2'b10;
                    HBURST     == 3'b110;  // WRAP16
                    HSIZE      == 3'b010;
                    HLENGTH    == 16;
                    HADDR[5:2] == start_word[3:0];
                    HADDR[1:0] == 2'b00;
                });

                window_base = {req.HADDR[31:6], 6'b000000};  // 64-byte aligned window

            end else begin

                automatic int word_idx = (start_word + i) % 16;

                assert(req.randomize() with {
                    HWRITE  == 1'b1;
                    HTRANS  == 2'b11;
                    HBURST  == 3'b110;
                    HSIZE   == 3'b010;
                    HLENGTH == 16;
                    HADDR   == window_base + (word_idx * 4);
                });

            end

            finish_item(req);

        end

        //---------------------------------------------
        // Read Burst
        //---------------------------------------------

        start_word = $urandom_range(0,15);

        for(int i = 0; i < 16; i++) begin

            req = master_transaction::type_id::create($sformatf("rd_req_%0d", i));

            start_item(req);

            if (i == 0) begin

                assert(req.randomize() with {
                    HWRITE     == 1'b0;
                    HTRANS     == 2'b10;
                    HBURST     == 3'b110;
                    HSIZE      == 3'b010;
                    HLENGTH    == 16;
                    HADDR[5:2] == start_word[3:0];
                    HADDR[1:0] == 2'b00;
                });

                window_base = {req.HADDR[31:6], 6'b000000};

            end else begin

                automatic int word_idx = (start_word + i) % 16;

                assert(req.randomize() with {
                    HWRITE  == 1'b0;
                    HTRANS  == 2'b11;
                    HBURST  == 3'b110;
                    HSIZE   == 3'b010;
                    HLENGTH == 16;
                    HADDR   == window_base + (word_idx * 4);
                });

            end

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

        bit [31:0] base_addr;

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

        base_addr = req.HADDR;


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

            HADDR   == base_addr + 4;

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

            // NOTE: HREADY is a slave-driven signal, not part of the
            // master's own randomizable fields. The actual wait state
            // is inserted by slave_wait_state_sequence on the slave
            // agent (see wait_state_test in test_pkg.sv), which runs
            // concurrently with this sequence.

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

        // Write that receives ERROR
        req = master_transaction::type_id::create("req_write");

        start_item(req);

        assert(req.randomize() with {

            HWRITE  == 1'b1;

            HTRANS  == 2'b10;

            HBURST  == 3'b000;

            HSIZE   == 3'b010;

            HLENGTH == 1;

            // NOTE: HRESP is a slave-driven signal, not part of the
            // master's own randomizable fields. The actual ERROR
            // response is generated by slave_error_response_sequence
            // on the slave agent (see error_response_test in
            // test_pkg.sv), which runs concurrently with this sequence.

        });

        finish_item(req);

        // Read that receives ERROR
        req = master_transaction::type_id::create("req_read");

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