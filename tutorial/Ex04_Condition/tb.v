`timescale 1ns/1ps
module tb_ex04_condition;
    reg [7:0] a, b, value, low, high;
    wire a_gt_b, a_eq_b, value_in_range;
    wire [7:0] larger, smaller;
    wire [7:0] clamped;
    integer errors, log_fd, result_fd, pattern;

    Ex04_condition dut(.a(a), .b(b), .value(value), .low(low), .high(high), .a_gt_b(a_gt_b), .a_eq_b(a_eq_b), .value_in_range(value_in_range), .larger(larger), .smaller(smaller), .clamped(clamped));

    task check;
        input [7:0] ia, ib, ivalue, ilow, ihigh;
        reg [7:0] exp_clamped;
        begin
            pattern = pattern + 1;
            a=ia; b=ib; value=ivalue; low=ilow; high=ihigh; #1;
            if (ivalue < ilow) exp_clamped = ilow;
            else if (ivalue > ihigh) exp_clamped = ihigh;
            else exp_clamped = ivalue;
            if (a_gt_b !== (ia > ib) || a_eq_b !== (ia == ib) || value_in_range !== ((ivalue >= ilow) && (ivalue <= ihigh)) ||
                larger !== ((ia > ib) ? ia : ib) || smaller !== ((ia > ib) ? ib : ia) || clamped !== exp_clamped) begin
                $display("[ERROR] pattern %0d: a=%0d b=%0d value=%0d range=[%0d,%0d] clamped expected=%0d got=%0d", pattern, ia, ib, ivalue, ilow, ihigh, exp_clamped, clamped);
                $fdisplay(log_fd,"[ERROR] pattern %0d: a=%0d b=%0d value=%0d range=[%0d,%0d] clamped expected=%0d got=%0d", pattern, ia, ib, ivalue, ilow, ihigh, exp_clamped, clamped);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_ex04_condition);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        errors=0; pattern=0;
        check(8'd9, 8'd3, 8'd5, 8'd2, 8'd8);
        check(8'd3, 8'd9, 8'd1, 8'd2, 8'd8);
        check(8'd7, 8'd7, 8'd9, 8'd2, 8'd8);
        if(errors==0) begin $display("[PASS] Ex04_condition"); $fdisplay(log_fd,"[PASS] Ex04_condition"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] Ex04_condition, errors = %0d", errors); $fdisplay(log_fd,"[FAIL] Ex04_condition, errors = %0d", errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
