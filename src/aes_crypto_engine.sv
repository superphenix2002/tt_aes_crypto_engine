module crypto_engine(input logic clk,
input logic [7:0] data_aes_in00,
input logic [7:0] data_aes_in01,
input logic [7:0] data_aes_in02,
input logic [7:0] data_aes_in03,
input logic [7:0] data_aes_in10,
input logic [7:0] data_aes_in11,
input logic [7:0] data_aes_in12,
input logic [7:0] data_aes_in13,
input logic [7:0] data_aes_in20,
input logic [7:0] data_aes_in21,
input logic [7:0] data_aes_in22,
input logic [7:0] data_aes_in23,
input logic [7:0] data_aes_in30,
input logic [7:0] data_aes_in31,
input logic [7:0] data_aes_in32,
input logic [7:0] data_aes_in33,
output logic [7:0] data_aes_out00,
output logic [7:0] data_aes_out01,
output logic [7:0] data_aes_out02,
output logic [7:0] data_aes_out03,
output logic [7:0] data_aes_out10,
output logic [7:0] data_aes_out11,
output logic [7:0] data_aes_out12,
output logic [7:0] data_aes_out13,
output logic [7:0] data_aes_out20,
output logic [7:0] data_aes_out21,
output logic [7:0] data_aes_out22,
output logic [7:0] data_aes_out23,
output logic [7:0] data_aes_out30,
output logic [7:0] data_aes_out31,
output logic [7:0] data_aes_out32,
output logic [7:0] data_aes_out33,
output logic ready,
input logic [255:0] initial_key,
input logic encrypt,
input logic reset);

logic ready_encrypt;
logic ready_decrypt;
logic reset_encrypt;
logic reset_decrypt;
logic encrypt_status;
logic [4:0] logic_count_decrypt;
logic [2:0] logic_count;
logic [7:0] s_box[16][16];
logic [255:0] initial_key_reg;
logic [31:0] rcon[8];

logic [127:0] keys0;
logic [127:0] keys1;
logic [127:0] keys2;
logic [127:0] keys3;
logic [127:0] keys4;
logic [127:0] keys5;
logic [127:0] keys6;
logic [127:0] keys7;
logic [127:0] keys8;
logic [127:0] keys9;
logic [127:0] keys10;
logic [127:0] keys11;
logic [127:0] keys12;
logic [127:0] keys13;
logic [127:0] keys14;

logic [7:0] data_aes_mat00;
logic [7:0] data_aes_mat01;
logic [7:0] data_aes_mat02;
logic [7:0] data_aes_mat03;
logic [7:0] data_aes_mat10;
logic [7:0] data_aes_mat11;
logic [7:0] data_aes_mat12;
logic [7:0] data_aes_mat13;
logic [7:0] data_aes_mat20;
logic [7:0] data_aes_mat21;
logic [7:0] data_aes_mat22;
logic [7:0] data_aes_mat23;
logic [7:0] data_aes_mat30;
logic [7:0] data_aes_mat31;
logic [7:0] data_aes_mat32;
logic [7:0] data_aes_mat33;

logic [7:0] out_plain_mat00;
logic [7:0] out_plain_mat01;
logic [7:0] out_plain_mat02;
logic [7:0] out_plain_mat03;
logic [7:0] out_plain_mat10;
logic [7:0] out_plain_mat11;
logic [7:0] out_plain_mat12;
logic [7:0] out_plain_mat13;
logic [7:0] out_plain_mat20;
logic [7:0] out_plain_mat21;
logic [7:0] out_plain_mat22;
logic [7:0] out_plain_mat23;
logic [7:0] out_plain_mat30;
logic [7:0] out_plain_mat31;
logic [7:0] out_plain_mat32;
logic [7:0] out_plain_mat33;

logic [7:0] out_cipher_mat00;
logic [7:0] out_cipher_mat01;
logic [7:0] out_cipher_mat02;
logic [7:0] out_cipher_mat03;
logic [7:0] out_cipher_mat10;
logic [7:0] out_cipher_mat11;
logic [7:0] out_cipher_mat12;
logic [7:0] out_cipher_mat13;
logic [7:0] out_cipher_mat20;
logic [7:0] out_cipher_mat21;
logic [7:0] out_cipher_mat22;
logic [7:0] out_cipher_mat23;
logic [7:0] out_cipher_mat30;
logic [7:0] out_cipher_mat31;
logic [7:0] out_cipher_mat32;
logic [7:0] out_cipher_mat33;

assign ready = ready_decrypt | ready_encrypt;

gen_round_keys gen_round_keys1(
.init_key(initial_key_reg),
.s_box(s_box),
.rcon(rcon),
.key0(keys0),
.key1(keys1),
.key2(keys2),
.key3(keys3),
.key4(keys4),
.key5(keys5),
.key6(keys6),
.key7(keys7),
.key8(keys8),
.key9(keys9),
.key10(keys10),
.key11(keys11),
.key12(keys12),
.key13(keys13),
.key14(keys14));

