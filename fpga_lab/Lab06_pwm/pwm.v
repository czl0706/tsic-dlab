module pwm (
    input  wire       clk,
    input  wire       rst,
    input  wire [6:0] duty,     // 0 to 100 percent
    output reg        pwm_out
);

reg [6:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        pwm_out <= 1'b0;
    end else begin
        // Advance count from 0 to 99, then roll over.
        if (...) begin
            ...
        end else begin
            ...
        end

        // Output high while count is lower than the duty percentage.
        pwm_out <= ...;
    end
end

endmodule
