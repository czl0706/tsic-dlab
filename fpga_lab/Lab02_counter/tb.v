`timescale 1ns/1ps
module tb_counter;
    reg clk,rst,clr,en,up;
    wire [3:0] count;
    wire [2:0] count_mod6;
    integer errors,log_fd,result_fd,i,pattern;

    counter dut(.clk(clk),.rst(rst),.clr(clr),.en(en),.up(up),.count(count));
    counter #(.MAX_COUNT(5)) dut_mod6(.clk(clk),.rst(rst),.clr(clr),.en(en),.up(up),.count(count_mod6));
    initial begin clk=0; forever #5 clk=~clk; end

    task check_count;
        input [8*32-1:0] name;
        input [3:0] expected;
        begin
            pattern = pattern + 1;
            #1;
            if(count!==expected) begin
                if (errors == 0) $display("[ERROR] pattern %0d (%0s): en=%b up=%b clr=%b expected count=%0d got=%0d", pattern, name, en, up, clr, expected, count);
                if (errors == 0) $fdisplay(log_fd,"[ERROR] pattern %0d (%0s): en=%b up=%b clr=%b expected count=%0d got=%0d", pattern, name, en, up, clr, expected, count);
                errors=errors+1;
            end
        end
    endtask

    task check_mod6;
        input [8*32-1:0] name;
        input [2:0] expected;
        begin
            pattern = pattern + 1;
            #1;
            if(count_mod6!==expected) begin
                if (errors == 0) $display("[ERROR] pattern %0d (%0s): MAX_COUNT=5 expected count=%0d got count=%0d", pattern, name, expected, count_mod6);
                if (errors == 0) $fdisplay(log_fd,"[ERROR] pattern %0d (%0s): MAX_COUNT=5 expected count=%0d got count=%0d", pattern, name, expected, count_mod6);
                errors=errors+1;
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_counter);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1] checks reset release");
        $fdisplay(log_fd,"[CASE 1] checks reset release");
        $display("[CASE 2-10] checks count-up sequence");
        $fdisplay(log_fd,"[CASE 2-10] checks count-up sequence");
        $display("[CASE 11] checks rollover");
        $fdisplay(log_fd,"[CASE 11] checks rollover");
        $display("[CASE 12] checks clear");
        $fdisplay(log_fd,"[CASE 12] checks clear");
        $display("[CASE 13] checks hold when disabled");
        $fdisplay(log_fd,"[CASE 13] checks hold when disabled");
        $display("[CASE 14] checks hold when up is low");
        $fdisplay(log_fd,"[CASE 14] checks hold when up is low");
        $display("[CASE 15-20] checks parameterized MAX_COUNT=5 rollover");
        $fdisplay(log_fd,"[CASE 15-20] checks parameterized MAX_COUNT=5 rollover");
        // GOLDEN_CASE_SUMMARY_END


        errors=0; pattern=0; rst=1; clr=0; en=0; up=1;
        repeat(2) @(posedge clk); @(negedge clk); rst=0; check_count("reset release", 4'd0);
        @(negedge clk); en=1;
        for(i=1;i<=9;i=i+1) begin @(posedge clk); check_count("count up", i[3:0]); end
        @(posedge clk); check_count("rollover 9 to 0", 4'd0);
        @(negedge clk); clr=1; @(posedge clk); check_count("clear", 4'd0);
        @(negedge clk); clr=0; en=0; @(posedge clk); check_count("hold when en=0", 4'd0);
        @(negedge clk); en=1; up=0; @(posedge clk); check_count("hold when up=0", 4'd0);

        @(negedge clk); rst=1; clr=0; en=0; up=1;
        @(posedge clk); @(negedge clk); rst=0; en=1;
        for(i=1;i<=5;i=i+1) begin @(posedge clk); check_mod6("parameterized count", i[2:0]); end
        @(posedge clk); check_mod6("parameterized rollover", 3'd0);
        @(negedge clk); en=0;
        repeat(5) @(posedge clk);
        if(errors==0) begin $display("[PASS] counter"); $fdisplay(log_fd,"[PASS] counter"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] counter, errors = %0d",errors); $fdisplay(log_fd,"[FAIL] counter, errors = %0d",errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
