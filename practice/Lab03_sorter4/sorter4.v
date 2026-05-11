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

// TODO:
// Build a 4-element sorting network with comparator modules.
// Output order: o0 <= o1 <= o2 <= o3.
wire [7:0] s0_min, s0_max;
wire [7:0] s1_min, s1_max;
... // Any other wires needed?

// Sorting network for four unsigned values.
sorter4_cmp c0 (.a(v0),     .b(v1),     .min(s0_min), .max(s0_max));
sorter4_cmp c1 (.a(v2),     .b(v3),     .min(s1_min), .max(s1_max));
... // Any other comparator module needed?

endmodule

module sorter4_cmp (
    input      [7:0] a,
    input      [7:0] b,
    output reg [7:0] min,
    output reg [7:0] max
);

// TODO:
// Compare a and b, then drive min and max.
always @(*) begin
    ... // To be completed
end

endmodule