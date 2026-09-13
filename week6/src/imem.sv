module imem (
    input  logic [31:0] addr,
    output logic [31:0] inst
);
    logic [31:0] memory [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'h0000006F;

        memory[0] = 32'h008000EF; // PC 0:  jal x1, +8
        memory[1] = 32'h0000006F; // PC 4:  skipped
        memory[2] = 32'h0080016F; // PC 8:  jal x2, +8
        memory[3] = 32'h0000006F; // PC 12: skipped
        memory[4] = 32'hFF9FF1EF; // PC 16: jal x3, -8
    end
    assign inst = memory[addr[9:2]];
endmodule