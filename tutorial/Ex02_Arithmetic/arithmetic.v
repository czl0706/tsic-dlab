module Ex02_Arithmetic (
    input      [7:0] in_a,
    input      [7:0] in_b,
    output     [8:0]  u_add,
    output     [8:0]  u_sub,
    output     [7:0]  u_add_8,
    output     [7:0]  u_sub_8,
    output     [8:0]  u_add_ext,
    output     [8:0]  u_sub_ext,
    output     [15:0] u_mul,
    output     [7:0]  u_sr,
    output     [7:0]  u_sl,
    output     [15:0] u_sl_wide,

    input signed [7:0] s_a,
    input signed [7:0] s_b,
    input        [1:0] shamt,
    output signed [8:0]  s_add,
    output signed [8:0]  s_sub,
    output signed [15:0] s_mul,

    output signed [7:0]  s_sr_logic,
    output signed [7:0]  s_sr_arith,
    output signed [7:0]  s_sl
);

// ** unsigned arithmetic operations **
assign u_add = in_a + in_b; // Direct expression assigned to a 9-bit output
assign u_sub = in_a - in_b; // Direct expression assigned to a 9-bit output

// Assigning the same expression to an 8-bit output shows wraparound.
// Example: 8'd250 + 8'd10 becomes 8'd4 here.
assign u_add_8 = in_a + in_b;
assign u_sub_8 = in_a - in_b;

// Explicitly extend operands when you want to make the 9-bit arithmetic visible.
// Example: 8'd250 + 8'd10 gives 9'd260 here.
assign u_add_ext = {1'b0, in_a} + {1'b0, in_b};
assign u_sub_ext = {1'b0, in_a} - {1'b0, in_b};

assign u_mul = in_a * in_b; // 8-bit x 8-bit = 16-bit result

assign u_sr = in_a >> 2; // Shift right by 2 equals to division by 4
assign u_sl = in_a << 2; // Shift left by 2 equals to multiplication by 4
assign u_sl_wide = {8'b0, in_a} << 4; // Use a wider destination when you want to keep bits shifted out of 8 bits.

// ** signed arithmetic examples **
// Use signed ports/sign extension when the values represent negative numbers.
assign s_add = s_a + s_b;
assign s_sub = s_a - s_b;
assign s_mul = s_a * s_b;

// For signed negative values, >> still fills with 0, but >>> keeps the sign bit.
assign s_sr_logic = s_a >> shamt;
assign s_sr_arith = s_a >>> shamt;
assign s_sl       = s_a <<< shamt;

endmodule