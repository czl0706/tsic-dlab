module bcd_counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       clr,
    input  wire       en,
    input  wire       up,         // 1: count up, 0: hold (or you can extend to count down)
    output reg  [3:0] count,
    output wire       carry
);

assign carry = up && !clr && (count == 9);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
    end else if (clr) begin
        count <= 0;
    end else if (en) begin
        if (up) begin
            count <= (count == 9) ? 0 : (count + 1);
        end
    end
end

endmodule