module hemanth1_42(
    input  x1,x2,x3,x4;
    output Sum, Carry
);
wire w1,w2,w3,w4;
wire y0,y1,y2,y3;
or (w1,x1,x2);
and (w2,x1,x2);
or (w3,x3,x4);
and (w4,x3,x4);
or (y0,w1,w3);
or (y1,w2,w4);
nand (y2,w1,w3);
or (y3,y1,y2);
and (Sum, y0,y3);
not (Carry,y2);
endmodule
