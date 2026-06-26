module counter #(
    parameter MAX_COUNT   = 9,
    parameter COUNT_WIDTH = $clog2(MAX_COUNT + 1)
) (
    input  wire       clk,
    input  wire       rst,
    input  wire       clr,
    input  wire       en,
    input  wire       up,         // 1: count up, 0: hold (or you can extend to count down)
    output reg  [COUNT_WIDTH-1:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
    end else if (clr) begin
        count <= 0;
    end else if (en) begin
        if (up) begin
            count <= (count == MAX_COUNT) ? 0 : (count + 1);
        end
    end
end

endmodule
