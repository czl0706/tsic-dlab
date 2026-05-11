`timescale 1ns/1ps
module tb_scan_ctrl;
    reg clk,rst;
    wire [1:0] scan_sel;
    wire [3:0] an;
    integer errors,log_fd,result_fd,pattern;

    scan_ctrl dut(.clk(clk),.rst(rst),.scan_sel(scan_sel),.an(an));
    initial begin clk=0; forever #5 clk=~clk; end

    task check;
        input [8*32-1:0] name;
        input [1:0] exp_sel;
        input [3:0] exp_an;
        begin
            pattern = pattern + 1;
            #1;
            if(scan_sel!==exp_sel || an!==exp_an) begin
                if (errors == 0) $display("[ERROR] pattern %0d (%0s): expected sel=%b an=%b got sel=%b an=%b", pattern, name, exp_sel, exp_an, scan_sel, an);
                if (errors == 0) $fdisplay(log_fd,"[ERROR] pattern %0d (%0s): expected sel=%b an=%b got sel=%b an=%b", pattern, name, exp_sel, exp_an, scan_sel, an);
                errors=errors+1;
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_scan_ctrl);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1] checks reset release");
        $fdisplay(log_fd,"[CASE 1] checks reset release");
        $display("[CASE 2-4] checks scan digit rotation");
        $fdisplay(log_fd,"[CASE 2-4] checks scan digit rotation");
        $display("[CASE 5] checks wraparound");
        $fdisplay(log_fd,"[CASE 5] checks wraparound");
        // GOLDEN_CASE_SUMMARY_END


        errors=0; pattern=0; rst=1;
        repeat(2) @(posedge clk); @(negedge clk); rst=0;
        check("reset release", 2'b00,4'b1110);
        @(posedge clk); check("scan digit 1", 2'b01,4'b1101);
        @(posedge clk); check("scan digit 2", 2'b10,4'b1011);
        @(posedge clk); check("scan digit 3", 2'b11,4'b0111);
        @(posedge clk); check("wrap to digit 0", 2'b00,4'b1110);
        if(errors==0) begin $display("[PASS] scan_ctrl"); $fdisplay(log_fd,"[PASS] scan_ctrl"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] scan_ctrl, errors = %0d",errors); $fdisplay(log_fd,"[FAIL] scan_ctrl, errors = %0d",errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
