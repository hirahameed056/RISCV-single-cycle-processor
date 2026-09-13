module cnt_tb;

    logic [6:0]  opcode;
    logic [2:0]  func3;
    logic [6:0]  func7;
    logic [1:0]  alu_op_signal;
    logic [3:0]  alu_operation;
    logic [31:0] operand1, operand2;
    logic        zero, negative;
    logic [31:0] result;

    first_level_controller u1 (.opcode(opcode), .ALUOP(alu_op_signal));

    alu_2nd_controller u2 (.func3(func3), .func7(func7), .ALUOP(alu_op_signal), .alu_operation(alu_operation));

    alu u3 (.operand1(operand1), .operand2(operand2), .alu_op(alu_operation),
            .zero(zero), .negative(negative), .result(result));

    initial begin
        // Test 1: ADD 
        opcode = 7'b0110011; func3 = 3'b000; func7 = 7'b0000000;
        operand1 = 15; operand2 = 10;
        #1;
        if (result == 25) $display("Test 1 ADD: PASS (result=%0d)", result);
        else $display("Test 1 ADD: FAIL (result=%0d, expected 25)", result);

        // Test 2: SUB 
        opcode = 7'b0110011; func3 = 3'b000; func7 = 7'b0100000;
        operand1 = 15; operand2 = 10;
        #1;
        if (result == 5) $display("Test 2 SUB: PASS (result=%0d)", result);
        else $display("Test 2 SUB: FAIL (result=%0d, expected 5)", result);

        //  Test 3: AND
        opcode = 7'b0110011; func3 = 3'b111; func7 = 7'b0000000;
        operand1 = 32'hFF00FF00; operand2 = 32'h0F0F0F0F;
        #1;
        if (result == 32'h0F000F00) $display("Test 3 AND: PASS (result=%h)", result);
        else $display("Test 3 AND: FAIL (result=%h, expected 0F000F00)", result);

        //  Test 4: or
        opcode = 7'b0110011; func3 = 3'b110; func7 = 7'b0000000;
        operand1 = 32'hFF00FF00; operand2 = 32'h0F0F0F0F;
        #1;
        if (result == 32'hFF0FFF0F) $display("Test 4 OR: PASS (result=%h)", result);
        else $display("Test 4 OR: FAIL (result=%h, expected FF0FFF0F)", result);

        // Test 5: ADDI
        opcode = 7'b0010011; func3 = 3'b000; func7 = 7'b0;
        operand1 = 100; operand2 = 20;
        #1;
        if (result == 120) $display("Test 5 ADDI: PASS (result=%0d)", result);
        else $display("Test 5 ADDI: FAIL (result=%0d, expected 120)", result);
        //Test6:
         // Test 6: BEQ (equal operands -> branch should be taken)
        // ALU does SUB; branch is taken when zero flag == 1
        opcode = 7'b1100011; func3 = 3'b000; func7 = 7'b0;
        operand1 = 15; operand2 = 15;
        #1;
        if (alu_op_signal == 2'b10 && zero == 1'b1)
            $display("Test 6 BEQ (equal): PASS (result=%0d, zero=%b -> branch taken)", result, zero);
        else
            $display("Test 6 BEQ (equal): FAIL (result=%0d, zero=%b, ALUOp=%b)", result, zero, alu_op_signal);
 
        // Test 7: BEQ (unequal operands -> branch should NOT be taken)
        opcode = 7'b1100011; func3 = 3'b000; func7 = 7'b0;
        operand1 = 15; operand2 = 20;
        #1;
        if (zero == 1'b0)
            $display("Test 7 BEQ (not equal): PASS (result=%0d, zero=%b -> branch not taken)", result, zero);
        else
            $display("Test 7 BEQ (not equal): FAIL (result=%0d, zero=%b)", result, zero);
 
        // Test 8: BGE (rs1 >= rs2 -> branch should be taken, i.e. SLT result == 0)
        opcode = 7'b1100011; func3 = 3'b101; func7 = 7'b0;
        operand1 = 20; operand2 = 10;
        #1;
        if (alu_op_signal == 2'b10 && result == 0)
            $display("Test 8 BGE (20>=10): PASS (result=%0d -> branch taken)", result);
        else
            $display("Test 8 BGE (20>=10): FAIL (result=%0d, ALUOp=%b)", result, alu_op_signal);
 
        // Test 9: BLT (rs1 < rs2 -> branch should be taken, i.e. SLT result == 1)
        opcode = 7'b1100011; func3 = 3'b100; func7 = 7'b0;
        operand1 = 5; operand2 = 10;
        #1;
        if (alu_op_signal == 2'b10 && result == 1)
            $display("Test 9 BLT (5<10): PASS (result=%0d -> branch taken)", result);
        else
            $display("Test 9 BLT (5<10): FAIL (result=%0d, ALUOp=%b)", result, alu_op_signal);
 
        // Test 10: JAL
        opcode = 7'b1101111; func3 = 3'b000; func7 = 7'b0;
        operand1 = 0; operand2 = 0;
        #1;
        if (alu_op_signal == 2'b11) $display("Test 10 JAL: PASS (ALUOp=%b)", alu_op_signal);
        else $display("Test 10 JAL: FAIL (ALUOp=%b, expected 11)", alu_op_signal);
 
        $finish;
    end
 
endmodule
