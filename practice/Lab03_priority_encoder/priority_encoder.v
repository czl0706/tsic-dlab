module priority_encoder (
    input      [7:0] in,
    output reg [2:0] out
);

// TODO:
// Implement an 8-to-3 priority encoder.
// Higher input bit has higher priority.
always @(*) begin
    out = 3'd0;

    casez (in)
        8'b1???_????: out = 3'd7;
        8'b01??_????: out = 3'd6;
        8'b001?_????: out = 3'd5;
        8'b0001_????: ...; // To be completed
        8'b0000_1???: ...; // To be completed
        8'b0000_01??: ...; // To be completed
        8'b0000_001?: ...; // To be completed
        8'b0000_0001: ...; // To be completed
        default:      out = 3'd0;
    endcase
end

endmodule