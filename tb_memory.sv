`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2025 16:59:54
// Design Name: 
// Module Name: tb_memory
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
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2025 10:00:00
// Design Name: 
// Module Name: tb_memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for memory module
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_memory;

  // Parameters
  localparam ADDR_WIDTH = 5;
  localparam DATA_WIDTH = 32;
  localparam DEPTH = 32;

  // Clock and Reset
  logic clk;
  logic reset_n;

  // Memory Signals
  logic [ADDR_WIDTH-1:0] write_address;
  logic [ADDR_WIDTH-1:0] read_address;
  logic [DATA_WIDTH-1:0] write_data;
  logic w_en;
  logic out_en;
  logic [DATA_WIDTH-1:0] read_data;

  // Reference Memory for Checking
  logic [DATA_WIDTH-1:0] reference_mem [0:DEPTH-1];

  // Instantiate the DUT (memory module)
  memory #(
    .addr_width(ADDR_WIDTH),
    .data_width(DATA_WIDTH),
    .depth(DEPTH)
  ) dut (
    .clk(clk),
    .reset_n(reset_n),
    .write_address(write_address),
    .read_address(read_address),
    .write_data(write_data),
    .w_en(w_en),
    .out_en(out_en),
    .read_data(read_data)
  );

  // Clock Generation (10ns period)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset Generation
  initial begin
    reset_n = 0;
    #20;
    reset_n = 1;
  end

  // **Write and Read Transactions**
  initial begin
    // Initialize all signals
    write_address = 0;
    read_address = 0;
    write_data = 0;
    w_en = 0;
    out_en = 0;

    #50;  // Wait for reset to settle

    // **WRITE TRANSACTIONS TO ALL MEMORY LOCATIONS**
    $display("Starting Memory Write Transactions...");
    for (int i = 0; i < DEPTH; i++) begin
      @(posedge clk);
      write_address = i;
      write_data = $random();
      reference_mem[i] = write_data;  // Store expected data
      w_en = 1;
      out_en = 0;

      @(posedge clk);
      w_en = 0;  // Deassert write enable

      $display("Write Addr: %d, Data: %h", i, reference_mem[i]);
    end

    #200;

    // **READ TRANSACTIONS TO VERIFY MEMORY**
    $display("Starting Memory Read Transactions...");
    for (int i = 0; i < DEPTH; i++) begin
      @(posedge clk);
      read_address = i;
      w_en = 0;
      out_en = 1;

      @(posedge clk);
      out_en = 0; // Deassert output enable

      // Check the read data
      if (read_data !== reference_mem[i]) begin
        $display("ERROR: Read Addr: %d, Expected: %h, Got: %h", i, reference_mem[i], read_data);
      end else begin
        $display("Read Addr: %d, Data: %h (PASS)", i, read_data);
      end
    end

    #200;
    $display("Memory Transactions Completed Successfully.");
    $finish;
  end

  // **Stop Simulation at 20,000 ns**
  initial begin
    #20000;
    $display("Simulation Timeout Reached (20,000 ns).");
    $finish;
  end

endmodule
