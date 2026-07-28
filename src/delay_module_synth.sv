
module dly_module(
logic input input_clk
logic output output_clk);

assign output_clk = input_clk & 1'b1;

endmodule
