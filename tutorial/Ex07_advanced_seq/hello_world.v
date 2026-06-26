module Ex07_HelloWorld (
    input        clk,
    input        rst_n,
    output reg [7:0] char
);

localparam MSG_LEN = 14;

reg [3:0] index;
reg [7:0] message [0:MSG_LEN-1];

// ** Array as a small ROM **
initial begin
    message[0]  = 8'h48; // H
    message[1]  = 8'h65; // e
    message[2]  = 8'h6c; // l
    message[3]  = 8'h6c; // l
    message[4]  = 8'h6f; // o
    message[5]  = 8'h20; // space
    message[6]  = 8'h57; // W
    message[7]  = 8'h6f; // o
    message[8]  = 8'h72; // r
    message[9]  = 8'h6c; // l
    message[10] = 8'h64; // d
    message[11] = 8'h20; // space
    message[12] = 8'h21; // !
    message[13] = 8'h20; // space
end

// ** sequential index counter **
// index advances every cycle and wraps around
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        index <= 4'd0;
    end else begin
        if (index == MSG_LEN - 1) begin
            index <= 4'd0;
        end else begin
            index <= index + 4'd1;
        end
    end
end

// ** array read **
// char is the ASCII character selected by the current index
always @(*) begin
    char = message[index];
end

endmodule
