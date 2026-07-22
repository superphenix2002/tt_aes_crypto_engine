module mix_cols(input logic [7:0] data_mat00,
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

logic [7:0] constants[4][4][4];

generate
for(genvar i=0 ; i<4 ; i++)begin
for(genvar j=0 ; j<4 ; j++)begin
assign constants [i][j][0] = 8'h00;
//assign constants [i][j][1] = data_mat [i][j];
//assign constants [i][j][2] = (data_mat [i][j][7]) ? {data_mat [i][j][6:0],1'b0} ^ 8'h1B : {data_mat [i][j][6:0],1'b0} ;
//assign constants [i][j][3] = (data_mat [i][j][7]) ? {data_mat [i][j][6:0],1'b0} ^ 8'h1B ^ data_mat [i][j] : {data_mat [i][j][6:0],1'b0} ^ data_mat [i][j] ;
end
end
endgenerate

assign constants[0][0][1] = data_mat00;
assign constants[0][1][1] = data_mat01;
assign constants[0][2][1] = data_mat02;
assign constants[0][3][1] = data_mat03;
assign constants[1][0][1] = data_mat10;
assign constants[1][1][1] = data_mat11;
assign constants[1][2][1] = data_mat12;
assign constants[1][3][1] = data_mat13;
assign constants[2][0][1] = data_mat20;
assign constants[2][1][1] = data_mat21;
assign constants[2][2][1] = data_mat22;
assign constants[2][3][1] = data_mat23;
assign constants[3][0][1] = data_mat30;
assign constants[3][1][1] = data_mat31;
assign constants[3][2][1] = data_mat32;
assign constants[3][3][1] = data_mat33;

assign constants[0][0][2] = (data_mat00[7]) ? {data_mat00[6:0],1'b0} ^ 8'h1B : {data_mat00[6:0],1'b0} ;
assign constants[0][1][2] = (data_mat01[7]) ? {data_mat01[6:0],1'b0} ^ 8'h1B : {data_mat01[6:0],1'b0} ;
assign constants[0][2][2] = (data_mat02[7]) ? {data_mat02[6:0],1'b0} ^ 8'h1B : {data_mat02[6:0],1'b0} ;
assign constants[0][3][2] = (data_mat03[7]) ? {data_mat03[6:0],1'b0} ^ 8'h1B : {data_mat03[6:0],1'b0} ;
assign constants[1][0][2] = (data_mat10[7]) ? {data_mat10[6:0],1'b0} ^ 8'h1B : {data_mat10[6:0],1'b0} ;
assign constants[1][1][2] = (data_mat11[7]) ? {data_mat11[6:0],1'b0} ^ 8'h1B : {data_mat11[6:0],1'b0} ;
assign constants[1][2][2] = (data_mat12[7]) ? {data_mat12[6:0],1'b0} ^ 8'h1B : {data_mat12[6:0],1'b0} ;
assign constants[1][3][2] = (data_mat13[7]) ? {data_mat13[6:0],1'b0} ^ 8'h1B : {data_mat13[6:0],1'b0} ;
assign constants[2][0][2] = (data_mat20[7]) ? {data_mat20[6:0],1'b0} ^ 8'h1B : {data_mat20[6:0],1'b0} ;
assign constants[2][1][2] = (data_mat21[7]) ? {data_mat21[6:0],1'b0} ^ 8'h1B : {data_mat21[6:0],1'b0} ;
assign constants[2][2][2] = (data_mat22[7]) ? {data_mat22[6:0],1'b0} ^ 8'h1B : {data_mat22[6:0],1'b0} ;
assign constants[2][3][2] = (data_mat23[7]) ? {data_mat23[6:0],1'b0} ^ 8'h1B : {data_mat23[6:0],1'b0} ;
assign constants[3][0][2] = (data_mat30[7]) ? {data_mat30[6:0],1'b0} ^ 8'h1B : {data_mat30[6:0],1'b0} ;
assign constants[3][1][2] = (data_mat31[7]) ? {data_mat31[6:0],1'b0} ^ 8'h1B : {data_mat31[6:0],1'b0} ;
assign constants[3][2][2] = (data_mat32[7]) ? {data_mat32[6:0],1'b0} ^ 8'h1B : {data_mat32[6:0],1'b0} ;
assign constants[3][3][2] = (data_mat33[7]) ? {data_mat33[6:0],1'b0} ^ 8'h1B : {data_mat33[6:0],1'b0} ;

assign constants[0][0][3] = (data_mat00[7]) ? {data_mat00[6:0],1'b0} ^ 8'h1B ^ data_mat00 : {data_mat00[6:0],1'b0} ^ data_mat00 ;
assign constants[0][1][3] = (data_mat01[7]) ? {data_mat01[6:0],1'b0} ^ 8'h1B ^ data_mat01 : {data_mat01[6:0],1'b0} ^ data_mat01 ;
assign constants[0][2][3] = (data_mat02[7]) ? {data_mat02[6:0],1'b0} ^ 8'h1B ^ data_mat02 : {data_mat02[6:0],1'b0} ^ data_mat02 ;
assign constants[0][3][3] = (data_mat03[7]) ? {data_mat03[6:0],1'b0} ^ 8'h1B ^ data_mat03 : {data_mat03[6:0],1'b0} ^ data_mat03 ;
assign constants[1][0][3] = (data_mat10[7]) ? {data_mat10[6:0],1'b0} ^ 8'h1B ^ data_mat10 : {data_mat10[6:0],1'b0} ^ data_mat10 ;
assign constants[1][1][3] = (data_mat11[7]) ? {data_mat11[6:0],1'b0} ^ 8'h1B ^ data_mat11 : {data_mat11[6:0],1'b0} ^ data_mat11 ;
assign constants[1][2][3] = (data_mat12[7]) ? {data_mat12[6:0],1'b0} ^ 8'h1B ^ data_mat12 : {data_mat12[6:0],1'b0} ^ data_mat12 ;
assign constants[1][3][3] = (data_mat13[7]) ? {data_mat13[6:0],1'b0} ^ 8'h1B ^ data_mat13 : {data_mat13[6:0],1'b0} ^ data_mat13 ;
assign constants[2][0][3] = (data_mat20[7]) ? {data_mat20[6:0],1'b0} ^ 8'h1B ^ data_mat20 : {data_mat20[6:0],1'b0} ^ data_mat20 ;
assign constants[2][1][3] = (data_mat21[7]) ? {data_mat21[6:0],1'b0} ^ 8'h1B ^ data_mat21 : {data_mat21[6:0],1'b0} ^ data_mat21 ;
assign constants[2][2][3] = (data_mat22[7]) ? {data_mat22[6:0],1'b0} ^ 8'h1B ^ data_mat22 : {data_mat22[6:0],1'b0} ^ data_mat22 ;
assign constants[2][3][3] = (data_mat23[7]) ? {data_mat23[6:0],1'b0} ^ 8'h1B ^ data_mat23 : {data_mat23[6:0],1'b0} ^ data_mat23 ;
assign constants[3][0][3] = (data_mat30[7]) ? {data_mat30[6:0],1'b0} ^ 8'h1B ^ data_mat30 : {data_mat30[6:0],1'b0} ^ data_mat30 ;
assign constants[3][1][3] = (data_mat31[7]) ? {data_mat31[6:0],1'b0} ^ 8'h1B ^ data_mat31 : {data_mat31[6:0],1'b0} ^ data_mat31 ;
assign constants[3][2][3] = (data_mat32[7]) ? {data_mat32[6:0],1'b0} ^ 8'h1B ^ data_mat32 : {data_mat32[6:0],1'b0} ^ data_mat32 ;
assign constants[3][3][3] = (data_mat33[7]) ? {data_mat33[6:0],1'b0} ^ 8'h1B ^ data_mat33 : {data_mat33[6:0],1'b0} ^ data_mat33 ;
/*
generate
for(genvar j=0 ; j<4 ; j++)begin
assign out_mat[0][j] = constants [0][j][2] ^ constants [1][j][3] ^ constants [2][j][1] ^ constants [3][j][1];
assign out_mat[1][j] = constants [0][j][1] ^ constants [1][j][2] ^ constants [2][j][3] ^ constants [3][j][1];
assign out_mat[2][j] = constants [0][j][1] ^ constants [1][j][1] ^ constants [2][j][2] ^ constants [3][j][3];
assign out_mat[3][j] = constants [0][j][3] ^ constants [1][j][1] ^ constants [2][j][1] ^ constants [3][j][2];
end
endgenerate
*/
assign out_mat00 = constants [0][0][2] ^ constants [1][0][3] ^ constants [2][0][1] ^ constants [3][0][1];
assign out_mat01 = constants [0][1][2] ^ constants [1][1][3] ^ constants [2][1][1] ^ constants [3][1][1];
assign out_mat02 = constants [0][2][2] ^ constants [1][2][3] ^ constants [2][2][1] ^ constants [3][2][1];
assign out_mat03 = constants [0][3][2] ^ constants [1][3][3] ^ constants [2][3][1] ^ constants [3][3][1];

assign out_mat10 = constants [0][0][1] ^ constants [1][0][2] ^ constants [2][0][3] ^ constants [3][0][1];
assign out_mat11 = constants [0][1][1] ^ constants [1][1][2] ^ constants [2][1][3] ^ constants [3][1][1];
assign out_mat12 = constants [0][2][1] ^ constants [1][2][2] ^ constants [2][2][3] ^ constants [3][2][1];
assign out_mat13 = constants [0][3][1] ^ constants [1][3][2] ^ constants [2][3][3] ^ constants [3][3][1];

assign out_mat20 = constants [0][0][1] ^ constants [1][0][1] ^ constants [2][0][2] ^ constants [3][0][3];
assign out_mat21 = constants [0][1][1] ^ constants [1][1][1] ^ constants [2][1][2] ^ constants [3][1][3];
assign out_mat22 = constants [0][2][1] ^ constants [1][2][1] ^ constants [2][2][2] ^ constants [3][2][3];
assign out_mat23 = constants [0][3][1] ^ constants [1][3][1] ^ constants [2][3][2] ^ constants [3][3][3];

assign out_mat30 = constants [0][0][3] ^ constants [1][0][1] ^ constants [2][0][1] ^ constants [3][0][2];
assign out_mat31 = constants [0][1][3] ^ constants [1][1][1] ^ constants [2][1][1] ^ constants [3][1][2];
assign out_mat32 = constants [0][2][3] ^ constants [1][2][1] ^ constants [2][2][1] ^ constants [3][2][2];
assign out_mat33 = constants [0][3][3] ^ constants [1][3][1] ^ constants [2][3][1] ^ constants [3][3][2];


endmodule