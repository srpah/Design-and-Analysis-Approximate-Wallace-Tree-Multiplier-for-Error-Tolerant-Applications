// top_module.v
// FPGA UART Image Multiplier
// Pixel-wise multiplication of TWO images
//
// Operation:
// output_pixel = (image1_pixel * image2_pixel) >> 8

module top_module #(
    parameter CLK_FREQ = 100_000_000,
    parameter BAUD_RATE = 115200
)(
    input  wire clk,
    input  wire uart_rx_pin,
    output wire uart_tx_pin
);

    // -------------------------------------------------
    // Permanent reset disable
    // -------------------------------------------------
    wire rst_n;
    assign rst_n = 1'b1;

    // -------------------------------------------------
    // PS7 stub for Zynq
    // -------------------------------------------------
    PS7 ps7_inst ();

    // -------------------------------------------------
    // UART RX
    // -------------------------------------------------
    wire rx_done;
    wire [7:0] rx_byte;

    uart_rx #(CLK_FREQ, BAUD_RATE) rx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rx_serial(uart_rx_pin),
        .rx_byte(rx_byte),
        .rx_done(rx_done)
    );

    // -------------------------------------------------
    // UART TX
    // -------------------------------------------------
    reg tx_start;
    reg [7:0] tx_byte;
    wire tx_busy;

    uart_tx #(CLK_FREQ, BAUD_RATE) tx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .tx_byte(tx_byte),
        .tx_start(tx_start),
        .tx_serial(uart_tx_pin),
        .tx_busy(tx_busy)
    );

    // -------------------------------------------------
    // Multiplier
    // -------------------------------------------------
    reg  [7:0] pixel1_reg;
    reg  [7:0] pixel2_reg;

    wire [15:0] mult_result;

    image_multiplier mult_inst (
        .pixel1(pixel1_reg),
        .pixel2(pixel2_reg),
        .result(mult_result)
    );

    // -------------------------------------------------
    // Pipeline Register
    // -------------------------------------------------
    reg [7:0] result_8bit_reg;
    reg mult_valid_d2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_8bit_reg <= 0;
            mult_valid_d2   <= 0;
        end
        else begin
            result_8bit_reg <= mult_result[15:8];
            mult_valid_d2   <= mult_valid_d1;
        end
    end

    // -------------------------------------------------
    // FIFO
    // -------------------------------------------------
    localparam FIFO_DEPTH = 2048;

    reg [7:0] fifo_mem [0:FIFO_DEPTH-1];

    reg [10:0] fifo_wr_ptr;
    reg [10:0] fifo_rd_ptr;
    reg [10:0] fifo_count;

    wire fifo_empty = (fifo_count == 0);
    wire fifo_full  = (fifo_count == FIFO_DEPTH);

    reg fifo_wr_en;
    reg fifo_rd_en;

    reg [7:0] fifo_wr_data;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            fifo_wr_ptr <= 0;
            fifo_rd_ptr <= 0;
            fifo_count  <= 0;
        end
        else begin

            if (fifo_wr_en && !fifo_full) begin
                fifo_mem[fifo_wr_ptr] <= fifo_wr_data;
                fifo_wr_ptr <= fifo_wr_ptr + 1;
                fifo_count  <= fifo_count + 1;
            end

            if (fifo_rd_en && !fifo_empty) begin
                fifo_rd_ptr <= fifo_rd_ptr + 1;
                fifo_count  <= fifo_count - 1;
            end

            if (fifo_wr_en && fifo_rd_en &&
                !fifo_full && !fifo_empty)
                fifo_count <= fifo_count;
        end
    end

    wire [7:0] fifo_rd_data;

    assign fifo_rd_data = fifo_mem[fifo_rd_ptr];

    // -------------------------------------------------
    // FSM
    // -------------------------------------------------
    localparam WAIT_START = 3'd0;
    localparam RECV_HDR   = 3'd1;
    localparam RECV_PIX   = 3'd2;
    localparam WAIT_END   = 3'd3;

    reg [2:0] state;

    reg [1:0] hdr_cnt;

    reg [15:0] img_w;
    reg [15:0] img_h;

    reg [31:0] total_pix;
    reg [31:0] pix_cnt;

    reg wait_second;

    reg mult_valid;
    reg mult_valid_d1;

    always @(posedge clk)
        mult_valid_d1 <= mult_valid;

    // -------------------------------------------------
    // Main FSM
    // -------------------------------------------------
    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            state <= WAIT_START;

            hdr_cnt <= 0;

            img_w <= 0;
            img_h <= 0;

            total_pix <= 0;
            pix_cnt   <= 0;

            wait_second <= 0;

            mult_valid <= 0;

            pixel1_reg <= 0;
            pixel2_reg <= 0;

            tx_start <= 0;
            tx_byte  <= 0;

            fifo_wr_en <= 0;
            fifo_rd_en <= 0;

            fifo_wr_data <= 0;
        end

        else begin

            tx_start   <= 0;
            mult_valid <= 0;

            fifo_wr_en <= 0;
            fifo_rd_en <= 0;

            // -----------------------------------------
            // Push multiplier result into FIFO
            // -----------------------------------------
            if (mult_valid_d2 && !fifo_full) begin
                fifo_wr_en   <= 1;
                fifo_wr_data <= result_8bit_reg;
            end

            // -----------------------------------------
            // Send FIFO data through UART TX
            // -----------------------------------------
            if (!fifo_empty && !tx_busy && !tx_start) begin

                tx_byte    <= fifo_rd_data;
                tx_start   <= 1;
                fifo_rd_en <= 1;
            end

            case (state)

                // -------------------------------------
                // Wait for frame start byte
                // -------------------------------------
                WAIT_START: begin

                    if (rx_done && rx_byte == 8'hAA) begin

                        hdr_cnt <= 0;
                        pix_cnt <= 0;

                        wait_second <= 0;

                        state <= RECV_HDR;
                    end
                end

                // -------------------------------------
                // Receive width + height
                // -------------------------------------
                RECV_HDR: begin

                    if (rx_done) begin

                        case (hdr_cnt)

                            2'd0:
                                img_w[15:8] <= rx_byte;

                            2'd1:
                                img_w[7:0] <= rx_byte;

                            2'd2:
                                img_h[15:8] <= rx_byte;

                            2'd3: begin

                                img_h[7:0] <= rx_byte;

                                total_pix <=
                                    img_w *
                                    {img_h[15:8], rx_byte};

                                state <= RECV_PIX;
                            end
                        endcase

                        hdr_cnt <= hdr_cnt + 1;
                    end
                end

                // -------------------------------------
                // Receive TWO image pixels
                // -------------------------------------
                RECV_PIX: begin

                    if (rx_done) begin

                        pix_cnt <= pix_cnt + 1;

                        // First image pixel
                        if (!wait_second) begin

                            pixel1_reg <= rx_byte;
                            wait_second <= 1;
                        end

                        // Second image pixel
                        else begin

                            pixel2_reg <= rx_byte;

                            wait_second <= 0;

                            mult_valid <= 1;
                        end

                        if (pix_cnt + 1 >= (total_pix * 2))
                            state <= WAIT_END;
                    end
                end

                // -------------------------------------
                // Wait for frame end byte
                // -------------------------------------
                WAIT_END: begin

                    if (rx_done && rx_byte == 8'h55)
                        state <= WAIT_START;
                end

            endcase
        end
    end

endmodule