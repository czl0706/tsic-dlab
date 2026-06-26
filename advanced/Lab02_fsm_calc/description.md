# Lab: FSM Calculator

## 1. Objective

In this lab, you will design a simple calculator using a finite state machine, or FSM.

The calculator supports:

- Decimal digit input: `0` to `9`
- Addition: `+`
- Subtraction: `-`
- Multiplication: `*`
- Equal: `=`
- All clear: `AC`

The calculator should update its output whenever a valid button is pressed.

This lab focuses on:

- FSM design
- Register-based datapath design
- Decimal number input accumulation
- Operator handling
- Simple sequential arithmetic control

---

## 2. Top Module

Please complete the following Verilog module:

```verilog
module FSM_CALC (
    input  wire        clk,
    input  wire        rst_n,

    input  wire        in_valid,
    input  wire [3:0]  in_data,

    output reg signed [31:0] out_data
);
```

### Signal Description

| Signal | Direction | Width | Description |
|---|---:|---:|---|
| `clk` | input | 1 | Clock signal |
| `rst_n` | input | 1 | Asynchronous active-low reset |
| `in_valid` | input | 1 | High for one cycle when a button is pressed |
| `in_data` | input | 4 | Encoded button input |
| `out_data` | output | 32 | Current calculator display value |

---

## 3. Button Encoding

| `in_data` | Button |
|---:|---|
| `4'd0` ~ `4'd9` | Digit `0` ~ `9` |
| `4'd10` | Reserved |
| `4'd11` | `+` |
| `4'd12` | `-` |
| `4'd13` | `*` |
| `4'd14` | `=` |
| `4'd15` | `AC` |

Each button input is valid for exactly one clock cycle when `in_valid = 1`.

---

## 4. Calculator Behavior

### 4.1 Digit Input

When a digit is pressed, the calculator updates the current number register.

For example, if the user presses:

```text
1 2 3
```

The display should update as:

```text
1
12
123
```

The hardware behavior should be equivalent to:

```verilog
curr_num = curr_num * 10 + digit;
```

---

### 4.2 Operator Input: `+`, `-`, `*`

When an operator is pressed, the calculator should update the output immediately.

If there is no pending operator, the current number becomes the accumulated value.

Example:

```text
Input: 12 +
Display: 12
```

If there is already a pending operator, the calculator should first evaluate the previous operation, then store the new operator.

Example:

```text
Input: 12 + 3 *
```

When `*` is pressed, the calculator first evaluates:

```text
12 + 3 = 15
```

Then it stores `*` as the next pending operator.

The display becomes:

```text
15
```

---

### 4.3 Equal Input: `=`

When `=` is pressed, the calculator evaluates the pending operation and displays the result.

Example:

```text
Input: 12 + 3 =
Output: 15
```

After pressing `=`, the calculator enters the result state.

If the next input is a digit, the previous result is cleared and a new number begins.

Example:

```text
Input: 12 + 3 = 4
Display sequence: 1, 12, 12, 3, 15, 4
```

The display should be `4`, not `154`.

If the next input is an operator, the previous result is used as the left-hand operand of the next operation.

Example:

```text
Input: 12 + 3 = * 4 =
Result: 60
```

This is interpreted as:

```text
15 * 4 = 60
```

---

### 4.4 AC Input

When `AC` is pressed, all internal registers are cleared.

The display becomes:

```text
0
```

---

## 5. Operation Order

This calculator does not support operator precedence.

All operations are evaluated strictly from left to right.

Example:

```text
Input: 12 + 3 * 4 =
```

The result should be:

```text
(12 + 3) * 4 = 60
```

not:

```text
12 + (3 * 4) = 24
```

---

## 6. Suggested FSM States

You may use the following four states:

```verilog
localparam S_IDLE     = 2'd0;
localparam S_INPUT    = 2'd1;
localparam S_WAIT_NUM = 2'd2;
localparam S_RESULT   = 2'd3;
```

| State | Description |
|---|---|
| `S_IDLE` | Reset state or after `AC` |
| `S_INPUT` | Currently entering a number |
| `S_WAIT_NUM` | An operator has been pressed; waiting for the next number |
| `S_RESULT` | `=` has been pressed; result is displayed |

---

## 7. Suggested Internal Registers

```verilog
reg signed [31:0] curr_num;
reg signed [31:0] acc;
reg [1:0]         op;
reg               has_op;
```

### Register Meaning

| Register | Description |
|---|---|
| `curr_num` | Current number being entered |
| `acc` | Accumulated left-hand operand or intermediate result |
| `op` | Pending operator |
| `has_op` | Indicates whether there is a pending operator |

---

## 8. Example Test Sequences

### Example 1

```text
Input:
1 2 + 3 =
```

Display sequence:

```text
1
12
12
3
15
```

Final result:

```text
15
```

---

### Example 2

```text
Input:
8 * 7 =
```

Display sequence:

```text
8
8
7
56
```

Final result:

```text
56
```

---

### Example 3

```text
Input:
9 - 1 5 =
```

Display sequence:

```text
9
9
1
15
-6
```

Final result:

```text
-6
```

---

### Example 4: Left-to-right evaluation

```text
Input:
1 2 + 3 * 4 =
```

Display sequence:

```text
1
12
12
3
15
4
60
```

Final result:

```text
60
```

---

### Example 5: AC

```text
Input:
9 9 AC 1 + 2 =
```

Display sequence:

```text
9
99
0
1
1
2
3
```

Final result:

```text
3
```

---

### Example 6: New input after result

```text
Input:
1 2 + 3 = 4 5
```

Display sequence:

```text
1
12
12
3
15
4
45
```

Final displayed value:

```text
45
```

---

### Example 7: Continue calculation after result

```text
Input:
1 2 + 3 = * 4 =
```

Display sequence:

```text
1
12
12
3
15
15
4
60
```

Final result:

```text
60
```

---

## 9. Design Constraints

1. Use positive-edge triggered registers.
2. Reset is asynchronous and active-low.
3. Do not infer latches.
4. Do not use division `/` or modulo `%`.
5. Do not use operator precedence.
6. Overflow does not need to be handled.
7. `out_data` should always represent the current calculator display value.
8. Reserved input `4'd10` can be ignored.
