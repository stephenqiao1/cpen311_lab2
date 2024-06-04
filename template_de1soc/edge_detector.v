module Edge_Detector(
	input wire signal,
	input wire clk,
	output reg rising_edge
);

	reg signal_2;
	
	always_ff @(posedge clk) begin
		signal_2 <= signal;
	end
	
	assign rising_edge = signal & ~signal_2;
endmodule