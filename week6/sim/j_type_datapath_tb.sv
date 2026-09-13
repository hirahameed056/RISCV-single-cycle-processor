`timescale 1ns/1ps

module j_type_datapath_tb;

    logic clk;
    logic rst;

    j_type_datapath dut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #12;
        rst = 0;

        @(posedge clk);
        #1;

        $display("Test 1: jal x1, +8");
        $display("PC = %0d, x1 = %0d",
                 dut.pc_out, dut.r.regs[1]);

        if ((dut.pc_out == 32'd8) &&
            (dut.r.regs[1] == 32'd4))
            $display("TEST 1 PASSED\n");
        else
            $display("TEST 1 FAILED\n");

        @(posedge clk);
        #1;

        $display("Test 2: jal x2, +8");
        $display("PC = %0d, x2 = %0d",
                 dut.pc_out, dut.r.regs[2]);

        if ((dut.pc_out == 32'd16) &&
            (dut.r.regs[2] == 32'd12))
            $display("TEST 2 PASSED\n");
        else
            $display("TEST 2 FAILED\n");


        @(posedge clk);
        #1;

        $display("Test 3: jal x3, -8");
        $display("PC = %0d, x3 = %0d",
                 dut.pc_out, dut.r.regs[3]);

        if ((dut.pc_out == 32'd8) &&
            (dut.r.regs[3] == 32'd20))
            $display("TEST 3 PASSED\n");
        else
            $display("TEST 3 FAILED\n");

        $finish;
    end

endmodule