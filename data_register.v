module data_register (
    input clk,
    input reset,
    input load_data,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    
    always @(posedge clk or posedge reset) 
    begin
        if (reset) begin
            data_out <= 8'b00000000;
        end 
        else if (load_data) 
        begin
            data_out <= data_in;
        end 
    end
endmodule