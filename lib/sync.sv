// MIT License
// Copyright (c) 2021 0xDEBB20E3, 0xDEBB20E3@gmail.com  
// git@github.com:0xDEBB20E3/simple10GbaseR.git


module sync
#(
    parameter LENGHT = 2,
    parameter INIT = 0
)
(
    input wire clk,
    input wire in,
    output wire out
);    

reg [LENGHT-1:0] sjy63sd19_sync_r = '{LENGHT{INIT}} /* synthesis keep = 1 */;

always @(posedge clk) sjy63sd19_sync_r <= {sjy63sd19_sync_r[LENGHT-2],in};
assign out = sjy63sd19_sync_r[LENGHT-1];

endmodule
