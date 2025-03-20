`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2025 00:12:17
// Design Name: 
// Module Name: axi4lite_master
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

module axi4lite_master#(parameter data_width = 32, address_width=6)(
                     //global signals
                     input bit ACLK,
                     input logic ARESET_N,
                     //write address channel
                     output logic [address_width-1:0] AWADDR,
                     output logic AWVALID,
                     input logic AWREADY,
                     //write data channel
                     output logic [data_width-1:0] WDATA,
                     output logic  WVALID,
                     input  logic  WREADY,
                     //write response channel
                     input logic BVALID,
                     input logic  [1:0] BRESP,
                     output logic  BREADY,
                     //read channel
                     input logic RVALID,
                     input logic [data_width-1:0] RDATA,
                     output logic  RREADY,
                     //read address channel
                     input logic ARREADY,
                     output logic  ARVALID,
                     output logic [address_width-1:0] ARADDR,
                     //external signals 
                     input logic write_request,
                     input logic read_request,
                     input logic [address_width-1:0] ext_waddr,
                     input logic [address_width-1:0] ext_raddr,
                     input logic [data_width-1:0] ext_wdata,
                     output logic [data_width-1:0] ext_rdata
                        

    );
   
   
   
    //write adddress channel   
    localparam [3:0] WA_IDLE='b0001;
    localparam [3:0] WA_VALID='b0010;
    localparam [3:0] WA_ACCESS='b0100;
    localparam [3:0] WA_COMPLETE='b1000;
    logic [3:0] WA_presentstate;
    logic [3:0] WA_nextstate;
    //WRITE address next state register
    always_ff @ (posedge ACLK,negedge ARESET_N)
    begin
    if (!ARESET_N)
        WA_presentstate<=WA_IDLE;
    else
        WA_presentstate<=WA_nextstate;
    end  
    //write address channel next state logic
    always_comb
    begin
    case ( WA_presentstate)
    WA_IDLE:begin
            if (!ARESET_N)
                WA_nextstate=WA_IDLE;
            else if (write_request)
            WA_nextstate=WA_VALID;
            else
                WA_nextstate=WA_IDLE;
            end 
    WA_VALID:begin
             if (write_request)
             WA_nextstate=WA_ACCESS;            
             else
             WA_nextstate=WA_IDLE;
             end
    WA_ACCESS:begin
              if(AWREADY)
              WA_nextstate=WA_COMPLETE;
              else
                WA_nextstate=WA_ACCESS;
              end 
   WA_COMPLETE:  begin
             
             WA_nextstate=WA_IDLE;
            
             end  
   default: begin
            WA_nextstate=WA_IDLE;
            end          
  endcase
  end
  //write channel output logic
  always_ff @ (posedge ACLK,negedge ARESET_N)
  begin
   if (!ARESET_N)
   AWVALID <='h0;
   else begin
   case ( WA_presentstate)
  WA_IDLE: begin 
           AWVALID <= 'b0;
           end
  WA_VALID: begin 
            AWVALID <= 'b1;
           end

    WA_ACCESS:begin 
              AWVALID<='b1;
              end
   WA_COMPLETE:  begin 
             AWVALID<='b0;
             end  
   default:begin
           AWVALID<='b0;
           
           end
   endcase    
   end 
   end 
   //write address channel address logic
   /*here on clk edge address is driven to awaddr from external block like axi
   if external block is not a clocked block to drive awaddr we can use always_comb 
   so that address is reflected on to addr lines immediately,in the always ff case it will take one extra clk cycle
   to reflect address on to the lines*/
  always_ff @ (posedge ACLK,negedge ARESET_N)
  begin
   if (!ARESET_N)
   AWADDR<='h0;
   else if (write_request) 
   AWADDR<=ext_waddr;
   else
   AWADDR<='h0;
   end   
   
   //write data channel
    localparam [3:0] W_IDLE='b0001;
    localparam [3:0] W_VALID='b0010;
    localparam [3:0] W_ACCESS='b0100;
    localparam [3:0] W_COMPLETE='b1000;
    logic [3:0] W_presentstate;
    logic [3:0] W_nextstate;
    //WRITE data next state register
    always_ff @ (posedge ACLK,negedge ARESET_N)
    begin
    if (!ARESET_N)
        W_presentstate<=W_IDLE;
    else
        W_presentstate<=W_nextstate;
    end
    
    //write data nextstate logic
    always_comb
    begin
    case(W_presentstate)
    W_IDLE:begin
           if (!ARESET_N)
                W_nextstate=W_IDLE;
            else if (write_request)
            W_nextstate=W_VALID;
            else
                W_nextstate=W_IDLE;
            end 
    W_VALID:begin
            if(write_request)
            W_nextstate=W_ACCESS;
            else
            W_nextstate= W_IDLE;
            end      
    W_ACCESS:begin
            if(WREADY)
            W_nextstate=W_COMPLETE;
            else
            W_nextstate= W_ACCESS;
            end      
    W_COMPLETE:  begin
            
             W_nextstate= W_IDLE;
            
             end
    default:begin
            W_nextstate=W_IDLE;
            end
    endcase
    end
    
    //write data channel output logic 
    always_ff @ (posedge ACLK,negedge ARESET_N)
    begin
    if (!ARESET_N)
    WVALID <='b0;
    else 
    begin
    case (W_presentstate)
    W_IDLE:begin
           WVALID<='b0;
           end
    W_VALID:begin
            WVALID<='b1;
            end 
    W_ACCESS:begin
             WVALID<='b1;
             end
    W_COMPLETE:  begin
             WVALID<='b0;
             end 
    default :WVALID<='b0;         
    endcase 
    end
    end 
  
    //write data channel output
   always_ff @ (posedge ACLK,negedge ARESET_N)
   begin
   if (!ARESET_N)  
   WDATA<='b0;
   else if (WREADY)
   WDATA<=ext_wdata;
   end
   
   //write response channel
    localparam [1:0] BW_IDLE='b01;
    localparam [1:0] BW_RESP='b10;
    // localparam [3:0] BW_ACCESS='b0100;
    // localparam [3:0] BW_HOLD='b1000;
    logic [1:0] BW_presentstate;
    logic [1:0] BW_nextstate;   
      
      //WRITE response channel next state register
    always_ff @ (posedge ACLK,negedge ARESET_N)
    begin
    if (!ARESET_N)
        BW_presentstate<=BW_IDLE;
    else
        BW_presentstate<=BW_nextstate;
    end
    
    //write response channel next state logic
    always_comb
    begin
    case (BW_presentstate)
        BW_IDLE:begin 
                if (BVALID)
                    BW_nextstate=BW_RESP;
                else
                    BW_nextstate=BW_IDLE;
                end
        BW_RESP:begin
                if (BRESP) 
                    BW_nextstate=BW_IDLE;
                else
                    BW_nextstate=BW_RESP;
                end        
    


    
        default : BW_nextstate=BW_IDLE;
    endcase
    end
    //write response channel output logic

   always_ff @(posedge ACLK, negedge ARESET_N)
   begin
  if (!ARESET_N)
    BREADY <= 'b0;
  else if (BVALID && (BREADY==2'b00) )  
    BREADY <= 'b1; 
  else 
    BREADY <= 'b0;
  
  end

    //read address channel
    localparam [3:0] AR_IDLE='b0001;
    localparam [3:0] AR_VALID='b0010;
    localparam [3:0] AR_ACCESS='b0100;
    localparam [3:0] AR_COMPLETE='b1000;
    logic [3:0] AR_presentstate;
    logic [3:0] AR_nextstate;

    //read address channel nextstate register

    always_ff @(posedge ACLK or negedge ARESET_N) begin 
        if(!ARESET_N) begin
             AR_presentstate<= AR_IDLE;
        end else begin
             AR_presentstate<=AR_nextstate ;
        end
    end

    //read address channel nextstate logic

    always_comb begin 
        case (AR_presentstate)
        AR_IDLE:begin 
                if (!ARESET_N)
                AR_nextstate=AR_IDLE;
                else if (read_request)
                    AR_nextstate=AR_VALID;
                else
                    AR_nextstate=AR_IDLE;

                end
        AR_VALID:begin
                 if (read_request) 
                 AR_nextstate=AR_ACCESS;
                 else
                 AR_nextstate=AR_IDLE;
                 end 
        AR_ACCESS: begin
                 if (ARREADY)
                 AR_nextstate=AR_COMPLETE;
                 else
                 AR_nextstate=AR_ACCESS;
                 end 
        AR_COMPLETE:begin
                    AR_nextstate=AR_IDLE;
                        
                    end                      
            default :  AR_nextstate=AR_IDLE;
        endcase
        
    end
    //read address channel output logic
    always_ff @(posedge ACLK or negedge ARESET_N) begin 
        if(~ARESET_N) begin
     ARVALID <= 'b0;
        end else begin
              case (AR_presentstate)
                AR_IDLE:begin
                        ARVALID<='b0;
                        //ARADDR  <='b0;
                        end
                AR_VALID: begin 
                          ARVALID <= 'b1;
                          end
                AR_ACCESS:begin 
                          ARVALID<='b1;
                          end
                AR_COMPLETE:begin
                            ARVALID<='b1;
                            end                
                  default : ARVALID<='b0;
              endcase
        end
    end
    
   
     always_ff @(posedge ACLK or negedge ARESET_N)
         begin
    if (!ARESET_N)
    ARADDR<='h0;
    else if (read_request)
     ARADDR<=ext_raddr;
    else
     ARADDR<='h0;
     end   
    //read data channel
    localparam [3:0] R_IDLE='b0001;
    localparam [3:0] R_ADDRESSPHASE='b0010;
    localparam [3:0] R_READPHASE='b0100;
    localparam [3:0] R_COMPLETE='b1000;
    logic [3:0] R_presentstate;
    logic [3:0] R_nextstate;

    //read channel state register

    always_ff @(posedge ACLK or negedge ARESET_N) begin 
        if(!ARESET_N) begin
       R_presentstate<= R_IDLE;
        end else begin
      R_presentstate <=R_nextstate ;
        end
    end

    //read channel next state logic
    
    always_comb
    begin
     case (R_presentstate)
        R_IDLE:begin
               if (!ARESET_N ) 
                   R_nextstate=R_IDLE;
                   else
                    R_nextstate=R_ADDRESSPHASE;

               end
        R_ADDRESSPHASE:begin
                if (read_request && ARREADY) 

                   R_nextstate=R_READPHASE;
                else
                   R_nextstate=R_IDLE;
                end
        R_READPHASE:begin
               if ( RVALID) begin
                    R_nextstate=R_COMPLETE;
                       end 
                 else begin  
                    R_nextstate=R_READPHASE;
                    end 

                    end 
         R_COMPLETE:begin
                 
                    R_nextstate=R_IDLE;
                    end   
                                              
            default : R_nextstate=R_IDLE;
        endcase   
    end
    
   always_ff @(posedge ACLK or negedge ARESET_N)
begin
  if (~ARESET_N)
    RREADY <= 0;
  else if (RVALID)
    RREADY <= 'b1;
  else
    RREADY <= 'b0;
end


    always_ff @(posedge ACLK or negedge ARESET_N) begin
        if(~ARESET_N) begin
     ext_rdata <= 0;
        end else 
     ext_rdata <=RDATA ;
        
    end
    // assign ARADDR=ARESET_N?ext_raddr:'b0;
    //external data reset
  

endmodule