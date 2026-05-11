`timescale 1ns/1ps
module tb_ex00_basics;
    reg [7:0] in;
    wire [7:0] out_reg, out_ass, const_15, const_63, in_sign;
    wire [1:0] bresp;
    wire [3:0] lo_nibs, hi_nibs;
    wire [15:0] out_s16;
    integer errors, log_fd, result_fd, pattern;

    Ex00_basics dut(
        .in(in), .out_reg(out_reg), .out_ass(out_ass), .const_15(const_15), .const_63(const_63), .bresp(bresp),
        .lo_nibs(lo_nibs), .hi_nibs(hi_nibs), .in_sign(in_sign), .out_s16(out_s16)
    );

    task check;
        input [7:0] value;
        begin
            pattern = pattern + 1;
            in = value; #1;
            if (out_reg !== value || out_ass !== value || in_sign !== value || lo_nibs !== value[3:0] || hi_nibs !== value[7:4] ||
                const_15 !== 8'd15 || const_63 !== 8'd63 || bresp !== 2'b11 || out_s16 !== {{8{value[7]}}, value}) begin
                $display("[ERROR] pattern %0d: in=%h out_reg=%h out_ass=%h lo=%h hi=%h sign16=%h", pattern, value, out_reg, out_ass, lo_nibs, hi_nibs, out_s16);
                $fdisplay(log_fd, "[ERROR] pattern %0d: in=%h out_reg=%h out_ass=%h lo=%h hi=%h sign16=%h", pattern, value, out_reg, out_ass, lo_nibs, hi_nibs, out_s16);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_ex00_basics);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        errors=0; pattern=0;
        check(8'h00); check(8'h3c); check(8'h80); check(8'hff);
        if(errors==0) begin $display("[PASS] Ex00_basics"); $fdisplay(log_fd,"[PASS] Ex00_basics"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] Ex00_basics, errors = %0d", errors); $fdisplay(log_fd,"[FAIL] Ex00_basics, errors = %0d", errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule