module sorter4 (
    input  [7:0] v0,
    input  [7:0] v1,
    input  [7:0] v2,
    input  [7:0] v3,
    output [7:0] o0,
    output [7:0] o1,
    output [7:0] o2,
    output [7:0] o3
);

wire [7:0] s0_min, s0_max;
wire [7:0] s1_min, s1_max;
wire [7:0] s2_min, s2_max;
wire [7:0] s3_min, s3_max;
wire [7:0] s4_min, s4_max;

// Sorting network for four unsigned values.
sorter4_cmp c0 (.a(v0),     .b(v1),     .min(s0_min), .max(s0_max));
sorter4_cmp c1 (.a(v2),     .b(v3),     .min(s1_min), .max(s1_max));
sorter4_cmp c2 (.a(s0_min), .b(s1_min), .min(o0),     .max(s2_max));
sorter4_cmp c3 (.a(s0_max), .b(s1_max), .min(s3_min), .max(o3));
sorter4_cmp c4 (.a(s2_max), .b(s3_min), .min(o1),     .max(o2));

endmodule

module sorter4_cmp (
    input      [7:0] a,
    input      [7:0] b,
    output reg [7:0] min,
    output reg [7:0] max
);

always @(*) begin
    if (a > b) begin
        min = b;
        max = a;
    end else begin
        min = a;
        max = b;
    end

    // Same as {min, max} = (a > b) ? {b, a} : {a, b};
end

endmodule