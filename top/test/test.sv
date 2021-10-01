// MIT License
// Copyright (c) 2021 0xDEBB20E3, 0xDEBB20E3@gmail.com  
// git@github.com:0xDEBB20E3/simple10GbaseR.git


`include "environment.sv"

program automatic test
#(
    parameter XGMII_WIDTH_BASER = 64
)
(
    xgmii_if.TbTx baserTx,
    xgmii_if.TbRx baserRx
);

Environment #(.XGMII_WIDTH_BASER(XGMII_WIDTH_BASER)) env;

initial begin
    env = new(baserTx, baserRx);
    env.build();
    env.run();
    env.wrap_up();
end

endprogram 

