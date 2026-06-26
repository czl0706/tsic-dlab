`timescale 1ns/1ps
module tb_mux_comparator;
    reg [7:0] a, b;
    reg sel;
    wire [7:0] mux_out, larger, smaller;
    integer errors, log_fd, result_fd, pattern;

    mux_comparator dut (.a(a), .b(b), .sel(sel), .mux_out(mux_out), .larger(larger), .smaller(smaller));

    task check;
        input [7:0] va;
        input [7:0] vb;
        input vsel;
        input [7:0] exp_mux;
        input [7:0] exp_larger;
        input [7:0] exp_smaller;
        begin
            a = va; b = vb; sel = vsel;
            pattern = pattern + 1;
            #1;
            if (mux_out !== exp_mux || larger !== exp_larger || smaller !== exp_smaller) begin
                if (errors == 0) $display("[ERROR] pattern %0d: a=%0d b=%0d sel=%b expected mux=%0d larger=%0d smaller=%0d got mux=%0d larger=%0d smaller=%0d", pattern, a, b, sel, exp_mux, exp_larger, exp_smaller, mux_out, larger, smaller);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d: a=%0d b=%0d sel=%b expected mux=%0d larger=%0d smaller=%0d got mux=%0d larger=%0d smaller=%0d", pattern, a, b, sel, exp_mux, exp_larger, exp_smaller, mux_out, larger, smaller);
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
        $display("[CASE 3-4] checks comparator greater/equal cases");
        $fdisplay(log_fd,"[CASE 3-4] checks comparator greater/equal cases");
        // GOLDEN_CASE_SUMMARY_END


        errors = 0; pattern = 0;
        check(8'd3,  8'd9,  1'b0, 8'd3,  8'd9,  8'd3);
        check(8'd3,  8'd9,  1'b1, 8'd9,  8'd9,  8'd3);
        check(8'd12, 8'd4,  1'b0, 8'd12, 8'd12, 8'd4);
        check(8'd7,  8'd7,  1'b1, 8'd7,  8'd7,  8'd7);
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
