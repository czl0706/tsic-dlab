module logic_mask (
    input [7:0] a,
    input [7:0] b,

    output [7:0] inv_a,
    output [7:0] and_ab,
    output [7:0] or_ab,
    output [7:0] xor_ab,
    output [7:0] nand_ab,

    output has_one,
    output all_one,
    output odd_parity,

    output [7:0] keep_low,
    output [7:0] keep_high
);

assign inv_a = ~a;
assign and_ab = a & b;
assign or_ab = a | b;
assign xor_ab = a ^ b;
assign nand_ab = ~(a & b);

assign has_one = |a;
assign all_one = &a;
assign odd_parity = ^a;

assign keep_low = a & 8'h0f;
assign keep_high = a & 8'hf0;

endmodule
