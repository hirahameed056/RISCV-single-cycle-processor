module j_type_datapath(
input logic clk,
input logic rst
);

logic [6:0] opcode;
logic [4:0] rd;
logic [31:0] pc_out;
logic [31:0] inst;
logic [31:0] immediate;


imm_gen u_imm_gen (
    .instruction (inst),
    .immediate   (immediate)
);
pc u_pc (
    .clk (clk),
    .rst (rst),
    .immediate(immediate),
    .pc  (pc_out)
);

imem u_imem (
    .addr (pc_out),
    .inst (inst)
);

assign rd = inst[11:7];
assign opcode = inst[6:0];
logic RegWEn;
assign RegWEn = (opcode == 7'b1101111);


Reg_file r(
    .clk(clk),
    .RegWEn(RegWEn),
    .rs1(5'd0),
    .rs2(5'd0),
    .rd (rd),
    .wdata  (pc_out + 32'd4),
    .rdata1 (),
    .rdata2 ()
);
endmodule