module sabetzadeh_42(x1,x3,x4,sum,carry);
input x1,x3,x4;
output sum,carry;
assign sum = 1'b1;
assign carry = (x1 & x3)|(x3 & x4)|(x4 & x1);
endmodule