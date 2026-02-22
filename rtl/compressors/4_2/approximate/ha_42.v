module ha_42(x1,x2,x3,x4,sum,carry);
input x1,x2,x3,x4;
output sum,carry;
wire w1,w2;
nor (w1,x1,x2);
or (w2,x3,x4);
nor (sum,w1,w2);
assign carry = (x1 & x2)|(w1 & w2);
endmodule