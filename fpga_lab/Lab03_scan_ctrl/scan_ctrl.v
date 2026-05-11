module scan_ctrl (
    input             clk,
    input             rst,
    output reg  [1:0] scan_sel,
    output reg  [3:0] an
);

// Input: clk, rst
// Output: scan_sel, an

// Output scan_sel that count from 0 to 3, and then repeat
// Output an decode the scan_sel to active-low select signal
// E.g., when scan_sel is 0, an should be 1110; when scan_sel is 1, an should be 1101; ...

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ...
    end else begin
        ...
    end
end

// Active-low select signal
always @(*) begin
    case (scan_sel)
        ...
    endcase
end

endmodule
