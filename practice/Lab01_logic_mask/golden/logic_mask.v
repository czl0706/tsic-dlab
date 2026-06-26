module logic_mask (
    input [7:0] a,
    input [7:0] b,

    output [7:0] and_ab,
    output [7:0] or_ab,
    output [7:0] nand_ab,

    output has_one,
    output odd_parity,

    output [7:0] keep_middle
);

assign and_ab = a & b;
assign or_ab = a | b;
assign nand_ab = ~(a & b);

assign has_one = |a;
assign odd_parity = ^a;

assign keep_middle = a & 8'b0011_1100;

endmodule
