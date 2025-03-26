module pc_mux (
    input [7:0] pc_plus_1,
    input [7:0] jump_address,
    input sel,
    output [7:0] pc_in
);

    assign pc_in = sel ? jump_address : pc_plus_1;

endmodule
