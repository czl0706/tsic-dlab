module swap_gate (
    input  [1:0] a,
    input  [1:0] b,
    output [1:0] lo,
    output [1:0] hi,
    output       swap
);

wire a_gt_b;

cmp2_gate u_cmp (
    .a(a),
    .b(b),
    .gt(a_gt_b)
);

// If a > b, swap them so lo=b and hi=a.
assign swap = a_gt_b;
mux2_gate u_lo (
    .sel(swap),
    .in0(a),
    .in1(b),
    .y(lo)
);

mux2_gate u_hi (
    .sel(swap),
    .in0(b),
    .in1(a),
    .y(hi)
);

endmodule

module cmp2_gate (
    input  [1:0] a,
    input  [1:0] b,
    output       gt
);

assign gt = (a > b);

endmodule

module mux2_gate (
    input        sel,
    input  [1:0] in0,
    input  [1:0] in1,
    output [1:0] y
);

wire not_sel;
wire in0_bit0;
wire in1_bit0;
wire in0_bit1;
wire in1_bit1;

not g0 (not_sel, sel);

and g1 (in0_bit0, in0[0], not_sel);
and g2 (in1_bit0, in1[0], sel);
or  g3 (y[0], in0_bit0, in1_bit0);

and g4 (in0_bit1, in0[1], not_sel);
and g5 (in1_bit1, in1[1], sel);
or  g6 (y[1], in0_bit1, in1_bit1);

endmodule
