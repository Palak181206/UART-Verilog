`timescale 1ns/1ps

module testbench;

    reg clk;
    reg rst;

    wire tx_tick;
    wire rx_tick;

    // Baud Rate Generator ko connect karna
    baud_generator uut (
        .clk(clk),
        .rst(rst),
        .tx_tick(tx_tick),
        .rx_tick(rx_tick)
    );

    // 50 MHz clock
    always #10 clk = ~clk;

    // Test
    initial begin
        clk = 0;
        rst = 1;

        #100;
        rst = 0;

        #120000;
        $finish;
    end

    // Waveform generate karna
    initial begin
        $dumpfile("baud_generator.vcd");
        $dumpvars(0, testbench);
    end

endmodule