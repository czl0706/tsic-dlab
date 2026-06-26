module basic_wire (
    input  [7:0] in,

    output [7:0] pass,
    output [7:0] const_42,

    output [3:0] lo_nibble,
    output [3:0] hi_nibble,

    output [15:0] zero_ext,
    output [15:0] sign_ext,

    output [7:0] swap_nibble
);

assign pass = in;
assign const_42 = 8'd42;
assign lo_nibble = in[3:0];
assign hi_nibble = in[7:4];
assign zero_ext = {8'b0, in};
assign sign_ext = {{8{in[7]}}, in};
assign swap_nibble = {in[3:0], in[7:4]};

endmodule
