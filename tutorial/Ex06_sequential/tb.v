`timescale 1ns/1ps
module tb_ex05_sequential;
    reg clk, rst_n;
    reg en, clear, d, serial_in;
    wire [3:0] cnt;
    wire rollover;
    wire dff_q, dff_q_b;
    wire serial_out;
    wire [7:0] shift_data;
    integer errors, log_fd, result_fd, pattern, i;
    reg [7:0] expected_shift;

    Ex06_Counter u_counter(.clk(clk), .rst_n(rst_n), .en(en), .clear(clear), .cnt(cnt), .rollover(rollover));
    Ex06_DFF u_dff(.clk(clk), .rst_n(rst_n), .d(d), .q(dff_q), .q_b(dff_q_b));
    Ex06_ShiftRegister u_shift(.clk(clk), .rst_n(rst_n), .en(en), .serial_in(serial_in), .serial_out(serial_out), .data(shift_data));

    initial begin clk = 0; forever #5 clk = ~clk; end

    task check;
        input [8*32-1:0] name;
        input [3:0] exp_cnt;
        input exp_rollover;
        input exp_dff_q;
        input [7:0] exp_shift_value;
        begin
            pattern = pattern + 1;
            #1;
            if (cnt !== exp_cnt || rollover !== exp_rollover || dff_q !== exp_dff_q || shift_data !== exp_shift_value) begin
                $display("[ERROR] pattern %0d (%0s): cnt=%0d/%0d rollover=%b/%b dff=%b/%b shift=%b/%b", pattern, name, exp_cnt, cnt, exp_rollover, rollover, exp_dff_q, dff_q, exp_shift_value, shift_data);
                $fdisplay(log_fd,"[ERROR] pattern %0d (%0s): cnt=%0d/%0d rollover=%b/%b dff=%b/%b shift=%b/%b", pattern, name, exp_cnt, cnt, exp_rollover, rollover, exp_dff_q, dff_q, exp_shift_value, shift_data);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_ex05_sequential);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        errors=0; pattern=0; rst_n=0; en=0; clear=0; d=0; serial_in=0; expected_shift=8'b0000_0000;
        repeat(2) @(posedge clk); @(negedge clk); rst_n=1; @(posedge clk); check("reset release", 4'd0, 1'b0, 1'b0, 8'b0000_0000);

        @(negedge clk); en=1; d=1; serial_in=1;
        expected_shift = {expected_shift[6:0], 1'b1};
        @(posedge clk); check("set and shift 1", 4'd1, 1'b0, 1'b1, expected_shift);

        @(negedge clk); d=0; serial_in=0;
        expected_shift = {expected_shift[6:0], 1'b0};
        @(posedge clk); check("shift 0", 4'd2, 1'b0, 1'b0, expected_shift);

        @(negedge clk); serial_in=1;
        expected_shift = {expected_shift[6:0], 1'b1};
        @(posedge clk); check("shift 1", 4'd3, 1'b0, 1'b0, expected_shift);

        @(negedge clk); clear=1; en=1; serial_in=1;
        expected_shift = {expected_shift[6:0], 1'b1};
        @(posedge clk); check("clear counter", 4'd0, 1'b0, 1'b0, expected_shift);

        @(negedge clk); clear=0; en=0; serial_in=0;
        @(posedge clk); check("hold counter and shift", 4'd0, 1'b0, 1'b0, expected_shift);

        @(negedge clk); en=1; d=0; serial_in=0;
        for (i = 1; i <= 14; i = i + 1) begin
            expected_shift = {expected_shift[6:0], 1'b0};
            @(posedge clk); check("count toward rollover", i[3:0], 1'b0, 1'b0, expected_shift);
        end
        expected_shift = {expected_shift[6:0], 1'b0};
        @(posedge clk); check("rollover asserted at 15", 4'd15, 1'b1, 1'b0, expected_shift);
        expected_shift = {expected_shift[6:0], 1'b0};
        @(posedge clk); check("wrap after rollover", 4'd0, 1'b0, 1'b0, expected_shift);

        if(errors==0) begin $display("[PASS] Ex06_sequential"); $fdisplay(log_fd,"[PASS] Ex06_sequential"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] Ex06_sequential, errors = %0d", errors); $fdisplay(log_fd,"[FAIL] Ex06_sequential, errors = %0d", errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
