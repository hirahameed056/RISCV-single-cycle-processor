module Itype_datapath_tb;

    logic clk;
    logic rst;
    logic [31:0] alu_result;

    Itype_datapath uut (
        .clk        (clk),
        .rst        (rst),
        .alu_result (alu_result)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b1;

        repeat (2) @(posedge clk);
        @(negedge clk);
        rst = 1'b0;

        //x1 = 20 and x2 = 2
        uut.r.regs[1] = 32'd20;
        uut.r.regs[2] = 32'd2;

        // R-TYPE TESTS

        @(posedge clk);
        #1;
        if (uut.r.regs[3] == 32'd22)
            $display("ADD PASS");
        else
            $display("ADD FAIL: got %0d", uut.r.regs[3]);

        @(posedge clk);
        #1;
        if (uut.r.regs[4] == 32'd18)
            $display("SUB PASS");
        else
            $display("SUB FAIL: got %0d", uut.r.regs[4]);

        @(posedge clk);
        #1;
        if (uut.r.regs[5] == 32'd0)
            $display("AND PASS");
        else
            $display("AND FAIL: got %0d", uut.r.regs[5]);

        @(posedge clk);
        #1;
        if (uut.r.regs[6] == 32'd22)
            $display("OR PASS");
        else
            $display("OR FAIL: got %0d", uut.r.regs[6]);

        @(posedge clk);
        #1;
        if (uut.r.regs[7] == 32'd80)
            $display("SLL PASS");
        else
            $display("SLL FAIL: got %0d", uut.r.regs[7]);

        @(posedge clk);
        #1;
        if (uut.r.regs[8] == 32'd5)
            $display("SRL PASS");
        else
            $display("SRL FAIL: got %0d", uut.r.regs[8]);
        // I-TYPE TEST
        @(posedge clk);
        #1;
        if (uut.r.regs[9] == 32'd25)
            $display("ADDI PASS");
        else
            $display("ADDI FAIL: got %0d", uut.r.regs[9]);

        @(posedge clk);
        #1;
        if (uut.r.regs[10] == 32'd4)
            $display("ANDI PASS");
        else
            $display("ANDI FAIL: got %0d", uut.r.regs[10]);

        @(posedge clk);
        #1;
        if (uut.r.regs[11] == 32'd10)
            $display("ORI PASS");
        else
            $display("ORI FAIL: got %0d", uut.r.regs[11]);

        @(posedge clk);
        #1;
        if (uut.r.regs[12] == 32'd16)
            $display("SLLI PASS");
        else
            $display("SLLI FAIL: got %0d", uut.r.regs[12]);

        @(posedge clk);
        #1;
        if (uut.r.regs[13] == 32'd5)
            $display("SRLI PASS");
        else
            $display("SRLI FAIL: got %0d", uut.r.regs[13]);

        $display("R/I DATAPATH TEST COMPLETED");

        $finish;
    end

endmodule