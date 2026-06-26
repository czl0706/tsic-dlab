module alu_comp (
    input         clk,
    input         rst_n,

    input         wen,
    input  [1:0]  waddr,
    input  [7:0]  wdata,

    input  [1:0]  src_a,
    input  [1:0]  src_b,
    input  [1:0]  op,

    output [7:0]  reg0,
    output [7:0]  reg1,
    output [7:0]  reg2,
    output [7:0]  reg3,
    output reg [15:0] result
);

localparam OP_ADD  = 2'd0;
localparam OP_SUB  = 2'd1;
localparam OP_MUL  = 2'd2;
localparam OP_DIV2 = 2'd3;

reg [7:0] regs [0:3];
reg [7:0] a_val;
reg [7:0] b_val;

// ** register set write **
// Four 8-bit registers can be updated by wen, waddr, and wdata.
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 4; i = i + 1) begin
            regs[i] <= 8'd0;
        end
    end
    else if (wen) begin
        regs[waddr] <= wdata;
    end
end

// ** expose all registers for direct read **
assign reg0 = regs[0];
assign reg1 = regs[1];
assign reg2 = regs[2];
assign reg3 = regs[3];

// ** register source selection **
always @(*) begin
    a_val = regs[src_a];
    b_val = regs[src_b];
end

// ** ALU operations **
// ADD/SUB/MUL use src_a and src_b. DIV2 uses only src_a.
always @(*) begin
    case (op)
        OP_ADD: begin
            result = a_val + b_val;
        end
        OP_SUB: begin
            result = a_val - b_val;
        end
        OP_MUL: begin
            result = a_val * b_val;
        end
        OP_DIV2: begin
            result = a_val >> 1;
        end
        default: begin
            result = 16'd0;
        end
    endcase
end

endmodule