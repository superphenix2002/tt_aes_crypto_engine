module crypto_clk_synth(
input logic clk,
input logic ss,
output logic crypto_clk
);

logic [2:0] clk_cnt;

if(!ss) begin
always_ff @(posedge clk) begin
case(clk_cnt)
3'b000:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b1;
end
3'b001:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b1;
end
3'b010:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b1;
end
3'b011:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b0;
end
3'b100:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b0;
end
3'b101:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b0;
end
3'b110:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b0;
end
3'b111:begin
clk_cnt <= 3'b000;
crypto_clk <= 1'b1;
end
endcase
end
end
else begin
clk_cnt <= 3'b000;
crypto_clk <= 1'b1;
end



endmodule 