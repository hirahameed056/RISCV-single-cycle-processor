module b_type_datapath_tb;
logic clk;
logic rst;
logic [31:0] alu_result;

b_type_datapath dut (
    .clk(clk),
    .rst(rst),
    .alu_result(alu_result)
);
always #5 clk = ~clk;
initial begin

    clk = 0;
    rst = 1;
    dut.r.regs[1] = 5;  
    dut.r.regs[2] = 5; 
    dut.r.regs[3] = 3; 
    dut.r.regs[4] = 8;  
    #10;
    rst = 0;
    #100;

    $finish;

end
initial begin
    $monitor(
        "Time=%0t  PC=%0d  rs1=%0d  rs2=%0d  pc_sel=%b",
        $time,
        dut.pc_out,
        dut.rdata1,
        dut.rdata2,
        dut.pc_sel
    );
end
endmodule