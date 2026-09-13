module first_level_controller(
input logic [6:0] opcode,
output logic [1:0] ALUOP
);
always_comb begin
    case(opcode)
        7'b0110011:ALUOP = 2'b00; //R_type
        7'b0010011:ALUOP = 2'b01; //I_type
        7'b0000011:ALUOP = 2'b01; // lw
        7'b0100011:ALUOP = 2'b01; // sw
        7'b1100011:ALUOP = 2'b10; //branch
        7'b1101111:ALUOP = 2'b11; //jal
        default:ALUOP = 'x;
    endcase
end

endmodule