
## zedboard.xdc 
## ZedBoard Zynq-7020 - UART via PMOD JA
## Ports: clk, rst_n, uart_rx_pin, uart_tx_pin

## From ZedBoard Reference Manual:
##   PMOD JA is in PL Bank 13 (3.3V LVCMOS)
##   JA Pin1 = Y11 (uart_tx),  JA Pin2 = AA11 (uart_rx)
##   USB-UART J14 = PS MIO[48:49] - NOT accessible from PL

## CLOCK - 125 MHz onboard oscillator, pin Y9
set_property PACKAGE_PIN Y9      [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

## RESET - BTN0 pushbutton (active LOW)
#set_property PACKAGE_PIN P16     [get_ports rst_n]
#set_property IOSTANDARD LVCMOS18 [get_ports rst_n]

## UART TX - PMOD JA Pin 1 (Y11) - FPGA sends to PC
set_property PACKAGE_PIN Y11     [get_ports uart_tx_pin]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx_pin]

## UART RX - PMOD JA Pin 2 (AA11) - FPGA receives from PC
set_property PACKAGE_PIN AA11    [get_ports uart_rx_pin]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx_pin]

## TIMING EXCEPTIONS
set_false_path -from [get_ports rst_n]
set_false_path -from [get_ports uart_rx_pin]
set_false_path -to   [get_ports uart_tx_pin]

## I/O DELAY HINTS (for reports only)
set_input_delay  -clock sys_clk -max 2.0 [get_ports uart_rx_pin]
set_input_delay  -clock sys_clk -min 0.5 [get_ports uart_rx_pin]
set_output_delay -clock sys_clk -max 2.0 [get_ports uart_tx_pin]
set_output_delay -clock sys_clk -min 0.5 [get_ports uart_tx_pin]
