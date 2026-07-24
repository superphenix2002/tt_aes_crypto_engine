module aes_wrapper(
input logic mosi,
output logic miso,
input logic sclk,             // SPI clk = 100MHz
input logic ss,
input logic rst);              //CPOL - 1 , CPHA - 1     , ss active low             always reset chip once before starting communication with it, (rst high)

logic key_sampling_mode;   //sampling 256 bit key mode         ,cmd word :  01 hex            MSB first
logic operation_mode;      //encryption or decryption selection mode  , cmd word :  02 hex
logic input_data_mode;     //samples entries of cryptography matrix (data in)  , cmd word : 03 hex
logic output_data_mode;     //sending output data mode            , cmd word : 05  hex
logic interrogate;           //interrogates if crypto engine is ready with result, cmd word: 04 hex
logic key_ok;                 //high when 256 bit key is fully loaded in buffer
logic data_ok;                //high when input data is loaded fully
logic crypto_ok;               //high when cryptography mode is fully loaded
//assign reset_buff = key_ok & data_ok & crypto_ok;
logic [3:0] mosi_cnt;
logic [3:0] miso_cnt;
logic inhibit;            //inhibits start of any other mode while mode is active
//receiver acknowledge code word = 01 hex
//receiver not acknowledge code word = 00 hex
//ACK -> 8'h11 on tx_buff
logic [7:0] rx_buff;
logic [7:0] tx_buff;
logic [5:0] op_cnt;
logic clk_crypto;
logic dly_clk;

logic [255:0] initial_key_buff;

logic encrypt_buff;
logic reset_buff;
logic output_rdy;          //active high when output is ready from cryptography engine

logic [7:0] input_buff00;
logic [7:0] input_buff01;
logic [7:0] input_buff02;
logic [7:0] input_buff03;
logic [7:0] input_buff10;
logic [7:0] input_buff11;
logic [7:0] input_buff12;
logic [7:0] input_buff13;
logic [7:0] input_buff20;
logic [7:0] input_buff21;
logic [7:0] input_buff22;
logic [7:0] input_buff23;
logic [7:0] input_buff30;
logic [7:0] input_buff31;
logic [7:0] input_buff32;
logic [7:0] input_buff33;

logic [7:0] output_buff00;
logic [7:0] output_buff01;
logic [7:0] output_buff02;
logic [7:0] output_buff03;
logic [7:0] output_buff10;
logic [7:0] output_buff11;
logic [7:0] output_buff12;
logic [7:0] output_buff13;
logic [7:0] output_buff20;
logic [7:0] output_buff21;
logic [7:0] output_buff22;
logic [7:0] output_buff23;
logic [7:0] output_buff30;
logic [7:0] output_buff31;
logic [7:0] output_buff32;
logic [7:0] output_buff33;

assign reset_buff = key_ok & data_ok & crypto_ok;

crypto_clk_synth synth1(
.clk(sclk),
.ss(ss),
.crypto_clk(clk_crypto));

dly_module dly1(
.input_clk(clk_crypto),
.output_clk(dly_clk));

crypto_engine engine1(
.clk(dly_clk),
.initial_key(initial_key_buff),
.encrypt(encrypt_buff),
.reset(reset_buff),
.data_aes_in00(input_buff00),
.data_aes_in01(input_buff01),
.data_aes_in02(input_buff02),
.data_aes_in03(input_buff03),
.data_aes_in10(input_buff10),
.data_aes_in11(input_buff11),
.data_aes_in12(input_buff12),
.data_aes_in13(input_buff13),
.data_aes_in20(input_buff20),
.data_aes_in21(input_buff21),
.data_aes_in22(input_buff22),
.data_aes_in23(input_buff23),
.data_aes_in30(input_buff30),
.data_aes_in31(input_buff31),
.data_aes_in32(input_buff32),
.data_aes_in33(input_buff33),
.data_aes_out00(output_buff00),
.data_aes_out01(output_buff01),
.data_aes_out02(output_buff02),
.data_aes_out03(output_buff03),
.data_aes_out10(output_buff10),
.data_aes_out11(output_buff11),
.data_aes_out12(output_buff12),
.data_aes_out13(output_buff13),
.data_aes_out20(output_buff20),
.data_aes_out21(output_buff21),
.data_aes_out22(output_buff22),
.data_aes_out23(output_buff23),
.data_aes_out30(output_buff30),
.data_aes_out31(output_buff31),
.data_aes_out32(output_buff32),
.data_aes_out33(output_buff33),
.ready(output_rdy));

