`timescale 1ns/1ps
module tb_seg7_dec;
    reg [3:0] value;
    wire [6:0] seg;
    integer errors, log_fd, result_fd, pattern;

    seg7_dec dut (.value(value), .seg(seg));

    task check;
        input [3:0] v;
        input [6:0] exp;
        begin
            value = v;
            pattern = pattern + 1;
            #1;
            if (seg !== exp) begin
                if (errors == 0) $display("[ERROR] pattern %0d: value=%h expected seg=%b got=%b", pattern, v, exp, seg);
                if (errors == 0) $fdisplay(log_fd,"[ERROR] pattern %0d: value=%h expected seg=%b got=%b", pattern, v, exp, seg);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_seg7_dec);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1-10] checks decimal digit encodings");
        $fdisplay(log_fd,"[CASE 1-10] checks decimal digit encodings");
        $display("[CASE 11] checks one default-code input");
        $fdisplay(log_fd,"[CASE 11] checks one default-code input");
        // GOLDEN_CASE_SUMMARY_END


        errors=0; pattern=0;
        check(4'h0,7'b0000001); check(4'h1,7'b1001111); check(4'h2,7'b0010010); check(4'h3,7'b0000110);
        check(4'h4,7'b1001100); check(4'h5,7'b0100100); check(4'h6,7'b0100000); check(4'h7,7'b0001111);
        check(4'h8,7'b0000000); check(4'h9,7'b0000100); check(4'hA,7'b1111111);
        if(errors==0) begin $display("[PASS] seg7_dec"); $fdisplay(log_fd,"[PASS] seg7_dec"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] seg7_dec, errors = %0d",errors); $fdisplay(log_fd,"[FAIL] seg7_dec, errors = %0d",errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
