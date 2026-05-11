`timescale 1ns/1ps
module tb_ex02_arithmetic;
    reg [7:0] in_a, in_b;
    reg signed [7:0] s_a, s_b;
    reg [1:0] shamt;
    wire [8:0] u_add, u_sub, u_add_ext, u_sub_ext;
    wire [7:0] u_add_8, u_sub_8;
    wire [15:0] u_mul, u_sl_wide;
    wire [7:0] u_sr, u_sl;
    wire signed [8:0] s_add, s_sub;
    wire signed [15:0] s_mul;
    wire signed [7:0] s_sr_logic, s_sr_arith, s_sl;
    integer errors, log_fd, result_fd, pattern;

    Ex02_Arithmetic dut(
        .in_a(in_a), .in_b(in_b),
        .u_add(u_add), .u_sub(u_sub), .u_add_8(u_add_8), .u_sub_8(u_sub_8), .u_add_ext(u_add_ext), .u_sub_ext(u_sub_ext),
        .u_mul(u_mul), .u_sr(u_sr), .u_sl(u_sl), .u_sl_wide(u_sl_wide),
        .s_a(s_a), .s_b(s_b), .shamt(shamt),
        .s_add(s_add), .s_sub(s_sub), .s_mul(s_mul),
        .s_sr_logic(s_sr_logic), .s_sr_arith(s_sr_arith), .s_sl(s_sl)
    );

    task check;
        input [7:0] a, b;
        input signed [7:0] sa, sb;
        input [1:0] shift;
        reg [7:0] exp_u_add_8;
        reg [7:0] exp_u_sub_8;
        reg [8:0] exp_u_add_ext;
        reg [8:0] exp_u_sub_ext;
        begin
            pattern = pattern + 1;
            in_a=a; in_b=b; s_a=sa; s_b=sb; shamt=shift; #1;

            exp_u_add_8 = a + b;
            exp_u_sub_8 = a - b;
            exp_u_add_ext = {1'b0, a} + {1'b0, b};
            exp_u_sub_ext = {1'b0, a} - {1'b0, b};

            if (u_add !== exp_u_add_ext || u_sub !== exp_u_sub_ext ||
                u_add_8 !== exp_u_add_8 || u_sub_8 !== exp_u_sub_8 ||
                u_add_ext !== exp_u_add_ext || u_sub_ext !== exp_u_sub_ext ||
                u_mul !== (a*b) || u_sr !== (a >> 2) || u_sl !== (a << 2) || u_sl_wide !== ({8'b0,a} << 4) ||
                s_add !== (sa+sb) || s_sub !== (sa-sb) || s_mul !== (sa*sb) ||
                s_sr_logic !== (sa >> shift) || s_sr_arith !== (sa >>> shift) || s_sl !== (sa <<< shift)) begin
                $display("[ERROR] pattern %0d: a=%0d b=%0d add8=%0d add_ext=%0d got add8=%0d add_ext=%0d", pattern, a, b, exp_u_add_8, exp_u_add_ext, u_add_8, u_add_ext);
                $fdisplay(log_fd,"[ERROR] pattern %0d: a=%0d b=%0d add8=%0d add_ext=%0d got add8=%0d add_ext=%0d", pattern, a, b, exp_u_add_8, exp_u_add_ext, u_add_8, u_add_ext);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_ex02_arithmetic);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        errors=0; pattern=0;
        check(8'd12, 8'd3,  8'sd12,  -8'sd3, 2'd1);
        check(8'd250,8'd10, -8'sd16,  8'sd5, 2'd2);
        check(8'd15, 8'd20, -8'sd64, -8'sd2, 2'd3);
        if(errors==0) begin $display("[PASS] Ex02_Arithmetic"); $fdisplay(log_fd,"[PASS] Ex02_Arithmetic"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] Ex02_Arithmetic, errors = %0d", errors); $fdisplay(log_fd,"[FAIL] Ex02_Arithmetic, errors = %0d", errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule