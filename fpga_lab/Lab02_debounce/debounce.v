module debounce #(
    parameter N = 5 // Number of samples for debouncing
)(
    input clk,      // slow clock, e.g. 1kHz
    input rst,
    input btn_in,
    output btn_db
);

reg [N-1:0] shift_reg;

assign btn_db = ...; // btn_db is 1 if all bits in shift_reg are 1

always @(posedge clk or posedge rst) begin
    if (rst) begin
        shift_reg <= 0;
    end else begin
        shift_reg <= ...; // Shift in the btn_in into shift_reg
    end
end

endmodule