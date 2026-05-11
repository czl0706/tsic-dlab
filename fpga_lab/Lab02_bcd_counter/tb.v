`timescale 1ns/1ps
module tb_bcd_counter;
    reg clk,rst,clr,en,up;
    wire [3:0] count;
    wire carry;
    integer errors,log_fd,result_fd,i,pattern;

    bcd_counter dut(.clk(clk),.rst(rst),.clr(clr),.en(en),.up(up),.count(count),.carry(carry));
    initial begin clk=0; forever #5 clk=~clk; end

    task check_count;
        input [8*32-1:0] name;
        input [3:0] expected;
        begin
            pattern = pattern + 1;
            #1;
            if(count!==expected) begin
                if (errors == 0) $display("[ERROR] pattern %0d (%0s): en=%b up=%b clr=%b expected count=%0d got=%0d carry=%b", pattern, name, en, up, clr, expected, count, carry);
                if (errors == 0) $fdisplay(log_fd,"[ERROR] pattern %0d (%0s): en=%b up=%b clr=%b expected count=%0d got=%0d carry=%b", pattern, name, en, up, clr, expected, count, carry);
                errors=errors+1;
            end
        end
    endtask

    task check_carry;
        input [8*32-1:0] name;
        input expected;
        begin
            pattern = pattern + 1;
            #1;
            if(carry!==expected) begin
                if (errors == 0) $display("[ERROR] pattern %0d (%0s): count=%0d en=%b up=%b clr=%b expected carry=%b got=%b", pattern, name, count, en, up, clr, expected, carry);
                if (errors == 0) $fdisplay(log_fd,"[ERROR] pattern %0d (%0s): count=%0d en=%b up=%b clr=%b expected carry=%b got=%b", pattern, name, count, en, up, clr, expected, carry);
                errors=errors+1;
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_bcd_counter);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1] checks reset release");
        $fdisplay(log_fd,"[CASE 1] checks reset release");
        $display("[CASE 2-10] checks count-up sequence");
        $fdisplay(log_fd,"[CASE 2-10] checks count-up sequence");
        $display("[CASE 11] checks carry behavior");
        $fdisplay(log_fd,"[CASE 11] checks carry behavior");
        $display("[CASE 12] checks rollover");
        $fdisplay(log_fd,"[CASE 12] checks rollover");
        $display("[CASE 13] checks clear");
        $fdisplay(log_fd,"[CASE 13] checks clear");
        $display("[CASE 14] checks hold when disabled");
        $fdisplay(log_fd,"[CASE 14] checks hold when disabled");
        $display("[CASE 15] checks hold when up is low");
        $fdisplay(log_fd,"[CASE 15] checks hold when up is low");
        // GOLDEN_CASE_SUMMARY_END


        errors=0; pattern=0; rst=1; clr=0; en=0; up=1;
        repeat(2) @(posedge clk); @(negedge clk); rst=0; check_count("reset release", 4'd0);
        @(negedge clk); en=1;
        for(i=1;i<=9;i=i+1) begin @(posedge clk); check_count("count up", i[3:0]); end
        check_carry("carry at 9", 1'b1);
        @(posedge clk); check_count("rollover 9 to 0", 4'd0);
        @(negedge clk); clr=1; @(posedge clk); check_count("clear", 4'd0);
        @(negedge clk); clr=0; en=0; @(posedge clk); check_count("hold when en=0", 4'd0);
        @(negedge clk); en=1; up=0; @(posedge clk); check_count("hold when up=0", 4'd0);
        if(errors==0) begin $display("[PASS] bcd_counter"); $fdisplay(log_fd,"[PASS] bcd_counter"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] bcd_counter, errors = %0d",errors); $fdisplay(log_fd,"[FAIL] bcd_counter, errors = %0d",errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
