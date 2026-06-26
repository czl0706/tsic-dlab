`timescale 1ns/1ps
module tb_alu_comp;
    reg clk, rst_n, wen;
    reg [1:0] waddr, src_a, src_b, op;
    reg [7:0] wdata;
    wire [7:0] reg0, reg1, reg2, reg3;
    wire [15:0] result;
    integer errors, log_fd, result_fd, pattern;

    alu_comp dut (
        .clk(clk), .rst_n(rst_n), .wen(wen), .waddr(waddr), .wdata(wdata),
        .src_a(src_a), .src_b(src_b), .op(op),
        .reg0(reg0), .reg1(reg1), .reg2(reg2), .reg3(reg3), .result(result)
    );
    initial begin clk = 0; forever #5 clk = ~clk; end

    function [7:0] reg_value;
        input [1:0] sel;
        begin
            case (sel)
                2'd0: reg_value = reg0;
                2'd1: reg_value = reg1;
                2'd2: reg_value = reg2;
                default: reg_value = reg3;
            endcase
        end
    endfunction

    task write_reg;
        input [1:0] addr;
        input [7:0] data;
        begin
            @(negedge clk); waddr = addr; wdata = data; wen = 1'b1;
            @(posedge clk);
            @(negedge clk); wen = 1'b0; wdata = 8'd0; waddr = 2'd0;
            #1;
        end
    endtask

    task check_alu;
        input [8*16-1:0] name;
        input [1:0] a_sel, b_sel, op_sel;
        input [15:0] expected;
        reg [7:0] a_value, b_value;
        begin
            @(negedge clk); src_a = a_sel; src_b = b_sel; op = op_sel;
            a_value = reg_value(a_sel);
            b_value = reg_value(b_sel);
            pattern = pattern + 1;
            #1;
            if (result !== expected) begin
                if (errors == 0) $display("[ERROR] pattern %0d (%0s): op=%0d src_a=r%0d(%0d) src_b=r%0d(%0d) expected=%0d got=%0d", pattern, name, op_sel, a_sel, a_value, b_sel, b_value, expected, result);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d (%0s): op=%0d src_a=r%0d(%0d) src_b=r%0d(%0d) expected=%0d got=%0d", pattern, name, op_sel, a_sel, a_value, b_sel, b_value, expected, result);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd = $fopen("sim/log.txt", "w");
        result_fd = $fopen("sim/result.txt", "w");
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_alu_comp);
        $display("##SEC_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1] checks register write/readback");
        $fdisplay(log_fd,"[CASE 1] checks register write/readback");
        $display("[CASE 2-5] checks each ALU operation");
        $fdisplay(log_fd,"[CASE 2-5] checks each ALU operation");
        // GOLDEN_CASE_SUMMARY_END


        errors = 0; pattern = 0; rst_n = 0; wen = 0; waddr = 0; wdata = 0; src_a = 0; src_b = 0; op = 0;
        repeat (2) @(posedge clk); @(negedge clk); rst_n = 1; #1;
        write_reg(2'd0, 8'd20);
        write_reg(2'd1, 8'd7);
        write_reg(2'd2, 8'd3);
        write_reg(2'd3, 8'd12);
        pattern = pattern + 1;
        if (reg0 !== 8'd20 || reg1 !== 8'd7 || reg2 !== 8'd3 || reg3 !== 8'd12) begin
            if (errors == 0) $display("[ERROR] pattern %0d (register write/readback): expected r0=20 r1=7 r2=3 r3=12 got r0=%0d r1=%0d r2=%0d r3=%0d", pattern, reg0, reg1, reg2, reg3);
            if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d (register write/readback): expected r0=20 r1=7 r2=3 r3=12 got r0=%0d r1=%0d r2=%0d r3=%0d", pattern, reg0, reg1, reg2, reg3);
            errors = errors + 1;
        end
        check_alu("add",  2'd0, 2'd1, 2'd0, 16'd27);
        check_alu("sub",  2'd0, 2'd1, 2'd1, 16'd13);
        check_alu("mul",  2'd1, 2'd2, 2'd2, 16'd21);
        check_alu("div2", 2'd3, 2'd0, 2'd3, 16'd6);
        if (errors == 0) begin
            $display("[PASS] alu_comp");
            $fdisplay(log_fd, "[PASS] alu_comp");
            $fdisplay(result_fd, "pass");
        end else begin
            $display("[FAIL] alu_comp, errors = %0d", errors);
            $fdisplay(log_fd, "[FAIL] alu_comp, errors = %0d", errors);
            $fdisplay(result_fd, "fail");
        end
        $display("##END_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd);
        $finish;
    end
endmodule
