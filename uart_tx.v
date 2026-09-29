module uart_tx (
    input  wire       clk,
    input  wire       rst,
    input  wire       tx_enb,
    input  wire       tx_tick,
    input  wire [7:0] data_in,
    output reg        tx
);

    // UART states
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    // Internal registers
    reg [1:0] state;
    reg [7:0] data_reg;
    reg [2:0] bit_count;

    // Main transmitter logic
    always @(posedge clk) begin

        if (rst) begin
            state     <= IDLE;
            tx        <= 1;
            data_reg  <= 0;
            bit_count <= 0;
        end

        else begin

            case (state)

                // Waiting state
                IDLE: begin
                    tx <= 1;

                    if (tx_enb) begin
                        data_reg  <= data_in;
                        bit_count <= 0;
                        state     <= START;
                    end
                end

                // Start bit
                START: begin
                    tx <= 0;

                    if (tx_tick) begin
                        state <= DATA;
                    end
                end

                // Sending 8 data bits
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

                // Stop bit
                STOP: begin
                    tx <= 1;

                    if (tx_tick) begin
                        state <= IDLE;
                    end
                end

                // Safety condition
                default: begin
                    state     <= IDLE;
                    tx        <= 1;
                    data_reg  <= 0;
                    bit_count <= 0;
                end

            endcase

        end

    end

endmodule

