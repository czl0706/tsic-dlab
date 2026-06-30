`timescale 1ns/1ps
module tb_ex01_logic;
    reg a, b;
    reg [3:0] in_v1, in_v2, in_v3;
    wire not_a, o_and, o_or, o_xor, o_nand;
    wire [3:0] inv_v1, o_and_v, o_or_v, o_not_v3;
    wire       o_reduced_and, o_reduced_or;
    integer errors, log_fd, result_fd, pattern;

    Ex01_logic dut(
        .a(a), .b(b), .not_a(not_a), .o_and(o_and), .o_or(o_or), .o_xor(o_xor), .o_nand(o_nand),
        .in_v1(in_v1), .in_v2(in_v2), .inv_v1(inv_v1), .o_and_v(o_and_v), .o_or_v(o_or_v),
        .in_v3(in_v3), .o_not_v3(o_not_v3), .o_reduced_and(o_reduced_and), .o_reduced_or(o_reduced_or)
    );

    task check;
        input ia, ib;
        input [3:0] v1, v2, v3;
        begin
            pattern = pattern + 1;
            a=ia; b=ib; in_v1=v1; in_v2=v2; in_v3=v3; #1;
            if (not_a !== ~ia || o_and !== (ia & ib) || o_or !== (ia | ib) || o_xor !== (ia ^ ib) || o_nand !== ~(ia & ib) ||
                inv_v1 !== ~v1 || o_and_v !== (v1 & v2) || o_or_v !== (v1 | v2) || o_not_v3 !== ~v3 ||
                o_reduced_and !== {3'b000, &v3} || o_reduced_or !== {3'b000, |v3}) begin
                $display("[ERROR] pattern %0d: scalar a=%b b=%b vector v1=%b v2=%b v3=%b", pattern, ia, ib, v1, v2, v3);
                $fdisplay(log_fd,"[ERROR] pattern %0d: scalar a=%b b=%b vector v1=%b v2=%b v3=%b", pattern, ia, ib, v1, v2, v3);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_ex01_logic);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        errors=0; pattern=0;
        check(0,0,4'b0000,4'b1111,4'b0000);
        check(0,1,4'b1010,4'b1100,4'b1111);
        check(1,0,4'b0101,4'b0011,4'b1000);
        check(1,1,4'b1111,4'b0000,4'b0110);
        if(errors==0) begin $display("[PASS] Ex01_logic"); $fdisplay(log_fd,"[PASS] Ex01_logic"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] Ex01_logic, errors = %0d", errors); $fdisplay(log_fd,"[FAIL] Ex01_logic, errors = %0d", errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule