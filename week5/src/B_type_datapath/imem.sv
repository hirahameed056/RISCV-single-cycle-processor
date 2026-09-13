module imem (
    input  logic [31:0] addr,
    output logic [31:0] inst
);
logic [31:0] memory [0:255];
integer i;
initial begin
    for (i = 0; i < 256; i = i + 1)
        memory[i] = 32'h00000013;

    memory[0] = 32'h00208463; 
    memory[1] = 32'h00000013; 
    memory[2] = 32'h00308463; 
    memory[3] = 32'h0041c463; 
    memory[4] = 32'h00000013;
    memory[5] = 32'h00324463; 
    memory[6] = 32'h00325463; 
    memory[7] = 32'h00000013;
    memory[8] = 32'h0041d463; 
    memory[9] = 32'h00000063; 

end
assign inst = memory[addr[9:2]];
endmodule