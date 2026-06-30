`timescale 1ns/1ps
module tb_mux_comparator;
    reg [7:0] a, b;
    reg sel;
    wire [7:0] mux_out, abs_diff;
    integer errors, log_fd, result_fd, pattern;

    mux_comparator dut (.a(a), .b(b), .sel(sel), .mux_out(mux_out), .abs_diff(abs_diff));

    task check;
        input [7:0] va;
        input [7:0] vb;
        input vsel;
        input [7:0] exp_mux;
        input [7:0] exp_abs_diff;
        begin
            a = va; b = vb; sel = vsel;
            pattern = pattern + 1;
            #1;
            if (mux_out !== exp_mux || abs_diff !== exp_abs_diff) begin
                if (errors == 0) $display("[ERROR] pattern %0d: a=%0d b=%0d sel=%b expected mux=%0d abs_diff=%0d got mux=%0d abs_diff=%0d", pattern, a, b, sel, exp_mux, exp_abs_diff, mux_out, abs_diff);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d: a=%0d b=%0d sel=%b expected mux=%0d abs_diff=%0d got mux=%0d abs_diff=%0d", pattern, a, b, sel, exp_mux, exp_abs_diff, mux_out, abs_diff);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd = $fopen("sim/log.txt", "w");
        result_fd = $fopen("sim/result.txt", "w");
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_mux_comparator);
        $display("##SEC_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1-2] checks mux select both directions");
        $fdisplay(log_fd,"[CASE 1-2] checks mux select both directions");
        $display("[CASE 3-5] checks absolute difference cases");
        $fdisplay(log_fd,"[CASE 3-5] checks absolute difference cases");
        // GOLDEN_CASE_SUMMARY_END


        errors = 0; pattern = 0;
        check(8'd3,   8'd9,   1'b0, 8'd3,   8'd6);
        check(8'd3,   8'd9,   1'b1, 8'd9,   8'd6);
        check(8'd12,  8'd4,   1'b0, 8'd12,  8'd8);
        check(8'd7,   8'd7,   1'b1, 8'd7,   8'd0);
        check(8'd250, 8'd100, 1'b0, 8'd250, 8'd150);
        if (errors == 0) begin
            $display("[PASS] mux_comparator");
            $fdisplay(log_fd, "[PASS] mux_comparator");
            $fdisplay(result_fd, "pass");
        end else begin
            $display("[FAIL] mux_comparator, errors = %0d", errors);
            $fdisplay(log_fd, "[FAIL] mux_comparator, errors = %0d", errors);
            $fdisplay(result_fd, "fail");
        end
        $display("##END_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd);
        $finish;
    end
endmodule
