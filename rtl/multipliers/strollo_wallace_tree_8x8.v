`timescale 1ns/1ps

module strollo_wallace_tree_8x8 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [15:0] prod
);

wire pp [7:0][7:0];
    genvar i, j;
    generate
        for (i=0;i<8;i=i+1) begin : gen_pp_i
            for (j=0;j<8;j=j+1) begin : gen_pp_j
                assign pp[i][j] = a[i] & b[j];
            end
        end
    endgenerate

wire zero;
assign zero=1'b0;

wire sum0_0, carry0_0;
    ha h01 (.a(pp[1][0]), .b(pp[0][1]), .sum(sum0_0), .cout(carry0_0)); 

wire sum0_1, carry0_1;
fa fa01 (.a(pp[2][0]), .b(pp[1][1]), .cin(pp[0][2]), .sum(sum0_1), .cout(carry0_1));

wire sum0_2, carry0_2;
strollo_42 cp01 (
        .x1(pp[3][0]), .x2(pp[2][1]), .x3(pp[1][2]), .x4(pp[0][3]), .sum(sum0_2), .carry(carry0_2));

wire sum0_3, carry0_3;
strollo_42 cp02 (
        .x1(pp[4][0]), .x2(pp[3][1]), .x3(pp[2][2]), .x4(pp[1][3]), .sum(sum0_3), .carry(carry0_3));

wire sum0_4, carry0_4;
strollo_42 cp03 (
        .x1(pp[5][0]), .x2(pp[4][1]), .x3(pp[3][2]), .x4(pp[2][3]), .sum(sum0_4), .carry(carry0_4));

wire sum0_5, carry0_5;
strollo_42 cp04 (
        .x1(pp[6][0]), .x2(pp[5][1]), .x3(pp[4][2]), .x4(pp[3][3]), .sum(sum0_5), .carry(carry0_5));

wire sum0_6, carry0_6;
strollo_42 cp05 (
        .x1(pp[7][0]), .x2(pp[6][1]), .x3(pp[5][2]), .x4(pp[4][3]), .sum(sum0_6), .carry(carry0_6));

wire sum0_7, cout0_7;
fa fa02 (.a(pp[7][1]), .b(pp[6][2]), .cin(pp[5][3]), .sum(sum0_7), .cout(cout0_7));

wire sum0_8, carry0_8;
ha ha02 (.a(pp[7][2]), .b(pp[6][3]), .sum(sum0_8), .cout(carry0_8));

//---------------------------------------------------------------------------------------------//
wire sum1_0, carry1_0;
ha ha03 (.a(pp[1][4]), .b(pp[0][5]), .sum(sum1_0), .cout(carry1_0)); 

wire sum1_1, carry1_1;
fa fa03 (.a(pp[2][4]), .b(pp[1][5]), .cin(pp[0][6]), .sum(sum1_1), .cout(carry1_1));

wire sum1_2, carry1_2;
strollo_42 cp07 (
        .x1(pp[3][4]), .x2(pp[2][5]), .x3(pp[1][6]), .x4(pp[0][7]), .sum(sum1_2), .carry(carry1_2));

wire sum1_3, carry1_3, cout1_3;
compressor4_2 cp08 (
        .x1(pp[4][4]), .x2(pp[3][5]), .x3(pp[2][6]), .x4(pp[1][7]), .cin(zero),
        .sum(sum1_3), .carry(carry1_3), .cout(cout1_3)
    );

wire sum1_4, carry1_4, cout1_4;
compressor4_2 cp09 (
        .x1(pp[5][4]), .x2(pp[4][5]), .x3(pp[3][6]), .x4(pp[2][7]), .cin(cout1_3),
        .sum(sum1_4), .carry(carry1_4), .cout(cout1_4)
    );

wire sum1_5, carry1_5, cout1_5;
compressor4_2 cp10 (
        .x1(pp[6][4]), .x2(pp[5][5]), .x3(pp[4][6]), .x4(pp[3][7]), .cin(cout1_4),
        .sum(sum1_5), .carry(carry1_5), .cout(cout1_5)
    );

wire sum1_6, carry1_6, cout1_6;
compressor4_2 cp11 (
        .x1(pp[7][4]), .x2(pp[6][5]), .x3(pp[5][6]), .x4(pp[4][7]), .cin(cout1_5),
        .sum(sum1_6), .carry(carry1_6), .cout(cout1_6)
    );

wire sum1_7, carry1_7, cout1_7;
compressor4_2 cp12 (
        .x1(zero), .x2(pp[7][5]), .x3(pp[6][6]), .x4(pp[5][7]), .cin(cout1_6),
        .sum(sum1_7), .carry(carry1_7), .cout(cout1_7)
    );

wire sum1_8, carry1_8;
fa fa04 (.a(pp[7][6]), .b(pp[6][7]), .cin(cout1_7), .sum(sum1_8), .cout(carry1_8));


//-------------------------------------------------------------------------------------------------//

wire sum2_0, carry2_0;
ha ha04 (.a(sum0_1), .b(carry0_0), .sum(sum2_0), .cout(carry2_0)); 

wire sum2_1, carry2_1;
ha ha05 (.a(sum0_2), .b(carry0_1), .sum(sum2_1), .cout(carry2_1)); 

wire sum2_2, carry2_2;
fa fa05(.a(sum0_3), .b(carry0_2),.cin(pp[0][4]), .sum(sum2_2), .cout(carry2_2)); 

wire sum2_3, carry2_3;
fa fa06 (.a(sum0_4), .b(carry0_3),.cin(sum1_0), .sum(sum2_3), .cout(carry2_3)); 

wire sum2_4, carry2_4;
strollo_42 cp13 (
        .x1(sum0_5), .x2(carry0_4), .x3(sum1_1), .x4(carry1_0), .sum(sum2_4), .carry(carry2_4));

wire sum2_5, carry2_5;
strollo_42 cp14 (
        .x1(sum0_6), .x2(carry0_5), .x3(sum1_2), .x4(carry1_1), .sum(sum2_5), .carry(carry2_5));

wire sum2_6, carry2_6, cout2_6;
compressor4_2 cp15 (
        .x1(sum0_7), .x2(carry0_6), .x3(sum1_3), .x4(carry1_2), .cin(zero),
        .sum(sum2_6), .carry(carry2_6), .cout(cout2_6)
    );

wire sum2_7, carry2_7, cout2_7;
compressor4_2 cp16 (
        .x1(sum0_8), .x2(cout0_7), .x3(sum1_4), .x4(carry1_3), .cin(cout2_6),
        .sum(sum2_7), .carry(carry2_7), .cout(cout2_7)
    );

wire sum2_8, carry2_8, cout2_8;
compressor4_2 cp17 (
        .x1(pp[7][3]), .x2(carry0_8), .x3(sum1_5), .x4(carry1_4), .cin(cout2_7),
        .sum(sum2_8), .carry(carry2_8), .cout(cout2_8)
    );

wire sum2_9, carry2_9;
fa fa07 (.a(sum1_6), .b(carry1_5),.cin(cout2_8),.sum(sum2_9), .cout(carry2_9)); 

wire sum2_10, carry2_10;
ha ha06 (.a(sum1_7), .b(carry1_6), .sum(sum2_10), .cout(carry2_10)); 

wire sum2_11, carry2_11;
ha ha07 (.a(sum1_8), .b(carry1_7), .sum(sum2_11), .cout(carry2_11)); 

wire sum2_12, carry2_12;
ha ha08 (.a(pp[7][7]), .b(carry1_8), .sum(sum2_12), .cout(carry2_12)); 


//------------------------------------------------------------------------------------------------------//

wire [15:0]Sum;
wire [12:0]Car;


assign Sum[0]=pp[0][0];
assign Sum[1]=sum0_0;
assign Sum[2]=sum2_0;
ha h09 (.a(sum2_1), .b(carry2_0), .sum(Sum[3]), .cout(Car[0]));
fa f08 (.a(sum2_2), .b(carry2_1), .cin(Car[0]), .sum(Sum[4]), .cout(Car[1]));
fa f09 (.a(sum2_3), .b(carry2_2), .cin(Car[1]), .sum(Sum[5]), .cout(Car[2]));
fa f10 (.a(sum2_4), .b(carry2_3), .cin(Car[2]), .sum(Sum[6]), .cout(Car[3]));
fa f11 (.a(sum2_5), .b(carry2_4), .cin(Car[3]), .sum(Sum[7]), .cout(Car[4]));
fa f12 (.a(sum2_6), .b(carry2_5), .cin(Car[4]), .sum(Sum[8]), .cout(Car[5]));
fa f13 (.a(sum2_7), .b(carry2_6), .cin(Car[5]), .sum(Sum[9]), .cout(Car[6]));
fa f14 (.a(sum2_8), .b(carry2_7), .cin(Car[6]), .sum(Sum[10]), .cout(Car[7]));
fa f15 (.a(sum2_9), .b(carry2_8), .cin(Car[7]), .sum(Sum[11]), .cout(Car[8]));
fa f16 (.a(sum2_10), .b(carry2_9), .cin(Car[8]), .sum(Sum[12]), .cout(Car[9]));
fa f17 (.a(sum2_11), .b(carry2_10), .cin(Car[9]), .sum(Sum[13]), .cout(Car[10]));
fa f18 (.a(sum2_12), .b(carry2_11), .cin(Car[10]), .sum(Sum[14]), .cout(Car[11]));
ha h10 (.a(carry2_12), .b(Car[11]), .sum(Sum[15]), .cout(Car[12]));

assign prod=Sum;

endmodule

//-------------------------------------------------------------------------------------------------//

module ha (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b;
    assign cout = a & b;
endmodule

module fa (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module compressor4_2 (
    input  wire x1,
    input  wire x2,
    input  wire x3,
    input  wire x4,
    input  wire cin,    // incoming carry from previous column (weight w-1)
    output wire sum,    // weight w
    output wire carry,  // weight w+1
    output wire cout    // weight w+2
);
    wire s1, c1, c2;

    fa fa1 (.a(x1), .b(x2), .cin(x3), .sum(s1), .cout(c1));

    fa fa2 (.a(s1), .b(x4), .cin(cin), .sum(sum), .cout(c2));

    assign carry = c2;  // LSB -> next weight
    assign cout  = c1;  // MSB -> weight+1 above that
endmodule


module strollo_42 (
    input  x1, x2, x3, x4,
    output sum, carry
);

    wire w1, w2, w3;
    wire and1;
    or (w1, x1, x2);
    and (and1, x1, x2);
    or  (w2, and1, x3);
    assign w3 = x4;
    fa FA1 (
        .a(w1),
        .b(w2),
        .cin(w3),
        .sum(sum),
        .cout(carry)
    );
endmodule











