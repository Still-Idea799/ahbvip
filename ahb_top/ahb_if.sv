`ifndef AHB_IF_SV
`define AHB_IF_SV

interface ahb_if(input logic HCLK, input logic HRESETn);

    //=========================================================
    // AHB Global Signals
    //=========================================================

    logic [31:0] HADDR;
    logic [31:0] HWDATA;
    logic [31:0] HRDATA;

    logic        HWRITE;
    logic [1:0]  HTRANS;
    logic [2:0]  HSIZE;
    logic [2:0]  HBURST;
    logic [3:0]  HLENGTH;

    logic        HREADY;
    logic [1:0]  HRESP;

    //=========================================================
    // Master Driver Clocking Block
    //=========================================================

    clocking master_driver_cb @(posedge HCLK);
        default input #1step output #1step;

        output HADDR;
        output HWDATA;
        output HWRITE;
        output HTRANS;
        output HSIZE;
        output HBURST;
        output HLENGTH;

        input  HRDATA;
        input  HREADY;
        input  HRESP;
    endclocking

    //=========================================================
    // Master Monitor Clocking Block
    //=========================================================

    clocking master_monitor_cb @(posedge HCLK);
        default input #1step;

        input HADDR;
        input HWDATA;
        input HRDATA;
        input HWRITE;
        input HTRANS;
        input HSIZE;
        input HBURST;
        input HLENGTH;
        input HREADY;
        input HRESP;
    endclocking

    //=========================================================
    // Slave Driver Clocking Block
    //=========================================================

    clocking slave_driver_cb @(posedge HCLK);
        default input #1step output #1step;

        input  HADDR;
        input  HWDATA;
        input  HWRITE;
        input  HTRANS;
        input  HSIZE;
        input  HBURST;
        input  HLENGTH;

        output HRDATA;
        output HREADY;
        output HRESP;
    endclocking

    //=========================================================
    // Slave Monitor Clocking Block
    //=========================================================

    clocking slave_monitor_cb @(posedge HCLK);
        default input #1step;

        input HADDR;
        input HWDATA;
        input HRDATA;
        input HWRITE;
        input HTRANS;
        input HSIZE;
        input HBURST;
        input HLENGTH;
        input HREADY;
        input HRESP;
    endclocking

    //=========================================================
    // Modports
    //=========================================================

    modport MASTER_DRIVER_MP (
        clocking master_driver_cb,
        input HCLK,
        input HRESETn
    );

    modport MASTER_MONITOR_MP (
        clocking master_monitor_cb,
        input HCLK,
        input HRESETn
    );

    modport SLAVE_DRIVER_MP (
        clocking slave_driver_cb,
        input HCLK,
        input HRESETn
    );

    modport SLAVE_MONITOR_MP (
        clocking slave_monitor_cb,
        input HCLK,
        input HRESETn
    );

endinterface

`endif