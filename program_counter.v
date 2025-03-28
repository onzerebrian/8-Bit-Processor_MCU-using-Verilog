module program_counter (clk, reset, load_pc, inc_pc,pc_in,pc_out);
    input clk, reset, load_pc, inc_pc;
    input [7:0] pc_in;
    
    output reg [7:0] pc_out;


    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 8'b00000000;
        else if (load_pc) 
            pc_out <= pc_in;
        else if (inc_pc) 
            pc_out <= pc_out + 1;
        
    end

endmodule
