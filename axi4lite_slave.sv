`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2025 12:38:45
// Design Name: 
// Module Name: axi4lite_slave
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


module axi4lite_slave#(parameter DATA_WIDTH=32,ADDR_WIDTH=6)(
    // Global signals
input  logic                                  s_axi_aresetn,
input  logic                                  s_axi_aclk,
// Write Address Channel
input  logic [ADDR_WIDTH-1:0]                 s_axi_awaddr,
input  logic                                  s_axi_awvalid,
output logic                                  s_axi_awready,

// Write Data Channel
input  logic [DATA_WIDTH-1:0]                 s_axi_wdata,
input  logic                                  s_axi_wvalid,
output logic                                  s_axi_wready,
//output  logic [DATA_WIDTH-1:0]                 s_ext_wdata,
// Write Response Channel
output logic [1:0]                            s_axi_bresp,
output logic                                  s_axi_bvalid,
input  logic                                  s_axi_bready,

// Read Address Channel
input  logic [ADDR_WIDTH-1:0]                 s_axi_araddr,
input  logic                                  s_axi_arvalid,
output logic                                  s_axi_arready,

// Read Data Channel
output logic [DATA_WIDTH-1:0]                 s_axi_rdata,
//output logic [1:0]                  s_axi_rresp,
output logic                                  s_axi_rvalid,
input  logic                                  s_axi_rready
  

    );
//external signals
  logic [DATA_WIDTH-1:0]                 s_ext_wdata;
  logic  [DATA_WIDTH-1:0]                s_ext_rdata;
    //reg [DATA_WIDTH-1:0]mem[1:2**ADDR_WIDTH];
    //memory signals
//    logic [ADDR_WIDTH-1:0] temp_waddr;
//    logic [ADDR_WIDTH-1:0] temp_raddr;
//    logic [DATA_WIDTH-1:0] temp_wdata;
//    logic [DATA_WIDTH-1:0] temp_rddata;
//write address channel
logic [2:0] s_wa_presentstate;
logic [2:0] s_wa_nextstate;
localparam [2:0] s_wa_idle=001;
localparam [2:0] s_wa_start=010;
localparam [2:0] s_wa_complete=100;
//write address channel  state registers

always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin 
    if(!s_axi_aresetn) begin
     s_wa_presentstate<= s_wa_idle;
    end else begin
     s_wa_presentstate<= s_wa_nextstate;
    end
end

//write address channel next statelogic
always_comb
begin
    case (s_wa_presentstate)
        s_wa_idle:begin 
                  if (!s_axi_aresetn)
                  s_wa_nextstate=s_wa_idle;
                  else 
                    s_wa_nextstate=s_wa_start;
                  end
        s_wa_start:begin
                   if (s_axi_awvalid || s_axi_wvalid) 
                      s_wa_nextstate=s_wa_start;
                      else
                        s_wa_nextstate=s_wa_complete;
                   end
        s_wa_complete:begin
                      s_wa_nextstate=s_wa_idle;
                      end 

    
        default :  s_wa_nextstate=s_wa_idle;
    endcase
end
//write address channel output logic
// Write handshake logic
    always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn)
            s_axi_awready <= 1'b0;
        else if (!s_axi_awready && s_axi_awvalid && s_axi_wvalid) 
            s_axi_awready <= 1'b1;
        else
            s_axi_awready <= 1'b0;
    end


//write data channel
logic [2:0] s_wd_presentstate;
logic [2:0] s_wd_nextstate;
localparam [2:0] s_wd_idle=001;
localparam [2:0] s_wd_start=010;
localparam [2:0] s_wd_complete=100;
//write data channel  state registers

always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin 
    if(!s_axi_aresetn) begin
     s_wd_presentstate<= s_wd_idle;
    end else begin
     s_wd_presentstate<= s_wd_nextstate;
    end
end

 //write data channel next state logic

always_comb
begin
    case (s_wd_presentstate)
        s_wd_idle:begin 
                  if (!s_axi_aresetn)
                  s_wd_nextstate=s_wd_idle;
                  else 
                    s_wd_nextstate=s_wd_start;
                  end
        s_wd_start:begin
                   if (s_axi_awvalid || s_axi_wvalid) 
                      s_wd_nextstate=s_wd_start;
                      else
                        s_wd_nextstate=s_wd_complete;
                   end
        s_wd_complete:begin
                      s_wd_nextstate=s_wd_idle;
                      end 

    
        default :  s_wd_nextstate=s_wa_idle;
    endcase
end

//write data channel output logic

    always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn)
            s_axi_wready <= 1'b0;
        else if (!s_axi_wready && s_axi_awvalid && s_axi_wvalid) 
            s_axi_wready <= 1'b1;
        else
            s_axi_wready <= 1'b0;
    end
//write response channel 
logic [2:0] s_bw_presentstate;
logic [2:0] s_bw_nextstate;
localparam [2:0] s_bw_idle=001;
localparam [2:0] s_bw_validphase=010;
localparam [2:0] s_bw_complete=100;
//write response channel state registers
always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin 
    if(!s_axi_aresetn) begin
     s_bw_presentstate<= s_bw_idle;
    end else begin
     s_bw_presentstate<= s_bw_nextstate;
    end
end
//write response channel nextstatelogic
always_comb
begin
    case (s_bw_presentstate)
        s_bw_idle:begin
                          if (s_axi_wvalid && s_axi_wready) begin
                              s_bw_nextstate=s_bw_validphase;
                          end 
                          else
                              s_bw_nextstate=s_bw_idle;
                          end

        s_bw_validphase:begin
                          s_bw_nextstate=s_bw_complete;
                        end
        s_bw_complete:  begin
                        if (s_axi_bready)
                          s_bw_nextstate=s_bw_idle;
                          else
                          s_bw_nextstate=s_bw_complete;
                          end                
        default :  s_bw_nextstate=s_bw_idle;
    endcase
end

// Write Response logic
    always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn)
            s_axi_bvalid <= 1'b0;
        else if (s_axi_wready && s_axi_wvalid && !s_axi_bvalid)
            s_axi_bvalid <= 1'b1;
        else if (s_axi_bvalid && s_axi_bready)
            s_axi_bvalid <= 1'b0;
    end

    always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn)
            s_axi_bresp <= 2'b00;  // 'OKAY' response
        else if (s_axi_wready && s_axi_wvalid)
            s_axi_bresp <= 2'b00;  // 'OKAY' response
    end

//read address channel
logic [1:0] s_ar_presentstate;
logic [1:0] s_ar_nextstate;
localparam [1:0] s_ar_idle=01;
localparam [1:0] s_ar_readyphase=10;

//read address channel state registers
always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin : proc_
    if(~s_axi_aresetn) begin
        s_ar_presentstate <= s_ar_idle;
    end else begin
       s_ar_presentstate  <= s_ar_nextstate;
    end
end
//read address channel next state  logic

always_comb
begin
    case (s_ar_presentstate)
        s_ar_idle:begin
                  if (!s_axi_aresetn) 
                      s_ar_nextstate=s_ar_idle;
                      else
                        s_ar_nextstate=s_ar_readyphase;
                  end
        s_ar_readyphase:begin
                        if (s_axi_arvalid) begin
                            s_ar_nextstate=s_ar_readyphase;                       
                             end
                             else
                                s_ar_nextstate=s_ar_idle;
                                end
        default : s_ar_nextstate=s_ar_readyphase;  
    endcase
end

//read address channel output logic

always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn)
            s_axi_arready <= 1'b0;
        else
            s_axi_arready <= !s_axi_arready && s_axi_arvalid;
    end

//read data channel

logic [3:0] s_rd_presentstate;
logic [3:0] s_rd_nextstate;
localparam [3:0] s_rd_idle=0001;
localparam [3:0] s_rd_start=0010;
localparam [3:0] s_rd_transfer=0100;
localparam [3:0] s_rd_complete=1000;

//read data channel state registers

always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin 
    if(~s_axi_aresetn) begin
        s_rd_presentstate <= s_rd_idle;
    end else begin
        s_rd_presentstate <= s_rd_nextstate;
    end
end

//read data channel next state logic

always_comb
begin
    case (s_rd_presentstate)
        s_rd_idle:begin 
                  if (!s_axi_aresetn)
                    s_rd_nextstate=s_rd_idle;
                  else
                    s_rd_nextstate=s_rd_start;
                  end

        s_rd_start:begin
                   if (s_axi_arvalid && s_axi_arready) 
                       s_rd_nextstate=s_rd_transfer;
                       else
                        s_rd_nextstate=s_rd_start;
                   end
        s_rd_transfer:begin
                    if (s_axi_rready) 
                        s_rd_nextstate=s_rd_complete;
                        else
                          s_rd_nextstate=s_rd_transfer;   
                    end
        s_rd_complete:begin
                      s_rd_nextstate=s_rd_start;
                  end
        default : s_rd_nextstate=s_rd_start;
    endcase
end
 //read data channel output logic
 always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn)
            s_axi_rvalid <= 1'b0;
        else if (s_axi_arvalid && s_axi_arready)
            s_axi_rvalid <= 1'b1;
        else if (s_axi_rvalid && s_axi_rready)
            s_axi_rvalid <= 1'b0;
    end

    always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn)
            s_axi_rdata <= 'b0;
        else if (s_axi_arvalid && s_axi_arready)
            s_axi_rdata <= s_ext_rdata;
    end

//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------
//MEMORY logic
//output read data logic from memory
always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin 
    if(~s_axi_aresetn) 
    s_axi_rdata <= 'b0;
    else if (s_axi_rready)
    s_axi_rdata <=  s_ext_rdata;
end
//write data logic for mrmemoryarray
 always_ff @(posedge s_axi_aclk) begin
        if (s_axi_awvalid && s_axi_awready && s_axi_wvalid && s_axi_wready)
            s_ext_wdata <= s_axi_wdata;
    end

   
    memory #(
        .addr_width(ADDR_WIDTH),
        .data_width(DATA_WIDTH)
    ) dut (
        .clk(s_axi_aclk),
        .reset_n(s_axi_aresetn),
        .write_address(s_axi_awaddr),
        .read_address(s_axi_araddr),
        .write_data(s_axi_wdata),
        //.w_en(s_axi_wvalid && s_axi_wready),
        .w_en('b1),
        //.out_en(s_axi_arvalid && s_axi_arready),
        .out_en('b1),
        .read_data(s_ext_rdata)
    );

endmodule