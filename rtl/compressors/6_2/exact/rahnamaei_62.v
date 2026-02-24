module FA(input a,b,cin, output S,C);
assign S = a^b^cin;
assign C = (a&b)|(b&cin)|(cin&a);
endmodule

module comp42(input i1,i2,i3,i4,i5,i6,output cout1,cout2,sum4_2);
wire w1;
FA fa0(.a(i1),.b(i2),.c(i3),.S(w1),.C(cout2));
FA fa1(.a(w1),.b(i4),.c(i5),.S(sum4_2),.C(cout1));
endmodule

module rahnamaei_62(input x1,x2,x3,x4,x5,x6,cin1,cin2,cin3, output cout1,cout2,cout3,sum,carry);
wire w1,w2,w3,w4,w5,w6,w7;
FA (.a(cin3),.b(cin2),.c(x6),.S(w1),.C(cout3));
comp42 (.i1(x1),.i2(x2),.i3(x3),.i4(x4),.i5(x5),.cout2(cout2),.cout1(cout1),.sum4_2(w2));
xor (w3,w1,w2);
xnor (w4,w1,w2);
assign sum = x6?w4:w3;
and (w5,w2,cin1);
and (w6,w1,cin1);
and (w7,w1,w2);
or (carry,w5,w6,w7);
endmodule;
