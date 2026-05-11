`timescale 1ns/1ps
module tb_lfsr_3bits;
    reg clk,rst,en;
    wire [2:0] lfsr_out;
    integer errors,log_fd,result_fd,i,pattern;
    reg [2:0] exp [0:6];

    lfsr_3bits dut(.clk(clk),.rst(rst),.en(en),.lfsr_out(lfsr_out));
    initial begin clk=0; forever #5 clk=~clk; end
    initial begin exp[0]=3'b101; exp[1]=3'b010; exp[2]=3'b100; exp[3]=3'b001; exp[4]=3'b011; exp[5]=3'b111; exp[6]=3'b110; end

    task check;
        input [8*32-1:0] name;
        input [2:0] expected;
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
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_lfsr_3bits);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1] checks reset seed");
        $fdisplay(log_fd,"[CASE 1] checks reset seed");
        $display("[CASE 2-7] checks enabled LFSR sequence");
        $fdisplay(log_fd,"[CASE 2-7] checks enabled LFSR sequence");
        $display("[CASE 8] checks hold when disabled");
        $fdisplay(log_fd,"[CASE 8] checks hold when disabled");
        // GOLDEN_CASE_SUMMARY_END


        errors=0; pattern=0; rst=1; en=0;
        repeat(2) @(posedge clk); @(negedge clk); rst=0; check("reset release", exp[0]);
        @(negedge clk); en=1;
        for(i=1;i<=6;i=i+1) begin @(posedge clk); check("lfsr sequence", exp[i]); end
        @(negedge clk); en=0; @(posedge clk); check("hold when en=0", exp[6]);
        if(errors==0) begin $display("[PASS] lfsr_3bits"); $fdisplay(log_fd,"[PASS] lfsr_3bits"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] lfsr_3bits, errors = %0d",errors); $fdisplay(log_fd,"[FAIL] lfsr_3bits, errors = %0d",errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
