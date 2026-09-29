`timescale 1ns/1ps

module testbench;

    reg clk;
    reg rst;
    reg tx_enb;
    reg tx_tick;
    reg [7:0] data_in;

    wire tx;

    // UART TX ko connect karna
    uart_tx uut (
        .clk(clk),
        .rst(rst),
        .tx_enb(tx_enb),
        .tx_tick(tx_tick),
        .data_in(data_in),
        .tx(tx)
    );

    // 50 MHz clock
    always #10 clk = ~clk;

    initial begin

        // Initial values
        clk     = 0;
        rst     = 1;
        tx_enb  = 0;
        tx_tick = 0;
        data_in = 8'b10110010;

        // Reset
        #100;
        rst = 0;

        // Data transmit karne ka command
        #100;
        tx_enb = 1;

        #20;
        tx_enb = 0;

        // Baud ticks
      repeat (8) begin
            #200;
            tx_tick = 1;

            #20;
            tx_tick = 0;
        end

        #200;
        $finish;

    end

    // Waveform generate karna
    initial begin
        $dumpfile("uart_tx.vcd");
      $dumpvars(0, testbench.tx);
    end

endmodule