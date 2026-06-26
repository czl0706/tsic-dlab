module Ex07_VendingMachine (
    input        clk,
    input        rst_n,
    input        coin_5,
    input        coin_10,
    output reg   vend,
    output reg   change_5,
    output reg [3:0] amount
);

localparam S0  = 2'd0;
localparam S5  = 2'd1;
localparam S10 = 2'd2;

reg [1:0] S, S_nxt;

reg       vend_nxt;
reg       change_5_nxt;
reg [3:0] amount_nxt;

// ** state and output register **
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        S        <= S0;
        vend     <= 1'b0;
        change_5 <= 1'b0;
        amount   <= 4'd0;
    end else begin
        S        <= S_nxt;
        vend     <= vend_nxt;
        change_5 <= change_5_nxt;
        amount   <= amount_nxt;
    end
end

// ** next state and next output logic **
// Price is 15. The machine accepts 5 and 10 coins.
// coin_10 has higher priority than coin_5.
always @(*) begin
    S_nxt        = S;
    vend_nxt     = 1'b0;
    change_5_nxt = 1'b0;

    case (S)
        S0: begin
            if (coin_10) begin
                S_nxt = S10;
            end else if (coin_5) begin
                S_nxt = S5;
            end
        end

        S5: begin
            if (coin_10) begin
                // 5 + 10 = 15
                vend_nxt = 1'b1;
                S_nxt    = S0;
            end else if (coin_5) begin
                // 5 + 5 = 10
                S_nxt = S10;
            end
        end

        S10: begin
            if (coin_10) begin
                // 10 + 10 = 20, return 5
                vend_nxt     = 1'b1;
                change_5_nxt = 1'b1;
                S_nxt        = S0;
            end else if (coin_5) begin
                // 10 + 5 = 15
                vend_nxt = 1'b1;
                S_nxt    = S0;
            end
        end

        default: begin
            S_nxt = S0;
        end
    endcase

    case (S_nxt)
        S0:      amount_nxt = 4'd0;
        S5:      amount_nxt = 4'd5;
        S10:     amount_nxt = 4'd10;
        default: amount_nxt = 4'd0;
    endcase
end

endmodule
