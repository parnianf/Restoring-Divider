`timescale 1ns/1ns
module Adder(en,A,B,sum);
  input[6:0] A,B;
  input en;
  output[6:0] sum;
  assign sum = en ? (A+B) : sum;
endmodule

module mux_2_to_1(i0, i1, sel, y);
  input[6:0] i0,i1;
  input sel;
  output[6:0] y;
  assign y = sel?i1:i0;
endmodule

module twos_comp(A, B);
  input[6:0] A;
  output[6:0] B;
  assign B = ~A + 1;
endmodule

module shreg_7b(d, ser_in, ld, sh, clk, q, sign_A);
  input[6:0] d;
  input ser_in, ld, sh, clk;
  output [6:0] q;
  reg [6:0] q;
  output sign_A;
  
  always @(posedge clk) begin
    if(ld) 
      q <= d;
    else if(sh)
      q <= {q[5:0],ser_in};
  end
  assign sign_A = q[6];
endmodule

module shreg_6b(d, ld, sh, clk, set_Q0, q);
  input[5:0] d;
  input ld, sh, clk, set_Q0;
  output [5:0] q;
  reg [5:0] q;
  
  always @(posedge clk) begin
    if(ld) 
      q <= d;
    else if(sh)
      q <= {q[4:0], 1'b0};
    else if(set_Q0)
      q[0] <= 1'b1;
  end
endmodule

module counter_3b (in, clk, en, rst, ld, cnt, co);
  input[2:0] in;
  input clk, en, rst, ld;
  output[2:0] cnt;
  reg[2:0] cnt;
  output co;
  
  always @(posedge clk, posedge rst) begin
    if (rst) cnt <= 3'b000;
    else if (ld) cnt <= in;
    else if (en) cnt <= cnt + 1;
  end
  assign co = &{cnt, ~ld};

endmodule

module datapath(en, D, AQ, ld_A, sh_A, ld_Q, sh_Q, set_Q0, sel_D, sel_A, ld_cnt, en_cnt, clk, sign_A, Q, Rem, co);
  input[5:0] D;
  input[11:0] AQ;
  input en, ld_A, sh_A, ld_Q, sh_Q, set_Q0, sel_D, sel_A,  clk, en_cnt, ld_cnt;
  output sign_A,co;
  output[6:0] Rem;
  output[5:0] Q;
  wire[6:0] AOut,sum,mux1Out,mux2Out;
  wire[5:0] QOut;
  wire[6:0] DOut_twos_comp;
  wire[2:0] count;
  
  Adder add_7b(en, AOut, mux1Out, sum);
  twos_comp i0({1'b0,D}, DOut_twos_comp);
  mux_2_to_1 mux1 (DOut_twos_comp, {1'b0,D}, sel_D,mux1Out);
  mux_2_to_1 mux2 (sum,{1'b0, AQ[11:6]}, sel_A, mux2Out);
  shreg_7b A_reg(mux2Out, QOut[5], ld_A, sh_A, clk, AOut, sign_A);
  shreg_6b q_reg(AQ[5:0], ld_Q, sh_Q, clk, set_Q0, QOut);
  counter_3b cnt3b (3'b010, clk, en_cnt, 1'b0, ld_cnt, count, co);
  assign Q = QOut;
  assign Rem = AOut;
  
endmodule
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
