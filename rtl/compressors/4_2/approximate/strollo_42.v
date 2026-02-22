module full_adder (
    input  a, b, cin,
    output sum, cout
);

    assign {cout, sum} = a + b + cin;

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
    full_adder FA1 (
        .a(w1),
        .b(w2),
        .cin(w3),
        .sum(sum),
        .cout(carry)
    );
endmodule




