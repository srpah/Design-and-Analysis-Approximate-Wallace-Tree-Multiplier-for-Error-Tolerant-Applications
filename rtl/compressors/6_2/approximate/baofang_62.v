module baofang_62(input x1,x2,x3,x4,x5,x6,output sum, carry);
wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11);
or (w1,x1,x3);
or (w2,x1,x2,x3);
and (w3,x4,x5);
or (w4,w3,x6);
or (w5,x4,x5);
xor (w6,w1,w2);
xor (w7,w4,w5);
and (w8,w1,w5);
and (w9,w2,w5);
and (w10,w1,w2);
and (w11,w4,w5);
or (sum,w6,w7,w8,w9);
or (carry,w8,w9,w10,w11);
endmodule