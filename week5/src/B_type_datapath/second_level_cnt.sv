module alu_2nd_controller(
input logic [2:0] func3,
input logic [6:0] func7,
input logic [1:0] ALUOP,
output logic [3:0] alu_operation
);
    localparam logic [3:0] add = 4'b0000;
    localparam logic [3:0] sub = 4'b0001;
    localparam logic [3:0] sll = 4'b0010;
    localparam logic [3:0] blt = 4'b0011;   // SLT code, reused for blt/bge
    localparam logic [3:0] srl = 4'b0110;
    localparam logic [3:0] orr = 4'b1000;
    localparam logic [3:0] And = 4'b1001;
    localparam logic [3:0] beq = sub;       
    localparam logic [3:0] bge = blt;       
    localparam logic [3:0] jal = add;     
    localparam logic [3:0] addi = add;
    localparam logic [3:0] andi = And;
    localparam logic [3:0] ori  = orr;
    localparam logic [3:0] slli = sll;
    localparam logic [3:0] srli = srl;
    localparam logic [3:0] lw   = add;


always_comb begin
 alu_operation = add;

        case (ALUOP)
            2'b00: begin
                case (func3) 
                    3'b000: begin
                        if (func7 == 7'b0000000)
                            alu_operation = add;
                        else if (func7 == 7'b0100000)    
                           alu_operation = sub;
                        else
                            alu_operation = add;
                    end
                    3'b111:alu_operation = And;
                    3'b110:alu_operation = orr;
                    3'b001:alu_operation = sll;
                    3'b101:alu_operation = srl;
                    default : alu_operation = add;
                endcase
            end 

            2'b01:begin
                case(func3)  
                    3'b000:alu_operation = addi;
                    3'b111:alu_operation = andi;
                    3'b110:alu_operation = ori;
                    3'b001:alu_operation = slli;
                    3'b101:alu_operation = srli;
                    3'b010:alu_operation = lw;
                   
                    default: alu_operation = addi;
                endcase
            end
            2'b10:begin
                case (func3)
                    3'b000: alu_operation = beq;
                    3'b101: alu_operation = bge;
                    3'b100: alu_operation = blt;
                    default: alu_operation = beq;
                endcase
            end
            2'b11:begin
            alu_operation = jal;
            end
            default:begin
                alu_operation = 'x;
            end
        endcase
end
endmodule
 
