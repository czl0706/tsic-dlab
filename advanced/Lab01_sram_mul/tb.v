`timescale 1ns/1ps
module tb_sram_mul;
  reg clk, rst_n, start;
  wire done;
  wire C_cen, C_wen;
  wire [1:0] A_addr, B_addr;
  reg  [31:0] A_rdata, B_rdata;
  wire [3:0] C_addr;
  wire [17:0] C_wdata;

  reg [31:0] A_mem [0:3];
  reg [31:0] B_mem [0:3];
  reg signed [17:0] C_got [0:15];
  reg signed [17:0] C_exp [0:15];
  integer log_fd, result_fd, any_fail, reported_error, i, cycle, done_seen;

  sram_mul dut(
    .clk(clk), .rst_n(rst_n), .start(start), .done(done),
    .A_addr(A_addr), .A_rdata(A_rdata),
    .B_addr(B_addr), .B_rdata(B_rdata),
    .C_cen(C_cen), .C_wen(C_wen), .C_addr(C_addr), .C_wdata(C_wdata)
  );

  always #5 clk = ~clk;
  always @(*) begin
    A_rdata = A_mem[A_addr];
    B_rdata = B_mem[B_addr];
  end

  always @(posedge clk) begin
    #1;
    if (!C_cen && !C_wen) C_got[C_addr] = C_wdata;
  end

  initial begin
    log_fd = $fopen("sim/log.txt", "w");
    result_fd = $fopen("sim/result.txt", "w");
    $dumpfile("sim/wave.vcd");
    $dumpvars(0, tb_sram_mul);
    $display("##SEC_STUDENT_CAN_SEE");
    $fdisplay(log_fd, "##SEC_STUDENT_CAN_SEE");
        // GOLDEN_CASE_SUMMARY_BEGIN
        $display("[CASE 1] checks start/done handshake");
        $fdisplay(log_fd,"[CASE 1] checks start/done handshake");
        $display("[CASE 2] checks all output matrix entries, including signed values");
        $fdisplay(log_fd,"[CASE 2] checks all output matrix entries, including signed values");
        // GOLDEN_CASE_SUMMARY_END



    clk = 0; rst_n = 0; start = 0; any_fail = 0; reported_error = 0;
    for (i = 0; i < 16; i = i + 1) begin C_got[i] = 0; C_exp[i] = 0; end

    A_mem[0] = {8'sd4, 8'sd3, 8'sd2, 8'sd1};
    A_mem[1] = {8'sd8, 8'sd7, 8'sd6, 8'sd5};
    A_mem[2] = {8'sd1, 8'sd1, 8'sd1, 8'sd1};
    A_mem[3] = {8'sd3, -8'sd1, 8'sd0, 8'sd2};

    B_mem[0] = {8'sd2, 8'sd1, 8'sd0, 8'sd1};
    B_mem[1] = {8'sd1, 8'sd0, 8'sd1, 8'sd0};
    B_mem[2] = {8'sd0, 8'sd1, 8'sd2, 8'sd2};
    B_mem[3] = {8'sd4, 8'sd3, 8'sd2, 8'sd1};

    C_exp[0]=18'sd12; C_exp[1]=18'sd6;  C_exp[2]=18'sd9;  C_exp[3]=18'sd30;
    C_exp[4]=18'sd28; C_exp[5]=18'sd14; C_exp[6]=18'sd29; C_exp[7]=18'sd70;
    C_exp[8]=18'sd4;  C_exp[9]=18'sd2;  C_exp[10]=18'sd5; C_exp[11]=18'sd10;
    C_exp[12]=18'sd7; C_exp[13]=18'sd3; C_exp[14]=18'sd3; C_exp[15]=18'sd11;

    repeat (3) @(posedge clk);
    @(negedge clk); rst_n = 1;
    @(negedge clk); start = 1;
    @(posedge clk);
    @(negedge clk); start = 0;

    cycle = 0; done_seen = 0;
    while (!done_seen && cycle < 200) begin
      @(posedge clk);
      #1;
      if (done) done_seen = 1;
      cycle = cycle + 1;
    end

    if (!done_seen) begin
      any_fail = 1;
      if (!reported_error) begin
        reported_error = 1;
        $display("[ERROR] timeout waiting for done after %0d cycles start=%b done=%b", cycle, start, done);
        $fdisplay(log_fd, "[ERROR] timeout waiting for done after %0d cycles start=%b done=%b", cycle, start, done);
      end
    end

    for (i = 0; i < 16; i = i + 1) begin
      if (C_got[i] !== C_exp[i]) begin
        any_fail = 1;
        if (!reported_error) begin
          reported_error = 1;
          $display("[ERROR] C[%0d] row=%0d col=%0d expected=%0d got=%0d", i, i/4, i%4, C_exp[i], C_got[i]);
          $fdisplay(log_fd, "[ERROR] C[%0d] row=%0d col=%0d expected=%0d got=%0d", i, i/4, i%4, C_exp[i], C_got[i]);
        end
      end
    end

    if (!any_fail) begin
      $display("[PASS] sram_mul");
      $fdisplay(log_fd, "[PASS] sram_mul");
    end

    $display("##END_STUDENT_CAN_SEE");
    $fdisplay(log_fd, "##END_STUDENT_CAN_SEE");
    if (any_fail) $fdisplay(result_fd, "fail"); else $fdisplay(result_fd, "pass");
    $fclose(log_fd); $fclose(result_fd); #1; $finish;
  end
endmodule