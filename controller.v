`timescale 1ns/1ns
module controller(start, sign_A, co, clk, rst, ld_A, sh_A, ld_Q, sh_Q, set_Q0, sel_D, sel_A, ld_cnt, en_cnt, Done, en);
  input start, sign_A, co, clk, rst;
  output ld_A, sh_A, ld_Q, sh_Q, set_Q0, sel_D, sel_A, ld_cnt, en_cnt, Done, en;
  reg ld_D, ld_A, sh_A, ld_Q, sh_Q, set_Q0, sel_D, sel_A, ld_cnt, en_cnt, Done, en;
  parameter [3:0] Idle = 0, A = 1, B = 2, C = 3, D = 4, E = 5, F = 6, G = 7, H = 8;
  reg[3:0] ps,ns;
  always @(posedge clk) begin
    if(rst)
      ps <= Idle;
    else
      ps <= ns;
  end
  
  always@(ps or start or sign_A or co) begin
    case(ps)
      Idle: ns = start ? A : Idle;
      A: ns = B;
      B: ns = C;
      C: ns = D;
      D: ns = sign_A ? E : F;
      E: ns = G;
      F: ns = G;
      G: ns = co ? H : B; 
      H: ns = Idle;
    endcase
  end
  
  always @(ps) begin
    {ld_A,sh_A,ld_Q,sh_Q,set_Q0,sel_D,sel_A,en_cnt,ld_cnt,Done,en} = 11'b00000000000;
    case(ps)
      Idle: ;
      A: {ld_A,ld_Q,ld_cnt,sel_A} = 5'b11111;
      B: {sh_A,sh_Q} = 2'b11;
      C: begin ld_A = 1'b1; en = 1; end
      D: ;
      E: begin en = 1; sel_D = 1'b1; ld_A = 1'b1; end
      F: set_Q0 = 1'b1;
      G: en_cnt = 1'b1; 
      H: Done = 1'b1;
    endcase
  end
endmodule
      
      
      
      
      
      
      
      
      
      
      
