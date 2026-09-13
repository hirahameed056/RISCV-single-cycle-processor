module r_type_datapath_tb;

    logic clk;
    logic rst;

    // Instantiate datapath
    r_type_datapath dut (
        .clk (clk),
        .rst (rst)
    );

    always #5 clk = ~clk;
    initial begin
        clk = 0;
        rst = 1;
        #1;

        dut.r.regs[1] = 32'd20;
        dut.r.regs[2] = 32'd2
        #1;
        rst = 0;

        @(posedge clk);
        #1;

        if (dut.r.regs[3] == 32'd22)
            $display("ADD PASS: x3 = %0d",
                     dut.r.regs[3]);
        else
            $display("ADD FAIL: x3 = %0d, expected 22",
                     dut.r.regs[3]);

        @(posedge clk);
        #1;

        if (dut.r.regs[4] == 32'd18)
            $display("SUB PASS: x4 = %0d",
                     dut.r.regs[4]);
        else
            $display("SUB FAIL: x4 = %0d, expected 18",
                     dut.r.regs[4]);

        @(posedge clk);
        #1;

        if (dut.r.regs[5] == 32'd0)
            $display("AND PASS: x5 = %0d",
                     dut.r.regs[5]);
        else
            $display("AND FAIL: x5 = %0d, expected 0",
                     dut.r.regs[5]);

        @(posedge clk);
        #1;

        if (dut.r.regs[6] == 32'd22)
            $display("OR PASS: x6 = %0d",
                     dut.r.regs[6]);
        else
            $display("OR FAIL: x6 = %0d, expected 22",
                     dut.r.regs[6]);

        @(posedge clk);
        #1;

        if (dut.r.regs[7] == 32'd80)
            $display("SLL PASS: x7 = %0d",
                     dut.r.regs[7]);
        else
            $display("SLL FAIL: x7 = %0d, expected 80",
                     dut.r.regs[7]);

        @(posedge clk);
        #1;

        if (dut.r.regs[8] == 32'd5)
            $display("SRL PASS: x8 = %0d",
                     dut.r.regs[8]);
        else
            $display("SRL FAIL: x8 = %0d, expected 5",
                     dut.r.regs[8]);

        $display("");
        $display("============================");
        $display("R-TYPE DATAPATH TEST FINISHED");
        $display("============================");

        $finish;

    end

endmodule
