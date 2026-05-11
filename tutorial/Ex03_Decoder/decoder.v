module Ex03_Decoder (
    input  [1:0] sel,
    output reg [3:0] onehot_case,
    output     [3:0] onehot_shift
);

// ** one-hot decoder with case **
// When en is 1, exactly one output bit is selected by sel.
always @(*) begin
    case (sel)
        2'd0: onehot_case = 4'b0001;
        2'd1: onehot_case = 4'b0010;
        2'd2: onehot_case = 4'b0100;
        2'd3: onehot_case = 4'b1000;
        default: onehot_case = 4'b0000;
    endcase
end

// ** one-hot decoder with shift **
assign onehot_shift = 1 << sel; // Same to the 2-to-4 decoder above
endmodule