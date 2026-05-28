module uart_tx #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 115200
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] tx_byte,
    input  wire       tx_start,
    output reg        tx_serial,
    output wire       tx_busy
);
    wire baud_tick;
    baud_gen #(CLK_FREQ, BAUD_RATE) bg (
        .clk(clk), .rst_n(rst_n), .baud_tick(baud_tick));

    localparam IDLE=2'd0, START=2'd1, DATA=2'd2, STOP=2'd3;
    reg [1:0] state;
    reg [3:0] tick_cnt;
    reg [2:0] bit_idx;
    reg [7:0] tx_shift;

    assign tx_busy = (state != IDLE);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE; tick_cnt <= 0; bit_idx <= 0;
            tx_shift <= 0; tx_serial <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    tx_serial <= 1'b1;
                    if (tx_start) begin
                        tx_shift <= tx_byte;
                        tick_cnt <= 0;
                        state    <= START;
                    end
                end
                START: begin
                    tx_serial <= 1'b0;
                    if (baud_tick) begin
                        if (tick_cnt == 4'd15) begin
                            tick_cnt <= 0; bit_idx <= 0; state <= DATA;
                        end else tick_cnt <= tick_cnt + 1;
                    end
                end
                DATA: begin
                    tx_serial <= tx_shift[bit_idx];
                    if (baud_tick) begin
                        if (tick_cnt == 4'd15) begin
                            tick_cnt <= 0;
                            if (bit_idx == 3'd7) begin
                                bit_idx <= 0; state <= STOP;
                            end else bit_idx <= bit_idx + 1;
                        end else tick_cnt <= tick_cnt + 1;
                    end
                end
                STOP: begin
                    tx_serial <= 1'b1;
                    if (baud_tick) begin
                        if (tick_cnt == 4'd15) begin
                            tick_cnt <= 0; state <= IDLE;
                        end else tick_cnt <= tick_cnt + 1;
                    end
                end
            endcase
        end
    end
endmodule