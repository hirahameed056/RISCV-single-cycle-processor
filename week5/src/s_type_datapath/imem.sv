module imem(
input  logic [31:0] addr,
output logic [31:0] inst
);

logic [31:0] memory [0:255];
initial begin
    memory[0] = 32'h0020A023; 
    memory[1] = 32'h0030A423; 
    memory[2] = 32'hFE40AE23; 
end
assign inst = memory[addr[9:2]];
endmodule