`timescale 1ns/1ps
module tb_ex03_decoder;
    reg [1:0] sel;
    wire [3:0] onehot_case, onehot_shift;
    integer errors, log_fd, result_fd, pattern;

    Ex03_Decoder dut(.sel(sel), .onehot_case(onehot_case), .onehot_shift(onehot_shift));

    task check;
        input [1:0] s;
        input [3:0] expected;
        begin
            pattern = pattern + 1;
            sel = s; #1;
            if (onehot_case !== expected || onehot_shift !== expected) begin
                $display("[ERROR] pattern %0d: sel=%0d expected=%b got case=%b shift=%b", pattern, s, expected, onehot_case, onehot_shift);
                $fdisplay(log_fd,"[ERROR] pattern %0d: sel=%0d expected=%b got case=%b shift=%b", pattern, s, expected, onehot_case, onehot_shift);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_ex03_decoder);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        errors=0; pattern=0;
        check(2'd0,4'b0001); check(2'd1,4'b0010); check(2'd2,4'b0100); check(2'd3,4'b1000);
        if(errors==0) begin $display("[PASS] Ex03_Decoder"); $fdisplay(log_fd,"[PASS] Ex03_Decoder"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] Ex03_Decoder, errors = %0d", errors); $fdisplay(log_fd,"[FAIL] Ex03_Decoder, errors = %0d", errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule