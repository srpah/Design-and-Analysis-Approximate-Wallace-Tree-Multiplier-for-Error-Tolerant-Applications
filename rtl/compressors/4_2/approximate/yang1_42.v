module yang_1(x1,x2,x3,x4,sum,carry);
input x1,x2,x3,x4;
output sum,carry;
wire w1,w2,w3,w4,w5,w6,w7;
or (w1,x1,x2);
nand (w2,x1,x2);
not (w3,x3);
xnor (w4,x3,x4);
nand (w5,w1,w2);
or (w6,w2,w3);
xnor (w7,w5,w4);
nand (sum,w6,w7);
assign carry = ~(((w4 | w5) & w2) | (w3 | ~x4));
endmodule

