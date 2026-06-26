module fsm_calc (
    input         clk,
    input         rst_n,

    input         btn_valid,
    input  [3:0]  btn,

    output reg [15:0] out
);

// ------------------------------
// Button encoding
// ------------------------------
localparam BTN_ADD = 4'd11;
localparam BTN_SUB = 4'd12;
localparam BTN_MUL = 4'd13;
localparam BTN_EQ  = 4'd14;
localparam BTN_AC  = 4'd15;

// ------------------------------
// FSM states
// ------------------------------
localparam S_FIRST  = 2'd0; // entering first number
localparam S_WAIT   = 2'd1; // operator pressed, waiting for second number
localparam S_SECOND = 2'd2; // entering second number
localparam S_RESULT = 2'd3; // result shown

// ------------------------------
// Operator encoding
// No OP_NONE needed.
// Whether an operator is pending is represented by state.
// ------------------------------
localparam OP_ADD = 2'd0;
localparam OP_SUB = 2'd1;
localparam OP_MUL = 2'd2;

reg [1:0] S, S_nxt;

reg [15:0] acc, acc_nxt; // left-hand operand / accumulated result
reg [1:0]  op, op_nxt;
reg [15:0] out_nxt;

// ------------------------------
// Registers
// ------------------------------
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        S   <= S_FIRST;
        acc <= 0;
        op  <= OP_ADD;
        out <= 0;
    end else begin
        S   <= S_nxt;
        acc <= acc_nxt;
        op  <= op_nxt;
        out <= out_nxt;
    end
end

// ------------------------------
// Button decode
// ------------------------------
wire is_digit = (btn < 10);
wire is_op = (btn == BTN_ADD) || (btn == BTN_SUB) || (btn == BTN_MUL);
wire is_eq = (btn == BTN_EQ);

reg [1:0] btn_op;
always @(*) begin
    case (btn)
        BTN_ADD: btn_op = OP_ADD;
        BTN_SUB: btn_op = OP_SUB;
        BTN_MUL: btn_op = OP_MUL;
        default: btn_op = OP_ADD;
    endcase
end

// ------------------------------
// Datapath: acc op out
// ------------------------------
reg [15:0] alu_result;

always @(*) begin
    case (op)
        OP_ADD:  alu_result = acc + out;
        OP_SUB:  alu_result = acc - out;
        OP_MUL:  alu_result = acc * out;
        default: alu_result = acc + out;
    endcase
end

// ------------------------------
// Next-state and datapath logic
// ------------------------------
always @(*) begin
    S_nxt   = S;
    acc_nxt = acc;
    op_nxt  = op;
    out_nxt = out;

    if (btn_valid) begin
        if (btn == BTN_AC) begin
            S_nxt   = S_FIRST;
            acc_nxt = 0;
            op_nxt  = OP_ADD;
            out_nxt = 0;
        end else begin
            case (S)
                // ----------------------------------
                // Entering first number
                // ----------------------------------
                S_FIRST: begin
                    if (is_digit) begin
                        out_nxt = out * 10 + btn;
                    end else if (is_op) begin
                        acc_nxt = out;
                        op_nxt  = btn_op;
                        S_nxt   = S_WAIT;
                    end else if (is_eq) begin
                        S_nxt = S_RESULT;
                    end
                end

                // ----------------------------------
                // Operator pressed, waiting for RHS
                // ----------------------------------
                S_WAIT: begin
                    if (is_digit) begin
                        out_nxt = btn;
                        S_nxt   = S_SECOND;
                    end else if (is_op) begin
                        // allow changing operator before entering RHS
                        op_nxt = btn_op;
                    end else if (is_eq) begin
                        // no RHS entered, just keep current display
                        S_nxt = S_RESULT;
                    end
                end

                // ----------------------------------
                // Entering second number
                // ----------------------------------
                S_SECOND: begin
                    if (is_digit) begin
                        out_nxt = out * 10 + btn;
                    end else if (is_op) begin
                        acc_nxt = alu_result;
                        out_nxt = alu_result;
                        op_nxt  = btn_op;
                        S_nxt   = S_WAIT;
                    end else if (is_eq) begin
                        acc_nxt = alu_result;
                        out_nxt = alu_result;
                        S_nxt   = S_RESULT;
                    end
                end

                // ----------------------------------
                // Result shown
                // ----------------------------------
                S_RESULT: begin
                    if (is_digit) begin
                        acc_nxt = 0;
                        out_nxt = btn;
                        S_nxt   = S_FIRST;
                    end else if (is_op) begin
                        acc_nxt = out;
                        op_nxt  = btn_op;
                        S_nxt   = S_WAIT;
                    end else if (is_eq) begin
                        S_nxt = S_RESULT;
                    end
                end

                default: begin
                    S_nxt   = S_FIRST;
                    acc_nxt = 0;
                    op_nxt  = OP_ADD;
                    out_nxt = 0;
                end
            endcase
        end
    end
end

endmodule