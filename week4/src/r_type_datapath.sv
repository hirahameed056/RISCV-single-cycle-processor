module r_type_datapath(
input logic clk,
input logic rst
);
logic [6:0] opcode;
logic [2:0] func3;
logic [6:0] func7;
logic [4:0] rs1, rs2, rd;
logic [31:0] pc_out;
logic [31:0] inst;
 
pc u_pc (
    .clk (clk),
    .rst (rst),
    .pc  (pc_out)
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
logic b_sel;
logic RegWEn;
logic Mem_RW;
logic wb_Sel;


first_level_controller c1(
    .opcode(opcode),
    .ALUOP(alu_op),
    .RegWEn(RegWEn),
    .b_sel(b_sel),
    .Mem_RW(Mem_RW),
    .wb_Sel(wb_Sel)
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
logic [31:0] alu_result;

Reg_file r(
    .clk(clk),
    .RegWEn(RegWEn),
    .rs1(rs1),
    .rs2(rs2),
    .rd (rd),
    .wdata  (alu_result),
    .rdata1 (rdata1),
    .rdata2 (rdata2)
);


logic zero;
logic negative;
    alu alu (
        .operand1 (rdata1),
        .operand2 (rdata2),
        .alu_op   (alu_operation),
        .zero     (zero),
        .negative (negative),
        .result   (alu_result)
    );
endmodule