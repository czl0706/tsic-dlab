`timescale 1ns/1ps
module tb_clk_divN;
    reg clk_in, rst;
    wire clk_out;
    integer errors, log_fd, result_fd, i, pattern;
    reg expected;

    clk_divN #(.N(4)) dut (.clk_in(clk_in), .rst(rst), .clk_out(clk_out));
    initial begin clk_in = 0; forever #5 clk_in = ~clk_in; end

    task report_error;
        input [8*32-1:0] name;
        input exp;
        begin
            if (errors == 0) $display("[ERROR] pattern %0d (%0s): expected clk_out=%b got=%b", pattern, name, exp, clk_out);
            if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d (%0s): expected clk_out=%b got=%b", pattern, name, exp, clk_out);
            errors = errors + 1;
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_clk_divN);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1] checks reset release");
        $fdisplay(log_fd,"[CASE 1] checks reset release");
        $display("[CASE 2-9] checks divider toggle timing");
        $fdisplay(log_fd,"[CASE 2-9] checks divider toggle timing");
        // GOLDEN_CASE_SUMMARY_END


        errors=0; pattern=0; rst=1; expected=0;
        repeat(2) @(posedge clk_in); @(negedge clk_in); rst=0; #1;
        pattern=pattern+1; if(clk_out!==0) report_error("reset release", 1'b0);
        for(i=0;i<8;i=i+1) begin
            @(posedge clk_in); #1;
            pattern=pattern+1;
            if(i%2==1) expected=~expected;
            if(clk_out!==expected) report_error("divide-by-4 step", expected);
        end
        if(errors==0) begin $display("[PASS] clk_divN"); $fdisplay(log_fd,"[PASS] clk_divN"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] clk_divN, errors = %0d",errors); $fdisplay(log_fd,"[FAIL] clk_divN, errors = %0d",errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
