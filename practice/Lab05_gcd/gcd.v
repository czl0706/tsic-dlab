module gcd (
    input        clk,
    input        rst_n,
    input        in_valid,
    input  [7:0] a,
    input  [7:0] b,
    output reg   out_valid,
    output reg [7:0] result
);

localparam IDLE = 2'd0;
localparam BUSY = 2'd1;
localparam DONE = 2'd2;

reg [1:0] S, S_nxt;
reg [7:0] x, x_nxt;
reg [7:0] y, y_nxt;

always @(*) begin
    S_nxt = S;
    x_nxt = x;
    y_nxt = y;

    case (S)
        IDLE: begin
            if (in_valid) begin
                x_nxt = a;
                y_nxt = b;
                S_nxt = BUSY;
            end
        end

        BUSY: begin
            // If either x or y is zero, we are done
            // Otherwise, subtract the smaller from the larger

            // To be completed
            if (...) begin
                ...;
            end else if (x > y) begin
                ...;
            end else begin
                ...;
            end
        end

        DONE: begin
            S_nxt = IDLE;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        S <= IDLE;
        x <= 8'd0;
        y <= 8'd0;
    end
    else begin
        S <= S_nxt;
        x <= x_nxt;
        y <= y_nxt;
    end
end

always @(*) begin
    out_valid = (S == DONE);
    result = (x == 0) ? y : x;
end

endmodule