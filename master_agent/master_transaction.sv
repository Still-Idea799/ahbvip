`ifndef MASTER_TRANSACTION_SV
`define MASTER_TRANSACTION_SV

class master_transaction extends uvm_sequence_item;

    `uvm_object_utils(master_transaction)

    //=========================================================
    // AHB Transaction Fields
    //=========================================================

    rand bit [31:0] HADDR;
    rand bit [31:0] HWDATA;
         bit [31:0] HRDATA;

    rand bit        HWRITE;
    rand bit [1:0]  HTRANS;
    rand bit [2:0]  HSIZE;
    rand bit [2:0]  HBURST;
    rand bit [4:0]  HLENGTH;

         bit        HREADY;
         bit [1:0]  HRESP;

    //=========================================================
    // Constraints
    //=========================================================

    // Address must be word aligned
    constraint c_addr_align {
        soft HADDR[1:0] == 2'b00;
    }

    // Valid AHB transfer types
    constraint c_htrans {
        HTRANS inside {2'b00, 2'b01, 2'b10, 2'b11};
    }

    // Valid transfer sizes
    constraint c_hsize {
        HSIZE inside {[0:2]};
    }

    // Valid burst types
    constraint c_hburst {
        HBURST inside {[0:7]};
    }

    // Burst length (used by sequences)
    constraint c_length {
        HLENGTH inside {[1:16]};
    }

    //=========================================================
    // Constructor
    //=========================================================

    function new(string name = "master_transaction");
        super.new(name);
    endfunction

    //=========================================================
    // UVM Field Registration
    //=========================================================

    `uvm_object_utils_begin(master_transaction)

        `uvm_field_int(HADDR   , UVM_ALL_ON)
        `uvm_field_int(HWDATA  , UVM_ALL_ON)
        `uvm_field_int(HRDATA  , UVM_ALL_ON)

        `uvm_field_int(HWRITE  , UVM_ALL_ON)
        `uvm_field_int(HTRANS  , UVM_ALL_ON)
        `uvm_field_int(HSIZE   , UVM_ALL_ON)
        `uvm_field_int(HBURST  , UVM_ALL_ON)
        `uvm_field_int(HLENGTH , UVM_ALL_ON)

        `uvm_field_int(HREADY  , UVM_ALL_ON)
        `uvm_field_int(HRESP   , UVM_ALL_ON)

    `uvm_object_utils_end

    //=========================================================
    // Convert Transaction to String
    //=========================================================

    function string convert2string();

        return $sformatf(
            "\n----------------------------------------\n\
             HADDR   = 0x%08h\n\
             HWDATA  = 0x%08h\n\
             HRDATA  = 0x%08h\n\
             HWRITE  = %0b\n\
             HTRANS  = %0d\n\
             HSIZE   = %0d\n\
             HBURST  = %0d\n\
             HLENGTH = %0d\n\
             HREADY  = %0b\n\
             HRESP   = %0d\n\
             ----------------------------------------",
             HADDR,
             HWDATA,
             HRDATA,
             HWRITE,
             HTRANS,
             HSIZE,
             HBURST,
             HLENGTH,
             HREADY,
             HRESP
        );

    endfunction

endclass

`endif