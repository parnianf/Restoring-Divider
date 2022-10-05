`timescale 1ns/1ns
module Restoring_Divider(start, D, AQ, clk, rst, Rem, Q, Done);
  input clk,rst,start;
  input[5:0] D;
  input[11:0] AQ;
  output[5:0] Rem;
  output[5:0] Q;
  output Done;
  wire [6:0] Atemp;
  wire sign_A, co, clk, rst, ld_A, sh_A, ld_Q, sh_Q, set_Q0, sel_D, sel_A, ld_cnt, en_cnt,  en;
  controller cu (start, sign_A, co, clk, rst, ld_A,  sh_A, ld_Q,  sh_Q, set_Q0, sel_D, sel_A, ld_cnt, en_cnt, Done, en);
  datapath dp (en, D, AQ, ld_A, sh_A, ld_Q, sh_Q, set_Q0, sel_D, sel_A, ld_cnt, en_cnt, clk, sign_A, Q, Atemp, co);
  assign Rem = Atemp[5:0];
endmodule

module Restoring_Divider_TB();
  reg clk = 1'b0, rst = 1'b1, start = 1'b0;
  reg [5:0] divisor = 6'b001000;//divisor = 8
  reg [11:0] dividend = 12'b000001011000;//dividend = 88
  wire done;
  wire [5:0] quotient, Rem;
  Restoring_Divider CUT(start, divisor, dividend, clk, rst, Rem, quotient, done);
  always #151 clk = ~clk;
  initial begin
    #500 rst = 1'b0;
    #700 start = 1'b1;
    #700 start = 1'b0;
    #15000 divisor = 6'b001011; dividend = 12'b000001001011; start = 1'b1;//dividend = 75, divisor = 11 
    #700 start = 1'b0;
    #15000 divisor = 6'b110011; dividend = 12'b011111010000; start = 1'b1;//dividend = 2000, divisor = 51
    #700 start = 1'b0;
    #15000 divisor = 6'b111000; dividend = 12'b011101010100; start = 1'b1;//dividend = 1876, divisor = 56
    #700 start = 1'b0;
    #50000 $stop;
  end
endmodule

    
  
  
  
  
  