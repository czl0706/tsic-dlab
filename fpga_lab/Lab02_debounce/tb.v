`timescale 1ns/1ps
module tb_debounce;
    reg clk,rst,btn_in;
    wire btn_db;
    integer errors,log_fd,result_fd,pattern;

    debounce #(.N(3)) dut(.clk(clk),.rst(rst),.btn_in(btn_in),.btn_db(btn_db));
    initial begin clk=0; forever #5 clk=~clk; end

    task step; input v; begin @(negedge clk); btn_in=v; @(posedge clk); #1; end endtask
    task check;
        input [8*32-1:0] name;
        input expected;
        begin
            pattern = pattern + 1;
            if(btn_db!==expected) begin
                if (errors == 0) $display("[ERROR] pattern %0d (%0s): btn_in=%b expected btn_db=%b got=%b", pattern, name, btn_in, expected, btn_db);
                if (errors == 0) $fdisplay(log_fd,"[ERROR] pattern %0d (%0s): btn_in=%b expected btn_db=%b got=%b", pattern, name, btn_in, expected, btn_db);
                errors=errors+1;
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_debounce);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1] checks reset release");
        $fdisplay(log_fd,"[CASE 1] checks reset release");
        $display("[CASE 2-4] checks consecutive high samples");
        $fdisplay(log_fd,"[CASE 2-4] checks consecutive high samples");
        $display("[CASE 5] checks low sample behavior");
        $fdisplay(log_fd,"[CASE 5] checks low sample behavior");
        // GOLDEN_CASE_SUMMARY_END


        errors=0; pattern=0; rst=1; btn_in=0;
        repeat(2) @(posedge clk); @(negedge clk); rst=0; #1; check("reset release", 1'b0);
        step(1); check("first high sample", 1'b0);
        step(1); check("second high sample", 1'b0);
        step(1); check("third high sample", 1'b1);
        step(0); check("drop after low sample", 1'b0);
        if(errors==0) begin $display("[PASS] debounce"); $fdisplay(log_fd,"[PASS] debounce"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] debounce, errors = %0d",errors); $fdisplay(log_fd,"[FAIL] debounce, errors = %0d",errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
