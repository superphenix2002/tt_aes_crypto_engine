module mix_cols_inverse(input logic [7:0] data_mat00,
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

//constants[x][y][0] = e
//constants[x][y][1] = b
//constants[x][y][2] = d
//constants[x][y][3] = 9

logic [7:0] temp000;
logic [7:0] temp001;
logic [7:0] temp002;
logic [7:0] temp003;

logic [7:0] temp010;
logic [7:0] temp011;
logic [7:0] temp012;
logic [7:0] temp013;

logic [7:0] temp020;
logic [7:0] temp021;
logic [7:0] temp022;
logic [7:0] temp023;

logic [7:0] temp030;
logic [7:0] temp031;
logic [7:0] temp032;
logic [7:0] temp033;

logic [7:0] temp100;
logic [7:0] temp101;
logic [7:0] temp102;
logic [7:0] temp103;

logic [7:0] temp110;
logic [7:0] temp111;
logic [7:0] temp112;
logic [7:0] temp113;

logic [7:0] temp120;
logic [7:0] temp121;
logic [7:0] temp122;
logic [7:0] temp123;

logic [7:0] temp130;
logic [7:0] temp131;
logic [7:0] temp132;
logic [7:0] temp133;

logic [7:0] temp200;
logic [7:0] temp201;
logic [7:0] temp202;
logic [7:0] temp203;

logic [7:0] temp210;
logic [7:0] temp211;
logic [7:0] temp212;
logic [7:0] temp213;

logic [7:0] temp220;
logic [7:0] temp221;
logic [7:0] temp222;
logic [7:0] temp223;

logic [7:0] temp230;
logic [7:0] temp231;
logic [7:0] temp232;
logic [7:0] temp233;

logic [7:0] temp300;
logic [7:0] temp301;
logic [7:0] temp302;
logic [7:0] temp303;

logic [7:0] temp310;
logic [7:0] temp311;
logic [7:0] temp312;
logic [7:0] temp313;

logic [7:0] temp320;
logic [7:0] temp321;
logic [7:0] temp322;
logic [7:0] temp323;

logic [7:0] temp330;
logic [7:0] temp331;
logic [7:0] temp332;
logic [7:0] temp333;

assign temp000 = data_mat00;
assign temp001 = (data_mat00[7]) ? {data_mat00[6:0],1'b0} ^ 8'h1B : {data_mat00[6:0],1'b0} ;
assign temp002 = (temp001[7]) ? {temp001[6:0],1'b0} ^ 8'h1B : {temp001[6:0],1'b0} ;
assign temp003 = (temp002[7]) ? {temp002[6:0],1'b0} ^ 8'h1B : {temp002[6:0],1'b0} ;

assign temp010 = data_mat01;
assign temp011 = (data_mat01[7]) ? {data_mat01[6:0],1'b0} ^ 8'h1B : {data_mat01[6:0],1'b0} ;
assign temp012 = (temp011[7]) ? {temp011[6:0],1'b0} ^ 8'h1B : {temp011[6:0],1'b0} ;
assign temp013 = (temp012[7]) ? {temp012[6:0],1'b0} ^ 8'h1B : {temp012[6:0],1'b0} ;

assign temp020 = data_mat02;
assign temp021 = (data_mat02[7]) ? {data_mat02[6:0],1'b0} ^ 8'h1B : {data_mat02[6:0],1'b0} ;
assign temp022 = (temp021[7]) ? {temp021[6:0],1'b0} ^ 8'h1B : {temp021[6:0],1'b0} ;
assign temp023 = (temp022[7]) ? {temp022[6:0],1'b0} ^ 8'h1B : {temp022[6:0],1'b0} ;

assign temp030 = data_mat03;
assign temp031 = (data_mat03[7]) ? {data_mat03[6:0],1'b0} ^ 8'h1B : {data_mat03[6:0],1'b0} ;
assign temp032 = (temp031[7]) ? {temp031[6:0],1'b0} ^ 8'h1B : {temp031[6:0],1'b0} ;
assign temp033 = (temp032[7]) ? {temp032[6:0],1'b0} ^ 8'h1B : {temp032[6:0],1'b0} ;

assign temp100 = data_mat10;
assign temp101 = (data_mat10[7]) ? {data_mat10[6:0],1'b0} ^ 8'h1B : {data_mat10[6:0],1'b0} ;
assign temp102 = (temp101[7]) ? {temp101[6:0],1'b0} ^ 8'h1B : {temp101[6:0],1'b0} ;
assign temp103 = (temp102[7]) ? {temp102[6:0],1'b0} ^ 8'h1B : {temp102[6:0],1'b0} ;

assign temp110 = data_mat11;
assign temp111 = (data_mat11[7]) ? {data_mat11[6:0],1'b0} ^ 8'h1B : {data_mat11[6:0],1'b0} ;
assign temp112 = (temp111[7]) ? {temp111[6:0],1'b0} ^ 8'h1B : {temp111[6:0],1'b0} ;
assign temp113 = (temp112[7]) ? {temp112[6:0],1'b0} ^ 8'h1B : {temp112[6:0],1'b0} ;

assign temp120 = data_mat12;
assign temp121 = (data_mat12[7]) ? {data_mat12[6:0],1'b0} ^ 8'h1B : {data_mat12[6:0],1'b0} ;
assign temp122 = (temp121[7]) ? {temp121[6:0],1'b0} ^ 8'h1B : {temp121[6:0],1'b0} ;
assign temp123 = (temp122[7]) ? {temp122[6:0],1'b0} ^ 8'h1B : {temp122[6:0],1'b0} ;

assign temp130 = data_mat13;
assign temp131 = (data_mat13[7]) ? {data_mat13[6:0],1'b0} ^ 8'h1B : {data_mat13[6:0],1'b0} ;
assign temp132 = (temp131[7]) ? {temp131[6:0],1'b0} ^ 8'h1B : {temp131[6:0],1'b0} ;
assign temp133 = (temp132[7]) ? {temp132[6:0],1'b0} ^ 8'h1B : {temp132[6:0],1'b0} ;

assign temp200 = data_mat20;
assign temp201 = (data_mat20[7]) ? {data_mat20[6:0],1'b0} ^ 8'h1B : {data_mat20[6:0],1'b0} ;
assign temp202 = (temp201[7]) ? {temp201[6:0],1'b0} ^ 8'h1B : {temp201[6:0],1'b0} ;
assign temp203 = (temp202[7]) ? {temp202[6:0],1'b0} ^ 8'h1B : {temp202[6:0],1'b0} ;

assign temp210 = data_mat21;
assign temp211 = (data_mat21[7]) ? {data_mat21[6:0],1'b0} ^ 8'h1B : {data_mat21[6:0],1'b0} ;
assign temp212 = (temp211[7]) ? {temp211[6:0],1'b0} ^ 8'h1B : {temp211[6:0],1'b0} ;
assign temp213 = (temp212[7]) ? {temp212[6:0],1'b0} ^ 8'h1B : {temp212[6:0],1'b0} ;

assign temp220 = data_mat22;
assign temp221 = (data_mat22[7]) ? {data_mat22[6:0],1'b0} ^ 8'h1B : {data_mat22[6:0],1'b0} ;
assign temp222 = (temp221[7]) ? {temp221[6:0],1'b0} ^ 8'h1B : {temp221[6:0],1'b0} ;
assign temp223 = (temp222[7]) ? {temp222[6:0],1'b0} ^ 8'h1B : {temp222[6:0],1'b0} ;

assign temp230 = data_mat23;
assign temp231 = (data_mat23[7]) ? {data_mat23[6:0],1'b0} ^ 8'h1B : {data_mat23[6:0],1'b0} ;
assign temp232 = (temp231[7]) ? {temp231[6:0],1'b0} ^ 8'h1B : {temp231[6:0],1'b0} ;
assign temp233 = (temp232[7]) ? {temp232[6:0],1'b0} ^ 8'h1B : {temp232[6:0],1'b0} ;

assign temp300 = data_mat30;
assign temp301 = (data_mat30[7]) ? {data_mat30[6:0],1'b0} ^ 8'h1B : {data_mat30[6:0],1'b0} ;
assign temp302 = (temp301[7]) ? {temp301[6:0],1'b0} ^ 8'h1B : {temp301[6:0],1'b0} ;
assign temp303 = (temp302[7]) ? {temp302[6:0],1'b0} ^ 8'h1B : {temp302[6:0],1'b0} ;

assign temp310 = data_mat31;
assign temp311 = (data_mat31[7]) ? {data_mat31[6:0],1'b0} ^ 8'h1B : {data_mat31[6:0],1'b0} ;
assign temp312 = (temp311[7]) ? {temp311[6:0],1'b0} ^ 8'h1B : {temp311[6:0],1'b0} ;
assign temp313 = (temp312[7]) ? {temp312[6:0],1'b0} ^ 8'h1B : {temp312[6:0],1'b0} ;

assign temp320 = data_mat32;
assign temp321 = (data_mat32[7]) ? {data_mat32[6:0],1'b0} ^ 8'h1B : {data_mat32[6:0],1'b0} ;
assign temp322 = (temp321[7]) ? {temp321[6:0],1'b0} ^ 8'h1B : {temp321[6:0],1'b0} ;
assign temp323 = (temp322[7]) ? {temp322[6:0],1'b0} ^ 8'h1B : {temp322[6:0],1'b0} ;

assign temp330 = data_mat33;
assign temp331 = (data_mat33[7]) ? {data_mat33[6:0],1'b0} ^ 8'h1B : {data_mat33[6:0],1'b0} ;
assign temp332 = (temp331[7]) ? {temp331[6:0],1'b0} ^ 8'h1B : {temp331[6:0],1'b0} ;
assign temp333 = (temp332[7]) ? {temp332[6:0],1'b0} ^ 8'h1B : {temp332[6:0],1'b0} ;


assign constants[0][0][0] = temp003 ^ temp002 ^ temp001;
assign constants[0][1][0] = temp013 ^ temp012 ^ temp011;
assign constants[0][2][0] = temp023 ^ temp022 ^ temp021;
assign constants[0][3][0] = temp033 ^ temp032 ^ temp031;
assign constants[1][0][0] = temp103 ^ temp102 ^ temp101;
assign constants[1][1][0] = temp113 ^ temp112 ^ temp111;
assign constants[1][2][0] = temp123 ^ temp122 ^ temp121;
assign constants[1][3][0] = temp133 ^ temp132 ^ temp131;
assign constants[2][0][0] = temp203 ^ temp202 ^ temp201;
assign constants[2][1][0] = temp213 ^ temp212 ^ temp211;
assign constants[2][2][0] = temp223 ^ temp222 ^ temp221;
assign constants[2][3][0] = temp233 ^ temp232 ^ temp231;
assign constants[3][0][0] = temp303 ^ temp302 ^ temp301;
assign constants[3][1][0] = temp313 ^ temp312 ^ temp311;
assign constants[3][2][0] = temp323 ^ temp322 ^ temp321;
assign constants[3][3][0] = temp333 ^ temp332 ^ temp331;

assign constants[0][0][1] = temp003 ^ temp001 ^ temp000;
assign constants[0][1][1] = temp013 ^ temp011 ^ temp010;
assign constants[0][2][1] = temp023 ^ temp021 ^ temp020;
assign constants[0][3][1] = temp033 ^ temp031 ^ temp030;
assign constants[1][0][1] = temp103 ^ temp101 ^ temp100;
assign constants[1][1][1] = temp113 ^ temp111 ^ temp110;
assign constants[1][2][1] = temp123 ^ temp121 ^ temp120;
assign constants[1][3][1] = temp133 ^ temp131 ^ temp130;
assign constants[2][0][1] = temp203 ^ temp201 ^ temp200;
assign constants[2][1][1] = temp213 ^ temp211 ^ temp210;
assign constants[2][2][1] = temp223 ^ temp221 ^ temp220;
assign constants[2][3][1] = temp233 ^ temp231 ^ temp230;
assign constants[3][0][1] = temp303 ^ temp301 ^ temp300;
assign constants[3][1][1] = temp313 ^ temp311 ^ temp310;
assign constants[3][2][1] = temp323 ^ temp321 ^ temp320;
assign constants[3][3][1] = temp333 ^ temp331 ^ temp330;

assign constants[0][0][2] = temp003 ^ temp002 ^ temp000;
assign constants[0][1][2] = temp013 ^ temp012 ^ temp010;
assign constants[0][2][2] = temp023 ^ temp022 ^ temp020;
assign constants[0][3][2] = temp033 ^ temp032 ^ temp030;
assign constants[1][0][2] = temp103 ^ temp102 ^ temp100;
assign constants[1][1][2] = temp113 ^ temp112 ^ temp110;
assign constants[1][2][2] = temp123 ^ temp122 ^ temp120;
assign constants[1][3][2] = temp133 ^ temp132 ^ temp130;
assign constants[2][0][2] = temp203 ^ temp202 ^ temp200;
assign constants[2][1][2] = temp213 ^ temp212 ^ temp210;
assign constants[2][2][2] = temp223 ^ temp222 ^ temp220;
assign constants[2][3][2] = temp233 ^ temp232 ^ temp230;
assign constants[3][0][2] = temp303 ^ temp302 ^ temp300;
assign constants[3][1][2] = temp313 ^ temp312 ^ temp310;
assign constants[3][2][2] = temp323 ^ temp322 ^ temp320;
assign constants[3][3][2] = temp333 ^ temp332 ^ temp330;

assign constants[0][0][3] = temp003 ^ temp000;
assign constants[0][1][3] = temp013 ^ temp010;
assign constants[0][2][3] = temp023 ^ temp020;
assign constants[0][3][3] = temp033 ^ temp030;
assign constants[1][0][3] = temp103 ^ temp100;
assign constants[1][1][3] = temp113 ^ temp110;
assign constants[1][2][3] = temp123 ^ temp120;
assign constants[1][3][3] = temp133 ^ temp130;
assign constants[2][0][3] = temp203 ^ temp200;
assign constants[2][1][3] = temp213 ^ temp210;
assign constants[2][2][3] = temp223 ^ temp220;
assign constants[2][3][3] = temp233 ^ temp230;
assign constants[3][0][3] = temp303 ^ temp300;
assign constants[3][1][3] = temp313 ^ temp310;
assign constants[3][2][3] = temp323 ^ temp320;
assign constants[3][3][3] = temp333 ^ temp330;

assign out_mat00 = constants [0][0][0] ^ constants [1][0][1] ^ constants [2][0][2] ^ constants [3][0][3];
assign out_mat01 = constants [0][1][0] ^ constants [1][1][1] ^ constants [2][1][2] ^ constants [3][1][3];
assign out_mat02 = constants [0][2][0] ^ constants [1][2][1] ^ constants [2][2][2] ^ constants [3][2][3];
assign out_mat03 = constants [0][3][0] ^ constants [1][3][1] ^ constants [2][3][2] ^ constants [3][3][3];

assign out_mat10 = constants [0][0][3] ^ constants [1][0][0] ^ constants [2][0][1] ^ constants [3][0][2];
assign out_mat11 = constants [0][1][3] ^ constants [1][1][0] ^ constants [2][1][1] ^ constants [3][1][2];
assign out_mat12 = constants [0][2][3] ^ constants [1][2][0] ^ constants [2][2][1] ^ constants [3][2][2];
assign out_mat13 = constants [0][3][3] ^ constants [1][3][0] ^ constants [2][3][1] ^ constants [3][3][2];

assign out_mat20 = constants [0][0][2] ^ constants [1][0][3] ^ constants [2][0][0] ^ constants [3][0][1];
assign out_mat21 = constants [0][1][2] ^ constants [1][1][3] ^ constants [2][1][0] ^ constants [3][1][1];
assign out_mat22 = constants [0][2][2] ^ constants [1][2][3] ^ constants [2][2][0] ^ constants [3][2][1];
assign out_mat23 = constants [0][3][2] ^ constants [1][3][3] ^ constants [2][3][0] ^ constants [3][3][1];

assign out_mat30 = constants [0][0][1] ^ constants [1][0][2] ^ constants [2][0][3] ^ constants [3][0][0];
assign out_mat31 = constants [0][1][1] ^ constants [1][1][2] ^ constants [2][1][3] ^ constants [3][1][0];
assign out_mat32 = constants [0][2][1] ^ constants [1][2][2] ^ constants [2][2][3] ^ constants [3][2][0];
assign out_mat33 = constants [0][3][1] ^ constants [1][3][2] ^ constants [2][3][3] ^ constants [3][3][0];

endmodule