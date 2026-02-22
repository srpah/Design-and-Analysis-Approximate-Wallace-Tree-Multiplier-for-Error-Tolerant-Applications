module akbari2_42(x1,x2,x3,x4,sum,carry);
input x1,x2,x3,x4;
output sum, carry;
wire w1,w2,w3,w4;
nand (w1,x1,x2);
nand (w2,x1,x2);
xnor (w3,x1,x2);
xnor (w4,x3,x4);
nand (carry,w1,w2);
nand (sum,w3,w4);
endmodule




