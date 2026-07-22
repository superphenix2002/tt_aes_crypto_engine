
module dly_module(
logic input input_clk
logic output output_clk);

sky130_fd_sc_hd__dlygate4sd3 my_delay_cell(
.A (input_clk),
.X (output_clk));

endmodule