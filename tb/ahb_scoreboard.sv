`ifndef AHB_SCOREBOARD_SV
`define AHB_SCOREBOARD_SV

class ahb_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(ahb_scoreboard)

    //=========================================================
    // Analysis FIFOs
    //=========================================================

    uvm_tlm_analysis_fifo #(master_transaction) master_fifo;
    uvm_tlm_analysis_fifo #(slave_transaction)  slave_fifo;

    //=========================================================
    // Transaction Handles
    //=========================================================

    master_transaction master_tr;
    slave_transaction  slave_tr;

    //=========================================================
    // Statistics
    //=========================================================

    int total_transactions;
    int passed_transactions;
    int failed_transactions;

    //=========================================================
    // Constructor
    //=========================================================

    function new(string name = "ahb_scoreboard",
                 uvm_component parent = null);

        super.new(name, parent);

    endfunction

    //=========================================================
    // Build Phase
    //=========================================================

    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        master_fifo = new("master_fifo", this);
        slave_fifo  = new("slave_fifo", this);

        total_transactions  = 0;
        passed_transactions = 0;
        failed_transactions = 0;

    endfunction

    //=========================================================
    // Run Phase
    //=========================================================

    virtual task run_phase(uvm_phase phase);

        forever begin

            //---------------------------------------------
            // Wait for Transactions
            //---------------------------------------------

            master_fifo.get(master_tr);
            slave_fifo.get(slave_tr);

            total_transactions++;

            compare_transactions(master_tr, slave_tr);

        end

    endtask

    //=========================================================
    // Compare Transactions
    //=========================================================

    task compare_transactions(master_transaction m_tr,
                              slave_transaction  s_tr);

        bit compare_status;

        compare_status = 1'b1;

        //---------------------------------------------
        // Address
        //---------------------------------------------

        if(m_tr.HADDR != s_tr.HADDR) begin

            compare_status = 1'b0;

            `uvm_error(get_type_name(),
                $sformatf("HADDR Mismatch : Master = %08h  Slave = %08h",
                           m_tr.HADDR,
                           s_tr.HADDR))

        end

        //---------------------------------------------
        // Transfer Type
        //---------------------------------------------

        if(m_tr.HTRANS != s_tr.HTRANS) begin

            compare_status = 1'b0;

            `uvm_error(get_type_name(),
                $sformatf("HTRANS Mismatch : Master = %0d  Slave = %0d",
                           m_tr.HTRANS,
                           s_tr.HTRANS))

        end

        //---------------------------------------------
        // Write / Read
        //---------------------------------------------

        if(m_tr.HWRITE != s_tr.HWRITE) begin

            compare_status = 1'b0;

            `uvm_error(get_type_name(),
                $sformatf("HWRITE Mismatch : Master = %0b  Slave = %0b",
                           m_tr.HWRITE,
                           s_tr.HWRITE))

        end

        //---------------------------------------------
        // Transfer Size
        //---------------------------------------------

        if(m_tr.HSIZE != s_tr.HSIZE) begin

            compare_status = 1'b0;

            `uvm_error(get_type_name(),
                $sformatf("HSIZE Mismatch : Master = %0d  Slave = %0d",
                           m_tr.HSIZE,
                           s_tr.HSIZE))

        end

        //---------------------------------------------
        // Burst Type
        //---------------------------------------------

        if(m_tr.HBURST != s_tr.HBURST) begin

            compare_status = 1'b0;

            `uvm_error(get_type_name(),
                $sformatf("HBURST Mismatch : Master = %0d  Slave = %0d",
                           m_tr.HBURST,
                           s_tr.HBURST))

        end

        //---------------------------------------------
        // Burst Length
        //---------------------------------------------

        if(m_tr.HLENGTH != s_tr.HLENGTH) begin

            compare_status = 1'b0;

            `uvm_error(get_type_name(),
                $sformatf("HLENGTH Mismatch : Master = %0d  Slave = %0d",
                           m_tr.HLENGTH,
                           s_tr.HLENGTH))

        end

        //---------------------------------------------
        // Write Data
        //---------------------------------------------

        if(m_tr.HWRITE) begin

            if(m_tr.HWDATA != s_tr.HWDATA) begin

                compare_status = 1'b0;

                `uvm_error(get_type_name(),
                    $sformatf("HWDATA Mismatch : Master = %08h  Slave = %08h",
                               m_tr.HWDATA,
                               s_tr.HWDATA))

            end

        end

        //---------------------------------------------
        // Read Data
        //---------------------------------------------

        else begin

            if(m_tr.HRDATA != s_tr.HRDATA) begin

                compare_status = 1'b0;

                `uvm_error(get_type_name(),
                    $sformatf("HRDATA Mismatch : Master = %08h  Slave = %08h",
                               m_tr.HRDATA,
                               s_tr.HRDATA))

            end

        end

        //---------------------------------------------
        // Response
        //---------------------------------------------

        if(m_tr.HRESP != s_tr.HRESP) begin

            compare_status = 1'b0;

            `uvm_error(get_type_name(),
                $sformatf("HRESP Mismatch : Master = %0d  Slave = %0d",
                           m_tr.HRESP,
                           s_tr.HRESP))

        end

        //---------------------------------------------
        // Ready
        //---------------------------------------------

        if(m_tr.HREADY != s_tr.HREADY) begin

            compare_status = 1'b0;

            `uvm_error(get_type_name(),
                $sformatf("HREADY Mismatch : Master = %0b  Slave = %0b",
                           m_tr.HREADY,
                           s_tr.HREADY))

        end

        //---------------------------------------------
        // Final Result
        //---------------------------------------------

        if(compare_status) begin

            passed_transactions++;

            `uvm_info(get_type_name(),
                      "Transaction Matched Successfully",
                      UVM_LOW)

        end
        else begin

            failed_transactions++;

            `uvm_error(get_type_name(),
                       "Transaction Comparison Failed")

        end

    endtask

    //=========================================================
    // Report Phase
    //=========================================================

virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), $sformatf("\n=========================================\nAHB SCOREBOARD SUMMARY\n=========================================\nTotal Transactions  : %0d\nPassed Transactions : %0d\nFailed Transactions : %0d\n=========================================", total_transactions, passed_transactions, failed_transactions), UVM_NONE)
    endfunction

endclass

`endif
