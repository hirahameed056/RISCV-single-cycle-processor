module single_cycle_proc_tb_auto();

logic clk;
logic rst;
logic [31:0] pc_next, pc_out, instr, imm_out, rdata1, rdata2, alu_op1, alu_op2, alu_result, wdata;
logic [4:0] rd;
logic branch, regwrite, memread, memwrite;
logic [31:0] expected_regfile [0:31];
logic [31:0] expected_regfile_after_branch [0:31];
logic [31:0] actual_regfile [0:31];
logic [31:0] expected_dmem [0:511];
logic [31:0] actual_dmem [0:511];

//############################ Modify ############################
riscv_datapath uut (.clk(clk), .rst(rst));

assign pc_next     = uut.u_pc.pc_next;
assign pc_out      = uut.pc_out;
assign instr       = uut.inst;
assign imm_out     = uut.immediate;
assign rdata1      = uut.rdata1;
assign rdata2      = uut.rdata2;
assign alu_op1     = uut.rdata1;
assign alu_op2     = uut.operand_b;
assign alu_result  = uut.alu_result;
assign wdata       = uut.reg_data;
assign rd          = uut.rd;
assign regwrite    = uut.RegWEn;
assign branch      = (uut.opcode == 7'b1100011);
assign memread     = (uut.opcode == 7'b0000011);
assign memwrite    = uut.Mem_RW;

task test_memory();
    $readmemh("Single Cycle Contents/Reg File/RegFileContentsSingleCycle - Expected.txt", expected_regfile);
    $readmemh("Single Cycle Contents/Dmem/DataMemoryContents - Expected.txt", expected_dmem);
    actual_regfile = uut.r.regs;
    actual_dmem    = uut.d.memory;

    assert(actual_regfile == expected_regfile) else begin
        $display("RegFile contents are wrong.");
        $display("Expected contents = %p", expected_regfile);
        $display("Actual contents   = %p", actual_regfile);
        //$stop;
    end

    assert(actual_dmem == expected_dmem) else begin
        $display("DMEM contents are wrong.");
        $display("Expected contents = %p", expected_dmem);
        $display("Actual contents   = %p", actual_dmem);
        //$stop;
    end

endtask

task test_memory_after_branch();
    $readmemh("Single Cycle Contents/Reg File/RegFileContentsSingleCycleAfterBranchTest - Expected.txt", expected_regfile_after_branch);
    $readmemh("Single Cycle Contents/Dmem/DataMemoryContents - Expected.txt", expected_dmem);
    actual_regfile = uut.r.regs;
    actual_dmem    = uut.d.memory;

    assert(actual_regfile == expected_regfile_after_branch) else begin
        $display("RegFile contents are wrong.");
        $display("Expected contents = %p", expected_regfile_after_branch);
        $display("Actual contents   = %p", actual_regfile);
        //$stop;
    end

    assert(actual_dmem == expected_dmem) else begin
        $display("DMEM contents are wrong.");
        $display("Expected contents = %p", expected_dmem);
        $display("Actual contents   = %p", actual_dmem);
        //$stop;
    end
endtask


task reset();
    rst = 1;
    #2;
    rst = 0;
endtask

task test(logic [31:0] pc_nx, pc_ot, inst, imm_ot, rdat1, rdat2, alu_o1, alu_o2, alu_rslt, wdat,
               logic [4:0] rdest,
               logic brch, regwrt, memrd, memwrt);

    assert(pc_next == pc_nx) else begin
        $display("next pc address is wrong");
        $display("Expected value = %h", pc_nx);
        $display("Actual value   = %h", pc_next);
        //$stop;
    end

    assert(pc_out == pc_ot) else begin
        $display("output of PC is wrong.");
        $display("Expected value = %h", pc_ot);
        $display("Actual value   = %h", pc_out);
        //$stop;
    end

    assert(instr == inst) else begin
        $display("instruction memory output is wrong.");
        $display("Expected value = %h", inst);
        $display("Actual value   = %h", instr);
        //$stop;
    end

    assert((instr[6:0] == 7'b0110011) || (imm_out === imm_ot)) else begin
        $display("immediate gen output is wrong.");
        $display("Expected value = %h", imm_ot);
        $display("Actual value   = %h", imm_out);
        //$stop;
    end

    assert(rdata1 == rdat1) else begin
        $display("reg file data1 output is wrong.");
        $display("Expected value = %h", rdat1);
        $display("Actual value   = %h", rdata1);
        //$stop;
    end

    assert(rdata2 == rdat2) else begin
        $display("reg file data2 output is wrong.");
        $display("Expected value = %h", rdat2);
        $display("Actual value   = %h", rdata2);
        //$stop;
    end

    assert(alu_op1 == alu_o1) else begin
        $display("operand1 of alu is is wrong.");
        $display("Expected value = %h", alu_o1);
        $display("Actual value   = %h", alu_op1);
        //$stop;
    end

    assert(alu_op2 == alu_o2) else begin
        $display("operand2 of alu is is wrong.");
        $display("Expected value = %h", alu_o2);
        $display("Actual value   = %h", alu_op2);
        //$stop;
    end

    assert(alu_result == alu_rslt) else begin
        $display("alu result output is wrong.");
        $display("Expected value = %h", alu_rslt);
        $display("Actual value   = %h", alu_result);
        //$stop;
    end

    assert(memread == memrd) else begin
        $display("Data memory used is wrong.");
        $display("Expected value of memread  = %h", memrd);
        $display("Actual value of memread    = %h", memread);
        //$stop;
    end

    assert(memwrite == memwrt) else begin
        $display("Data memory used is wrong.");
        $display("Expected value of memwrite = %h", memwrt);
        $display("Actual value of memwrite   = %h", memwrite);
        //$stop;
    end

    assert(wdata == wdat) else begin
        $display("reg file write data is wrong.");
        $display("Expected value = %h", wdat);
        $display("Actual value   = %h", wdata);
        //$stop;
    end

    assert(rd == rdest) else begin
        $display("reg file destination register is wrong.");
        $display("Expected value = %h", rdest);
        $display("Actual value   = %h", rd);
        //$stop;
    end

    assert(regwrite == regwrt) else begin
        $display("reg file's regwrite signal is wrong.");
        $display("Expected value = %h", regwrt);
        $display("Actual value   = %h", regwrite);
        //$stop;
    end

    assert(branch == brch) else begin
        $display("control logic's branch signal is wrong.");
        $display("Expected value = %h", brch);
        $display("Actual value   = %h", branch);
        //$stop;
    end

endtask

always begin
    #5 clk = ~clk;
end

initial begin
    clk = 0;
    $readmemh("Single Cycle Contents/IMEM/InstMemoryContentsSingleCycle - without branch.txt", uut.u_imem.memory);
    $readmemh("Single Cycle Contents/Reg File/RegFileContentsSingleCycle.txt", uut.r.regs);
    $readmemh("Single Cycle Contents/Dmem/DataMemoryContents.txt", uut.d.memory);
    reset();

    #1;

    $display("-------addi test starts-------!");
    // pc_next, pc_out, instr, imm_out, rdata1, rdata2, alu_op1,
    // alu_op2, alu_result, wdata, rd, branch, regwrite, memread, memwrite
    test(  4,              //pc_next
           0,              //pc_out
           32'h00508093,   //instr
           5,              //imm_out
           5,              //rdata1
           rdata2,         //rdata2
           5,              //alu_op1
           5,              //alu_op2
           10,             //alu_result
           10,             //wdata
           1,              //rd
           0,              //branch
           1,              //regwrite
           0,              //memread
           0               //memwrite
        );
    $display("-------addi test successful!---");

    @(posedge clk);
    #1;

    $display("-------add test starts-------!");
    test(  8,              //pc_next
           4,              //pc_out
           32'h001101b3,   //instr
           imm_out,        //imm_out
           5,              //rdata1
           10,             //rdata2
           5,              //alu_op1
           10,             //alu_op2
           15,             //alu_result
           15,             //wdata
           3,              //rd
           0,              //branch
           1,              //regwrite
           0,              //memread
           0               //memwrite
        );
    $display("-------add test successful!---");

    @(posedge clk);
    #1;

    $display("-------sub test starts-------!");
    test(  12,             //pc_next
           8,              //pc_out
           32'h40218233,   //instr
           imm_out,        //imm_out - don't care
           15,             //rdata1
           5,              //rdata2
           15,             //alu_op1
           5,              //alu_op2
           10,             //alu_result
           10,             //wdata
           4,              //rd
           0,              //branch
           1,              //regwrite
           0,              //memread
           0               //memwrite
        );
    $display("-------sub test successful!---");

    @(posedge clk);
    #1;

    $display("-------lw test starts-------!");
    test(  16,             //pc_next
           12,             //pc_out
           32'h00832283,   //instr
           8,              //imm_out
           4,              //rdata1
           rdata2,         //rdata2
           4,              //alu_op1
           8,              //alu_op2
           12,             //alu_result
           32'h00502083,   //wdata
           5,              //rd
           0,              //branch
           1,              //regwrite
           1,              //memread
           0               //memwrite
        );
    $display("-------lw test successful!---");

    @(posedge clk);
    #1;

    $display("-------sw test starts-------!");
    test(  20,             //pc_next
           16,             //pc_out
           32'h00402223,   //instr
           4,              //imm_out
           0,              //rdata1
           rdata2,         //rdata2
           0,              //alu_op1
           4,              //alu_op2
           4,              //alu_result
           wdata,          //wdata
           rd,             //rd
           0,              //branch
           0,              //regwrite
           0,              //memread
           1               //memwrite
        );
    $display("-------sw test successful!---");

    @(posedge clk);
    #1;

   /* $display("-------mul test starts-------!");
    test(  24,             //pc_next
           20,             //pc_out
           32'h02208533,   //instr
           imm_out,        //imm_out
           10,             //rdata1
           5,              //rdata2
           10,             //alu_op1
           5,              //alu_op2
           50,             //alu_result
           50,             //wdata
           10,             //rd
           0,              //branch
           1,              //regwrite
           0,              //memread
           0               //memwrite
        );
    $display("-------mul test successful!---");
*/
    @(posedge clk);
    #1;
    $display("-------RegFile and DMEM Test starts!---");
    test_memory();
    $display("-------RegFile and DMEM Test successful!---");


    @(posedge clk);
    #1;
    $display("-------Branch Testing starts!---");
    $readmemh("Single Cycle Contents/IMEM/InstMemoryContentsSingleCycle - branches only.txt", uut.u_imem.memory);
    reset();
    repeat(3) @(posedge clk);
    #1;
    $display("-------beq test starts at 96ns-------!");
    test(  32'h14,         //pc_next
           32'hc,          //pc_out
           32'h00628463,   //instr
           8,              //imm_out
           rdata1,         //rdata1
           rdata2,         //rdata2
           alu_op1,        //alu_op1
           alu_op2,        //alu_op2
           alu_result,     //alu_result
           wdata,          //wdata
           rd,             //rd
           1,              //branch
           0,              //regwrite
           0,              //memread
           0               //memwrite
        );
    $display("-------beq test successful!---");

    repeat(2) @(posedge clk);
    #1;
    $display("-------j test starts 116ns-------!");
    test(  32'h24,         //pc_next
           32'h18,         //pc_out
           32'h00c0006f,   //instr
           32'hc,          //imm_out
           rdata1,         //rdata1
           rdata2,         //rdata2
           alu_op1,        //alu_op1
           alu_op2,        //alu_op2
           alu_result,     //alu_result
           32'h1c,         //wdata
           0,              //rd
           0,              //branch
           1,              //regwrite
           0,              //memread
           0               //memwrite
        );
    $display("-------j test successful!---");
/*
    @(posedge clk);
    #1;
    $display("-------bne test starts 126ns-------!");
    test(  32'h2c,         //pc_next
           32'h24,         //pc_out
           32'h00729463,   //instr
           8,              //imm_out
           rdata1,         //rdata1
           rdata2,         //rdata2
           alu_op1,        //alu_op1
           alu_op2,        //alu_op2
           alu_result,     //alu_result
           wdata,          //wdata
           rd,             //rd
           1,              //branch
           0,              //regwrite
           0,              //memread
           0               //memwrite
        );
    $display("-------bne test successful!---");
*/
    repeat(4) @(posedge clk);
    #1;
    $display("-------bge test starts 146ns-------!");
    test(  32'h44,         //pc_next
           32'h3c,         //pc_out
           32'h0072d463,   //instr
           8,              //imm_out
           rdata1,         //rdata1
           rdata2,         //rdata2
           alu_op1,        //alu_op1
           alu_op2,        //alu_op2
           alu_result,     //alu_result
           wdata,          //wdata
           rd,             //rd
           1,              //branch
           0,              //regwrite
           0,              //memread
           0               //memwrite
        );
    $display("-------bge test successful!---");

    repeat(3) @(posedge clk);
    #1;
    $display("-------blt test starts 176ns-------!");
    test(  32'h5c,         //pc_next
           32'h54,         //pc_out
           32'h0053c463,   //instr
           8,              //imm_out
           rdata1,         //rdata1
           rdata2,         //rdata2
           alu_op1,        //alu_op1
           alu_op2,        //alu_op2
           alu_result,     //alu_result
           wdata,          //wdata
           rd,             //rd
           1,              //branch
           0,              //regwrite
           0,              //memread
           0               //memwrite
        );
    $display("-------blt test successful!---");
    repeat(3) @(posedge clk);
    #1;
    $display("-------RegFile and DMEM Test Starts 177ns---");
    test_memory_after_branch();
    $display("-------RegFile and DMEM Test Successful---");
    $stop;
end

endmodule