module swap_gate (
    input  [1:0] a,
    input  [1:0] b,
    output [1:0] lo,
    output [1:0] hi,
    output       swap
);

// TODO:
// Use cmp2_gate to decide whether a and b should be swapped.
// Use mux2_gate instances to drive lo and hi.
wire a_gt_b;

cmp2_gate u_cmp (
    .a(a), .b(), .gt()
);

// If a > b, swap them so lo=b and hi=a.
mux2_gate u_lo (
    .sel(), .in0(a), .in1(b), .y()
);

mux2_gate u_hi (
    .sel(), .in0(b), .in1(a), .y()
);

endmodule

module cmp2_gate (
    input  [1:0] a,
    input  [1:0] b,
    output       gt
);

// TODO:
// Build gt = (a > b) using gate primitives only.
wire not_b1;
wire not_b0;
wire a1_gt_b1;
wire a1_xnor_b1;
wire a0_gt_b0_and_a1_eq_b1;

not g0 (not_b1, b[1]);
not g1 (not_b0, b[0]);
and g2 (a1_gt_b1, ..., ...);
xnor g3 (a1_xnor_b1, a[1], b[1]);
and g4 (a0_gt_b0_and_a1_eq_b1, ..., ..., ...);
or  g5 (gt, ..., ...);

endmodule

module mux2_gate (
    input        sel,
    input  [1:0] in0,
    input  [1:0] in1,
    output [1:0] y
);

// TODO:
// Build y = sel ? in1 : in0 using gate primitives only.
wire not_sel;
wire in0_bit0;
wire in1_bit0;
wire in0_bit1;
wire in1_bit1;

not g0 (not_sel, sel);

and g1 (in0_bit0, in0[0], not_sel);
and g2 (in1_bit0, in1[0], sel);
or  g3 (y[0], in0_bit0, in1_bit0);

and g4 (...);
and g5 (...);
or  g6 (...);

endmodule