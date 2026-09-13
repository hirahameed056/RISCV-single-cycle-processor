module dmem (
    input  logic        clk,
    input  logic        Mem_RW,
    input  logic [31:0] addr,
    input  logic [31:0] w_data,
    output logic [31:0] rdata
);
    logic [31:0] memory [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'b0;
    end
    assign rdata = memory[addr[9:2]];
    always @(posedge clk) begin
        if (Mem_RW)
            memory[addr[9:2]] <= w_data;
    end

endmodule