`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2025 16:37:35
// Design Name: 
// Module Name: memory
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
// Create Date: 15.03.2025 16:37:35
// Design Name: 
// Module Name: memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Synchronous Memory with Read/Write Control
// 
//////////////////////////////////////////////////////////////////////////////////

module memory #(
    parameter data_width = 32,
    parameter addr_width = 6  // 64 locations (2^6 = 64)
)(
    input logic clk,
    input logic reset_n,
    input logic [addr_width-1:0] write_address,
    input logic [addr_width-1:0] read_address,
    input logic [data_width-1:0] write_data,
    input logic w_en,            // Write enable
    input logic out_en,          // Read enable
    output logic [data_width-1:0] read_data // Read data
);

    // Memory array
    reg [data_width-1:0] mem [0:(2**addr_width)-1];

    // Reset Memory
    integer i;
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            for (i = 0; i < (2**addr_width); i = i + 1)
                mem[i] <= 'b0;
        end 
        else if (w_en) begin
            mem[write_address] <= write_data;  // Write operation
        end
    end    

    // Read Operation
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            read_data <= 'b0;
        else if (out_en)
            read_data <= mem[read_address];  // Direct read operation
    end

endmodule


