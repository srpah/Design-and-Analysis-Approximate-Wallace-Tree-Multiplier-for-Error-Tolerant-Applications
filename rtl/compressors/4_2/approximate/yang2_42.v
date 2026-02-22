module yang2_42(x1,x2,x3,x4,sum,carry);
input x1,x2,x3,x4;
output sum, carry;
wire w1,w2,w3,w4;
nor (w1,x1,x2);
or (w2,x3,x4);
nor (w3,w1,w2);
and (w4,x3,x4);
or (sum,w3,w4);
assign carry = (x1 & x2)|(w1 & w2)|(x3 & x4);
endmodule

