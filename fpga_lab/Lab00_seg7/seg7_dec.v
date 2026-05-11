module seg7_dec (
    input      [3:0] value,
    output reg [6:0] seg
);

// TODO:
// Complete the decoder with a case statement.
// seg[6:0] = {a, b, c, d, e, f, g}
// active-low: 0 means ON, 1 means OFF.
always @(*) begin
    case (value)
        4'h0: seg = 7'b0000001;
        4'h1: seg = 7'b1001111;
        4'h2: seg = 7'b0010010;
        4'h3: seg = 7'b0000110;
        4'h4: seg = 7'b1001100;
        4'h5: seg = 7'b0100100;
        4'h6: ... // to be completed
        4'h7: ... // to be completed
        4'h8: ... // to be completed
        4'h9: ... // to be completed
        default: seg = 7'b1111111;
    endcase
end

endmodule