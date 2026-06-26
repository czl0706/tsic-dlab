`timescale 1ns/1ps
module tb_swap_gate;
    reg [1:0] a, b;
    wire [1:0] lo, hi;
    wire swap;
    integer errors, log_fd, result_fd, pattern;

    swap_gate dut (.a(a), .b(b), .lo(lo), .hi(hi), .swap(swap));

    task check;
        input [1:0] va;
        input [1:0] vb;
        input [1:0] exp_lo;
        input [1:0] exp_hi;
        input       exp_swap;
        begin
            pattern = pattern + 1;
            a = va;
            b = vb;
            #1;
            if (lo !== exp_lo || hi !== exp_hi || swap !== exp_swap) begin
                if (errors == 0) $display("[ERROR] pattern %0d: a=%0d b=%0d expected lo=%0d hi=%0d swap=%b got lo=%0d hi=%0d swap=%b", pattern, va, vb, exp_lo, exp_hi, exp_swap, lo, hi, swap);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d: a=%0d b=%0d expected lo=%0d hi=%0d swap=%b got lo=%0d hi=%0d swap=%b", pattern, va, vb, exp_lo, exp_hi, exp_swap, lo, hi, swap);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd = $fopen("sim/log.txt", "w");
        result_fd = $fopen("sim/result.txt", "w");
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_swap_gate);
        $display("##SEC_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1-4] checks no-swap cases");
        $fdisplay(log_fd,"[CASE 1-4] checks no-swap cases");
        $display("[CASE 5-8] checks swap cases");
        $fdisplay(log_fd,"[CASE 5-8] checks swap cases");
        $display("[CASE 9-12] checks equal-value cases");
        $fdisplay(log_fd,"[CASE 9-12] checks equal-value cases");
        // GOLDEN_CASE_SUMMARY_END

        errors = 0;
        pattern = 0;
        check(2'd0, 2'd1, 2'd0, 2'd1, 1'b0);
        check(2'd1, 2'd2, 2'd1, 2'd2, 1'b0);
        check(2'd2, 2'd3, 2'd2, 2'd3, 1'b0);
        check(2'd0, 2'd3, 2'd0, 2'd3, 1'b0);
        check(2'd1, 2'd0, 2'd0, 2'd1, 1'b1);
        check(2'd2, 2'd1, 2'd1, 2'd2, 1'b1);
        check(2'd3, 2'd2, 2'd2, 2'd3, 1'b1);
        check(2'd3, 2'd0, 2'd0, 2'd3, 1'b1);
        check(2'd0, 2'd0, 2'd0, 2'd0, 1'b0);
        check(2'd1, 2'd1, 2'd1, 2'd1, 1'b0);
        check(2'd2, 2'd2, 2'd2, 2'd2, 1'b0);
        check(2'd3, 2'd3, 2'd3, 2'd3, 1'b0);

        if (errors == 0) begin
            $display("[PASS] swap_gate");
            $fdisplay(log_fd, "[PASS] swap_gate");
            $fdisplay(result_fd, "pass");
        end else begin
            $display("[FAIL] swap_gate, errors = %0d", errors);
            $fdisplay(log_fd, "[FAIL] swap_gate, errors = %0d", errors);
            $fdisplay(result_fd, "fail");
        end
        $display("##END_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd);
        $finish;
    end
endmodule