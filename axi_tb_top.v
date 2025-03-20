`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2025 00:31:44
// Design Name: 
// Module Name: axi_tb_top
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


module axi_tb_top(

    );// Parameters
  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 7;

  // DUT interface signals
  reg                     ACLK;
  reg                     ARESET_N;
  reg                     write_request;
  reg                     read_request;
  reg [ADDR_WIDTH-1:0]    ext_waddr;
  reg [ADDR_WIDTH-1:0]    ext_raddr;
  reg [DATA_WIDTH-1:0]    ext_wdata;
  wire [DATA_WIDTH-1:0]   ext_rdata;

  // Instantiate the DUT (axi_top)
  axi_top dut (
    .ACLK(ACLK),
    .ARESET_N(ARESET_N),
    .write_request(write_request),
    .read_request(read_request),
    .ext_waddr(ext_waddr),
    .ext_raddr(ext_raddr),
    .ext_wdata(ext_wdata),
    .ext_rdata(ext_rdata)
  );

  // Clock generation: 10 ns period (toggle every 5 ns)
  initial begin
    ACLK = 0;
    forever #5 ACLK = ~ACLK;
  end

  // Reset generation: active low reset, deasserted after 20 ns
  initial begin
    ARESET_N = 0;
    #20;
    ARESET_N = 1;
  end

  // Initialize control signals at time 0
  initial begin
    write_request = 0;
    read_request  = 0;
    ext_waddr     = 'h0;
    ext_raddr     = 'h0;
    ext_wdata     = 'h0;
  end

  // Toggle write_request every 50 time units
  always #50 write_request = ~write_request;

  // Toggle read_request every 70 time units
  always #70 read_request = ~read_request;

  // Increment write address every 5 time units
  always #5 ext_waddr = ext_waddr + 1;

  // Increment read address every 5 time units
  always #5 ext_raddr = ext_raddr + 1;

  // Generate random write data every 5 time units
  always #5 ext_wdata = $urandom % 32'hFFFFFFFF;

  // Terminate the simulation after 10000 time units
  initial begin
    #10000;
    $finish;
  end

endmodule
