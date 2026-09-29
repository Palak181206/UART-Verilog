module uart_rx (
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,
    input  wire       rx_tick,

    output reg [7:0]  data_out,
    output reg        data_valid
);

    // RX states
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    // Internal registers
    reg [1:0] state;
    reg [7:0] data_reg;
    reg [2:0] bit_count;
    reg [3:0] sample_count;

    always @(posedge clk) begin

        if (rst) begin
            state        <= IDLE;
            data_reg     <= 0;
            bit_count    <= 0;
            sample_count <= 0;
            data_out     <= 0;
            data_valid   <= 0;
        end

        else begin

            data_valid <= 0;

            case (state)

                // Wait for START bit
                IDLE: begin
                    sample_count <= 0;

                    if (rx == 0) begin
                        state <= START;
                    end
                end

                // Wait for middle of START bit
                START: begin
                    if (rx_tick) begin

                        if (sample_count == 4'd7) begin

                            if (rx == 0) begin
                                state        <= DATA;
                                bit_count    <= 0;
                                sample_count <= 0;
                            end
                            else begin
                                state <= IDLE;
                            end

                        end
                        else begin
                            sample_count <= sample_count + 1'b1;
                        end

                    end
                end

                // Receive 8 data bits
                DATA: begin
                    if (rx_tick) begin

                        if (sample_count == 4'd15) begin

                            data_reg[bit_count] <= rx;
                            sample_count <= 0;

                            if (bit_count == 3'd7) begin
                                state <= STOP;
                            end
                            else begin
                                bit_count <= bit_count + 1'b1;
                            end

                        end
                        else begin
                            sample_count <= sample_count + 1'b1;
                        end

                    end
                end

                // Check STOP bit
                STOP: begin
                    if (rx_tick) begin

                        if (sample_count == 4'd15) begin

                            if (rx == 1) begin
                                data_out   <= data_reg;
                                data_valid <= 1;
                            end

                            state        <= IDLE;
                            sample_count <= 0;

                        end
                        else begin
                            sample_count <= sample_count + 1'b1;
                        end

                    end
                end

                default: begin
                    state        <= IDLE;
                    data_reg     <= 0;
                    bit_count    <= 0;
                    sample_count <= 0;
                    data_out     <= 0;
                    data_valid   <= 0;
                end

            endcase

        end
    end

endmodule