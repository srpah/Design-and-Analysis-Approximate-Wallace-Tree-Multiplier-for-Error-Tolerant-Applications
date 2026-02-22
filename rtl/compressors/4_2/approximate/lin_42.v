module lin_42(x1,x2,x3,x4,sum,carry);
input x1,x2,x3,x4;
output sum, carry;
wire w1,w2,w3,w4,w5,w6;
xor (w1,x1,x2);
nand (w2,x1,x2);
xor (w3,x1,x2);
nand (w4,x3,x4);
not (w5,w1);
nand (w6,w1,w3);
nand (carry,w2,w6,w4);
assign sum = w3 ? w1 : w5;
endmodule




