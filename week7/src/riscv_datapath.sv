module riscv_datapath(
input logic clk,
input logic rst
);

logic [6:0] opcode;
logic [2:0] func3;
logic [6:0] func7;
logic [4:0] rs1, rs2, rd;
logic [31:0] inst;
 
logic [31:0] operand_b;
logic [31:0] immediate;
logic [31:0] pc_out;
logic [31:0] pc_4;
logic pc_sel;


pc u_pc (
    .clk       (clk),
    .rst       (rst),
    .pc_sel    (pc_sel),
    .immediate (immediate),
    .pc        (pc_out),
    .pc_4      (pc_4)
);


imem u_imem (
    .addr (pc_out),
    .inst (inst)
);

assign opcode = inst[6:0];
assign rd     = inst[11:7];
assign func3  = inst[14:12];
assign rs1    = inst[19:15];
assign rs2    = inst[24:20];
assign func7  = inst[31:25];


logic [1:0] alu_op;
logic [31:0] wb;
logic b_sel;
logic RegWEn;
logic Mem_RW;
logic wb_sel;
logic a_sel;
logic branch_taken;

first_level_controller c1(
    .opcode(opcode),
    .branch_taken(branch_taken),
    .ALUOP(alu_op),
    .RegWEn(RegWEn),
    .b_sel(b_sel),
    .Mem_RW(Mem_RW),
    .wb_sel(wb_sel),
    .pc_sel(pc_sel),
    .a_sel(a_sel)
);


logic [3:0]alu_operation;
alu_2nd_controller c2(
    .func3(func3),
    .func7(func7),
    .ALUOP(alu_op),
    .alu_operation(alu_operation)
);

logic [31:0] rdata1;
logic [31:0] rdata2;
logic [31:0] reg_data;
assign reg_data = a_sel ? pc_4 : wb;


Reg_file r(
    .clk(clk),
    .RegWEn(RegWEn),
    .rs1(rs1),
    .rs2(rs2),
    .rd (rd),
    .wdata  (reg_data),
    .rdata1 (rdata1),
    .rdata2 (rdata2)
);



assign operand_b = b_sel? immediate : rdata2;
imm_gen imm(
    .instruction(inst),
    .immediate(immediate)
);

logic zero;
logic negative;
logic [31:0] alu_result;

alu alu (
    .operand1 (rdata1),
    .operand2 (operand_b),
    .alu_op   (alu_operation),
    .zero     (zero),
    .negative (negative),
    .result   (alu_result)
);

always_comb begin
        case (func3)
            3'b000:  branch_taken = zero;                 // BEQ
            3'b101:  branch_taken = ~alu_result[0];       // BGE
            3'b100:  branch_taken = alu_result[0];        // BLT
            default: branch_taken = 1'b0;
        endcase
    end

logic [31:0] mem;
assign wb =  wb_sel ? mem:alu_result;

dmem d(.clk(clk),
       .addr(alu_result),
       .w_data(rdata2),
       .Mem_RW(Mem_RW),
       .rdata(mem)
);

endmodule
