# Lab: SRAM Matrix Multiplication Accelerator

## 1. Objective

In this lab, you will design a simple SRAM-based matrix multiplication accelerator.

The accelerator computes:

```text
C = A * B
```

where:

```text
A: 4 x 4 signed int8 matrix
B: 4 x 4 signed int8 matrix
C: 4 x 4 signed result matrix
```

The design uses three independent SRAMs:

```text
A SRAM: stores matrix A
B SRAM: stores matrix B
C SRAM: stores matrix C
```

This lab focuses on:

- SRAM address generation
- Packed data unpacking
- Signed 8-bit multiplication
- 4-element dot product
- FSM control
- SRAM write-back

---

## 2. Top Module

Please complete the following Verilog module:

```verilog
module SRAM_MUL (
    input  wire clk,
    input  wire rst_n,

    input  wire start,
    output reg  done,

    output reg         A_cen,
    output reg  [1:0]  A_addr,
    input  wire [31:0] A_rdata,

    output reg         B_cen,
    output reg  [1:0]  B_addr,
    input  wire [31:0] B_rdata,

    output reg         C_cen,
    output reg         C_wen,
    output reg  [3:0]  C_addr,
    output reg  [17:0] C_wdata
);
```

---

## 3. SRAM Interface Assumption

The SRAM control signals are active-low.

| Signal | Meaning |
|---|---|
| `A_cen = 0` | Enable A SRAM read |
| `B_cen = 0` | Enable B SRAM read |
| `C_cen = 0` | Enable C SRAM |
| `C_wen = 0` | Write C SRAM |
| `C_wen = 1` | Read or idle C SRAM |

A and B SRAMs are read-only in this lab.

C SRAM is write-only in this lab.

A and B SRAM read latency is assumed to be one cycle.

---

## 4. Data Format

Each SRAM address returns one 32-bit word.

The 32-bit word contains four signed 8-bit values.

```text
32 bits = 4 x signed int8
```

The packing format is:

```verilog
{data3, data2, data1, data0}
```

For example:

```verilog
A_rdata = {a3, a2, a1, a0};
B_rdata = {b3, b2, b1, b0};
```

The dot product is:

```text
result = a0*b0 + a1*b1 + a2*b2 + a3*b3
```

---

## 5. Matrix Layout

### A SRAM Layout

A SRAM stores one row of matrix A per address.

```text
A_addr = 0 -> {A[0][3], A[0][2], A[0][1], A[0][0]}
A_addr = 1 -> {A[1][3], A[1][2], A[1][1], A[1][0]}
A_addr = 2 -> {A[2][3], A[2][2], A[2][1], A[2][0]}
A_addr = 3 -> {A[3][3], A[3][2], A[3][1], A[3][0]}
```

### B SRAM Layout

B SRAM stores one column of matrix B per address.

```text
B_addr = 0 -> {B[3][0], B[2][0], B[1][0], B[0][0]}
B_addr = 1 -> {B[3][1], B[2][1], B[1][1], B[0][1]}
B_addr = 2 -> {B[3][2], B[2][2], B[1][2], B[0][2]}
B_addr = 3 -> {B[3][3], B[2][3], B[1][3], B[0][3]}
```

This layout allows one element of C to be computed using one read from A SRAM and one read from B SRAM.

---

## 6. Computation

For each output element:

```text
C[i][j] = A[i][0] * B[0][j]
        + A[i][1] * B[1][j]
        + A[i][2] * B[2][j]
        + A[i][3] * B[3][j]
```

The accelerator should compute all 16 elements of C:

```text
for i = 0 to 3:
    for j = 0 to 3:
        C[i][j] = dot(A row i, B column j)
```

The C SRAM address is:

```text
C_addr = i * 4 + j
```

Since `i` and `j` are both 2-bit values, this can be implemented as:

```verilog
C_addr = {i, j};
```

---

## 7. Output Width

A and B elements are signed 8-bit values.

Each multiplication produces a signed 16-bit result.

The sum of four signed 16-bit products should be stored in signed 18-bit format.

Therefore:

```verilog
output reg [17:0] C_wdata
```

represents a signed 18-bit value.

---

## 8. Suggested FSM

You may use the following FSM states:

```verilog
localparam S_IDLE  = 3'd0;
localparam S_READ  = 3'd1;
localparam S_WAIT  = 3'd2;
localparam S_CALC  = 3'd3;
localparam S_WRITE = 3'd4;
localparam S_NEXT  = 3'd5;
localparam S_DONE  = 3'd6;
```

| State | Description |
|---|---|
| `S_IDLE` | Wait for `start` |
| `S_READ` | Issue A and B SRAM read addresses |
| `S_WAIT` | Wait for one-cycle SRAM read latency |
| `S_CALC` | Capture A/B SRAM data and compute dot product |
| `S_WRITE` | Write result to C SRAM |
| `S_NEXT` | Update row/column indices |
| `S_DONE` | Raise `done` for one cycle |

---

## 9. Example

Assume:

```text
A =
[ 1  2  3  4
  5  6  7  8
  1  1  1  1
  2  0 -1  3 ]

B =
[ 1  0  2  1
  0  1  2  2
  1  0  1  3
  2  1  0  4 ]
```

Then:

```text
C[0][0] = 1*1 + 2*0 + 3*1 + 4*2 = 12
C[0][1] = 1*0 + 2*1 + 3*0 + 4*1 = 6
C[0][2] = 1*2 + 2*2 + 3*1 + 4*0 = 9
C[0][3] = 1*1 + 2*2 + 3*3 + 4*4 = 30
```

The accelerator should repeat this for all 16 output elements.

---

## 10. Design Constraints

1. Use positive-edge triggered registers.
2. Reset is asynchronous and active-low.
3. Do not infer latches.
4. A/B SRAM read latency is one cycle.
5. `done` should be high for one cycle after all 16 C elements are written.
6. `C_wen` should be low only when writing valid C data.
7. `C_cen` should be low only when accessing C SRAM.
8. No overflow handling is required.
9. Do not use division `/` or modulo `%`.
