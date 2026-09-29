module baud_generator (
    input  wire clk,
    input  wire rst,
    output reg  tx_tick,
    output reg  rx_tick
);

reg [12:0] tx_counter;
reg [12:0] rx_counter;

always @(posedge clk) begin
    if (rst) begin
        tx_counter <= 0;
        tx_tick    <= 0;
    end
    else if (tx_counter == 5207) begin
        tx_counter <= 0;
        tx_tick    <= 1;
    end
    else begin
        tx_counter <= tx_counter + 1'b1;
        tx_tick    <= 0;
    end
end

always @(posedge clk) begin
    if (rst) begin
        rx_counter <= 0;
        rx_tick    <= 0;
    end
    else if (rx_counter == 325) begin
        rx_counter <= 0;
        rx_tick    <= 1;
    end
    else begin
        rx_counter <= rx_counter + 1'b1;
        rx_tick    <= 0;
    end
end

endmodule