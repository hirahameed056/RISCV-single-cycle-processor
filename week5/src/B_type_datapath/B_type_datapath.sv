module b_type_datapath(
input logic clk,
input logic rst,
output logic[31:0] alu_result
);
logic [6:0] opcode;
logic [2:0] func3;
logic [4:0] rs1, rs2, rd;
logic [31:0] pc_out;
logic [31:0] inst;
logic pc_sel;

logic [31:0] immediate;


imm_gen u_imm_gen (
    .instruction (inst),
    .immediate   (immediate)
);


pc u_pc (
    .clk (clk),
    .rst (rst),
    .pc_sel(pc_sel),
    .immediate(immediate),
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


logic [1:0] alu_op;
logic b_sel;
logic RegWEn;
logic Mem_RW;

first_level_controller c1(
    .opcode(opcode),
    .ALUOP(alu_op),
    .RegWEn(RegWEn),
    .b_sel(b_sel),
    .Mem_RW(Mem_RW)
);

logic [3:0]alu_operation;
alu_2nd_controller c2(
    .func3(func3),
    .func7(7'b0),
    .ALUOP(alu_op),
    .alu_operation(alu_operation)
);


logic [31:0] rdata1;
logic [31:0] rdata2;
Reg_file r(
    .clk(clk),
    .RegWEn(RegWEn),
    .rs1(rs1),
    .rs2(rs2),
    .rd (5'd0),
    .wdata  (32'd0),
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


always_comb begin
    pc_sel = 1'b0;

    if (opcode == 7'b1100011) begin
        case (func3)
            3'b000: pc_sel = zero;          // BEQ
            3'b100: pc_sel = alu_result[0]; // BLT
            3'b101: pc_sel = ~alu_result[0];// BGE
            default: pc_sel = 1'b0;
        endcase
    end
end


endmodule