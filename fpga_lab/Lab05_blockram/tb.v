`timescale 1ns/1ps

module tb_blockram;

    reg clk;
    reg [3:0] raddr;
    wire [11:0] rdata;
    reg we;
    reg [3:0] waddr;
    reg [11:0] wdata;

    integer errors;
    integer log_fd;
    integer result_fd;
    integer pattern;

    blockram #(
        .ADDR_WIDTH(4),
        .DATA_WIDTH(12),
        .DEPTH(16)
    ) dut (
        .clk(clk),
        .raddr(raddr),
        .rdata(rdata),
        .we(we),
        .waddr(waddr),
        .wdata(wdata)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task write_mem;
        input [3:0] addr;
        input [11:0] data;
        begin
            @(negedge clk);
            waddr = addr;
            wdata = data;
            we = 1'b1;
            @(posedge clk);
            #1;
            @(negedge clk);
            we = 1'b0;
            waddr = 4'd0;
            wdata = 12'd0;
        end
    endtask

    task read_mem_check;
        input [3:0] addr;
        input [11:0] expected;
        begin
            pattern = pattern + 1;
            @(negedge clk);
            raddr = addr;
            @(posedge clk);
            #1;
            if (rdata !== expected) begin
                if (errors == 0) $display("[ERROR] pattern %0d (sync read): addr=%0d expected rdata=%h got=%h", pattern, addr, expected, rdata);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d (sync read): addr=%0d expected rdata=%h got=%h", pattern, addr, expected, rdata);
                errors = errors + 1;
            end
        end
    endtask

    task same_addr_read_write_check;
        input [3:0] addr;
        input [11:0] old_data;
        input [11:0] new_data;
        begin
            pattern = pattern + 1;
            @(negedge clk);
            raddr = addr;
            waddr = addr;
            wdata = new_data;
            we = 1'b1;
            @(posedge clk);
            #1;
            if (rdata !== old_data) begin
                if (errors == 0) $display("[ERROR] pattern %0d (same-address read/write): expected old data got=%h", pattern, rdata);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d (same-address read/write): expected old data got=%h", pattern, rdata);
                errors = errors + 1;
            end
            @(negedge clk);
            we = 1'b0;
            waddr = 4'd0;
            wdata = 12'd0;
            @(posedge clk);
            #1;
            if (rdata !== new_data) begin
                if (errors == 0) $display("[ERROR] pattern %0d (same-address next read): expected new data got=%h", pattern, rdata);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d (same-address next read): expected new data got=%h", pattern, rdata);
                errors = errors + 1;
            end
        end
    endtask

    task diff_addr_read_write_check;
        input [3:0] read_addr;
        input [11:0] read_expected;
        input [3:0] write_addr;
        input [11:0] write_data;
        begin
            pattern = pattern + 1;
            @(negedge clk);
            raddr = read_addr;
            waddr = write_addr;
            wdata = write_data;
            we = 1'b1;
            @(posedge clk);
            #1;
            if (rdata !== read_expected) begin
                if (errors == 0) $display("[ERROR] pattern %0d (different-address read/write): read data changed unexpectedly got=%h", pattern, rdata);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d (different-address read/write): read data changed unexpectedly got=%h", pattern, rdata);
                errors = errors + 1;
            end
            @(negedge clk);
            we = 1'b0;
            waddr = 4'd0;
            wdata = 12'd0;
        end
    endtask

    initial begin
        log_fd = $fopen("sim/log.txt", "w");
        result_fd = $fopen("sim/result.txt", "w");
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_blockram);
        $display("##SEC_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1-3] checks synchronous write/readback on multiple addresses");
        $fdisplay(log_fd,"[CASE 1-3] checks synchronous write/readback on multiple addresses");
        $display("[CASE 4] checks overwrite on the same address");
        $fdisplay(log_fd,"[CASE 4] checks overwrite on the same address");
        $display("[CASE 5] checks same-address read/write returns old data first");
        $fdisplay(log_fd,"[CASE 5] checks same-address read/write returns old data first");
        $display("[CASE 6] checks different-address read/write does not disturb read data");
        $fdisplay(log_fd,"[CASE 6] checks different-address read/write does not disturb read data");
        $display("[CASE 7] checks first and last valid depth addresses");
        $fdisplay(log_fd,"[CASE 7] checks first and last valid depth addresses");
        // GOLDEN_CASE_SUMMARY_END

        errors = 0;
        pattern = 0;
        raddr = 0;
        we = 0;
        waddr = 0;
        wdata = 0;

        repeat (2) @(posedge clk);

        write_mem(4'd2, 12'h123);
        write_mem(4'd5, 12'hABC);
        write_mem(4'd9, 12'h789);

        read_mem_check(4'd2, 12'h123);
        read_mem_check(4'd5, 12'hABC);
        read_mem_check(4'd9, 12'h789);

        write_mem(4'd2, 12'h456);
        read_mem_check(4'd2, 12'h456);

        same_addr_read_write_check(4'd5, 12'hABC, 12'h555);
        diff_addr_read_write_check(4'd2, 12'h456, 4'd9, 12'h999);
        read_mem_check(4'd9, 12'h999);

        write_mem(4'd0, 12'h00D);
        write_mem(4'd15, 12'hF15);
        read_mem_check(4'd0, 12'h00D);
        read_mem_check(4'd15, 12'hF15);

        if (errors == 0) begin
            $display("[PASS] blockram");
            $fdisplay(log_fd, "[PASS] blockram");
            $fdisplay(result_fd, "pass");
        end else begin
            $display("[FAIL] blockram, errors = %0d", errors);
            $fdisplay(log_fd, "[FAIL] blockram, errors = %0d", errors);
            $fdisplay(result_fd, "fail");
        end

        $display("##END_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##END_STUDENT_CAN_SEE");
        $fclose(log_fd);
        $fclose(result_fd);

        $finish;
    end

endmodule
