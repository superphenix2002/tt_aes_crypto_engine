module crypto_clk_synth(
input logic clk,
input logic ss,
output logic crypto_clk
);

logic [3:0] clk_cnt;

always_ff @(posedge clk) begin
if(!ss) begin
case(clk_cnt)
4'b0000:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b0;
end
4'b0001:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b0;
end
4'b0010:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b0;
end
4'b0011:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b0;
end
4'b0100:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b0;
end
4'b0101:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b0;
end
4'b0110:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b0;
end
4'b0111:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b1;
end
4'b1000:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b1;
end
4'b1001:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b1;
end
4'b1010:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b1;
end
4'b1011:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b1;
end
4'b1100:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b1;
end
4'b1101:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b1;
end
4'b1110:begin
clk_cnt <= clk_cnt + 1;
crypto_clk <= 1'b1;
end
4'b1111:begin
clk_cnt <= 4'b0000;
crypto_clk <= 1'b0;
end
endcase
end
else begin
clk_cnt <= 4'b0000;
crypto_clk <= 1'b0;
end
end


endmodule 