// or browse Examples
`timescale 1ns/1ps

module testbench;

    reg clk;
    reg rst;
    reg rx;
    reg rx_tick;

    wire [7:0] data_out;
    wire data_valid;

    // UART RX ko connect karna
    uart_rx uut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_tick(rx_tick),
        .data_out(data_out),
        .data_valid(data_valid)
    );

    // 50 MHz clock
    always #10 clk = ~clk;

    // One RX tick = approximately 6.51 us
    task rx_tick_once;
        begin
            #6510;
            rx_tick = 1;
            #20;
            rx_tick = 0;
        end
    endtask

    // Generate 16 RX ticks for one UART bit
    task one_uart_bit;
        begin
            repeat (16)
                rx_tick_once;
        end
    endtask

    initial begin

        // Initial values
        clk     = 0;
        rst     = 1;
        rx      = 1;
        rx_tick = 0;

        // Reset
        #100;
        rst = 0;

        // -------------------------
        // START BIT
        // -------------------------
        rx = 0;

        // RX confirms START at 8th sample
        repeat (8)
            rx_tick_once;

        // -------------------------
        // DATA BITS
        // 10110010
        // Sent LSB first:
        // 0 1 0 0 1 1 0 1
        // -------------------------

        rx = 0;
        one_uart_bit;

        rx = 1;
        one_uart_bit;

        rx = 0;
        one_uart_bit;

        rx = 0;
        one_uart_bit;

        rx = 1;
        one_uart_bit;

        rx = 1;
        one_uart_bit;

        rx = 0;
        one_uart_bit;

        rx = 1;
        one_uart_bit;

        // -------------------------
        // STOP BIT
        // -------------------------
        rx = 1;
        one_uart_bit;

        #2000;

        $finish;

    end

    // Waveform
    initial begin
        $dumpfile("uart_rx.vcd");

        $dumpvars(0, testbench.rx);
        $dumpvars(0, testbench.rx_tick);
        $dumpvars(0, testbench.data_out);
        $dumpvars(0, testbench.data_valid);
    end

endmodule