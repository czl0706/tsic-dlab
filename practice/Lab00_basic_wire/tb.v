`timescale 1ns/1ps
module tb_basic_wire;
    reg [7:0] in;
    wire [7:0] pass;
    wire [3:0] lo_nibble;
    wire [3:0] hi_nibble;
    wire [15:0] sign_ext;
    wire [7:0] swap_nibble;
    integer errors, log_fd, result_fd, pattern;

    basic_wire dut (
        .in(in),
        .pass(pass),
        .lo_nibble(lo_nibble),
        .hi_nibble(hi_nibble),
        .sign_ext(sign_ext),
        .swap_nibble(swap_nibble)
    );

    task check;
        input [7:0] value;
        begin
            pattern = pattern + 1;
            in = value;
            #1;
            if (pass !== value ||
                lo_nibble !== value[3:0] ||
                hi_nibble !== value[7:4] ||
                sign_ext !== {{8{value[7]}}, value} ||
                swap_nibble !== {value[3:0], value[7:4]}) begin
                if (errors == 0) $display("[ERROR] pattern %0d: in=%h got pass=%h lo=%h hi=%h sign_ext=%h swap=%h", pattern, value, pass, lo_nibble, hi_nibble, sign_ext, swap_nibble);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d: in=%h got pass=%h lo=%h hi=%h sign_ext=%h swap=%h", pattern, value, pass, lo_nibble, hi_nibble, sign_ext, swap_nibble);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd = $fopen("sim/log.txt", "w");
        result_fd = $fopen("sim/result.txt", "w");
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_basic_wire);
        $display("##SEC_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1-5] checks pass-through, nibbles, sign extension, and nibble swap");
        $fdisplay(log_fd, "[CASE 1-5] checks pass-through, nibbles, sign extension, and nibble swap");
        // GOLDEN_CASE_SUMMARY_END

        errors = 0;
        pattern = 0;
        check(8'h00);
        check(8'h3c);
        check(8'h80);
        check(8'hff);
        check(8'ha5);

        if (errors == 0) begin $display("[PASS] basic_wire"); $fdisplay(log_fd, "[PASS] basic_wire"); $fdisplay(result_fd, "pass"); end
        else begin $display("[FAIL] basic_wire, errors = %0d", errors); $fdisplay(log_fd, "[FAIL] basic_wire, errors = %0d", errors); $fdisplay(result_fd, "fail"); end
        $display("##END_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
