module Ex05_JKFF (
    input  clk,
    input  rst_n,
    input  j,
    input  k,
    output reg q,
    output     q_b
);

reg q_nxt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 1'b0;
    end else begin
        q <= q_nxt;
    end
end

// ** JK flip-flop truth table **
// j k | next q
// 0 0 | hold
// 0 1 | reset to 0
// 1 0 | set to 1
// 1 1 | toggle
always @(*) begin
    case ({j, k})
        2'b00: q_nxt = q;
        2'b01: q_nxt = 1'b0;
        2'b10: q_nxt = 1'b1;
        2'b11: q_nxt = ~q;
        default: q_nxt = q;
    endcase
end

assign q_b = ~q;

endmodule