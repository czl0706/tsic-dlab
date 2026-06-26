`timescale 1ns/1ps
module tb_pixel_addr_calc;
    reg [9:0] x;
    reg [8:0] y;
    wire [18:0] pixel_index;
    wire [19:0] byte_addr;
    wire [5:0] tile_x;
    wire [4:0] tile_y;
    wire [10:0] tile_index;
    wire [3:0] local_x;
    wire [3:0] local_y;
    wire [7:0] sprite_addr;
    integer errors, log_fd, result_fd, pattern;

    pixel_addr_calc dut (
        .x(x), .y(y),
        .pixel_index(pixel_index), .byte_addr(byte_addr),
        .tile_x(tile_x), .tile_y(tile_y), .tile_index(tile_index),
        .local_x(local_x), .local_y(local_y), .sprite_addr(sprite_addr)
    );

    task check;
        input [9:0] vx;
        input [8:0] vy;
        reg [18:0] exp_pixel_index;
        reg [19:0] exp_byte_addr;
        reg [5:0] exp_tile_x;
        reg [4:0] exp_tile_y;
        reg [10:0] exp_tile_index;
        reg [3:0] exp_local_x;
        reg [3:0] exp_local_y;
        reg [7:0] exp_sprite_addr;
        begin
            pattern = pattern + 1;
            x = vx;
            y = vy;
            exp_pixel_index = vy * 640 + vx;
            exp_byte_addr = exp_pixel_index << 1;
            exp_tile_x = vx >> 4;
            exp_tile_y = vy >> 4;
            exp_tile_index = exp_tile_y * 40 + exp_tile_x;
            exp_local_x = vx[3:0];
            exp_local_y = vy[3:0];
            exp_sprite_addr = (exp_local_y << 4) + exp_local_x;
            #1;
            if (pixel_index !== exp_pixel_index ||
                byte_addr !== exp_byte_addr ||
                tile_x !== exp_tile_x ||
                tile_y !== exp_tile_y ||
                tile_index !== exp_tile_index ||
                local_x !== exp_local_x ||
                local_y !== exp_local_y ||
                sprite_addr !== exp_sprite_addr) begin
                if (errors == 0) $display("[ERROR] pattern %0d: x=%0d y=%0d expected pixel_index=%0d byte_addr=%0d tile=(%0d,%0d) tile_index=%0d local=(%0d,%0d) sprite_addr=%0d", pattern, vx, vy, exp_pixel_index, exp_byte_addr, exp_tile_x, exp_tile_y, exp_tile_index, exp_local_x, exp_local_y, exp_sprite_addr);
                if (errors == 0) $fdisplay(log_fd, "[ERROR] pattern %0d: x=%0d y=%0d expected pixel_index=%0d byte_addr=%0d tile=(%0d,%0d) tile_index=%0d local=(%0d,%0d) sprite_addr=%0d", pattern, vx, vy, exp_pixel_index, exp_byte_addr, exp_tile_x, exp_tile_y, exp_tile_index, exp_local_x, exp_local_y, exp_sprite_addr);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        log_fd = $fopen("sim/log.txt", "w");
        result_fd = $fopen("sim/result.txt", "w");
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, tb_pixel_addr_calc);
        $display("##SEC_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1-8] checks framebuffer, tile, local, and sprite address calculations");
        $fdisplay(log_fd, "[CASE 1-8] checks framebuffer, tile, local, and sprite address calculations");
        // GOLDEN_CASE_SUMMARY_END

        errors = 0;
        pattern = 0;
        check(10'd0,   9'd0);
        check(10'd1,   9'd0);
        check(10'd0,   9'd1);
        check(10'd15,  9'd15);
        check(10'd16,  9'd0);
        check(10'd31,  9'd17);
        check(10'd100, 9'd50);
        check(10'd639, 9'd479);

        if (errors == 0) begin $display("[PASS] pixel_addr_calc"); $fdisplay(log_fd, "[PASS] pixel_addr_calc"); $fdisplay(result_fd, "pass"); end
        else begin $display("[FAIL] pixel_addr_calc, errors = %0d", errors); $fdisplay(log_fd, "[FAIL] pixel_addr_calc, errors = %0d", errors); $fdisplay(result_fd, "fail"); end
        $display("##END_STUDENT_CAN_SEE");
        $fdisplay(log_fd, "##END_STUDENT_CAN_SEE");
        $fclose(log_fd); $fclose(result_fd); $finish;
    end
endmodule
