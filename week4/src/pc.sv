module pc(
input logic clk,
input logic rst,
output logic [31:0] pc
);
always_ff @(posedge clk or posedge rst) begin
    if(rst)
        pc <= 32'd0;
    else
        pc <= pc + 32'd4;
end
endmodule