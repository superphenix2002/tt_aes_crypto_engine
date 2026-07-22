module shift_rows_inverse(
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

assign out_mat00 = data_mat00;
assign out_mat01 = data_mat01;
assign out_mat02 = data_mat02;
assign out_mat03 = data_mat03;
assign out_mat10 = data_mat13;
assign out_mat11 = data_mat10;
assign out_mat12 = data_mat11;
assign out_mat13 = data_mat12;
assign out_mat20 = data_mat22;
assign out_mat21 = data_mat23;
assign out_mat22 = data_mat20;
assign out_mat23 = data_mat21;
assign out_mat30 = data_mat31;
assign out_mat31 = data_mat32;
assign out_mat32 = data_mat33;
assign out_mat33 = data_mat30;


endmodule