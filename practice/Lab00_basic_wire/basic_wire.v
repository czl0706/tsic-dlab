module basic_wire (
    input  [7:0] in,

    output [7:0] pass,

    output [3:0] lo_nibble,
    output [3:0] hi_nibble,

    output [15:0] sign_ext,

    output [7:0] swap_nibble
);

// pass should equal in.
assign pass = ...;

// lo_nibble should be in[3:0].
assign lo_nibble = ...;

// hi_nibble should be in[7:4].
assign hi_nibble = ...;

// sign_ext should extend in to 16 bits using in[7] as the sign bit.
assign sign_ext = ...;

// swap_nibble should be {lo_nibble, hi_nibble}.
// Example: 8'hAB -> 8'hBA
assign swap_nibble = ...;

endmodule
