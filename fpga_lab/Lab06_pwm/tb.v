`timescale 1ns/1ps
module tb_pwm;
    reg clk,rst;
    reg [6:0] duty;
    wire pwm_out;
    integer errors,log_fd,result_fd,i,pattern;
    reg expected;

    pwm dut(.clk(clk),.rst(rst),.duty(duty),.pwm_out(pwm_out));
    initial begin clk=0; forever #5 clk=~clk; end

    task check_output;
        input [8*32-1:0] name;
        input expected_value;
        begin
            pattern = pattern + 1;
            #1;
            if(pwm_out!==expected_value) begin
                if (errors == 0) $display("[ERROR] pattern %0d (%0s): duty=%0d expected pwm_out=%b got=%b", pattern, name, duty, expected_value, pwm_out);
                if (errors == 0) $fdisplay(log_fd,"[ERROR] pattern %0d (%0s): duty=%0d expected pwm_out=%b got=%b", pattern, name, duty, expected_value, pwm_out);
                errors=errors+1;
            end
        end
    endtask

    task check_period;
        input [8*32-1:0] name;
        input [6:0] duty_value;
        begin
            for(i=0;i<100;i=i+1) begin
                @(posedge clk);
                expected = (i < duty_value);
                check_output(name, expected);
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_pwm);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1] checks reset output");
        $fdisplay(log_fd,"[CASE 1] checks reset output");
        $display("[CASE 2-101] checks 30 percent duty cycle");
        $fdisplay(log_fd,"[CASE 2-101] checks 30 percent duty cycle");
        $display("[CASE 102-201] checks dynamic duty update to 75 percent");
        $fdisplay(log_fd,"[CASE 102-201] checks dynamic duty update to 75 percent");
        $display("[CASE 202-301] checks zero percent duty");
        $fdisplay(log_fd,"[CASE 202-301] checks zero percent duty");
        $display("[CASE 302-401] checks 100 percent duty");
        $fdisplay(log_fd,"[CASE 302-401] checks 100 percent duty");
        // GOLDEN_CASE_SUMMARY_END

        errors=0; pattern=0; rst=1; duty=7'd30;
        repeat(2) @(posedge clk); @(negedge clk); rst=0; check_output("reset release", 1'b0);
        check_period("30 percent duty", 7'd30);
        @(negedge clk); duty=7'd75;
        check_period("dynamic 75 percent duty", 7'd75);
        @(negedge clk); duty=7'd0;
        check_period("zero percent duty", 7'd0);
        @(negedge clk); duty=7'd100;
        check_period("100 percent duty", 7'd100);

        if(errors==0) begin $display("[PASS] pwm"); $fdisplay(log_fd,"[PASS] pwm"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] pwm, errors = %0d",errors); $fdisplay(log_fd,"[FAIL] pwm, errors = %0d",errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
