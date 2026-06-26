`timescale 1ns/1ps
module tb_logic_mask;
    reg [7:0] a, b;
    wire [7:0] inv_a, and_ab, or_ab, xor_ab, nand_ab;
    wire has_one, all_one, odd_parity;
    wire [7:0] keep_low, keep_high;
    integer errors, log_fd, result_fd, pattern;

    logic_mask dut (
        .a(a), .b(b),
        .inv_a(inv_a), .and_ab(and_ab), .or_ab(or_ab), .xor_ab(xor_ab), .nand_ab(nand_ab),
        .has_one(has_one), .all_one(all_one), .odd_parity(odd_parity),
        .keep_low(keep_low), .keep_high(keep_high)
    );

    task check;
        input [7:0] va;
        input [7:0] vb;
        begin
            pattern = pattern + 1;
            a = va;
            b = vb;
            #1;
            if (inv_a !== ~va ||
                and_ab !== (va & vb) ||
                or_ab !== (va | vb) ||
                xor_ab !== (va ^ vb) ||
                nand_ab !== ~(va & vb) ||
                has_one !== (|va) ||
                all_one !== (&va) ||
                odd_parity !== (^va) ||
                keep_low !== (va & 8'h0f) ||
                keep_high !== (va & 8'hf0)) begin
                if (errors == 0) $display("[ERROR] pattern %0d: a=%b b=%b", pattern, va, vb);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d: a=%b b=%b", pattern, va, vb);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd = $fopen("sim/log.txt", "w");
        result_fd = $fopen("sim/result.txt", "w");
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_logic_mask);
        $display("##SEC_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1-5] checks bitwise logic, reductions, and masks");
        $fdisplay(log_fd, "[CASE 1-5] checks bitwise logic, reductions, and masks");
        // GOLDEN_CASE_SUMMARY_END

        errors = 0;
        pattern = 0;
        check(8'b0000_0000, 8'b1111_1111);
        check(8'b1111_1111, 8'b0000_0000);
        check(8'b1010_1010, 8'b1100_0011);
        check(8'b0000_1111, 8'b0011_1100);
        check(8'b1000_0000, 8'b0111_1111);

        if (errors == 0) begin $display("[PASS] logic_mask"); $fdisplay(log_fd, "[PASS] logic_mask"); $fdisplay(result_fd, "pass"); end
        else begin $display("[FAIL] logic_mask, errors = %0d", errors); $fdisplay(log_fd, "[FAIL] logic_mask, errors = %0d", errors); $fdisplay(result_fd, "fail"); end
        $display("##END_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
