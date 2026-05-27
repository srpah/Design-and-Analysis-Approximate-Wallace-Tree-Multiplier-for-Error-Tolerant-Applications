module full_adder(input a,b,c, output S,C);
assign S = a^b^c;
assign C = (a&b)|(b&c)|(c&a);
endmodule

module conv_52(input x1,x2,x3,x4,x5,cin1,cin2,output carry,sum,cout1,cout2);
wire s1,s2;
full_adder fa0(.a(x1),.b(x2),.c(x3),.S(s1),.C(cout1));
full_adder fa0(.a(cin1),.b(s1),.c(x4),.S(s2),.C(cout2));
full_adder fa0(.a(cin2),.b(s2),.c(x3),.S(sum),.C(carry));
endmodule