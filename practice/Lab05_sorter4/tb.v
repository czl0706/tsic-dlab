`timescale 1ns/1ps
module tb_sorter4;
    reg [7:0] v0, v1, v2, v3;
    wire [7:0] o0, o1, o2, o3;
    integer errors, log_fd, result_fd, pattern;

    sorter4 dut (.v0(v0), .v1(v1), .v2(v2), .v3(v3), .o0(o0), .o1(o1), .o2(o2), .o3(o3));

    task check;
        input [7:0] a, b, c, d;
        input [7:0] e0, e1, e2, e3;
        begin
            v0 = a; v1 = b; v2 = c; v3 = d;
            pattern = pattern + 1;
            #1;
            if (o0 !== e0 || o1 !== e1 || o2 !== e2 || o3 !== e3) begin
                if (errors == 0) $display("[ERROR] pattern %0d: in={%0d,%0d,%0d,%0d} expected={%0d,%0d,%0d,%0d} got={%0d,%0d,%0d,%0d}", pattern, a,b,c,d,e0,e1,e2,e3,o0,o1,o2,o3);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d: in={%0d,%0d,%0d,%0d} expected={%0d,%0d,%0d,%0d} got={%0d,%0d,%0d,%0d}", pattern, a,b,c,d,e0,e1,e2,e3,o0,o1,o2,o3);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd = $fopen("sim/log.txt", "w");
        result_fd = $fopen("sim/result.txt", "w");
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_sorter4);
        $display("##SEC_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1] checks unsorted input");
        $fdisplay(log_fd,"[CASE 1] checks unsorted input");
        $display("[CASE 2] checks duplicate values");
        $fdisplay(log_fd,"[CASE 2] checks duplicate values");
        $display("[CASE 3] checks range extremes");
        $fdisplay(log_fd,"[CASE 3] checks range extremes");
        $display("[CASE 4] checks descending input");
        $fdisplay(log_fd,"[CASE 4] checks descending input");
        // GOLDEN_CASE_SUMMARY_END


        errors = 0; pattern = 0;
        check(8'd4, 8'd1, 8'd9, 8'd2, 8'd1, 8'd2, 8'd4, 8'd9);
        check(8'd7, 8'd7, 8'd0, 8'd3, 8'd0, 8'd3, 8'd7, 8'd7);
        check(8'd255, 8'd1, 8'd128, 8'd0, 8'd0, 8'd1, 8'd128, 8'd255);
        check(8'd5, 8'd4, 8'd3, 8'd2, 8'd2, 8'd3, 8'd4, 8'd5);
        if (errors == 0) begin
            $display("[PASS] sorter4");
            $fdisplay(log_fd, "[PASS] sorter4");
            $fdisplay(result_fd, "pass");
        end else begin
            $display("[FAIL] sorter4, errors = %0d", errors);
            $fdisplay(log_fd, "[FAIL] sorter4, errors = %0d", errors);
            $fdisplay(result_fd, "fail");
        end
        $display("##END_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd);
        $finish;
    end
endmodule
