module Ex01_logic (
    input a,
    input b,
    output reg not_a, // = not a
    output reg o_and,  // = a and b
    output reg o_or,   // = a or b
    output reg o_xor,  // = a xor b
    output reg o_nand, // = not (a and b)

    input [3:0] in_v1,
    input [3:0] in_v2,
    output reg [3:0] inv_v1, // = not in_v1
    output reg [3:0] o_and_v, // = in_v1 and in_v2
    output reg [3:0] o_or_v,   // = in_v1 or in_v2

    input [3:0] in_v3,
    output reg [3:0] o_not_v3,
    output reg [3:0] o_reduced_and, // = and of all bits in in_v3
    output reg [3:0] o_reduced_or   // = or of all bits
);

// ** logical operations **
always @(*) begin
    not_a  = ~a; // assign value: not a, into the not_a
    o_and  = a & b;
    o_or   = a | b;
    o_xor  = a ^ b;

    o_nand = ~(a & b);
end

// ** bitwise operations **
always @(*) begin
    inv_v1  = ~in_v1;
    o_and_v = in_v1 & in_v2;
    o_or_v  = in_v1 | in_v2;
    o_not_v3 = ~in_v3;
end

// ** reduction operations **
always @(*) begin
    o_reduced_and = &in_v3; // equivalent to: in_v3[0] & in_v3[1] & in_v3[2] & in_v3[3]
    o_reduced_or  = |in_v3; // equivalent to: in_v3[0] | in_v3[1] | in_v3[2] | in_v3[3]
end

endmodule