module pwm (
    input  wire       clk,
    input  wire       rst,
    input  wire [6:0] duty,
    output reg        pwm_out
);

reg [6:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        pwm_out <= 1'b0;
    end else begin
        count <= (count == 99) ? 0 : (count + 1);
        pwm_out <= (count < duty);
    end
end

endmodule
