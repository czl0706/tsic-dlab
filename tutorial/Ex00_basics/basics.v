module Ex00_basics (
    // IO port declaration
    input      [7:0] in,
    output reg [7:0] out_reg,
    output     [7:0] out_ass,
    output     [7:0] const_15,
    output     [7:0] const_63,
    output     [1:0] bresp,

    output     [ 3:0] lo_nibs,
    output     [ 3:0] hi_nibs,
    output     [ 7:0] in_sign,
    output     [15:0] out_s16 
);

// ** combinational logic **

// dataflow modeling
assign out_ass = in; // direct assignment

// behavioral modeling
always @(*) begin
    out_reg = in; // blocking assignment
end

// ** constants **
assign const_15 = 15;
assign const_63 = 319; // 319 % 256 = 63

// ** parameters **
localparam BRESP_DECERR = 2'b11;
assign bresp = BRESP_DECERR;

// ** bit slice **
assign in_sign = in[7:0];
assign lo_nibs = in[3:0];
assign hi_nibs = in[7:4];
assign out_s16 = {{8{in[7]}}, in[7:0]};

endmodule