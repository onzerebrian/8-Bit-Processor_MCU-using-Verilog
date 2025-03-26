module instruction_register ( clk, reset, load_ir, instr_in, instr_out );
    input clk, reset, load_ir;
    input [7:0] instr_in;

    output reg [7:0] instr_out;

    always @(posedge clk or posedge reset) 
    begin
        if (reset)
            instr_out <= 8'b00000000;
        else if (load_ir)
            instr_out <= instr_in;
    end
endmodule