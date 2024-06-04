module Address_FSM_tb;

    // Testbench signals
    reg clk_50M;
    reg clk_22K;
    reg reset_n;
    reg read_done;
    reg pause;
    reg reverse;
    reg restart;
    reg [31:0] read_data;
    wire start_read;
    wire [15:0] audio_sample;
    wire [22:0] flash_mem_address;
    wire [3:0] state;

    // Instantiate the FSM
    Address_FSM uut (
        .clk_50M(clk_50M),
        .clk_22K(clk_22K),
        .reset_n(reset_n),
        .read_done(read_done),
        .pause(pause),
        .reverse(reverse),
        .restart(restart),
        .read_data(read_data),
        .start_read(start_read),
        .audio_sample(audio_sample),
        .flash_mem_address(flash_mem_address),
        .state(state)
    );

    // Clock generation for 50MHz
    always begin
        #10 clk_50M = ~clk_50M; // 50MHz clock
    end

    // Clock generation for 22KHz
    always begin
        #22727 clk_22K = ~clk_22K; // 22KHz clock
    end

    // Initial block to apply stimulus
    initial begin
        // Initialize inputs
        clk_50M = 0;
        clk_22K = 0;
        reset_n = 0;
        read_done = 0;
        pause = 0;
        reverse = 0;
        restart = 0;
        read_data = 32'b0;

        // Reset the FSM
        #20;
        reset_n = 1;

        // Wait for a few clock cycles
        #50;

        // Start the FSM
        read_done = 1;
        read_data = 32'hDEADBEEF;

        // Test normal operation
        #500;
        read_done = 0;

        // Test pause functionality
        #500;
        pause = 1;
        #500;
        pause = 0;

        // Test reverse functionality
        #500;
        reverse = 1;
        #500;
        reverse = 0;

        // Test restart functionality
        #500;
        restart = 1;
        #500;
        restart = 0;

        // Finish the simulation
        #1000;
        $stop;
    end
endmodule
