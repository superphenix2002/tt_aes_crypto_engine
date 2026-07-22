module add_rnd_key(input logic [7:0] data_mat00,
input logic [7:0] data_mat01,
input logic [7:0] data_mat02,
input logic [7:0] data_mat03,
input logic [7:0] data_mat10,
input logic [7:0] data_mat11,
input logic [7:0] data_mat12,
input logic [7:0] data_mat13,
input logic [7:0] data_mat20,
input logic [7:0] data_mat21,
input logic [7:0] data_mat22,
input logic [7:0] data_mat23,
input logic [7:0] data_mat30,
input logic [7:0] data_mat31,
input logic [7:0] data_mat32,
input logic [7:0] data_mat33,
input logic [127:0] key,
output logic [7:0] out_mat00,
output logic [7:0] out_mat01,
output logic [7:0] out_mat02,
output logic [7:0] out_mat03,
output logic [7:0] out_mat10,
output logic [7:0] out_mat11,
output logic [7:0] out_mat12,
output logic [7:0] out_mat13,
output logic [7:0] out_mat20,
output logic [7:0] out_mat21,
output logic [7:0] out_mat22,
output logic [7:0] out_mat23,
output logic [7:0] out_mat30,
output logic [7:0] out_mat31,
output logic [7:0] out_mat32,
output logic [7:0] out_mat33);

always_comb begin

out_mat00 = data_mat00 ^ key[127:120];
out_mat10 = data_mat10 ^ key[119:112];
out_mat20 = data_mat20 ^ key[111:104];
out_mat30 = data_mat30 ^ key[103:96];
out_mat01 = data_mat01 ^ key[95:88];
out_mat11 = data_mat11 ^ key[87:80];
out_mat21 = data_mat21 ^ key[79:72];
out_mat31 = data_mat31 ^ key[71:64];
out_mat02 = data_mat02 ^ key[63:56];
out_mat12 = data_mat12 ^ key[55:48];
out_mat22 = data_mat22 ^ key[47:40];
out_mat32 = data_mat32 ^ key[39:32];
out_mat03 = data_mat03 ^ key[31:24];
out_mat13 = data_mat13 ^ key[23:16];
out_mat23 = data_mat23 ^ key[15:8];
out_mat33 = data_mat33 ^ key[7:0];

end



endmodule



