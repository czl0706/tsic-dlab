module Ex04_condition (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] value,
    input  [7:0] low,
    input  [7:0] high,

    output       a_gt_b,
    output       a_eq_b,
    output       value_in_range,
    output [7:0] larger,
    output [7:0] smaller,
    output reg [7:0] clamped
);

// ** comparison results **
assign a_gt_b = (a > b);
assign a_eq_b = (a == b);
assign value_in_range = (value >= low) && (value <= high);

// ** conditional operator **
// Use ternary operator for simple two-way choices
assign larger  = (a > b) ? a : b;
assign smaller = (a > b) ? b : a;

// ** if / else condition **
// Clamp value into [low, high].
always @(*) begin
    if (value < low) begin
        clamped = low;
    end else if (value > high) begin
        clamped = high;
    end else begin
        clamped = value;
    end
end

endmodule
