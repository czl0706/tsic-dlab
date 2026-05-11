module clk_divN # (
    parameter N = 4
) (
    input  clk_in,
    input  rst,
    output reg clk_out
);
reg [$clog2(N)-1:0] cnt;

always @(posedge clk_in or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        clk_out <= 1'b0;
    end else begin
        if (cnt == ...) begin // toggle clk_out every N/2 cycles
            cnt <= 0;
            clk_out <= ... ; // toggle clk_out
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule