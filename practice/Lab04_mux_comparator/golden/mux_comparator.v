module mux_comparator (
    input      [7:0] a,
    input      [7:0] b,

    input            sel,
    output     [7:0] mux_out,

    output     [7:0] larger,
    output     [7:0] smaller
);

wire a_gt_b;

// Output b if sel is 1, otherwise output a.
assign mux_out = sel ? b : a;

// Output larger and smaller values between a and b.
assign a_gt_b = (a > b);
assign {larger, smaller} = a_gt_b ? {a, b} : {b, a};

endmodule