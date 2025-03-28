
`timescale 1ns / 1ps

module tb_mcu_program_hex_state_instr_mnemonic;

    reg clk, reset;
    reg [7:0] io_input;
    wire [7:0] io_output;

    reg [2:0] last_state;
    reg [7:0] last_instr;

    // Instantiate the MCU
    mcu_top uut (
        .clk(clk),
        .reset(reset),
        .io_input(io_input),
        .io_output(io_output)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    function [63*8:1] decode_instruction;
        input [7:0] instr;
        case (instr[7:4])
            4'h0: decode_instruction = "NOP        ";
            4'h1: decode_instruction = "ADD        ";
            4'h2: decode_instruction = "SUB        ";
            4'h3: decode_instruction = "AND        ";
            4'h4: decode_instruction = "OR         ";
            4'h5: decode_instruction = "XOR        ";
            4'h6: decode_instruction = "MOV        ";
            4'h7: decode_instruction = "LDI        ";
            4'h8: decode_instruction = "LOAD       ";
            4'h9: decode_instruction = "STORE      ";
            4'hA: decode_instruction = "IN         ";
            4'hB: decode_instruction = "OUT        ";
            4'hC: decode_instruction = "DEC        ";
            4'hD: decode_instruction = "JMP        ";
            4'hE: decode_instruction = "JNZ        ";
            4'hF: decode_instruction = "HLT/NOP    ";
            default: decode_instruction = "UNKNOWN    ";
        endcase
    endfunction

    integer i;
    initial begin
        $display("\n--- MCU Trace with Decoded Instruction Mnemonics ---");
        $display("Time  PC  STATE  INSTR   MNEMONIC     A   B   C  R1  R2  OUT");

        reset = 1;
        io_input = 8'h00;

        uut.dp.rf.registers[0] = 8'hF0;
        uut.dp.rf.registers[1] = 8'd1;
        uut.dp.rf.registers[2] = 8'd2;
        uut.dp.rf.registers[3] = 8'd3;

        last_state = 3'b111;
        last_instr = 8'hFF;

        // First cycle output (even during reset)
        @(negedge clk);
        $display("%5t  %2h    %0d     %2h  %s  %2h  %2h  %2h  %2h  %2h  %2h",
            $time,
            uut.dp.pc_out,
            uut.cu.state,
            uut.dp.instruction,
            decode_instruction(uut.dp.instruction),
            uut.dp.reg_a_out,
            uut.dp.reg_b_out,
            uut.dp.reg_c_out,
            uut.dp.rf.registers[1],
            uut.dp.rf.registers[2],
            io_output
        );

        reset = 0;

        repeat (100) begin
            @(negedge clk);
            if (uut.cu.state != last_state || uut.dp.instruction != last_instr) begin
                last_state = uut.cu.state;
                last_instr = uut.dp.instruction;
                $display("%5t  %2h    %0d     %2h  %s  %2h  %2h  %2h  %2h  %2h  %2h",
                    $time,
                    uut.dp.pc_out,
                    uut.cu.state,
                    uut.dp.instruction,
                    decode_instruction(uut.dp.instruction),
                    uut.dp.reg_a_out,
                    uut.dp.reg_b_out,
                    uut.dp.reg_c_out,
                    uut.dp.rf.registers[1],
                    uut.dp.rf.registers[2],
                    io_output
                );
            end
        end

        $display("\n--- Simulation Complete ---");
        $finish;
    end

endmodule
