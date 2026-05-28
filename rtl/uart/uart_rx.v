module uart_rx #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 115200
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       rx_serial,
    output reg  [7:0] rx_byte,
    output reg        rx_done
);
    wire baud_tick;
    baud_gen #(CLK_FREQ, BAUD_RATE) bg (
        .clk(clk), .rst_n(rst_n), .baud_tick(baud_tick));

    // Double-flop synchronizer (prevents metastability)
    reg rx_sync_0, rx_sync_1;
    always @(posedge clk) begin
        rx_sync_0 <= rx_serial;
        rx_sync_1 <= rx_sync_0;
    end
    wire rx = rx_sync_1;

    localparam IDLE=3'd0, START=3'd1, DATA=3'd2, STOP=3'd3, DONE=3'd4;
    reg [2:0] state;
    reg [3:0] tick_cnt;
    reg [2:0] bit_idx;
    reg [7:0] rx_shift;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE; tick_cnt <= 0; bit_idx <= 0;
            rx_shift <= 0; rx_byte <= 0; rx_done <= 0;
        end else begin
            rx_done <= 0;
            case (state)
                IDLE: begin
                    tick_cnt <= 0;
                    if (rx == 1'b0) state <= START;
                end
                START: begin
                    if (baud_tick) begin
                        if (tick_cnt == 4'd7) begin
                            if (rx == 1'b0) begin
                                tick_cnt <= 0; state <= DATA;
                            end else state <= IDLE;
                        end else tick_cnt <= tick_cnt + 1;
                    end
                end
                DATA: begin
                    if (baud_tick) begin
                        if (tick_cnt == 4'd15) begin
                            tick_cnt <= 0;
                            rx_shift[bit_idx] <= rx;
                            if (bit_idx == 3'd7) begin
                                bit_idx <= 0; state <= STOP;
                            end else bit_idx <= bit_idx + 1;
                        end else tick_cnt <= tick_cnt + 1;
                    end
                end
                STOP: begin
                    if (baud_tick) begin
                        if (tick_cnt == 4'd15) begin
                            tick_cnt <= 0; state <= DONE;
                        end else tick_cnt <= tick_cnt + 1;
                    end
                end
                DONE: begin
                    rx_done <= 1;
                    rx_byte <= rx_shift;
                    state   <= IDLE;
                end
            endcase
        end
    end
endmodule