aes_encrypt encrypt1(
.clk(clk),
.data_aes_mat00(data_aes_mat00),
.data_aes_mat01(data_aes_mat01),
.data_aes_mat02(data_aes_mat02),
.data_aes_mat03(data_aes_mat03),
.data_aes_mat10(data_aes_mat10),
.data_aes_mat11(data_aes_mat11),
.data_aes_mat12(data_aes_mat12),
.data_aes_mat13(data_aes_mat13),
.data_aes_mat20(data_aes_mat20),
.data_aes_mat21(data_aes_mat21),
.data_aes_mat22(data_aes_mat22),
.data_aes_mat23(data_aes_mat23),
.data_aes_mat30(data_aes_mat30),
.data_aes_mat31(data_aes_mat31),
.data_aes_mat32(data_aes_mat32),
.data_aes_mat33(data_aes_mat33),
.out_cipher_mat00(out_cipher_mat00),
.out_cipher_mat01(out_cipher_mat01),
.out_cipher_mat02(out_cipher_mat02),
.out_cipher_mat03(out_cipher_mat03),
.out_cipher_mat10(out_cipher_mat10),
.out_cipher_mat11(out_cipher_mat11),
.out_cipher_mat12(out_cipher_mat12),
.out_cipher_mat13(out_cipher_mat13),
.out_cipher_mat20(out_cipher_mat20),
.out_cipher_mat21(out_cipher_mat21),
.out_cipher_mat22(out_cipher_mat22),
.out_cipher_mat23(out_cipher_mat23),
.out_cipher_mat30(out_cipher_mat30),
.out_cipher_mat31(out_cipher_mat31),
.out_cipher_mat32(out_cipher_mat32),
.out_cipher_mat33(out_cipher_mat33),
.reset(reset_encrypt),
.keys0(keys0),
.keys1(keys1),
.keys2(keys2),
.keys3(keys3),
.keys4(keys4),
.keys5(keys5),
.keys6(keys6),
.keys7(keys7),
.keys8(keys8),
.keys9(keys9),
.keys10(keys10),
.keys11(keys11),
.keys12(keys12),
.keys13(keys13),
.keys14(keys14)
.ready(ready_encrypt));

aes_decrypt decrypt1(
.clk(clk),
.data_aes_mat00(data_aes_mat00),
.data_aes_mat01(data_aes_mat01),
.data_aes_mat02(data_aes_mat02),
.data_aes_mat03(data_aes_mat03),
.data_aes_mat10(data_aes_mat10),
.data_aes_mat11(data_aes_mat11),
.data_aes_mat12(data_aes_mat12),
.data_aes_mat13(data_aes_mat13),
.data_aes_mat20(data_aes_mat20),
.data_aes_mat21(data_aes_mat21),
.data_aes_mat22(data_aes_mat22),
.data_aes_mat23(data_aes_mat23),
.data_aes_mat30(data_aes_mat30),
.data_aes_mat31(data_aes_mat31),
.data_aes_mat32(data_aes_mat32),
.data_aes_mat33(data_aes_mat33),
.out_plain_mat00(out_plain_mat00),
.out_plain_mat01(out_plain_mat01),
.out_plain_mat02(out_plain_mat02),
.out_plain_mat03(out_plain_mat03),
.out_plain_mat10(out_plain_mat10),
.out_plain_mat11(out_plain_mat11),
.out_plain_mat12(out_plain_mat12),
.out_plain_mat13(out_plain_mat13),
.out_plain_mat20(out_plain_mat20),
.out_plain_mat21(out_plain_mat21),
.out_plain_mat22(out_plain_mat22),
.out_plain_mat23(out_plain_mat23),
.out_plain_mat30(out_plain_mat30),
.out_plain_mat31(out_plain_mat31),
.out_plain_mat32(out_plain_mat32),
.out_plain_mat33(out_plain_mat33),
.reset(reset_decrypt),
.keys0(keys0),
.keys1(keys1),
.keys2(keys2),
.keys3(keys3),
.keys4(keys4),
.keys5(keys5),
.keys6(keys6),
.keys7(keys7),
.keys8(keys8),
.keys9(keys9),
.keys10(keys10),
.keys11(keys11),
.keys12(keys12),
.keys13(keys13),
.keys14(keys14),
.ready(ready_decrypt));


always_ff @(posedge clk) begin
if(reset) begin
initial_key_reg <= initial_key;

