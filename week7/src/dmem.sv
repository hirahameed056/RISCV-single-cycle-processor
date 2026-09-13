module dmem (
    input  logic        clk,
    input  logic        Mem_RW,
    input  logic [31:0] addr,
    input  logic [31:0] w_data,
    output logic [31:0] rdata
);

    logic [31:0] memory [0:511];

    assign rdata = memory[addr[10:2]];

    always_ff @(posedge clk) begin
        if (Mem_RW)
            memory[addr[10:2]] <= w_data;
    end

endmodule