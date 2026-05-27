module full_adder(input a,b,c, output S,C);
wire w1,w2;
xnor (w1,a,b);
xor (w2,a,b);
assign S = c?w1:w2;
assign C = w1?c:a;
endmodule

module ha(input a,b,output s,c);
assign s = a ^ b;
assign c = a & b;
endmodule

module mandal4_52(input x1,x2,x3,x4,x5,output cout1,cout2,sum);
wire s1,c1
assign sum = x1^x2^x3^x4^x5;
full_adder fa0(.a(x1),.b(x2),.c(x3),.S(s1),.C(c1));
ha x(.a(x4),.(x5),.s(s2),.c(c2));
ha y(.a(c1),.b(c2),.s(cout1),.c(cout2));
endmodule

