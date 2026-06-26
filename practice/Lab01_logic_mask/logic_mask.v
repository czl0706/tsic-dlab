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

// inv_a should be bitwise NOT of a.
assign inv_a = ...;

// and_ab should be bitwise AND of a and b.
assign and_ab = ...;

// or_ab should be bitwise OR of a and b.
assign or_ab = ...;

// xor_ab should be bitwise XOR of a and b.
assign xor_ab = ...;

// nand_ab should be bitwise NAND of a and b.
assign nand_ab = ...;

// has_one should be 1 if any bit of a is 1.
assign has_one = ...;

// all_one should be 1 if all bits of a are 1.
assign all_one = ...;

// odd_parity should be XOR reduction of a.
assign odd_parity = ...;

// keep_low should keep only a[3:0], upper bits become 0.
assign keep_low = ...;

// keep_high should keep only a[7:4], lower bits become 0.
assign keep_high = ...;

endmodule
