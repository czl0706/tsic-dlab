module clk_divN # (
    parameter N = 10
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
        if (cnt == (N/2 - 1)) begin
            cnt <= 0;
            clk_out <= ~clk_out;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule