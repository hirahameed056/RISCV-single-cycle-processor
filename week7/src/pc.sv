module pc (
    input  logic        clk,
    input  logic        rst,
    input  logic        pc_sel,
    input  logic [31:0] immediate,

    output logic [31:0] pc,
    output logic [31:0] pc_4
);

    logic [31:0] target_address;
    logic [31:0] pc_next;

    assign pc_4 = pc + 32'd4;
    assign target_address = pc + immediate;
    assign pc_next = pc_sel ? target_address : pc_4;


    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'd0;
        else
            pc <= pc_next;
    end

endmodule