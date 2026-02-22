module venka_42(x1,x2,x3,x4,sum,carry);
input x1,x2,x3,x4;
output sum, carry;
wire w1,w2,w3,w4,w5;
xor (w1,x1,x2);
and (w2,x1,x2);
and (w3,x3,x4);
xor (w4,x3,x4);
and (w5,w2,w3);
or (carry,w2,w3);
or (sum,w1,w5,w4);
endmodule




