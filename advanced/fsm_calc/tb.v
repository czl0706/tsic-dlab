`timescale 1ns/1ps
module tb_fsm_calc;
    reg clk, rst_n, btn_valid;
    reg [3:0] btn;
    wire [15:0] out;
    integer errors, log_fd, result_fd, pattern;
    reg [3:0] last_key;

    localparam BTN_ADD = 4'd11;
    localparam BTN_SUB = 4'd12;
    localparam BTN_MUL = 4'd13;
    localparam BTN_EQ  = 4'd14;
    localparam BTN_AC  = 4'd15;

    fsm_calc dut (.clk(clk), .rst_n(rst_n), .btn_valid(btn_valid), .btn(btn), .out(out));
    initial begin clk = 0; forever #5 clk = ~clk; end

    task press;
        input [3:0] key;
        begin
            pattern = pattern + 1;
            last_key = key;
            @(negedge clk); btn = key; btn_valid = 1'b1;
            @(posedge clk);
            @(negedge clk); btn_valid = 1'b0; btn = 4'd0;
            #1;
        end
    endtask

    task check_out;
        input [15:0] expected;
        begin
            #1;
            if (out !== expected) begin
                if (errors == 0) $display("[ERROR] pattern %0d after key=%0d: expected out=%0d got=%0d", pattern, last_key, expected, out);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d after key=%0d: expected out=%0d got=%0d", pattern, last_key, expected, out);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd = $fopen("sim/log.txt", "w");
        result_fd = $fopen("sim/result.txt", "w");
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_fsm_calc);
        $display("##SEC_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1-15] checks add, subtract, multiply flows");
        $fdisplay(log_fd,"[CASE 1-15] checks add, subtract, multiply flows");
        $display("[CASE 16-26] checks result, operator-change, repeated-equals flows");
        $fdisplay(log_fd,"[CASE 16-26] checks result, operator-change, repeated-equals flows");
        $display("[CASE 27-33] checks chained operation flow");
        $fdisplay(log_fd,"[CASE 27-33] checks chained operation flow");
        // GOLDEN_CASE_SUMMARY_END


        errors = 0; pattern = 0; last_key = 0; rst_n = 0; btn_valid = 0; btn = 0;
        repeat (2) @(posedge clk); @(negedge clk); rst_n = 1; #1;

        press(4'd1); check_out(16'd1);
        press(4'd2); check_out(16'd12);
        press(BTN_ADD); check_out(16'd12);
        press(4'd3); check_out(16'd3);
        press(BTN_EQ); check_out(16'd15);

        press(BTN_AC); check_out(16'd0);
        press(4'd8); check_out(16'd8);
        press(BTN_SUB); check_out(16'd8);
        press(4'd5); check_out(16'd5);
        press(BTN_EQ); check_out(16'd3);

        press(BTN_AC); check_out(16'd0);
        press(4'd6); check_out(16'd6);
        press(BTN_MUL); check_out(16'd6);
        press(4'd7); check_out(16'd7);
        press(BTN_EQ); check_out(16'd42);

        press(4'd9); check_out(16'd9);
        press(BTN_EQ); check_out(16'd9);

        press(BTN_AC); check_out(16'd0);
        press(4'd9); check_out(16'd9);
        press(BTN_ADD); check_out(16'd9);
        press(BTN_SUB); check_out(16'd9);
        press(BTN_EQ); check_out(16'd9);
        press(BTN_MUL); check_out(16'd9);
        press(4'd2); check_out(16'd2);
        press(BTN_EQ); check_out(16'd18);
        press(BTN_EQ); check_out(16'd18);

        press(BTN_AC); check_out(16'd0);
        press(4'd2); check_out(16'd2);
        press(BTN_ADD); check_out(16'd2);
        press(4'd3); check_out(16'd3);
        press(BTN_MUL); check_out(16'd5);
        press(4'd4); check_out(16'd4);
        press(BTN_EQ); check_out(16'd20);

        if (errors == 0) begin
            $display("[PASS] fsm_calc");
            $fdisplay(log_fd, "[PASS] fsm_calc");
            $fdisplay(result_fd, "pass");
        end else begin
            $display("[FAIL] fsm_calc, errors = %0d", errors);
            $fdisplay(log_fd, "[FAIL] fsm_calc, errors = %0d", errors);
            $fdisplay(result_fd, "fail");
        end
        $display("##END_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd);
        $finish;
    end
endmodule
