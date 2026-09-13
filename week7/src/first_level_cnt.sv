module first_level_controller(
input logic [6:0] opcode,
input logic branch_taken,
output logic [1:0] ALUOP,
output logic RegWEn,
output logic a_sel,
output logic b_sel,
output logic Mem_RW,
output logic wb_sel,
output logic pc_sel
);
always_comb begin
    ALUOP  = 2'b00;
    RegWEn = 1'b0;
    a_sel = 1'b0;
    b_sel  = 1'b0;
    Mem_RW = 1'b0;
    wb_sel = 1'b0;
    pc_sel = 1'b0;

        case(opcode)
        7'b0110011: begin
            ALUOP  = 2'b00;
            RegWEn = 1'b1; 
            a_sel  = 1'b0;
            b_sel  = 1'b0; 
            Mem_RW = 1'b0;
            wb_sel = 1'b0; 
            pc_sel = 1'b0;
 
        end
        7'b0010011: begin //I type alu
            ALUOP  = 2'b01;
            RegWEn = 1'b1;
            a_sel  = 1'b0;
            b_sel  = 1'b1; 
            Mem_RW = 1'b0;
            wb_sel = 1'b0;
            pc_sel = 1'b0;
        end
        7'b0000011: begin // lw (Load Word)
            ALUOP  = 2'b01;
            RegWEn = 1'b1;
            a_sel  = 1'b0;
            b_sel  = 1'b1;
            Mem_RW = 1'b0;
            wb_sel = 1'b1;
            pc_sel = 1'b0;
        end
        7'b0100011:begin
            ALUOP = 2'b01;// sw
            RegWEn = 1'b0;
            a_sel  = 1'b0;
            b_sel  = 1'b1;
            Mem_RW = 1'b1;
            wb_sel = 1'b0; 
            pc_sel = 1'b0;
        end
        7'b1100011:begin
            ALUOP = 2'b10; //branch
            RegWEn = 1'b0;
            a_sel  = 1'b0;
            b_sel  = 1'b0;
            Mem_RW = 1'b0;
            wb_sel = 1'b0;
            pc_sel = branch_taken; 
        end
        7'b1101111:begin
            ALUOP = 2'b11; //jal
            RegWEn = 1'b1;
            a_sel  = 1'b1;
            b_sel  = 1'b0;
            Mem_RW = 1'b0;
            wb_sel = 1'b0;
            pc_sel = 1'b1;
        end
        default:ALUOP = 'x;
    endcase
end

endmodule