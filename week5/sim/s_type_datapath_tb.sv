`timescale 1ns/1ps

module s_type_datapath_tb;

logic clk;
logic rst;
logic [31:0] alu_result;

s_type_datapath dut (
    .clk        (clk),
    .rst        (rst),
    .alu_result (alu_result)
);
always #5 clk = ~clk;
initial begin
    clk = 0;
    rst = 1;

    dut.r.regs[1] = 32'd100;       
    dut.r.regs[2] = 32'h12345678;  
    dut.r.regs[3] = 32'hABCDEF01;  
    dut.r.regs[4] = 32'h5555AAAA;  
    #10;
    rst = 0;
    #35;

    $display("\n----- SW TEST RESULTS -----");
    if (dut.d.memory[25] == 32'h12345678)
        $display("Test 1 PASS: memory[25] = %h",
                 dut.d.memory[25]);
    else
        $display("Test 1 FAIL: memory[25] = %h",
                 dut.d.memory[25]);

    if (dut.d.memory[27] == 32'hABCDEF01)
        $display("Test 2 PASS: memory[27] = %h",
                 dut.d.memory[27]);
    else
        $display("Test 2 FAIL: memory[27] = %h",
                 dut.d.memory[27]);


    if (dut.d.memory[24] == 32'h5555AAAA)
        $display("Test 3 PASS: memory[24] = %h",
                 dut.d.memory[24]);
    else
        $display("Test 3 FAIL: memory[24] = %h",
                 dut.d.memory[24]);

    $display("---------------------------\n");

    $finish;
end

always @(posedge clk) begin
    if (!rst) begin
        $display(
            "PC=%0d  Immediate=%0d  Address=%0d  Data=%h",
            dut.pc_out,
            $signed(dut.immediate),
            dut.alu_result,
            dut.rdata2
        );
    end
end

endmodule