module cheweitung_52(input x1,x2,x3,x4,x5,output sum,carry);
wire w1,w2,w3,c1,c2,c3,ha1,ha2;
xnor (w1,x1,x2);
xnor (w2,x3,x4);
nor (w3,w1,w2);
or (sum,w3,x5);
assign c1 = (x1&x2)|(x2&x3)|(x1&x3);
assign c2 = x4&x5;
assign c3 = (x1|x2|x3)&(x4|x5);
assign carry = c1&c2&c3;
endmodule