data_aes_mat00 <= data_aes_in00;
data_aes_mat01 <= data_aes_in01;
data_aes_mat02 <= data_aes_in02;
data_aes_mat03 <= data_aes_in03;
data_aes_mat10 <= data_aes_in10;
data_aes_mat11 <= data_aes_in11;
data_aes_mat12 <= data_aes_in12;
data_aes_mat13 <= data_aes_in13;
data_aes_mat20 <= data_aes_in20;
data_aes_mat21 <= data_aes_in21;
data_aes_mat22 <= data_aes_in22;
data_aes_mat23 <= data_aes_in23;
data_aes_mat30 <= data_aes_in30;
data_aes_mat31 <= data_aes_in31;
data_aes_mat32 <= data_aes_in32;
data_aes_mat33 <= data_aes_in33;

data_aes_out00 <= data_aes_out00;
data_aes_out01 <= data_aes_out01;
data_aes_out02 <= data_aes_out02;
data_aes_out03 <= data_aes_out03;
data_aes_out10 <= data_aes_out10;
data_aes_out11 <= data_aes_out11;
data_aes_out12 <= data_aes_out12;
data_aes_out13 <= data_aes_out13;
data_aes_out20 <= data_aes_out20;
data_aes_out21 <= data_aes_out21;
data_aes_out22 <= data_aes_out22;
data_aes_out23 <= data_aes_out23;
data_aes_out30 <= data_aes_out30;
data_aes_out31 <= data_aes_out31;
data_aes_out32 <= data_aes_out32;
data_aes_out33 <= data_aes_out33;

