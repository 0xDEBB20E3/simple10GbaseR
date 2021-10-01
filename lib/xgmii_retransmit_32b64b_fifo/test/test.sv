// MIT License
// Copyright (c) 2021 0xDEBB20E3, 0xDEBB20E3@gmail.com  
// git@github.com:0xDEBB20E3/simple10GbaseR.git


`include "environment.sv"

program automatic test
#(
    parameter XGMII_WIDTH_TX = 32,
    parameter XGMII_WIDTH_RX = 64
)
(
    xgmii_if.TbTx Tx,
    xgmii_if.TbRx Rx
);

Environment #(.XGMII_WIDTH_TX(XGMII_WIDTH_TX),.XGMII_WIDTH_RX(XGMII_WIDTH_RX)) env;

initial begin
    env = new(Tx, Rx);
    env.build();
    env.run();
    env.wrap_up();
end

endprogram 

