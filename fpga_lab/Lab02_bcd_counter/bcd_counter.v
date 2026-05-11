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
        // When up is high, count up, and roll over to 0 after 9.
        if (...) begin
            ...
        end
    end
end

endmodule