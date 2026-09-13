module first_level_controller(
input logic [6:0] opcode,
output logic [1:0] ALUOP,
output logic RegWEn,
output logic b_sel,
output logic Mem_RW,
output logic wb_Sel
);
always_comb begin
    ALUOP  = 2'b00;
    RegWEn = 1'b0;
    b_sel  = 1'b0;
    Mem_RW = 1'b0;
    wb_Sel = 1'b0;

        case(opcode)
        7'b0110011: begin
            ALUOP  = 2'b00;
            RegWEn = 1'b1; 
            b_sel  = 1'b0; 
            Mem_RW = 1'b0;
            wb_Sel = 1'b0; 
        end
        7'b0010011: begin //I type alu
            ALUOP  = 2'b01;
            RegWEn = 1'b1;
            b_sel  = 1'b1; 
            Mem_RW = 1'b0;
            wb_Sel = 1'b0;
        end
        7'b0000011: begin // lw (Load Word)
            ALUOP  = 2'b01;
            RegWEn = 1'b1;
            b_sel  = 1'b1;
            Mem_RW = 1'b0;
            wb_Sel = 1'b1; 
        end
        7'b0100011:ALUOP = 2'b01; // sw
        7'b1100011:ALUOP = 2'b10; //branch
        7'b1101111:ALUOP = 2'b11; //jal
        default:ALUOP = 'x;
    endcase
end

endmodule