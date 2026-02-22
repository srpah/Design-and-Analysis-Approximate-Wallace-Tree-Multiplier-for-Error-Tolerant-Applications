module min3 (
    input  a, b, c,
    output y
);
    assign y = (a & b) | (b & c) | (a & c);
endmodule
module mux_inv (
    input  sel, d0, d1,
    output y
);
    assign y = ~ (sel ? d1 : d0);
endmodule
module kavand_42(
    input  x1, x2, x3, x4,
    output Sum, Carry
);

    wire x3_bar;
    wire min_out;
    wire zero = 1'b0;

    assign x3_bar = ~x3;

    min3 MIN1 (
        .a(x1),
        .b(x2),
        .c(x3_bar),
        .y(min_out)
    );
    mux_inv M1 (
        .sel(x4),
        .d0(zero),
        .d1(x3_bar),
        .y(Carry)
    );

    mux_inv M2 (
        .sel(x4),
        .d0(x3_bar),
        .d1(min_out),
        .y(Sum)
    );

endmodule





