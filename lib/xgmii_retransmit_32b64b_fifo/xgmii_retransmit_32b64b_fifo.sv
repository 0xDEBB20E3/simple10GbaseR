import gtype::xgmii32_t;
import gtype::xgmii64_t;

module xgmii_retransmit_32b64b_fifo
(
    input wire clk_32,
    input wire rst_32,
    input wire clk_64,
    input wire rst_64,
    input xgmii32_t xgmii32,
    output xgmii64_t xgmii64
);

wire [79:0] fifo_xgmii_retransmit_64b64b_data_w    ;
wire        fifo_xgmii_retransmit_64b64b_rdclk_w   ;
wire        fifo_xgmii_retransmit_64b64b_rdreq_w   ;
wire        fifo_xgmii_retransmit_64b64b_wrclk_w   ;
wire        fifo_xgmii_retransmit_64b64b_wrreq_w   ;
wire [79:0] fifo_xgmii_retransmit_64b64b_q_w       ;
wire        fifo_xgmii_retransmit_64b64b_rdempty_w ;
wire        fifo_xgmii_retransmit_64b64b_wrfull_w  ;
wire [8:0]  fifo_xgmii_retransmit_64b64b_rdusedw_w ;

wire        start_w = xgmii32.ena &  (xgmii32.ctrl==4'b0001 & xgmii32.data[7:0]==8'hFB);

wire        state_w = xgmii32.ena & ((xgmii32.ctrl==4'b0001 & xgmii32.data[7:0]==8'hFB) | //start
                                     (xgmii32.ctrl==4'b0000                           ) | //data 
                                     (xgmii32.ctrl==4'b1111 & xgmii32.data[7:0]==8'hFD) | //stop
                                     (xgmii32.ctrl==4'b1110                           ) | //stop
                                     (xgmii32.ctrl==4'b1100                           ) | //stop
                                     (xgmii32.ctrl==4'b1000                           ) );//stop

xgmii32_t     xgmii32_r;
reg           cnt_32_r = 0;
reg           state_0r = 0;
reg           state_1r = 0;

always @(posedge clk_32) if (xgmii32.ena) xgmii32_r <= xgmii32;
always @(posedge clk_32) if (xgmii32.ena) state_0r  <= state_w;
always @(posedge clk_32) if (xgmii32.ena) state_1r  <= state_0r;

always @(posedge clk_32) begin
    if      (rst_32 )     begin cnt_32_r <= 0;          end
    else if (start_w)     begin cnt_32_r <= 1;          end
    else if (xgmii32.ena) begin cnt_32_r <= !cnt_32_r;  end
end

////////////////////////////////////////////////////////////////////////////////
assign fifo_xgmii_retransmit_64b64b_wrclk_w  = clk_32; 
assign fifo_xgmii_retransmit_64b64b_wrreq_w  = cnt_32_r & !start_w & xgmii32.ena & (state_w | state_0r | state_1r);
assign fifo_xgmii_retransmit_64b64b_data_w   = {xgmii32.ctrl,xgmii32_r.ctrl,xgmii32.data,xgmii32_r.data};
assign fifo_xgmii_retransmit_64b64b_rdclk_w  = clk_64;
assign fifo_xgmii_retransmit_64b64b_rdreq_w  = !fifo_xgmii_retransmit_64b64b_rdempty_w;

fifo_xgmii_retransmit_64b64b fifo_xgmii_retransmit_64b64b_u 
(
    .wrclk   (fifo_xgmii_retransmit_64b64b_wrclk_w  ),
    .wrreq   (fifo_xgmii_retransmit_64b64b_wrreq_w  ),
    .data    (fifo_xgmii_retransmit_64b64b_data_w   ),
    .wrfull  (fifo_xgmii_retransmit_64b64b_wrfull_w ),
    .rdclk   (fifo_xgmii_retransmit_64b64b_rdclk_w  ),
    .rdreq   (fifo_xgmii_retransmit_64b64b_rdreq_w  ),
    .q       (fifo_xgmii_retransmit_64b64b_q_w      ),
    .rdempty (fifo_xgmii_retransmit_64b64b_rdempty_w),
    .rdusedw (fifo_xgmii_retransmit_64b64b_rdusedw_w)
);
////////////////////////////////////////////////////////////////////////////////

assign xgmii64.data = fifo_xgmii_retransmit_64b64b_q_w[63:0];
assign xgmii64.ctrl = fifo_xgmii_retransmit_64b64b_q_w[71:64];
assign xgmii64.ena  = fifo_xgmii_retransmit_64b64b_rdreq_w;

endmodule
