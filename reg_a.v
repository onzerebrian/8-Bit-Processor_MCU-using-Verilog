module reg_a (clk, reset, load_a, data_in, data_out);
    input clk, reset, load_a;
    input [7:0] data_in;

    output reg [7:0] data_out;



    always @(posedge clk or posedge reset) 
    begin
        if (reset)  begin 
            data_out = 8'b00000000;
        end
        else if (load_a) begin 
            data_out = data_in;
        end
        
    end
endmodule