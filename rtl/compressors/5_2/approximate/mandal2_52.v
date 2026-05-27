module full_adder(input a,b,c, output S,C);
wire w1,w2;
xnor (w1,a,b);
xor (w2,a,b);
assign S = c?w1:w2;
assign C = w1?c:a;
endmodule

module mandal2_52(input x1,x2,x3,x4,cin,output cout, sum,carry);
wire A,B,C,D,w1,w2,s1;
nor (A,x1,x2);
nand (B,x1,x2);
nor (C,x3,x4);
nand (D,x3,x4);
nand (w1,~A,B);
nand (w2,~C,D);
assign s1 = (~w1&w1)|(~w2&w2);
assign cout = ~((A&B)|(C&D));
full_adder fa0(.a(x5),.b(cin),.c(s1),.S(sum),.C(carry));
endmodule

