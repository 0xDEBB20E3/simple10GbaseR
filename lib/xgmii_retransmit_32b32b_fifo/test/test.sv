// MIT License
// Copyright (c) 2021 0xDEBB20E3, 0xDEBB20E3@gmail.com  
// git@github.com:0xDEBB20E3/simple10GbaseR.git


`include "environment.sv"

program automatic test
#(
    parameter XGMII_WIDTH = 32
)
(
    xgmii_if.TbTx Tx,
    xgmii_if.TbRx Rx
);

Environment #(.XGMII_WIDTH(XGMII_WIDTH)) env;

initial begin
    env = new(Tx, Rx);
    env.build();
    env.run();
    env.wrap_up();
end

endprogram 

