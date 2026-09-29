`timescale 1ns/1ps

//====================================================
// 1. BAUD GENERATOR
//====================================================

module baud_gen (
    input wire clk,
    input wire rst,
    output reg tx_tick,
    output reg rx_tick
);

reg [8:0] tx_counter;
reg [8:0] rx_counter;

always @(posedge clk) begin
    if (rst) begin
        tx_counter <= 0;
        tx_tick    <= 0;
    end
    else if (tx_counter == 325) begin
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


//====================================================
// 2. UART TRANSMITTER
//====================================================

module uart_tx (
    input wire clk,
    input wire rst,
    input wire tx_enb,
    input wire tx_tick,
    input wire [7:0] data_in,
    output reg tx
);

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

reg [1:0] state;
reg [7:0] data_reg;
reg [2:0] bit_count;

always @(posedge clk) begin

    if (rst) begin
        state     <= IDLE;
        tx        <= 1'b1;
        data_reg  <= 8'b0;
        bit_count <= 3'b0;
    end

    else begin

        case (state)

            IDLE: begin
                tx <= 1'b1;

                if (tx_enb) begin
                    data_reg  <= data_in;
                    bit_count <= 3'b0;
                    state     <= START;
                end
            end

            START: begin
                tx <= 1'b0;

                if (tx_tick) begin
                    state <= DATA;
                end
            end

            DATA: begin
                tx <= data_reg[bit_count];

                if (tx_tick) begin
                    if (bit_count == 3'd7) begin
                        state <= STOP;
                    end
                    else begin
                        bit_count <= bit_count + 1'b1;
                    end
                end
            end

            STOP: begin
                tx <= 1'b1;

                if (tx_tick) begin
                    state <= IDLE;
                end
            end

            default: begin
                state     <= IDLE;
                tx        <= 1'b1;
                data_reg  <= 8'b0;
                bit_count <= 3'b0;
            end

        endcase
    end
end

endmodule


//====================================================
// 3. UART RECEIVER
//====================================================

module uart_rx (
    input wire clk,
    input wire rst,
    input wire rx,
    input wire rx_tick,

    output reg [7:0] data_out,
    output reg data_valid
);

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

reg [1:0] state;
reg [7:0] data_reg;
reg [2:0] bit_count;

always @(posedge clk) begin

    if (rst) begin
        state      <= IDLE;
        data_reg   <= 8'b0;
        bit_count  <= 3'b0;
        data_out   <= 8'b0;
        data_valid <= 1'b0;
    end

    else begin

        // data_valid is normally 0
        data_valid <= 1'b0;

        case (state)

            IDLE: begin
                if (!rx) begin
                    state     <= START;
                    bit_count <= 3'b0;
                end
            end

            START: begin
                if (rx_tick) begin

                    if (!rx) begin
                        state     <= DATA;
                        bit_count <= 3'b0;
                    end
                    else begin
                        state <= IDLE;
                    end

                end
            end

            DATA: begin

                if (rx_tick) begin

                    data_reg[bit_count] <= rx;

                    if (bit_count == 3'd7) begin
                        state <= STOP;
                    end
                    else begin
                        bit_count <= bit_count + 1'b1;
                    end

                end
            end

            STOP: begin

                if (rx_tick) begin

                    if (rx) begin
                        data_out   <= data_reg;
                        data_valid <= 1'b1;
                    end

                    state <= IDLE;

                end
            end

            default: begin
                state      <= IDLE;
                data_reg   <= 8'b0;
                bit_count  <= 3'b0;
                data_out   <= 8'b0;
                data_valid <= 1'b0;
            end

        endcase
    end
end

endmodule


//====================================================
// 4. TOP UART MODULE
//====================================================

module uart_top (
    input wire clk,
    input wire rst,
    input wire tx_enb,
    input wire [7:0] data_in,
    input wire rx,

    output wire tx,
    output wire [7:0] data_out,
    output wire data_valid
);

wire tx_tick;
wire rx_tick;

baud_gen baud_inst (
    .clk(clk),
    .rst(rst),
    .tx_tick(tx_tick),
    .rx_tick(rx_tick)
);

uart_tx tx_inst (
    .clk(clk),
    .rst(rst),
    .tx_enb(tx_enb),
    .tx_tick(tx_tick),
    .data_in(data_in),
    .tx(tx)
);

uart_rx rx_inst (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .rx_tick(rx_tick),
    .data_out(data_out),
    .data_valid(data_valid)
);

endmodule