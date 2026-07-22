module gen_round_keys(input logic [255:0] init_key,
input logic [7:0] s_box[16][16],
input logic [31:0] rcon[8],
output logic [127:0] key0,
output logic [127:0] key1,
output logic [127:0] key2,
output logic [127:0] key3,
output logic [127:0] key4,
output logic [127:0] key5,
output logic [127:0] key6,
output logic [127:0] key7,
output logic [127:0] key8,
output logic [127:0] key9,
output logic [127:0] key10,
output logic [127:0] key11,
output logic [127:0] key12,
output logic [127:0] key13,
output logic [127:0] key14);

logic [31:0] temp;
logic [31:0] key_matrix_temp[60];
logic [31:0] rot_word[60];
/*
logic [31:0] rcon[0] = {32{1'b0}};
logic [31:0] rcon[1] = 32'h01000000;
logic [31:0] rcon[2] = 32'h02000000;
logic [31:0] rcon[3] = 32'h04000000;
logic [31:0] rcon[4] = 32'h08000000;
logic [31:0] rcon[5] = 32'h10000000;
logic [31:0] rcon[6] = 32'h20000000;
logic [31:0] rcon[7] = 32'h40000000;
*/

assign key_matrix_temp[0] = init_key[31:0];
assign key_matrix_temp[1] = init_key[63:32];
assign key_matrix_temp[2] = init_key[95:64];
assign key_matrix_temp[3] = init_key[127:96];
assign key_matrix_temp[4] = init_key[159:128];
assign key_matrix_temp[5] = init_key[191:160];
assign key_matrix_temp[6] = init_key[223:192];
assign key_matrix_temp[7] = init_key[255:224];

generate
for(genvar i = 8 ; i<60 ; i++) begin
assign rot_word[i] = (key_matrix_temp[i-1] << 8) | ({{24{1'b0}},key_matrix_temp[i-1][31:24]});
if(i%8 == 0)begin
//temp = {s_box[rot_word[i][31:28]][rot_word[i][27:24]],s_box[rot_word[i][23:20]][rot_word[i][19:16]],s_box[rot_word[i][15:12]][rot_word[i][11:8]],s_box[rot_word[i][7:4]][rot_word[i][3:0]]} ^ rcon[i/8];
assign key_matrix_temp[i] = key_matrix_temp[i-8] ^ ({s_box[rot_word[i][31:28]][rot_word[i][27:24]],s_box[rot_word[i][23:20]][rot_word[i][19:16]],s_box[rot_word[i][15:12]][rot_word[i][11:8]],s_box[rot_word[i][7:4]][rot_word[i][3:0]]} ^ rcon[i/8]);
end
else if(i%8 == 4)begin
assign key_matrix_temp[i] = key_matrix_temp[i-8] ^ {s_box[key_matrix_temp[i-1][31:28]][key_matrix_temp[i-1][27:24]],s_box[key_matrix_temp[i-1][23:20]][key_matrix_temp[i-1][19:16]],s_box[key_matrix_temp[i-1][15:12]][key_matrix_temp[i-1][11:8]],s_box[key_matrix_temp[i-1][7:4]][key_matrix_temp[i-1][3:0]]};
end
else begin
assign key_matrix_temp[i] = key_matrix_temp[i-8] ^ key_matrix_temp[i-1];
end
end
endgenerate
/*
generate
for(genvar j = 0 ; j<15 ; j++)begin
assign key_matrix[j] = {key_matrix_temp[4*j],key_matrix_temp[4*j+1],key_matrix_temp[4*j+2],key_matrix_temp[4*j+3]};
end
endgenerate
*/

assign key0 = {key_matrix_temp[0],key_matrix_temp[1],key_matrix_temp[2],key_matrix_temp[3]};
assign key1 = {key_matrix_temp[4],key_matrix_temp[5],key_matrix_temp[6],key_matrix_temp[7]};
assign key2 = {key_matrix_temp[8],key_matrix_temp[9],key_matrix_temp[10],key_matrix_temp[11]};
assign key3 = {key_matrix_temp[12],key_matrix_temp[13],key_matrix_temp[14],key_matrix_temp[15]};
assign key4 = {key_matrix_temp[16],key_matrix_temp[17],key_matrix_temp[18],key_matrix_temp[19]};
assign key5 = {key_matrix_temp[20],key_matrix_temp[21],key_matrix_temp[22],key_matrix_temp[23]};
assign key6 = {key_matrix_temp[24],key_matrix_temp[25],key_matrix_temp[26],key_matrix_temp[27]};
assign key7 = {key_matrix_temp[28],key_matrix_temp[29],key_matrix_temp[30],key_matrix_temp[31]};
assign key8 = {key_matrix_temp[32],key_matrix_temp[33],key_matrix_temp[34],key_matrix_temp[35]};
assign key9 = {key_matrix_temp[36],key_matrix_temp[37],key_matrix_temp[38],key_matrix_temp[39]};
assign key10 = {key_matrix_temp[40],key_matrix_temp[41],key_matrix_temp[42],key_matrix_temp[43]};
assign key11 = {key_matrix_temp[44],key_matrix_temp[45],key_matrix_temp[46],key_matrix_temp[47]};
assign key12 = {key_matrix_temp[48],key_matrix_temp[49],key_matrix_temp[50],key_matrix_temp[51]};
assign key13 = {key_matrix_temp[52],key_matrix_temp[53],key_matrix_temp[54],key_matrix_temp[55]};
assign key14 = {key_matrix_temp[56],key_matrix_temp[57],key_matrix_temp[58],key_matrix_temp[59]};
endmodule