module Ex06_ShiftRegister (
    input        clk,
    input        rst_n,
    input        en,
    input        serial_in,
    output       serial_out,
    output reg [7:0] data
);

// ** shift register **
// When en is 1, data shifts left by one bit every clock cycle.
// serial_in enters from bit 0, and the old bit 7 becomes serial_out.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= 8'd0;
    end else if (en) begin
        data <= {data[6:0], serial_in};
    end else begin
        data <= data;
    end
end

assign serial_out = data[7];

endmodule
