`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2025 19:36:47
// Design Name: 
// Module Name: axi_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axi_tb(

    );
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 6;
     // AXI Signals
  reg         s_axi_aclk;
  reg         s_axi_aresetn;
  reg [5:0]   s_axi_awaddr;
  reg         s_axi_awvalid;
  wire        s_axi_awready;
  reg [31:0]  s_axi_wdata;
  reg         s_axi_wvalid;
  wire        s_axi_wready;
  wire [1:0]  s_axi_bresp;
  wire        s_axi_bvalid;
  reg         s_axi_bready;
  reg [5:0]   s_axi_araddr;
  reg         s_axi_arvalid;
  wire        s_axi_arready;
  wire [31:0] s_axi_rdata;
  wire        s_axi_rvalid;
  reg         s_axi_rready;

  // Instantiate DUT
  axi4lite_slave  #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) DUT (
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
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

  // Clock Generation
    always #5 s_axi_aclk = ~s_axi_aclk;
    always #1000 s_axi_awvalid = ~s_axi_awvalid;
    always #5    s_axi_awaddr  = s_axi_awaddr + 1;
    always #10   s_axi_wvalid  = ~s_axi_wvalid;
    always #5    s_axi_bready  = ~s_axi_bready;
    always #5    s_axi_wdata   = $urandom % 32'hFFFFFFFF;
    always #20   s_axi_arvalid = ~s_axi_arvalid;
    always #5    s_axi_araddr  = s_axi_araddr + 1;
    always #5    s_axi_rready  = ~s_axi_rready;
   initial begin
        // Initialize signals
        s_axi_aclk = 0;
        s_axi_aresetn = 0;
        s_axi_awaddr = 0;
        s_axi_awvalid = 0;
        s_axi_wdata = 0;
        s_axi_wvalid = 0;
        s_axi_bready = 0;
        s_axi_araddr = 0;
        s_axi_arvalid = 0;
        s_axi_rready = 0;

        // Reset System
        #20;
        s_axi_aresetn = 1;
        end 
        initial begin
        #5000 $finish();
        end
endmodule
