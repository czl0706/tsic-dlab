`timescale 1ns/1ps
module tb_traffic_light;
    reg clk, rst_n;
    wire red, yellow, green;
    wire [3:0] timer;
    integer errors, log_fd, result_fd, cycle;

    traffic_light dut (.clk(clk), .rst_n(rst_n), .red(red), .yellow(yellow), .green(green), .timer(timer));

    initial begin clk = 0; forever #5 clk = ~clk; end

    task check;
        input exp_r, exp_y, exp_g;
        input [3:0] exp_timer;
        begin
            #1;
            if (red !== exp_r || yellow !== exp_y || green !== exp_g || timer !== exp_timer) begin
                if (errors == 0) $display("[ERROR] pattern cycle=%0d: expected r/y/g=%b%b%b timer=%0d got r/y/g=%b%b%b timer=%0d", cycle, exp_r, exp_y, exp_g, exp_timer, red, yellow, green, timer);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern cycle=%0d: expected r/y/g=%b%b%b timer=%0d got r/y/g=%b%b%b timer=%0d", cycle, exp_r, exp_y, exp_g, exp_timer, red, yellow, green, timer);
                errors = errors + 1;
            end
            cycle = cycle + 1;
        end
    endtask

    initial begin
        log_fd = $fopen("sim/log.txt", "w");
        result_fd = $fopen("sim/result.txt", "w");
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_traffic_light);
        $display("##SEC_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1-5] checks green phase");
        $fdisplay(log_fd,"[CASE 1-5] checks green phase");
        $display("[CASE 6-7] checks yellow phase");
        $fdisplay(log_fd,"[CASE 6-7] checks yellow phase");
        $display("[CASE 8-12] checks red phase");
        $fdisplay(log_fd,"[CASE 8-12] checks red phase");
        $display("[CASE 13] checks wraparound");
        $fdisplay(log_fd,"[CASE 13] checks wraparound");
        // GOLDEN_CASE_SUMMARY_END


        errors = 0; cycle = 0; rst_n = 0;
        repeat (2) @(posedge clk);
        @(negedge clk); rst_n = 1;
        check(1'b0, 1'b0, 1'b1, 4'd0);
        @(posedge clk); check(1'b0, 1'b0, 1'b1, 4'd1);
        @(posedge clk); check(1'b0, 1'b0, 1'b1, 4'd2);
        @(posedge clk); check(1'b0, 1'b0, 1'b1, 4'd3);
        @(posedge clk); check(1'b0, 1'b0, 1'b1, 4'd4);
        @(posedge clk); check(1'b0, 1'b1, 1'b0, 4'd0);
        @(posedge clk); check(1'b0, 1'b1, 1'b0, 4'd1);
        @(posedge clk); check(1'b1, 1'b0, 1'b0, 4'd0);
        @(posedge clk); check(1'b1, 1'b0, 1'b0, 4'd1);
        @(posedge clk); check(1'b1, 1'b0, 1'b0, 4'd2);
        @(posedge clk); check(1'b1, 1'b0, 1'b0, 4'd3);
        @(posedge clk); check(1'b1, 1'b0, 1'b0, 4'd4);
        @(posedge clk); check(1'b0, 1'b0, 1'b1, 4'd0);
        if (errors == 0) begin
            $display("[PASS] traffic_light");
            $fdisplay(log_fd, "[PASS] traffic_light");
            $fdisplay(result_fd, "pass");
        end else begin
            $display("[FAIL] traffic_light, errors = %0d", errors);
            $fdisplay(log_fd, "[FAIL] traffic_light, errors = %0d", errors);
            $fdisplay(result_fd, "fail");
        end
        $display("##END_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd);
        $finish;
    end
endmodule
