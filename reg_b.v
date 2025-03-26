module reg_b (clk, reset, load_b, data_in, data_out);
    input clk, reset, load_b;
    input [7:0] data_in;

    output reg [7:0] data_out;



    always @(posedge clk or posedge reset) 
    begin
        if (reset)  begin 
            data_out = 8'b00000000;
        end
        else if (load_b) begin 
            data_out = data_in;
        end
        
    end
endmodule