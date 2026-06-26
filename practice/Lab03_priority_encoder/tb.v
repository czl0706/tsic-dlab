`timescale 1ns/1ps
module tb_priority_encoder;
    reg [7:0] in;
    wire [2:0] out;
    integer errors, log_fd, result_fd, pattern;

    priority_encoder dut (.in(in), .out(out));

    task check;
        input [7:0] value;
        input [2:0] expected;
        begin
            in = value;
            pattern = pattern + 1;
            #1;
            if (out !== expected) begin
                if (errors == 0) $display("[ERROR] pattern %0d: in=%b expected out=%0d got=%0d", pattern, value, expected, out);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d: in=%b expected out=%0d got=%0d", pattern, value, expected, out);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd = $fopen("sim/log.txt", "w");
        result_fd = $fopen("sim/result.txt", "w");
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_priority_encoder);
        $display("##SEC_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1] checks zero input");
        $fdisplay(log_fd,"[CASE 1] checks zero input");
        $display("[CASE 2-9] checks priority branches and multi-bit inputs");
        $fdisplay(log_fd,"[CASE 2-9] checks priority branches and multi-bit inputs");
        // GOLDEN_CASE_SUMMARY_END


        errors = 0; pattern = 0;

        check(8'b0000_0000, 3'd0);
        check(8'b0000_0001, 3'd0);
        check(8'b0000_0010, 3'd1);
        check(8'b0000_0101, 3'd2);
        check(8'b0000_1000, 3'd3);
        check(8'b0001_0010, 3'd4);
        check(8'b0010_0010, 3'd5);
        check(8'b1010_0000, 3'd7);
        check(8'b0100_1111, 3'd6);

        if (errors == 0) begin
            $display("[PASS] priority_encoder");
            $fdisplay(log_fd, "[PASS] priority_encoder");
            $fdisplay(result_fd, "pass");
        end else begin
            $display("[FAIL] priority_encoder, errors = %0d", errors);
            $fdisplay(log_fd, "[FAIL] priority_encoder, errors = %0d", errors);
            $fdisplay(result_fd, "fail");
        end
        $display("##END_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd);
        $finish;
    end
endmodule
