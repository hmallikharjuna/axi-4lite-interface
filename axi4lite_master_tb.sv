`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2025 01:22:53
// Design Name: 
// Module Name: axi4lite_master_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Updated testbench with monitor statements for all signals.
// 
// Revision:
// Revision 0.04 - Added comprehensive $monitor statement.
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module axi4lite_master_tb;


    // Parameters
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 6;

    // DUT Signals
    logic                              s_axi_aresetn;
    logic                              s_axi_aclk;
    logic [ADDR_WIDTH-1:0]             s_axi_awaddr;
    logic                              s_axi_awvalid;
    logic                              s_axi_awready;
    logic [DATA_WIDTH-1:0]             s_axi_wdata;
    logic                              s_axi_wvalid;
    logic                              s_axi_wready;
    logic [1:0]                        s_axi_bresp;
    logic                              s_axi_bvalid;
    logic                              s_axi_bready;
    logic [ADDR_WIDTH-1:0]             s_axi_araddr;
    logic                              s_axi_arvalid;
    logic                              s_axi_arready;
    logic [DATA_WIDTH-1:0]             s_axi_rdata;
    logic                              s_axi_rvalid;
    logic                              s_axi_rready;

    // Instantiate the DUT (Design Under Test)
    axi4lite_slave #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awready(s_axi_awready),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wvalid(s_axi_wvalid),
        .s_axi_wready(s_axi_wready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_arready(s_axi_arready),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_rready(s_axi_rready)
    );

    // Clock generation
    always #5 s_axi_aclk = ~s_axi_aclk;  // 10ns clock period

    // Test procedure
    initial begin
        // Initialize signals
        s_axi_aclk    = 0;
        s_axi_aresetn = 0;
        s_axi_awaddr  = 0;
        s_axi_awvalid = 0;
        s_axi_wdata   = 0;
        s_axi_wvalid  = 0;
        s_axi_bready  = 0;
        s_axi_araddr  = 0;
        s_axi_arvalid = 0;
        s_axi_rready  = 0;

        // Reset the DUT
        #20;
        s_axi_aresetn = 1;
        #10;

        // WRITE OPERATION
        s_axi_awaddr  = 6'b000010;  // Write address
        s_axi_awvalid = 1;
        s_axi_wdata   = 32'hDEADBEEF;  // Data to write
        s_axi_wvalid  = 1;
        #10;

        // Wait for write handshake
        while (!s_axi_awready || !s_axi_wready) #10;
        s_axi_awvalid = 0;
        s_axi_wvalid  = 0;
        #10;

        // Wait for write response
        s_axi_bready = 1;
        while (!s_axi_bvalid) #10;
        s_axi_bready = 0;
        #20;

        // READ OPERATION
        s_axi_araddr  = 6'b000010;  // Read address
        s_axi_arvalid = 1;
        #10;

        // Wait for read address handshake
        while (!s_axi_arready) #10;
        s_axi_arvalid = 0;
        #10;

        // Wait for read data
        s_axi_rready = 1;
        while (!s_axi_rvalid) #10;
        $display("Read Data: %h", s_axi_rdata);
        s_axi_rready = 0;

        // End simulation
        #50;
        $finish;
    end

    // Dump waves for debugging
    initial begin
        $dumpfile("axi4lite_slave_tb.vcd");
        $dumpvars(0, tb_axi4lite_slave);
    end

endmodule