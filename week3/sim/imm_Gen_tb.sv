module imm_gen_tb;
logic [31:0] instruction;
logic [31:0] immediate;
logic [31:0] expected;

int unsigned seed;
integer errors;

imm_gen dut (
    .instruction(instruction),
    .immediate(immediate)
);
    initial begin
        seed = 32'h12345678;
        void'($urandom(seed));

        errors = 0;
        // I-Type positive
        instruction = $urandom;
        instruction[6:0] = 7'b0010011;
        instruction[31]  = 1'b0;
        expected = {
            {20{instruction[31]}},
            instruction[31:20]
        };
        #1;
        if (immediate !== expected) begin
            errors = errors + 1;
            $display("I-Type positive FAILED");
        end
        else
            $display("I-Type positive PASSED: %h", immediate);


        // I-Type negative
        instruction = $urandom;
        instruction[6:0] = 7'b0010011;
        instruction[31]  = 1'b1;

        expected = {
            {20{instruction[31]}},
            instruction[31:20]
        };
        #1;
        if (immediate !== expected) begin
            errors = errors + 1;
            $display("I-Type negative FAILED");
        end
        else
            $display("I-Type negative PASSED: %h", immediate);
        // S-Type positive
        instruction = $urandom;
        instruction[6:0] = 7'b0100011;
        instruction[31]  = 1'b0;

        expected = {
            {20{instruction[31]}},
            instruction[31:25],
            instruction[11:7]
        };
        #1;

        if (immediate !== expected) begin
            errors = errors + 1;
            $display("S-Type positive FAILED");
        end
        else
            $display("S-Type positive PASSED: %h", immediate);


        // S-Type negative
        instruction = $urandom;
        instruction[6:0] = 7'b0100011;
        instruction[31]  = 1'b1;

        expected = {
            {20{instruction[31]}},
            instruction[31:25],
            instruction[11:7]
        };

        #1;

        if (immediate !== expected) begin
            errors = errors + 1;
            $display("S-Type negative FAILED");
        end
        else
            $display("S-Type negative PASSED: %h", immediate);

        // B-Type positive
        instruction = $urandom;
        instruction[6:0] = 7'b1100011;
        instruction[31]  = 1'b0;

        expected = {
            {19{instruction[31]}},
            instruction[31],
            instruction[7],
            instruction[30:25],
            instruction[11:8],
            1'b0
        };

        #1;

        if (immediate !== expected) begin
            errors = errors + 1;
            $display("B-Type positive FAILED");
        end
        else
            $display("B-Type positive PASSED: %h", immediate);


        // B-Type negative
        instruction = $urandom;
        instruction[6:0] = 7'b1100011;
        instruction[31]  = 1'b1;

        expected = {
            {19{instruction[31]}},
            instruction[31],
            instruction[7],
            instruction[30:25],
            instruction[11:8],
            1'b0
        };
        #1;

        if (immediate !== expected) begin
            errors = errors + 1;
            $display("B-Type negative FAILED");
        end
        else
            $display("B-Type negative PASSED: %h", immediate);

        // U-Type random test
        instruction = $urandom;
        instruction[6:0] = 7'b0110111;

        expected = {
            instruction[31:12],
            12'b0
        };

        #1;

        if (immediate !== expected) begin
            errors = errors + 1;
            $display("U-Type FAILED");
        end
        else
            $display("U-Type PASSED: %h", immediate);

        // J-Type positive
        instruction = $urandom;
        instruction[6:0] = 7'b1101111;
        instruction[31]  = 1'b0;

        expected = {
            {11{instruction[31]}},
            instruction[31],
            instruction[19:12],
            instruction[20],
            instruction[30:21],
            1'b0
        };
        #1;

        if (immediate !== expected) begin
            errors = errors + 1;
            $display("J-Type positive FAILED");
        end
        else
            $display("J-Type positive PASSED: %h", immediate);


        // J-Type negative
        instruction = $urandom;
        instruction[6:0] = 7'b1101111;
        instruction[31]  = 1'b1;

        expected = {
            {11{instruction[31]}},
            instruction[31],
            instruction[19:12],
            instruction[20],
            instruction[30:21],
            1'b0
        };

        #1;

        if (immediate !== expected) begin
            errors = errors + 1;
            $display("J-Type negative FAILED");
        end
        else
            $display("J-Type negative PASSED: %h", immediate);


        if (errors == 0)
            $display("ALL RANDOM TESTS PASSED");
        else
            $display("%0d TESTS FAILED", errors);

        $finish;

    end

endmodule