module alu(
input logic [31:0] operand1,
input logic [31:0] operand2,
input logic [3:0] alu_op,
output logic zero,
output logic negative,
output logic [31:0] result
);
always_comb begin
    case(alu_op)
    4'b0000:result = operand1 + operand2; //add
    4'b0001:result = operand1 - operand2;//sub
    4'b0010:result = operand1 << operand2[4:0];//sll
    4'b0011:result = {31'b0,$signed(operand1) < $signed(operand2)};//slt
    4'b0100:result = {31'b0,(operand1 < operand2)};//sltu
    4'b0101:result = operand1 ^ operand2;//xor
    4'b0110:result = operand1 >> operand2[4:0];//srl
    4'b0111:result = $signed(operand1) >>> operand2[4:0];//sra
    4'b1000:result = operand1 | operand2;//or
    4'b1001:result = operand1 & operand2;//and
    default: result = 'x;
endcase
end
 assign zero = (result == 32'b0);
 assign negative = result[31];
endmodule