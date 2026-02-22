module akbari1_42(x1,x2,x3,x4,sum,carry);
input x1,x2,x3,x4;
output sum, carry;
wire w1,w2;
xnor (w1,x1,x2);
xnor (w2,x3,x4);
nand (sum, w1, w2);
assign carry = x4;
endmodule




