`timescale 1ns/1ps

module testbench;

reg clk;
reg rst;
reg tx_enb;
reg [7:0] data_in;

wire tx;

wire rx;

wire [7:0] data_out;
wire data_valid;


//====================================================
// Connect UART
//====================================================

uart_top uut (
    .clk(clk),
    .rst(rst),
    .tx_enb(tx_enb),
    .data_in(data_in),
    .rx(rx),
    .tx(tx),
    .data_out(data_out),
    .data_valid(data_valid)
);


//====================================================
// Clock generation
//====================================================

initial begin
    clk = 1'b0;

    forever #5 clk = ~clk;
end


//====================================================
// RX connected to TX
//====================================================

assign rx = tx;


//====================================================
// Test
//====================================================

initial begin

    rst     = 1'b1;
    tx_enb  = 1'b0;
    data_in = 8'h00;

    #100;

    rst = 1'b0;

    // Send A = 8'h41
    #100;
    data_in = 8'h41;
    tx_enb  = 1'b1;

    #20;
    tx_enb = 1'b0;


    // Wait for transmission
    #5000;

    // Send B = 8'h42
    data_in = 8'h42;
    tx_enb  = 1'b1;

    #20;
    tx_enb = 1'b0;


    #5000;

    $finish;

end


//====================================================
// Waveform
//====================================================

initial begin

    $dumpfile("uart_final.vcd");

    $dumpvars(0, testbench.clk);
    $dumpvars(0, testbench.rst);
    $dumpvars(0, testbench.tx_enb);
    $dumpvars(0, testbench.data_in);
    $dumpvars(0, testbench.tx);
    $dumpvars(0, testbench.rx);
    $dumpvars(0, testbench.data_out);
    $dumpvars(0, testbench.data_valid);

end

endmodule