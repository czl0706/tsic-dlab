`timescale 1ns/1ps
module tb_gcd;
    reg clk, rst_n, in_valid;
    reg [7:0] a, b;
    wire out_valid;
    wire [7:0] result;
    integer errors, log_fd, result_fd, pattern;

    gcd dut (.clk(clk), .rst_n(rst_n), .in_valid(in_valid), .a(a), .b(b), .out_valid(out_valid), .result(result));
    initial begin clk = 0; forever #5 clk = ~clk; end

    task run_case;
        input [7:0] va, vb, expected;
        integer timeout;
        begin
            pattern = pattern + 1;
            @(negedge clk); a = va; b = vb; in_valid = 1'b1;
            @(posedge clk);
            @(negedge clk); in_valid = 1'b0; a = 8'd0; b = 8'd0;
            timeout = 0;
            while (!out_valid && timeout < 100) begin
                @(posedge clk); #1; timeout = timeout + 1;
            end
            if (!out_valid || result !== expected) begin
                if (errors == 0) $display("[ERROR] pattern %0d: gcd(%0d,%0d) expected=%0d got=%0d out_valid=%b timeout=%0d", pattern, va, vb, expected, result, out_valid, timeout);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d: gcd(%0d,%0d) expected=%0d got=%0d out_valid=%b timeout=%0d", pattern, va, vb, expected, result, out_valid, timeout);
                errors = errors + 1;
            end
            @(posedge clk); #1;
        end
    endtask

    initial begin
        log_fd = $fopen("sim/log.txt", "w");
        result_fd = $fopen("sim/result.txt", "w");
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_gcd);
        $display("##SEC_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1-3] checks general GCD inputs");
        $fdisplay(log_fd,"[CASE 1-3] checks general GCD inputs");
        $display("[CASE 4-5] checks zero-input corner cases");
        $fdisplay(log_fd,"[CASE 4-5] checks zero-input corner cases");
        // GOLDEN_CASE_SUMMARY_END


        errors = 0; pattern = 0; rst_n = 0; in_valid = 0; a = 0; b = 0;
        repeat (2) @(posedge clk); @(negedge clk); rst_n = 1;
        run_case(8'd48, 8'd18, 8'd6);
        run_case(8'd27, 8'd15, 8'd3);
        run_case(8'd49, 8'd14, 8'd7);
        run_case(8'd0,  8'd9,  8'd9);
        run_case(8'd12, 8'd0,  8'd12);
        if (errors == 0) begin
            $display("[PASS] gcd");
            $fdisplay(log_fd, "[PASS] gcd");
            $fdisplay(result_fd, "pass");
        end else begin
            $display("[FAIL] gcd, errors = %0d", errors);
            $fdisplay(log_fd, "[FAIL] gcd, errors = %0d", errors);
            $fdisplay(result_fd, "fail");
        end
        $display("##END_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd);
        $finish;
    end
endmodule
