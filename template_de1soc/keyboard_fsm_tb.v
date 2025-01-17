module Keyboard_FSM_tb;

    // Testbench signals
    reg clk;
    reg reset_n;
    reg [7:0] ascii_code;
    wire pause;
    wire reverse;
    wire restart;

    // Instantiate the FSM
    Keyboard_FSM uut (
        .clk(clk),
        .reset_n(reset_n),
        .ascii_code(ascii_code),
        .pause(pause),
        .reverse(reverse),
        .restart(restart)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 100MHz clock
    end

    // Initial block to apply stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        reset_n = 0;
        ascii_code = 8'b0;

        // Reset the FSM
        #20;
        reset_n = 1;

        // Wait for a few clock cycles
        #50;

        // Test STOP functionality (ascii_code = "D")
        ascii_code = 8'h44; // "D"
        #10;
        ascii_code = 8'b0;
        #20;

        // Test PLAY_FORWARD functionality (ascii_code = "E")
        ascii_code = 8'h45; // "E"
        #10;
        ascii_code = 8'b0;
        #20;

        // Test PLAY_BACKWARD functionality (ascii_code = "B")
        ascii_code = 8'h42; // "B"
        #10;
        ascii_code = 8'b0;
        #20;

        // Test RESTART functionality (ascii_code = "R")
        ascii_code = 8'h52; // "R"
        #10;
        ascii_code = 8'b0;
        #20;

        // Test transition from STOP to PLAY_FORWARD (ascii_code = "E")
        ascii_code = 8'h44; // "D" to stop
        #10;
        ascii_code = 8'h45; // "E" to play forward
        #10;
        ascii_code = 8'b0;
        #20;

        // Test transition from PLAY_FORWARD to PLAY_BACKWARD (ascii_code = "B")
        ascii_code = 8'h42; // "B" to play backward
        #10;
        ascii_code = 8'b0;
        #20;

        // Test transition from PLAY_BACKWARD to PLAY_FORWARD (ascii_code = "F")
        ascii_code = 8'h46; // "F" to play forward
        #10;
        ascii_code = 8'b0;
        #20;

        // Finish the simulation
        #100;
        $stop;
    end

endmodule
