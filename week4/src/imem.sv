module imem(
input  logic [31:0] addr,
output logic [31:0] inst
);

logic [31:0] memory [0:255];
initial begin
    $readmemh("program.hex", memory);
end
assign inst = memory[addr[9:2]];
endmodule