`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2025 13:12:38
// Design Name: 
// Module Name: tb_axi4lite_slave
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

`timescale 1ns / 1ps

module axi_tb;

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
  axi4lite_slave DUT (
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

  // AXI Write Task
  task automatic axi_write;
    input [5:0] addr;
    input [31:0] data;
    begin
      s_axi_awaddr = addr;
      s_axi_awvalid = 1'b1;
      s_axi_wdata = data;
      s_axi_wvalid = 1'b1;
      
      // Wait for both ready signals
      fork
        wait(s_axi_awready);
        wait(s_axi_wready);
      join
      
      // Maintain valid until ready is seen
      @(posedge s_axi_aclk);
      s_axi_awvalid = 1'b0;
      s_axi_wvalid = 1'b0;
      
      // Handle write response
      wait(s_axi_bvalid);
      @(posedge s_axi_aclk);
      s_axi_bready = 1'b1;
      @(posedge s_axi_aclk);
      s_axi_bready = 1'b0;
    end
  endtask

  // AXI Read Task
  task automatic axi_read;
    input [5:0] addr;
    begin
      s_axi_araddr = addr;
      s_axi_arvalid = 1'b1;
      
      // Wait for read address ready
      wait(s_axi_arready);
      @(posedge s_axi_aclk);
      s_axi_arvalid = 1'b0;
      
      // Handle read data
      wait(s_axi_rvalid);
      @(posedge s_axi_aclk);
      s_axi_rready = 1'b1;
      @(posedge s_axi_aclk);
      s_axi_rready = 1'b0;
    end
  endtask

  // Test Procedure
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

    // Reset sequence
    #20;
    s_axi_aresetn = 1;
    #10;

    // Continuous transactions
    fork
      // Continuous write operations
      begin
        reg [5:0] addr = 0;
        forever begin
          axi_write(addr, $urandom());
          addr = (addr + 4) % 64;  // Increment by 4 bytes, wrap at 64
          #10;
        end
      end
      
      // Continuous read operations
      begin
        reg [5:0] addr = 0;
        forever begin
          axi_read(addr);
          addr = (addr + 4) % 64;  // Increment by 4 bytes, wrap at 64
          #10;
        end
      end
    join_none

    // Simulation duration
    #5000;
    $finish;
  end

endmodule

