module Flash_Read_FSM_tb;

    // Testbench Signals
    reg clk;
    reg start_read;
    reg flash_mem_waitrequest;
    reg flash_mem_readdatavalid;
    wire flash_mem_read;
    wire [31:0] read_data;
    wire read_done;
    wire [2:0] state;

    // Instantiate the FSM
    Flash_Read_FSM uut (
        .clk(clk),
        .start_read(start_read),
        .flash_mem_waitrequest(flash_mem_waitrequest),
        .flash_mem_readdatavalid(flash_mem_readdatavalid),
        .flash_mem_read(flash_mem_read),
        .read_data(read_data),
        .read_done(read_done),
        .state(state)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 100MHz clock
    end

    // Initial block to apply stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        start_read = 0;
        flash_mem_waitrequest = 0;
        flash_mem_readdatavalid = 1;

        // Wait for global reset
        #10;

        // Start the read process
        start_read = 1;

        // Wait for a few clock cycles
        #20;
		  
		  flash_mem_waitrequest = 1;
		  
		  #10;

        // Simulate flash memory waitrequest going low
        flash_mem_waitrequest = 0;

        // Wait for a few clock cycles
        #10;

        // Simulate readdatavalid signal going high
        flash_mem_readdatavalid = 0;

        // Wait for the FSM to complete
        #40;

        // Stop the simulation
        $stop;
    end
endmodule
