module momeni_42(x1,x2,x3,x4,sum,carry);
input x1,x2,x3,x4;
output sum, carry;
wire w1, w2, w3, w4;
xnor (w1,x1,x2);
xnor (w2,x3,x4);
nor (w3,x1,x2);
nor (w4,x3,x4);
nor (carry,w3,w4);
nor (sum, w1, w2);
endmodule
