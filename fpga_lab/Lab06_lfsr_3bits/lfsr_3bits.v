module lfsr_3bits (
	input        clk,
	input        rst,
	input        en,
	output [2:0] lfsr_out
);

parameter LFSR_INIT = 3'b101;
reg [2:0] lfsr, lfsr_nxt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        lfsr <= LFSR_INIT;
    end else begin
        lfsr <= lfsr_nxt;
    end
end

always @(*) begin
    if (en) begin
        // LFSR logic: shift left and feed in the XOR of the first and last bits
        lfsr_nxt = {lfsr[], lfsr[]  lfsr[]}; // To be completed
    end else begin
        lfsr_nxt = lfsr;
    end
end

assign lfsr_out = lfsr;

endmodule
