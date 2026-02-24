module yzhang_62(x1,x2,x3,x4,x5,x6,cout1,cout2,sum);
input x1,x2,x3,x4,x5,x6;
output cout1,cout2,sum;
assign cout1 = (x1&x2)|(x2&x3)|(x3&x1);
assign cout2 = (x4&x5)|(x4&x5)|(x5&x6);
endmodule

