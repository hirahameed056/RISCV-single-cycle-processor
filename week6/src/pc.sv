module pc (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] immediate,
    output logic [31:0] pc
);

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        pc <= 32'd0;
    else
        pc <= pc + immediate;
end

endmodule