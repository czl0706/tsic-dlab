module pulse_detector (
    input  clk,
    input  rst,
    input  in,
    output reg pulse
);

reg in_r;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        in_r  <= 1'b0;
        pulse <= 1'b0;
    end else begin
        in_r  <= ...; // register the input signal
        pulse <= in & ~in_r;
    end
end

endmodule