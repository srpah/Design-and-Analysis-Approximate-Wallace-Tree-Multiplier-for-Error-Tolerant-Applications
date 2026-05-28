// baud_gen.v
// Generates baud_tick pulse at 16x baud rate for UART oversampling
// 125 MHz clock, 115200 baud: DIVISOR = 125000000/(115200*16) = 68

module baud_gen #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 115200
)(
    input  wire clk,
    input  wire rst_n,
    output wire baud_tick
);
    localparam integer DIVISOR = CLK_FREQ / (BAUD_RATE * 16);
    reg [$clog2(DIVISOR)-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 0;
        else if (counter == DIVISOR - 1)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    assign baud_tick = (counter == DIVISOR - 1);
endmodule