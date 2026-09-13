module pc (
    input  logic        clk,
    input  logic        rst,
    input  logic        pc_sel,
    input  logic [31:0] immediate,
    output logic [31:0] pc
);

logic [31:0] bta;
assign bta = pc + immediate;
always_ff @(posedge clk or posedge rst) begin
    if (rst)
        pc <= 32'd0;
    else
        pc <= pc_sel ? bta : (pc + 32'd4);
end

endmodule