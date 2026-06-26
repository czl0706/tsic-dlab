module basic_wire (
    input  [7:0] in,

    output [7:0] pass,

    output [3:0] lo_nibble,
    output [3:0] hi_nibble,

    output [15:0] sign_ext,

    output [7:0] swap_nibble
);

assign pass = in;
assign lo_nibble = in[3:0];
assign hi_nibble = in[7:4];
assign sign_ext = {{8{in[7]}}, in};
assign swap_nibble = {lo_nibble, hi_nibble};

endmodule
