// ============================================================
// SRAM Matrix Multiplication Accelerator
// ------------------------------------------------------------
// Function:
//   C = A * B
//
// Matrix size:
//   A: 4 x 4
//   B: 4 x 4
//   C: 4 x 4
//
// Data layout:
//   A SRAM:
//     A_addr = i returns one row tile:
//       {A[i][3], A[i][2], A[i][1], A[i][0]}
//
//   B SRAM:
//     B_addr = j returns one column tile:
//       {B[3][j], B[2][j], B[1][j], B[0][j]}
//
//   C SRAM:
//     C_addr = i * 4 + j
//     C_wdata = dot(A row i, B column j)
//
// Notes:
//   - A and B data are signed int8.
//   - Dot-product result uses signed 18-bit.
//   - SRAM control signals are assumed active-low:
//       *_cen = 0 : SRAM enabled
//       C_wen = 0 : write C SRAM
//   - A/B SRAM read latency is assumed to be 1 cycle.
// ============================================================

module sram_mul (
    input  wire clk,
    input  wire rst_n,

    input  wire start,
    output reg  done,

    // -----------------------------
    // A SRAM read port
    // -----------------------------
    output reg  [1:0]  A_addr,
    input  wire [31:0] A_rdata,

    // -----------------------------
    // B SRAM read port
    // -----------------------------
    output reg  [1:0]  B_addr,
    input  wire [31:0] B_rdata,

    // -----------------------------
    // C SRAM write port
    // -----------------------------
    output reg         C_cen,
    output reg         C_wen,
    output reg  [3:0]  C_addr,
    output reg  [17:0] C_wdata
);

// ========================================================
// FSM states
// ========================================================
localparam S_IDLE  = 3'd0;
localparam S_READ  = 3'd1;
localparam S_WAIT  = 3'd2;
localparam S_CALC  = 3'd3;
localparam S_WRITE = 3'd4;
localparam S_NEXT  = 3'd5;
localparam S_DONE  = 3'd6;

reg [2:0] state, next_state;

// Matrix indices
reg [1:0] row_idx;
reg [1:0] col_idx;

// Registered SRAM read data
reg [31:0] A_tile_reg;
reg [31:0] B_tile_reg;

// Dot-product result
wire signed [17:0] dot_result;

// ========================================================
// 4-element int8 dot product
// ========================================================
dot4_int8 u_dot4 (
    .a_vec(A_tile_reg),
    .b_vec(B_tile_reg),
    .result(dot_result)
);

// ========================================================
// FSM state register
// ========================================================
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_IDLE;
    end else begin
        state <= next_state;
    end
end

// ========================================================
// FSM next-state logic
// ========================================================
always @(*) begin
    next_state = state;

    case (state)
        S_IDLE: begin
            if (start) begin
                next_state = S_READ;
            end
        end

        S_READ: begin
            next_state = S_WAIT;
        end

        S_WAIT: begin
            next_state = S_CALC;
        end

        S_CALC: begin
            next_state = S_WRITE;
        end

        S_WRITE: begin
            next_state = S_NEXT;
        end

        S_NEXT: begin
            if ((row_idx == 2'd3) && (col_idx == 2'd3)) begin
                next_state = S_DONE;
            end else begin
                next_state = S_READ;
            end
        end

        S_DONE: begin
            next_state = S_IDLE;
        end

        default: begin
            next_state = S_IDLE;
        end
    endcase
end

// ========================================================
// Datapath and SRAM control
// ========================================================
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        row_idx    <= 2'd0;
        col_idx    <= 2'd0;

        A_tile_reg <= 32'd0;
        B_tile_reg <= 32'd0;

        A_addr     <= 2'd0;
        B_addr     <= 2'd0;
        C_addr     <= 4'd0;

        C_cen      <= 1'b1;
        C_wen      <= 1'b1;
        C_wdata    <= 18'd0;

        done       <= 1'b0;
    end
    else begin
        // Default inactive values
        C_cen <= 1'b1;
        C_wen <= 1'b1;
        done  <= 1'b0;

        case (state)
            S_IDLE: begin
                if (start) begin
                    row_idx <= 2'd0;
                    col_idx <= 2'd0;
                end
            end

            S_READ: begin
                // Issue read addresses.
                A_addr <= row_idx;
                B_addr <= col_idx;
            end

            S_WAIT: begin
                // Wait for SRAM read data to be available in the next cycle.
            end

            S_CALC: begin
                // Capture SRAM outputs.
                A_tile_reg <= A_rdata;
                B_tile_reg <= B_rdata;
            end

            S_WRITE: begin
                // Write C[row_idx][col_idx].
                C_cen   <= 1'b0;
                C_wen   <= 1'b0;
                C_addr  <= {row_idx, col_idx};  // row_idx * 4 + col_idx
                C_wdata <= dot_result;
            end

            S_NEXT: begin
                if (col_idx == 2'd3) begin
                    col_idx <= 2'd0;
                    row_idx <= row_idx + 2'd1;
                end
                else begin
                    col_idx <= col_idx + 2'd1;
                end
            end

            S_DONE: begin
                done <= 1'b1;
            end

            default: begin
                row_idx <= 2'd0;
                col_idx <= 2'd0;
            end
        endcase
    end
end

endmodule


// ============================================================
// 4-way signed int8 dot product
// ------------------------------------------------------------
// Input packing:
//   a_vec = {a3, a2, a1, a0}
//   b_vec = {b3, b2, b1, b0}
//
// Output:
//   result = a0*b0 + a1*b1 + a2*b2 + a3*b3
// ============================================================
module dot4_int8 (
    input  wire [31:0] a_vec,
    input  wire [31:0] b_vec,
    output wire signed [17:0] result
);

wire signed [17:0] p0;
wire signed [17:0] p1;
wire signed [17:0] p2;
wire signed [17:0] p3;

assign p0 = $signed(a_vec[7:0])   * $signed(b_vec[7:0]);
assign p1 = $signed(a_vec[15:8])  * $signed(b_vec[15:8]);
assign p2 = $signed(a_vec[23:16]) * $signed(b_vec[23:16]);
assign p3 = $signed(a_vec[31:24]) * $signed(b_vec[31:24]);

assign result = p0 + p1 + p2 + p3;

endmodule