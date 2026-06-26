`timescale 1ns/1ps
module tb_lfsr_4bits;
    reg clk,rst,en;
    wire [3:0] lfsr_out;
    integer errors,log_fd,result_fd,i,pattern;
    reg [3:0] exp [0:8];

    lfsr_4bits dut(.clk(clk),.rst(rst),.en(en),.lfsr_out(lfsr_out));
    initial begin clk=0; forever #5 clk=~clk; end
    initial begin
        exp[0]=4'b1011; exp[1]=4'b0110; exp[2]=4'b1100; exp[3]=4'b1001; exp[4]=4'b0010;
        exp[5]=4'b0100; exp[6]=4'b1000; exp[7]=4'b0001; exp[8]=4'b0011;
    end

    task check;
        input [8*32-1:0] name;
        input [3:0] expected;
        begin
            pattern = pattern + 1;
            #1;
            if(lfsr_out!==expected) begin
                if (errors == 0) $display("[ERROR] pattern %0d (%0s): en=%b expected lfsr_out=%b got=%b", pattern, name, en, expected, lfsr_out);
                if (errors == 0) $fdisplay(log_fd,"[ERROR] pattern %0d (%0s): en=%b expected lfsr_out=%b got=%b", pattern, name, en, expected, lfsr_out);
                errors=errors+1;
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_lfsr_4bits);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1] checks reset seed");
        $fdisplay(log_fd,"[CASE 1] checks reset seed");
        $display("[CASE 2-9] checks enabled 4-bit LFSR sequence");
        $fdisplay(log_fd,"[CASE 2-9] checks enabled 4-bit LFSR sequence");
        $display("[CASE 10] checks hold when disabled");
        $fdisplay(log_fd,"[CASE 10] checks hold when disabled");
        // GOLDEN_CASE_SUMMARY_END


        errors=0; pattern=0; rst=1; en=0;
        repeat(2) @(posedge clk); @(negedge clk); rst=0; check("reset release", exp[0]);
        @(negedge clk); en=1;
        for(i=1;i<=8;i=i+1) begin @(posedge clk); check("lfsr sequence", exp[i]); end
        @(negedge clk); en=0; @(posedge clk); check("hold when en=0", exp[8]);
        if(errors==0) begin $display("[PASS] lfsr_4bits"); $fdisplay(log_fd,"[PASS] lfsr_4bits"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] lfsr_4bits, errors = %0d",errors); $fdisplay(log_fd,"[FAIL] lfsr_4bits, errors = %0d",errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
