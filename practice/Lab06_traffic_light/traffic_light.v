module traffic_light (
    input        clk,
    input        rst_n,
    output reg   red,
    output reg   yellow,
    output reg   green,
    output reg [3:0] timer
);

localparam S_GREEN  = 2'd0;
localparam S_YELLOW = 2'd1;
localparam S_RED    = 2'd2;

localparam GREEN_TIME  = 4'd5;
localparam YELLOW_TIME = 4'd2;
localparam RED_TIME    = 4'd5;

reg [1:0] S, S_nxt;
reg [3:0] timer_nxt;

// ** state register and timer register **
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        S     <= S_GREEN;
        timer <= 4'd0;
    end else begin
        S     <= S_nxt;
        timer <= timer_nxt;
    end
end

// ** state transition and timer update **
always @(*) begin
    // default behavior:
    // stay in the same state and count up
    S_nxt     = S;
    timer_nxt = timer + 4'd1;

    case (S)
        S_GREEN: begin
            if (timer == GREEN_TIME - 1) begin
                S_nxt     = S_YELLOW;
                timer_nxt = 4'd0;
            end
        end

        S_YELLOW: begin
            ...; // To be completed
        end

        S_RED: begin
            ...; // To be completed
        end

        default: begin
            S_nxt     = S_GREEN;
            timer_nxt = 4'd0;
        end
    endcase
end

// ** output decoder **
always @(*) begin
    red    = 1'b0;
    yellow = 1'b0;
    green  = 1'b0;

    case (S)
        S_GREEN:  ...; // To be completed
        S_YELLOW: ...; // To be completed
        S_RED:    ...; // To be completed
        default:  green  = 1'b1;
    endcase
end

endmodule