module scan_ctrl (
    input             clk,
    input             rst,
    output reg  [1:0] scan_sel,
    output reg  [3:0] an
);

always @(posedge clk or posedge rst) begin
    if (rst)
        scan_sel <= 2'b00;
    else
        scan_sel <= scan_sel + 2'b01;
end

// Active-low select signal
always @(*) begin
    case (scan_sel)
        2'b00: an = 4'b1110;
        2'b01: an = 4'b1101;
        2'b10: an = 4'b1011;
        2'b11: an = 4'b0111;
        default: an = 4'b1111;
    endcase
end

endmodule
