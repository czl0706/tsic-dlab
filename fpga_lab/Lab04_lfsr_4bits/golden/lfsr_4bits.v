module lfsr_4bits (
	input        clk,
	input        rst,
	input        en,
	output [3:0] lfsr_out
);

parameter LFSR_INIT = 4'b1011;
reg [3:0] lfsr, lfsr_nxt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        lfsr <= LFSR_INIT;
    end else begin
        lfsr <= lfsr_nxt;
    end
end

always @(*) begin
    if (en) begin
        lfsr_nxt = {lfsr[2:0], lfsr[3] ^ lfsr[0]};
    end else begin
        lfsr_nxt = lfsr;
    end
end

assign lfsr_out = lfsr;

endmodule
