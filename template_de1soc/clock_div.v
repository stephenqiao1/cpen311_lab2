module Clock_Div(input logic inclk,
					  input logic [31:0] div_clk_count,
					  input logic rst,
					  output logic outclk,
					  output logic [31:0] counter); // Added counter output for testing
	
	always_ff @(posedge inclk, posedge rst) begin
		if (rst) begin
			// On reset initialize counter and output clock
			counter <= 32'b0;
			outclk <= 0;
		end else begin
			// If counter reaches the division count, toggle the output clock and reset the counter
			if (counter >= div_clk_count - 1) begin
				counter <= 32'b0;
				outclk <= ~outclk;
			end else begin
				// Increment the counter on each rising edge of the clock
				counter <= counter + 1;
			end
		end
	end
	
endmodule