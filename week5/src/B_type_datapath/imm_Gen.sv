module imm_gen(
input logic [31:0] instruction,
output logic [31:0] immediate
);
always_comb begin 
    immediate = 32'b0000000;
    case(instruction[6:0])
        7'b0000011,
        7'b0010011,
        7'b1100111:begin
        immediate = {{20{instruction[31]}}, instruction[31:20]};//   I type
        end
    
        7'b0100011:begin//S type
            immediate = { {20{instruction[31]}},
                        instruction[31:25],
                        instruction[11:7]
            };
        end
        7'b1100011:begin //B type
           immediate = { {19{instruction[31]}}, 
            instruction[31]//imm12
            ,instruction[7],//imm11
            instruction[30:25],// imm[10:5]
            instruction[11:8],//
            1'b0
           };
        end
        7'b0110111,
        7'b0010111: begin
            immediate = { //u-type
            instruction[31:12],
            12'b0
        };
            end
        7'b1101111: begin
    immediate = {
        {11{instruction[31]}}, 
        instruction[31],       // imm[20]
        instruction[19:12],    // imm[19:12]
        instruction[20],       // imm[11]
        instruction[30:21],    // imm[10:1]
        1'b0                   // imm[0]
    };
end
    default: begin
        immediate = 'x;
            end
endcase
end
endmodule