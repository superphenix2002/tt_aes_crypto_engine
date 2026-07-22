module sub_bytes(input logic [7:0] s_box[16][16],
input logic [7:0] data_mat00,
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
/*
generate
for(genvar i=0 ; i<4 ; i++)begin
for(genvar j=0 ; j<4 ; j++)begin
assign out_mat[i][j] = s_box[data_mat[i][j][7:4]][data_mat[i][j][3:0]];
end
end
endgenerate
*/
always_comb begin
out_mat00 = s_box[data_mat00[7:4]][data_mat00[3:0]];
out_mat01 = s_box[data_mat01[7:4]][data_mat01[3:0]];
out_mat02 = s_box[data_mat02[7:4]][data_mat02[3:0]];
out_mat03 = s_box[data_mat03[7:4]][data_mat03[3:0]];
out_mat10 = s_box[data_mat10[7:4]][data_mat10[3:0]];
out_mat11 = s_box[data_mat11[7:4]][data_mat11[3:0]];
out_mat12 = s_box[data_mat12[7:4]][data_mat12[3:0]];
out_mat13 = s_box[data_mat13[7:4]][data_mat13[3:0]];
out_mat20 = s_box[data_mat20[7:4]][data_mat20[3:0]];
out_mat21 = s_box[data_mat21[7:4]][data_mat21[3:0]];
out_mat22 = s_box[data_mat22[7:4]][data_mat22[3:0]];
out_mat23 = s_box[data_mat23[7:4]][data_mat23[3:0]];
out_mat30 = s_box[data_mat30[7:4]][data_mat30[3:0]];
out_mat31 = s_box[data_mat31[7:4]][data_mat31[3:0]];
out_mat32 = s_box[data_mat32[7:4]][data_mat32[3:0]];
out_mat33 = s_box[data_mat33[7:4]][data_mat33[3:0]];
end

endmodule