s_box[0][0] <= 8'h63;
s_box[0][1] <= 8'h7c;
s_box[0][2] <= 8'h77;
s_box[0][3] <= 8'h7b;
s_box[0][4] <= 8'hf2;
s_box[0][5] <= 8'h6b;
s_box[0][6] <= 8'h6f;
s_box[0][7] <= 8'hc5;
s_box[0][8] <= 8'h30;
s_box[0][9] <= 8'h01;
s_box[0][10] <= 8'h67;
s_box[0][11] <= 8'h2b;
s_box[0][12] <= 8'hfe;
s_box[0][13] <= 8'hd7;
s_box[0][14] <= 8'hab;
s_box[0][15] <= 8'h76;
s_box[1][0] <= 8'hca;
s_box[1][1] <= 8'h82;
s_box[1][2] <= 8'hc9;
s_box[1][3] <= 8'h7d;
s_box[1][4] <= 8'hfa;
s_box[1][5] <= 8'h59;
s_box[1][6] <= 8'h47;
s_box[1][7] <= 8'hf0;
s_box[1][8] <= 8'had;
s_box[1][9] <= 8'hd4;
s_box[1][10] <= 8'ha2;
s_box[1][11] <= 8'haf;
s_box[1][12] <= 8'h9c;
s_box[1][13] <= 8'ha4;
s_box[1][14] <= 8'h72;
s_box[1][15] <= 8'hc0;
s_box[2][0] <= 8'hb7;
s_box[2][1] <= 8'hfd;
s_box[2][2] <= 8'h93;
s_box[2][3] <= 8'h26;
s_box[2][4] <= 8'h36;
s_box[2][5] <= 8'h3f;
s_box[2][6] <= 8'hf7;
s_box[2][7] <= 8'hcc;
s_box[2][8] <= 8'h34;
s_box[2][9] <= 8'ha5;
s_box[2][10] <= 8'he5;
s_box[2][11] <= 8'hf1;
s_box[2][12] <= 8'h71;
s_box[2][13] <= 8'hd8;
s_box[2][14] <= 8'h31;
s_box[2][15] <= 8'h15;
s_box[3][0] <= 8'h04;
s_box[3][1] <= 8'hc7;
s_box[3][2] <= 8'h23;
s_box[3][3] <= 8'hc3;
s_box[3][4] <= 8'h18;
s_box[3][5] <= 8'h96;
s_box[3][6] <= 8'h05;
s_box[3][7] <= 8'h9a;
s_box[3][8] <= 8'h07;
s_box[3][9] <= 8'h12;
s_box[3][10] <= 8'h80;
s_box[3][11] <= 8'he2;
s_box[3][12] <= 8'heb;
s_box[3][13] <= 8'h27;
s_box[3][14] <= 8'hb2;
s_box[3][15] <= 8'h75;
s_box[4][0] <= 8'h09;
s_box[4][1] <= 8'h83;
s_box[4][2] <= 8'h2c;
s_box[4][3] <= 8'h1a;
s_box[4][4] <= 8'h1b;
s_box[4][5] <= 8'h6e;
s_box[4][6] <= 8'h5a;
s_box[4][7] <= 8'ha0;
s_box[4][8] <= 8'h52;
s_box[4][9] <= 8'h3b;
s_box[4][10] <= 8'hd6;
s_box[4][11] <= 8'hb3;
s_box[4][12] <= 8'h29;
s_box[4][13] <= 8'he3;
s_box[4][14] <= 8'h2f;
s_box[4][15] <= 8'h84;
s_box[5][0] <= 8'h53;
s_box[5][1] <= 8'hd1;
s_box[5][2] <= 8'h00;
s_box[5][3] <= 8'hed;
s_box[5][4] <= 8'h20;
s_box[5][5] <= 8'hfc;
s_box[5][6] <= 8'hb1;
s_box[5][7] <= 8'h5b;
s_box[5][8] <= 8'h6a;
s_box[5][9] <= 8'hcb;
s_box[5][10] <= 8'hbe;
s_box[5][11] <= 8'h39;
s_box[5][12] <= 8'h4a;
s_box[5][13] <= 8'h4c;
s_box[5][14] <= 8'h58;
s_box[5][15] <= 8'hcf;
s_box[6][0] <= 8'hd0;
s_box[6][1] <= 8'hef;
s_box[6][2] <= 8'haa;
s_box[6][3] <= 8'hfb;
s_box[6][4] <= 8'h43;
s_box[6][5] <= 8'h4d;
s_box[6][6] <= 8'h33;
s_box[6][7] <= 8'h85;
s_box[6][8] <= 8'h45;
s_box[6][9] <= 8'hf9;
s_box[6][10] <= 8'h02;
s_box[6][11] <= 8'h7f;
s_box[6][12] <= 8'h50;
s_box[6][13] <= 8'h3c;
s_box[6][14] <= 8'h9f;
s_box[6][15] <= 8'ha8;
s_box[7][0] <= 8'h51;
s_box[7][1] <= 8'ha3;
s_box[7][2] <= 8'h40;
s_box[7][3] <= 8'h8f;
s_box[7][4] <= 8'h92;
s_box[7][5] <= 8'h9d;
s_box[7][6] <= 8'h38;
s_box[7][7] <= 8'hf5;
s_box[7][8] <= 8'hbc;
s_box[7][9] <= 8'hb6;
s_box[7][10] <= 8'hda;
s_box[7][11] <= 8'h21;
s_box[7][12] <= 8'h10;
s_box[7][13] <= 8'hff;
s_box[7][14] <= 8'hf3;
s_box[7][15] <= 8'hd2;
s_box[8][0] <= 8'hcd;
s_box[8][1] <= 8'h0c;
s_box[8][2] <= 8'h13;
s_box[8][3] <= 8'hec;
s_box[8][4] <= 8'h5f;
s_box[8][5] <= 8'h97;
s_box[8][6] <= 8'h44;
s_box[8][7] <= 8'h17;
s_box[8][8] <= 8'hc4;
s_box[8][9] <= 8'ha7;
s_box[8][10] <= 8'h7e;
s_box[8][11] <= 8'h3d;
s_box[8][12] <= 8'h64;
s_box[8][13] <= 8'h5d;
s_box[8][14] <= 8'h19;
s_box[8][15] <= 8'h73;
s_box[9][0] <= 8'h60;
s_box[9][1] <= 8'h81;
s_box[9][2] <= 8'h4f;
s_box[9][3] <= 8'hdc;
s_box[9][4] <= 8'h22;
s_box[9][5] <= 8'h2a;
s_box[9][6] <= 8'h90;
s_box[9][7] <= 8'h88;
s_box[9][8] <= 8'h46;
s_box[9][9] <= 8'hee;
s_box[9][10] <= 8'hb8;
s_box[9][11] <= 8'h14;
s_box[9][12] <= 8'hde;
s_box[9][13] <= 8'h5e;
s_box[9][14] <= 8'h0b;
s_box[9][15] <= 8'hdb;
s_box[10][0] <= 8'he0;
s_box[10][1] <= 8'h32;
s_box[10][2] <= 8'h3a;
s_box[10][3] <= 8'h0a;
s_box[10][4] <= 8'h49;
s_box[10][5] <= 8'h06;
s_box[10][6] <= 8'h24;
s_box[10][7] <= 8'h5c;
s_box[10][8] <= 8'hc2;
s_box[10][9] <= 8'hd3;
s_box[10][10] <= 8'hac;
s_box[10][11] <= 8'h62;
s_box[10][12] <= 8'h91;
s_box[10][13] <= 8'h95;
s_box[10][14] <= 8'he4;
s_box[10][15] <= 8'h79;
s_box[11][0] <= 8'he7;
s_box[11][1] <= 8'hc8;
s_box[11][2] <= 8'h37;
s_box[11][3] <= 8'h6d;
s_box[11][4] <= 8'h8d;
s_box[11][5] <= 8'hd5;
s_box[11][6] <= 8'h4e;
s_box[11][7] <= 8'ha9;
s_box[11][8] <= 8'h6c;
s_box[11][9] <= 8'h56;
s_box[11][10] <= 8'hf4;
s_box[11][11] <= 8'hea;
s_box[11][12] <= 8'h65;
s_box[11][13] <= 8'h7a;
s_box[11][14] <= 8'hae;
s_box[11][15] <= 8'h08;
s_box[12][0] <= 8'hba;
s_box[12][1] <= 8'h78;
s_box[12][2] <= 8'h25;
s_box[12][3] <= 8'h2e;
s_box[12][4] <= 8'h1c;
s_box[12][5] <= 8'ha6;
s_box[12][6] <= 8'hb4;
s_box[12][7] <= 8'hc6;
s_box[12][8] <= 8'he8;
s_box[12][9] <= 8'hdd;
s_box[12][10] <= 8'h74;
s_box[12][11] <= 8'h1f;
s_box[12][12] <= 8'h4b;
s_box[12][13] <= 8'hbd;
s_box[12][14] <= 8'h8b;
s_box[12][15] <= 8'h8a;
s_box[13][0] <= 8'h70;
s_box[13][1] <= 8'h3e;
s_box[13][2] <= 8'hb5;
s_box[13][3] <= 8'h66;
s_box[13][4] <= 8'h48;
s_box[13][5] <= 8'h03;
s_box[13][6] <= 8'hf6;
s_box[13][7] <= 8'h0e;
s_box[13][8] <= 8'h61;
s_box[13][9] <= 8'h35;
s_box[13][10] <= 8'h57;
s_box[13][11] <= 8'hb9;
s_box[13][12] <= 8'h86;
s_box[13][13] <= 8'hc1;
s_box[13][14] <= 8'h1d;
s_box[13][15] <= 8'h9e;
s_box[14][0] <= 8'he1;
s_box[14][1] <= 8'hf8;
s_box[14][2] <= 8'h98;
s_box[14][3] <= 8'h11;
s_box[14][4] <= 8'h69;
s_box[14][5] <= 8'hd9;
s_box[14][6] <= 8'h8e;
s_box[14][7] <= 8'h94;
s_box[14][8] <= 8'h9b;
s_box[14][9] <= 8'h1e;
s_box[14][10] <= 8'h87;
s_box[14][11] <= 8'he9;
s_box[14][12] <= 8'hce;
s_box[14][13] <= 8'h55;
s_box[14][14] <= 8'h28;
s_box[14][15] <= 8'hdf;
s_box[15][0] <= 8'h8c;
s_box[15][1] <= 8'ha1;
s_box[15][2] <= 8'h89;
s_box[15][3] <= 8'h0d;
s_box[15][4] <= 8'hbf;
s_box[15][5] <= 8'he6;
s_box[15][6] <= 8'h42;
s_box[15][7] <= 8'h68;
s_box[15][8] <= 8'h41;
s_box[15][9] <= 8'h99;
s_box[15][10] <= 8'h2d;
s_box[15][11] <= 8'h0f;
s_box[15][12] <= 8'hb0;
s_box[15][13] <= 8'h54;
s_box[15][14] <= 8'hbb;
s_box[15][15] <= 8'h16;

