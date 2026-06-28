`timescale 1ns/1ps
module tb_ex06_advanced_seq;
    reg clk, rst_n;
    reg coin_5, coin_10;
    wire [7:0] char;
    wire vend, change_5;
    wire [3:0] amount;
    integer errors, log_fd, result_fd, pattern;

    Ex07_HelloWorld u_hello(.clk(clk), .rst_n(rst_n), .char(char));
    Ex07_VendingMachine u_vending(.clk(clk), .rst_n(rst_n), .coin_5(coin_5), .coin_10(coin_10), .vend(vend), .change_5(change_5), .amount(amount));

    initial begin clk = 0; forever #5 clk = ~clk; end

    task check_hello;
        input [8*16-1:0] name;
        input [7:0] expected;
        begin
            pattern = pattern + 1;
            #1;
            if (char !== expected) begin
                $display("[ERROR] pattern %0d (%0s): expected char=%h got=%h", pattern, name, expected, char);
                $fdisplay(log_fd,"[ERROR] pattern %0d (%0s): expected char=%h got=%h", pattern, name, expected, char);
                errors = errors + 1;
            end
        end
    endtask

    task set_coins;
        input c5;
        input c10;
        begin
            @(negedge clk); coin_5 = c5; coin_10 = c10;
        end
    endtask

    task check_vending;
        input [8*24-1:0] name;
        input exp_vend;
        input exp_change_5;
        input [3:0] exp_amount;
        begin
            pattern = pattern + 1;
            #1;
            if (vend !== exp_vend || change_5 !== exp_change_5 || amount !== exp_amount) begin
                $display("[ERROR] pattern %0d (%0s): expected vend=%b change=%b amount=%0d got vend=%b change=%b amount=%0d", pattern, name, exp_vend, exp_change_5, exp_amount, vend, change_5, amount);
                $fdisplay(log_fd,"[ERROR] pattern %0d (%0s): expected vend=%b change=%b amount=%0d got vend=%b change=%b amount=%0d", pattern, name, exp_vend, exp_change_5, exp_amount, vend, change_5, amount);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd=$fopen("sim/log.txt","w"); result_fd=$fopen("sim/result.txt","w");
        $dumpfile("sim/wave.vcd"); $dumpvars(0,tb_ex06_advanced_seq);
        $display("##SEC_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##SEC_STUDENT_CAN_SEE");
        errors=0; pattern=0; rst_n=0; coin_5=0; coin_10=0;
        repeat(2) @(posedge clk); @(negedge clk); rst_n=1;

        #1; check_hello("H", 8'h48);
        @(posedge clk); check_hello("e", 8'h65);
        @(posedge clk); check_hello("l", 8'h6c);
        @(posedge clk); check_hello("l", 8'h6c);
        @(posedge clk); check_hello("o", 8'h6f);
        @(posedge clk); check_hello("space", 8'h20);
        @(posedge clk); check_hello("W", 8'h57);
        @(posedge clk); check_hello("o", 8'h6f);
        @(posedge clk); check_hello("r", 8'h72);
        @(posedge clk); check_hello("l", 8'h6c);
        @(posedge clk); check_hello("d", 8'h64);

        set_coins(1'b1, 1'b0); @(posedge clk); check_vending("insert 5", 1'b0, 1'b0, 4'd5);
        set_coins(1'b0, 1'b1); @(posedge clk); check_vending("5 plus 10 vend", 1'b1, 1'b0, 4'd0);
        set_coins(1'b0, 1'b0); @(posedge clk); check_vending("idle after vend", 1'b0, 1'b0, 4'd0);
        set_coins(1'b0, 1'b1); @(posedge clk); check_vending("insert 10", 1'b0, 1'b0, 4'd10);
        set_coins(1'b0, 1'b1); @(posedge clk); check_vending("10 plus 10 vend change", 1'b1, 1'b1, 4'd0);
        set_coins(1'b0, 1'b0); @(posedge clk); check_vending("idle final", 1'b0, 1'b0, 4'd0);

        if(errors==0) begin $display("[PASS] Ex07_advanced_seq"); $fdisplay(log_fd,"[PASS] Ex07_advanced_seq"); $fdisplay(result_fd,"pass"); end
        else begin $display("[FAIL] Ex07_advanced_seq, errors = %0d", errors); $fdisplay(log_fd,"[FAIL] Ex07_advanced_seq, errors = %0d", errors); $fdisplay(result_fd,"fail"); end
        $display("##END_STUDENT_CAN_SEE"); $fdisplay(log_fd,"##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
