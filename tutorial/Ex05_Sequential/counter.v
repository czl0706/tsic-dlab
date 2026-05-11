module Ex05_Counter (
    input        clk,
    input        rst_n,
    input        en,
    input        clear,
    output reg [3:0] cnt,
    output       rollover
);

reg [3:0] cnt_nxt;

// ** state transition **
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'd0;
    end else begin
        cnt <= cnt_nxt;
    end
end

// ** next state logic **
always @(*) begin
    if (clear) begin
        cnt_nxt = 4'd0;
    end else if (en) begin
        cnt_nxt = cnt + 4'd1;
    end else begin
        cnt_nxt = cnt;
    end
end

// ** output logic **
assign rollover = en && (cnt == 4'hf);

endmodule