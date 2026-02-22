module ahmadinejad_42(x1,x2,x3,x4,sum,carry);
input x1,x2,x3,x4;
output sum, carry;
wire w1,w2;
nor (w1,x1,x2);
nor (w2,x3,x4);
nor (carry,w1,w2);
nand (sum,w1,w2);
endmodule




