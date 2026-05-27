module full_adder(input a,b,c, output S,C);
wire w1,w2;
xnor (w1,a,b);
xor (w2,a,b);
assign S = c?w1:w2;
assign C = w1?c:a;
endmodule

module mandal1_52(input x1,x2,x3,x4,x5,cin,output sum,carry,cout);
wire s1, or1;
or (or1,x1,x2);
full_adder fa0(.a(x4),.b(x3),.c(or1),.S(s1),.C(cout));
full_adder fa0(.a(s1),.b(x5),.c(cin),.S(sum),.C(carry));
endmodule