always_ff @(posedge dly_clk) begin

if(rst)begin                          //reset
op_cnt <= 6'b000000;
key_sampling_mode <= 1'b0;
operation_mode <= 1'b0;
input_data_mode <= 1'b0;
output_data_mode <= 1'b0;
interrogate <= 1'b0;
inhibit <= 1'b0;
tx_buff <= 8'h00;    
input_buff00 <= 8'h00;
input_buff01 <= 8'h00;
input_buff02 <= 8'h00;
input_buff03 <= 8'h00;
input_buff10 <= 8'h00;
input_buff11 <= 8'h00;
input_buff12 <= 8'h00;
input_buff13 <= 8'h00;
input_buff20 <= 8'h00;
input_buff21 <= 8'h00;
input_buff22 <= 8'h00;
input_buff23 <= 8'h00;
input_buff30 <= 8'h00;
input_buff31 <= 8'h00;
input_buff32 <= 8'h00;
input_buff33 <= 8'h00;
encrypt_buff <= 1'b0;
initial_key_buff <= {256{1'b0}};
key_ok <= 1'b0;
crypto_ok <= 1'b0;
data_ok <= 1'b0;
end
else begin                          //not reset
if(!ss) begin                     // ss is low , chip enabled
//setting up modes
if((rx_buff == 2'h01)&&(!inhibit))begin        //key sampling mode
op_cnt <= 6'b000000;
key_sampling_mode <= 1'b1;
operation_mode <= 1'b0;
input_data_mode <= 1'b0;
output_data_mode <= 1'b0;
interrogate <= 1'b0;
inhibit <= 1'b1;
tx_buff <= 8'h11;    //ack
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= initial_key_buff;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
end
else if((rx_buff == 2'h02)&&(!inhibit))begin        //operation mode
op_cnt <= 6'b000000;
key_sampling_mode <= 1'b0;
operation_mode <= 1'b1;
input_data_mode <= 1'b0;
output_data_mode <= 1'b0;
interrogate <= 1'b0;
inhibit <= 1'b1;
tx_buff <= 8'h11;    //ack
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= initial_key_buff;
key_ok <= key_ok;
crypto_ok <= 1'b0;
data_ok <= data_ok;
end
else if((rx_buff == 2'h03)&&(!inhibit))begin        //input data mode
op_cnt <= 6'b000000;
key_sampling_mode <= 1'b0;
operation_mode <= 1'b0;
input_data_mode <= 1'b1;
output_data_mode <= 1'b0;
interrogate <= 1'b0;
inhibit <= 1'b1;
tx_buff <= 8'h11;    //ack
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= initial_key_buff;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
end
else if((rx_buff == 2'h04)&&(!inhibit))begin        //interrogate mode
op_cnt <= 6'b000000;
key_sampling_mode <= 1'b0;
operation_mode <= 1'b0;
input_data_mode <= 1'b0;
output_data_mode <= 1'b0;
interrogate <= 1'b1;
inhibit <= 1'b1;
tx_buff <= 8'h11;    //ack
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= initial_key_buff;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
end
else if((rx_buff == 2'h05)&&(!inhibit))begin        //output data mode
op_cnt <= 6'b000000;
key_sampling_mode <= 1'b0;
operation_mode <= 1'b0;
input_data_mode <= 1'b0;
output_data_mode <= 1'b1;
interrogate <= 1'b0;
inhibit <= 1'b1;
tx_buff <= 8'h11;    //ack
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= initial_key_buff;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
end

//
if(key_sampling_mode) begin         //key input
case(op_cnt)
6'b000000: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b000001:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b000010:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b000011:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b000100: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b000101: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b000110: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b000111: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b001000: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b001001: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b001010: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b001011: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b001100: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b001101: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b001110: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b001111: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b010000: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b010001: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b010010: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b010011: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b010100: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b010101: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b010110: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b010111: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b011000: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b011001: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b011010: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b011011: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b011100: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b011101: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b011110: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= op_cnt + 1;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
6'b011111: begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= (initial_key_buff << 8) | {{248{1'b0}},rx_buff};
op_cnt <= 6'b000000;
key_sampling_mode <= 1'b0;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= 1'b0;
key_ok <= 1'b1;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
tx_buff <= 8'h00;
end
endcase
end
//
if(operation_mode)begin              //operation choice encrypt or decrypt
case(op_cnt)
6'b000000:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
if(rx_buff == 2'h01)begin
encrypt_buff <= 1'b1;             //encrypt
end
else if(rx_buff == 2'h00)begin
encrypt_buff <= 1'b0;              //decrypt
end
else begin
encrypt_buff <= 1'b1;           //default(encrypt)
end
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= 1'b0;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= 1'b0;
key_ok <= key_ok;
crypto_ok <= 1'b1;
data_ok <= data_ok;
op_cnt <= 6'b000000;
end
endcase
end
//
//
if(input_mode)begin              //input data mode
case(op_cnt)
6'b000000:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= rx_buff;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b000001:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= rx_buff;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b000010:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= rx_buff;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b000011:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= rx_buff;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b000100:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= rx_buff;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b000101:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= rx_buff;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b000110:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= rx_buff;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b000111:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= rx_buff;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b001000:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= rx_buff;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b001001:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= rx_buff;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b001010:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= rx_buff;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b001011:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= rx_buff;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b001100:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= rx_buff;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b001101:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= rx_buff;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b001110:begin
input_buff00 <= input_buff00;
input_buff01 <= rx_buff;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b0;
op_cnt <= op_cnt + 1;
end
6'b001111:begin
input_buff00 <= rx_buff;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= 1'b0;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= 1'b0;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= 1'b1;
op_cnt <= 6'b000000;
end
endcase
end
//
//
if(interrogate)begin              //interrogate mode
case(op_cnt)
6'b000000:begin
if(output_rdy)begin
tx_buff <= 8'h01;      //output ready
end
else begin
tx_buff <= 8'h00;      //output not ready
end
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= 1'b0;
inhibit <= 1'b0;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= 6'b000000;
end
endcase
end
//
//
if(output_data_mode)begin                 //outputs data
case(op_cnt)
6'b000000:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff33;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b000001:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff32;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b000010:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff31;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b000011:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff30;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b000100:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff23;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b000101:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff22;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b000110:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff21;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b000111:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff20;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b001000:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff13;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b001001:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff12;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b001010:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff11;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b001011:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff10;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b001100:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff03;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b001101:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff02;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b001110:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff01;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt + 1;
end
6'b001111:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= output_buff00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= 1'b0;
interrogate <= interrogate;
inhibit <= 1'b0;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= 6'b000000;
end
endcase
end
//
//
if((!key_sampling_mode)&&(!operation_mode)&&(!input_data_mode)&&(!inhibit)&&(rx_buff != 2'h01)&&(rx_buff != 2'h02)&&(rx_buff != 2'h03))begin           //no mode case
case(op_cnt)
6'b000000:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= 1'b0;
crypto_ok <= 1'b0;
data_ok <= 1'b0;
op_cnt <= 6'b000000;
end
endcase
end
//
//
if((!interrogate)&&(!output_data_mode)&&(!inhibit)&&(rx_buff != 2'h04)&&(rx_buff != 2'h05))begin           //no mode case
case(op_cnt)
6'b000000:begin
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= 6'b000000;
end
endcase
end
//
end
else begin                     //if ss is high
input_buff00 <= input_buff00;
input_buff01 <= input_buff01;
input_buff02 <= input_buff02;
input_buff03 <= input_buff03;
input_buff10 <= input_buff10;
input_buff11 <= input_buff11;
input_buff12 <= input_buff12;
input_buff13 <= input_buff13;
input_buff20 <= input_buff20;
input_buff21 <= input_buff21;
input_buff22 <= input_buff22;
input_buff23 <= input_buff23;
input_buff30 <= input_buff30;
input_buff31 <= input_buff31;
input_buff32 <= input_buff32;
input_buff33 <= input_buff33;
encrypt_buff <= encrypt_buff;
tx_buff <= 8'h00;
initial_key_buff <= initial_key_buff;
key_sampling_mode <= key_sampling_mode;
operation_mode <= operation_mode;
input_data_mode <= input_data_mode;
output_data_mode <= output_data_mode;
interrogate <= interrogate;
inhibit <= inhibit;
key_ok <= key_ok;
crypto_ok <= crypto_ok;
data_ok <= data_ok;
op_cnt <= op_cnt;
end
end
end

always_ff @(negedge sclk) begin          
if(!ss) begin
//miso driver
case(miso_cnt)
3'b000:begin
miso <= tx_buff[7];
miso_cnt <= miso_cnt + 1;
end
3'b001:begin
miso <= tx_buff[6];
miso_cnt <= miso_cnt + 1;
end
3'b0010:begin
miso <= tx_buff[5];
miso_cnt <= miso_cnt + 1;
end
3'b011:begin
miso <= tx_buff[4];
miso_cnt <= miso_cnt + 1;
end
3'b100:begin
miso <= tx_buff[3];
miso_cnt <= miso_cnt + 1;
end
3'b101:begin
miso <= tx_buff[2];
miso_cnt <= miso_cnt + 1;
end
3'b110:begin
miso <= tx_buff[1];
miso_cnt <= miso_cnt + 1;
end
3'b111:begin
miso <= tx_buff[0];
miso_cnt <= 3'b000;
end
endcase
end
else begin
miso <= 1'bz;
miso_cnt <= 3'b000;
end
end

always_ff @(posedge sclk) begin
if(!ss) begin
//mosi driver
case(mosi_cnt)
3'b000:begin
rx_buff[0] <= mosi;
rx_buff <= rx_buff << 1;
mosi_cnt <= mosi_cnt + 1;
end
3'b001:begin
rx_buff[0] <= mosi;
rx_buff <= rx_buff << 1;
mosi_cnt <= mosi_cnt + 1;
end
3'b0010:begin
rx_buff[0] <= mosi;
rx_buff <= rx_buff << 1;
mosi_cnt <= mosi_cnt + 1;
end
3'b011:begin
rx_buff[0] <= mosi;
rx_buff <= rx_buff << 1;
mosi_cnt <= mosi_cnt + 1;
end
3'b100:begin
rx_buff[0] <= mosi;
rx_buff <= rx_buff << 1;
mosi_cnt <= mosi_cnt + 1;
end
3'b101:begin
rx_buff[0] <= mosi;
rx_buff <= rx_buff << 1;
mosi_cnt <= mosi_cnt + 1;
end
3'b110:begin
rx_buff[0] <= mosi;
rx_buff <= rx_buff << 1;
mosi_cnt <= mosi_cnt + 1;
end
3'b111:begin
rx_buff[0] <= mosi;
rx_buff <= rx_buff << 1;
mosi_cnt <= 3'b000;
end
endcase
end
else begin
mosi_cnt <= 3'b000;
end
end

endmodule
