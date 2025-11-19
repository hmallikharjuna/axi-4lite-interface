`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Fixed AXI Top Module - Corrected parameter widths
//////////////////////////////////////////////////////////////////////////////////

module axi_top #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 6
)(
  // Global signals
  input  wire                       ACLK,
  input  wire                       ARESET_N,
  // External master control signals
  input  wire                       write_request,
  input  wire                       read_request,
  input  wire [ADDR_WIDTH-1:0]      ext_waddr,      // FIXED: Was [ADDR_WIDTH:0]
  input  wire [ADDR_WIDTH-1:0]      ext_raddr,      // FIXED: Was [ADDR_WIDTH:0]
  input  wire [DATA_WIDTH-1:0]      ext_wdata,      // FIXED: Was [DATA_WIDTH:0]
  output wire [DATA_WIDTH-1:0]      ext_rdata       // FIXED: Was [DATA_WIDTH:0]
);

  // AXI channel interconnect signals
  // Write Address Channel
  wire [ADDR_WIDTH-1:0] AWADDR;
  wire                  AWVALID;
  wire                  AWREADY;
  // Write Data Channel
  wire [DATA_WIDTH-1:0] WDATA;
  wire                  WVALID;
  wire                  WREADY;
  // Write Response Channel
  wire [1:0]            BRESP;
  wire                  BVALID;
  wire                  BREADY;
  // Read Address Channel
  wire [ADDR_WIDTH-1:0] ARADDR;
  wire                  ARVALID;
  wire                  ARREADY;
  // Read Data Channel
  wire [DATA_WIDTH-1:0] RDATA;
  wire                  RVALID;
  wire                  RREADY;

  // Instantiate the AXI4-Lite Master
  axi4lite_master #(
    .data_width   (DATA_WIDTH),
    .address_width(ADDR_WIDTH)
  ) master_inst (
    // Global signals
    .ACLK         (ACLK),
    .ARESET_N     (ARESET_N),
    // Write address channel
    .AWADDR       (AWADDR),
    .AWVALID      (AWVALID),
    .AWREADY      (AWREADY),
    // Write data channel
    .WDATA        (WDATA),
    .WVALID       (WVALID),
    .WREADY       (WREADY),
    // Write response channel
    .BVALID       (BVALID),
    .BRESP        (BRESP),
    .BREADY       (BREADY),
    // Read data channel
    .RVALID       (RVALID),
    .RDATA        (RDATA),
    .RREADY       (RREADY),
    // Read address channel
    .ARREADY      (ARREADY),
    .ARVALID      (ARVALID),
    .ARADDR       (ARADDR),
    // External control signals
    .write_request(write_request),
    .read_request (read_request),
    .ext_waddr    (ext_waddr),
    .ext_raddr    (ext_raddr),
    .ext_wdata    (ext_wdata),
    .ext_rdata    (ext_rdata)
  );

  // Instantiate the AXI4-Lite Slave
  axi4lite_slave #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) slave_inst (
    .s_axi_aresetn(ARESET_N),
    .s_axi_aclk   (ACLK),
    // Write Address Channel
    .s_axi_awaddr (AWADDR),
    .s_axi_awvalid(AWVALID),
    .s_axi_awready(AWREADY),
    // Write Data Channel
    .s_axi_wdata  (WDATA),
    .s_axi_wvalid (WVALID),
    .s_axi_wready (WREADY),
    // Write Response Channel
    .s_axi_bresp  (BRESP),
    .s_axi_bvalid (BVALID),
    .s_axi_bready (BREADY),
    // Read Address Channel
    .s_axi_araddr (ARADDR),
    .s_axi_arvalid(ARVALID),
    .s_axi_arready(ARREADY),
    // Read Data Channel
    .s_axi_rdata  (RDATA),
    .s_axi_rvalid (RVALID),
    .s_axi_rready (RREADY)
  );

endmodule
