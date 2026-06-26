`timescale 1ns/1ps
module tb_pulse_detector;
    reg clk,rst,in;
    wire pulse;
    integer errors,log_fd,result_fd,pattern;

    pulse_detector dut(.clk(clk),.rst(rst),.in(in),.pulse(pulse));
    initial begin clk=0; forever #5 clk=~clk; end

    task check;
        input [8*32-1:0] name;
        input exp;
        begin
            pattern = pattern + 1;
            #1;
            if(pulse!==exp) begin
                if (errors == 0) $display("[ERROR] pattern %0d (%0s): in=%b expected pulse=%b got=%b", pattern, name, in, exp, pulse);
                if (errors == 0) $fdisplay(log_fd,"[ERROR] pattern %0d (%0s): in=%b expected pulse=%b got=%b", pattern, name, in, exp, pulse);
                errors=errors+1;
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_pulse_detector);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1] checks idle low");
        $fdisplay(log_fd,"[CASE 1] checks idle low");
        $display("[CASE 2] checks first rising edge pulse");
        $fdisplay(log_fd,"[CASE 2] checks first rising edge pulse");
        $display("[CASE 3] checks no repeated pulse while held high");
        $fdisplay(log_fd,"[CASE 3] checks no repeated pulse while held high");
        $display("[CASE 4] checks return low");
        $fdisplay(log_fd,"[CASE 4] checks return low");
        $display("[CASE 5] checks second rising edge pulse");
        $fdisplay(log_fd,"[CASE 5] checks second rising edge pulse");
        // GOLDEN_CASE_SUMMARY_END


        errors=0; pattern=0; rst=1; in=0;
        repeat(2) @(posedge clk); @(negedge clk); rst=0;
        @(posedge clk); check("idle low", 1'b0);
        @(negedge clk); in=1; @(posedge clk); check("first rising edge", 1'b1);
        @(posedge clk); check("hold high no repeat", 1'b0);
        @(negedge clk); in=0; @(posedge clk); check("return low", 1'b0);
        @(negedge clk); in=1; @(posedge clk); check("second rising edge", 1'b1);
        if(errors==0) begin $display("[PASS] pulse_detector"); $fdisplay(log_fd,"[PASS] pulse_detector"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] pulse_detector, errors = %0d",errors); $fdisplay(log_fd,"[FAIL] pulse_detector, errors = %0d",errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
