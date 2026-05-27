module full_adder(input a,b,c, output S,C);
wire w1,w2;
xnor (w1,a,b);
xor (w2,a,b);
assign S = c?w1:w2;
assign C = w1?c:a;
endmodule

module mandal3_52(input x1,x2,x3,x4,x5,cin,output cout,sum,carry);
wire s1,w1,w2;
xor (w1,x1,x2);
or (w2,x3,x4);
xor (s1,w1,w2);
assign cout = (x1&x2)|(w1&w2);
full_adder fa0(.a(s1),.b(x5),.c(cin),.S(sum),.C(carry));
endmodule