rcon[0] <= {32{1'b0}};
rcon[1] <= 32'h01000000;
rcon[2] <= 32'h02000000;
rcon[3] <= 32'h04000000;
rcon[4] <= 32'h08000000;
rcon[5] <= 32'h10000000;
rcon[6] <= 32'h20000000;
rcon[7] <= 32'h40000000;
logic_count <= 3'b000;
logic_count_decrypt <= 5'b00000;
reset_decrypt <= 1'b0;
reset_encrypt <= 1'b0;
if(encrypt) begin          //encrypt
encrypt_status <= 1'b1;

end
else begin            //decrypt
encrypt_status <= 1'b0;

end
end
else begin                        //not reset
initial_key_reg <= initial_key_reg;

encrypt_status <= encrypt_status;

if(encrypt_status == 1'b1) begin  //encrypt
logic_count_decrypt <= 5'b00000;
reset_decrypt <= 1'b0;
if(logic_count == 3'b011)begin
logic_count <= 3'b100;
reset_encrypt <= 1'b1;
end
else if(logic_count < 3'b011) begin
logic_count <= logic_count + 3'b001;
reset_encrypt <= 1'b0;
end
else begin
logic_count <= logic_count;
reset_encrypt <= 1'b0;
end
data_aes_out00 <= out_cipher_mat00;
data_aes_out01 <= out_cipher_mat01;
data_aes_out02 <= out_cipher_mat02;
data_aes_out03 <= out_cipher_mat03;
data_aes_out10 <= out_cipher_mat10;
data_aes_out11 <= out_cipher_mat11;
data_aes_out12 <= out_cipher_mat12;
data_aes_out13 <= out_cipher_mat13;
data_aes_out20 <= out_cipher_mat20;
data_aes_out21 <= out_cipher_mat21;
data_aes_out22 <= out_cipher_mat22;
data_aes_out23 <= out_cipher_mat23;
data_aes_out30 <= out_cipher_mat30;
data_aes_out31 <= out_cipher_mat31;
data_aes_out32 <= out_cipher_mat32;
data_aes_out33 <= out_cipher_mat33;
end
else if(encrypt_status == 1'b0) begin            //decrypt
logic_count <= 3'b000;
reset_encrypt <= 1'b0;
if(logic_count_decrypt == 5'b01111)begin
logic_count_decrypt <= 5'b10000;
reset_decrypt <= 1'b1;
end
else if(logic_count_decrypt < 5'b01111) begin
logic_count_decrypt <= logic_count_decrypt + 5'b00001;
reset_decrypt <= 1'b0;
end
else begin
logic_count_decrypt <= logic_count_decrypt;
reset_decrypt <=1'b0;
end
data_aes_out00 <= out_plain_mat00;
data_aes_out01 <= out_plain_mat01;
data_aes_out02 <= out_plain_mat02;
data_aes_out03 <= out_plain_mat03;
data_aes_out10 <= out_plain_mat10;
data_aes_out11 <= out_plain_mat11;
data_aes_out12 <= out_plain_mat12;
data_aes_out13 <= out_plain_mat13;
data_aes_out20 <= out_plain_mat20;
data_aes_out21 <= out_plain_mat21;
data_aes_out22 <= out_plain_mat22;
data_aes_out23 <= out_plain_mat23;
data_aes_out30 <= out_plain_mat30;
data_aes_out31 <= out_plain_mat31;
data_aes_out32 <= out_plain_mat32;
data_aes_out33 <= out_plain_mat33;
end

data_aes_mat00 <= data_aes_mat00;
data_aes_mat01 <= data_aes_mat01;
data_aes_mat02 <= data_aes_mat02;
data_aes_mat03 <= data_aes_mat03;
data_aes_mat10 <= data_aes_mat10;
data_aes_mat11 <= data_aes_mat11;
data_aes_mat12 <= data_aes_mat12;
data_aes_mat13 <= data_aes_mat13;
data_aes_mat20 <= data_aes_mat20;
data_aes_mat21 <= data_aes_mat21;
data_aes_mat22 <= data_aes_mat22;
data_aes_mat23 <= data_aes_mat23;
data_aes_mat30 <= data_aes_mat30;
data_aes_mat31 <= data_aes_mat31;
data_aes_mat32 <= data_aes_mat32;
data_aes_mat33 <= data_aes_mat33;

rcon[0] <= rcon[0];
rcon[1] <= rcon[1];
rcon[2] <= rcon[2];
rcon[3] <= rcon[3];
rcon[4] <= rcon[4];
rcon[5] <= rcon[5];
rcon[6] <= rcon[6];
rcon[7] <= rcon[7];

s_box[0][0] <= s_box[0][0];
s_box[0][1] <= s_box[0][1];
s_box[0][2] <= s_box[0][2];
s_box[0][3] <= s_box[0][3];
s_box[0][4] <= s_box[0][4];
s_box[0][5] <= s_box[0][5];
s_box[0][6] <= s_box[0][6];
s_box[0][7] <= s_box[0][7];
s_box[0][8] <= s_box[0][8];
s_box[0][9] <= s_box[0][9];
s_box[0][10] <= s_box[0][10];
s_box[0][11] <= s_box[0][11];
s_box[0][12] <= s_box[0][12];
s_box[0][13] <= s_box[0][13];
s_box[0][14] <= s_box[0][14];
s_box[0][15] <= s_box[0][15];
s_box[1][0] <= s_box[1][0];
s_box[1][1] <= s_box[1][1];
s_box[1][2] <= s_box[1][2];
s_box[1][3] <= s_box[1][3];
s_box[1][4] <= s_box[1][4];
s_box[1][5] <= s_box[1][5];
s_box[1][6] <= s_box[1][6];
s_box[1][7] <= s_box[1][7];
s_box[1][8] <= s_box[1][8];
s_box[1][9] <= s_box[1][9];
s_box[1][10] <= s_box[1][10];
s_box[1][11] <= s_box[1][11];
s_box[1][12] <= s_box[1][12];
s_box[1][13] <= s_box[1][13];
s_box[1][14] <= s_box[1][14];
s_box[1][15] <= s_box[1][15];
s_box[2][0] <= s_box[2][0];
s_box[2][1] <= s_box[2][1];
s_box[2][2] <= s_box[2][2];
s_box[2][3] <= s_box[2][3];
s_box[2][4] <= s_box[2][4];
s_box[2][5] <= s_box[2][5];
s_box[2][6] <= s_box[2][6];
s_box[2][7] <= s_box[2][7];
s_box[2][8] <= s_box[2][8];
s_box[2][9] <= s_box[2][9];
s_box[2][10] <= s_box[2][10];
s_box[2][11] <= s_box[2][11];
s_box[2][12] <= s_box[2][12];
s_box[2][13] <= s_box[2][13];
s_box[2][14] <= s_box[2][14];
s_box[2][15] <= s_box[2][15];
s_box[3][0] <= s_box[3][0];
s_box[3][1] <= s_box[3][1];
s_box[3][2] <= s_box[3][2];
s_box[3][3] <= s_box[3][3];
s_box[3][4] <= s_box[3][4];
s_box[3][5] <= s_box[3][5];
s_box[3][6] <= s_box[3][6];
s_box[3][7] <= s_box[3][7];
s_box[3][8] <= s_box[3][8];
s_box[3][9] <= s_box[3][9];
s_box[3][10] <= s_box[3][10];
s_box[3][11] <= s_box[3][11];
s_box[3][12] <= s_box[3][12];
s_box[3][13] <= s_box[3][13];
s_box[3][14] <= s_box[3][14];
s_box[3][15] <= s_box[3][15];
s_box[4][0] <= s_box[4][0];
s_box[4][1] <= s_box[4][1];
s_box[4][2] <= s_box[4][2];
s_box[4][3] <= s_box[4][3];
s_box[4][4] <= s_box[4][4];
s_box[4][5] <= s_box[4][5];
s_box[4][6] <= s_box[4][6];
s_box[4][7] <= s_box[4][7];
s_box[4][8] <= s_box[4][8];
s_box[4][9] <= s_box[4][9];
s_box[4][10] <= s_box[4][10];
s_box[4][11] <= s_box[4][11];
s_box[4][12] <= s_box[4][12];
s_box[4][13] <= s_box[4][13];
s_box[4][14] <= s_box[4][14];
s_box[4][15] <= s_box[4][15];
s_box[5][0] <= s_box[5][0];
s_box[5][1] <= s_box[5][1];
s_box[5][2] <= s_box[5][2];
s_box[5][3] <= s_box[5][3];
s_box[5][4] <= s_box[5][4];
s_box[5][5] <= s_box[5][5];
s_box[5][6] <= s_box[5][6];
s_box[5][7] <= s_box[5][7];
s_box[5][8] <= s_box[5][8];
s_box[5][9] <= s_box[5][9];
s_box[5][10] <= s_box[5][10];
s_box[5][11] <= s_box[5][11];
s_box[5][12] <= s_box[5][12];
s_box[5][13] <= s_box[5][13];
s_box[5][14] <= s_box[5][14];
s_box[5][15] <= s_box[5][15];
s_box[6][0] <= s_box[6][0];
s_box[6][1] <= s_box[6][1];
s_box[6][2] <= s_box[6][2];
s_box[6][3] <= s_box[6][3];
s_box[6][4] <= s_box[6][4];
s_box[6][5] <= s_box[6][5];
s_box[6][6] <= s_box[6][6];
s_box[6][7] <= s_box[6][7];
s_box[6][8] <= s_box[6][8];
s_box[6][9] <= s_box[6][9];
s_box[6][10] <= s_box[6][10];
s_box[6][11] <= s_box[6][11];
s_box[6][12] <= s_box[6][12];
s_box[6][13] <= s_box[6][13];
s_box[6][14] <= s_box[6][14];
s_box[6][15] <= s_box[6][15];
s_box[7][0] <= s_box[7][0];
s_box[7][1] <= s_box[7][1];
s_box[7][2] <= s_box[7][2];
s_box[7][3] <= s_box[7][3];
s_box[7][4] <= s_box[7][4];
s_box[7][5] <= s_box[7][5];
s_box[7][6] <= s_box[7][6];
s_box[7][7] <= s_box[7][7];
s_box[7][8] <= s_box[7][8];
s_box[7][9] <= s_box[7][9];
s_box[7][10] <= s_box[7][10];
s_box[7][11] <= s_box[7][11];
s_box[7][12] <= s_box[7][12];
s_box[7][13] <= s_box[7][13];
s_box[7][14] <= s_box[7][14];
s_box[7][15] <= s_box[7][15];
s_box[8][0] <= s_box[8][0];
s_box[8][1] <= s_box[8][1];
s_box[8][2] <= s_box[8][2];
s_box[8][3] <= s_box[8][3];
s_box[8][4] <= s_box[8][4];
s_box[8][5] <= s_box[8][5];
s_box[8][6] <= s_box[8][6];
s_box[8][7] <= s_box[8][7];
s_box[8][8] <= s_box[8][8];
s_box[8][9] <= s_box[8][9];
s_box[8][10] <= s_box[8][10];
s_box[8][11] <= s_box[8][11];
s_box[8][12] <= s_box[8][12];
s_box[8][13] <= s_box[8][13];
s_box[8][14] <= s_box[8][14];
s_box[8][15] <= s_box[8][15];
s_box[9][0] <= s_box[9][0];
s_box[9][1] <= s_box[9][1];
s_box[9][2] <= s_box[9][2];
s_box[9][3] <= s_box[9][3];
s_box[9][4] <= s_box[9][4];
s_box[9][5] <= s_box[9][5];
s_box[9][6] <= s_box[9][6];
s_box[9][7] <= s_box[9][7];
s_box[9][8] <= s_box[9][8];
s_box[9][9] <= s_box[9][9];
s_box[9][10] <= s_box[9][10];
s_box[9][11] <= s_box[9][11];
s_box[9][12] <= s_box[9][12];
s_box[9][13] <= s_box[9][13];
s_box[9][14] <= s_box[9][14];
s_box[9][15] <= s_box[9][15];
s_box[10][0] <= s_box[10][0];
s_box[10][1] <= s_box[10][1];
s_box[10][2] <= s_box[10][2];
s_box[10][3] <= s_box[10][3];
s_box[10][4] <= s_box[10][4];
s_box[10][5] <= s_box[10][5];
s_box[10][6] <= s_box[10][6];
s_box[10][7] <= s_box[10][7];
s_box[10][8] <= s_box[10][8];
s_box[10][9] <= s_box[10][9];
s_box[10][10] <= s_box[10][10];
s_box[10][11] <= s_box[10][11];
s_box[10][12] <= s_box[10][12];
s_box[10][13] <= s_box[10][13];
s_box[10][14] <= s_box[10][14];
s_box[10][15] <= s_box[10][15];
s_box[11][0] <= s_box[11][0];
s_box[11][1] <= s_box[11][1];
s_box[11][2] <= s_box[11][2];
s_box[11][3] <= s_box[11][3];
s_box[11][4] <= s_box[11][4];
s_box[11][5] <= s_box[11][5];
s_box[11][6] <= s_box[11][6];
s_box[11][7] <= s_box[11][7];
s_box[11][8] <= s_box[11][8];
s_box[11][9] <= s_box[11][9];
s_box[11][10] <= s_box[11][10];
s_box[11][11] <= s_box[11][11];
s_box[11][12] <= s_box[11][12];
s_box[11][13] <= s_box[11][13];
s_box[11][14] <= s_box[11][14];
s_box[11][15] <= s_box[11][15];
s_box[12][0] <= s_box[12][0];
s_box[12][1] <= s_box[12][1];
s_box[12][2] <= s_box[12][2];
s_box[12][3] <= s_box[12][3];
s_box[12][4] <= s_box[12][4];
s_box[12][5] <= s_box[12][5];
s_box[12][6] <= s_box[12][6];
s_box[12][7] <= s_box[12][7];
s_box[12][8] <= s_box[12][8];
s_box[12][9] <= s_box[12][9];
s_box[12][10] <= s_box[12][10];
s_box[12][11] <= s_box[12][11];
s_box[12][12] <= s_box[12][12];
s_box[12][13] <= s_box[12][13];
s_box[12][14] <= s_box[12][14];
s_box[12][15] <= s_box[12][15];
s_box[13][0] <= s_box[13][0];
s_box[13][1] <= s_box[13][1];
s_box[13][2] <= s_box[13][2];
s_box[13][3] <= s_box[13][3];
s_box[13][4] <= s_box[13][4];
s_box[13][5] <= s_box[13][5];
s_box[13][6] <= s_box[13][6];
s_box[13][7] <= s_box[13][7];
s_box[13][8] <= s_box[13][8];
s_box[13][9] <= s_box[13][9];
s_box[13][10] <= s_box[13][10];
s_box[13][11] <= s_box[13][11];
s_box[13][12] <= s_box[13][12];
s_box[13][13] <= s_box[13][13];
s_box[13][14] <= s_box[13][14];
s_box[13][15] <= s_box[13][15];
s_box[14][0] <= s_box[14][0];
s_box[14][1] <= s_box[14][1];
s_box[14][2] <= s_box[14][2];
s_box[14][3] <= s_box[14][3];
s_box[14][4] <= s_box[14][4];
s_box[14][5] <= s_box[14][5];
s_box[14][6] <= s_box[14][6];
s_box[14][7] <= s_box[14][7];
s_box[14][8] <= s_box[14][8];
s_box[14][9] <= s_box[14][9];
s_box[14][10] <= s_box[14][10];
s_box[14][11] <= s_box[14][11];
s_box[14][12] <= s_box[14][12];
s_box[14][13] <= s_box[14][13];
s_box[14][14] <= s_box[14][14];
s_box[14][15] <= s_box[14][15];
s_box[15][0] <= s_box[15][0];
s_box[15][1] <= s_box[15][1];
s_box[15][2] <= s_box[15][2];
s_box[15][3] <= s_box[15][3];
s_box[15][4] <= s_box[15][4];
s_box[15][5] <= s_box[15][5];
s_box[15][6] <= s_box[15][6];
s_box[15][7] <= s_box[15][7];
s_box[15][8] <= s_box[15][8];
s_box[15][9] <= s_box[15][9];
s_box[15][10] <= s_box[15][10];
s_box[15][11] <= s_box[15][11];
s_box[15][12] <= s_box[15][12];
s_box[15][13] <= s_box[15][13];
s_box[15][14] <= s_box[15][14];
s_box[15][15] <= s_box[15][15];

end



end


endmodule