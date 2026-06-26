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

// and_ab should be bitwise AND of a and b.
assign and_ab = ...;

// or_ab should be bitwise OR of a and b.
assign or_ab = ...;

// nand_ab should be bitwise NAND of a and b.
assign nand_ab = ...;

// has_one should be 1 if any bit of a is 1.
assign has_one = ...;

// odd_parity should be XOR reduction of a.
assign odd_parity = ...;

// keep_middle should keep only a[5:2], other bits become 0.
// Hint: use a mask shaped like 8'b00xx_xx00.
assign keep_middle = ...;

endmodule
