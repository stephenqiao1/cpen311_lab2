module Speed_Control(
	input wire clk, 
	input wire KEY,
	input wire speed_up,
	input wire speed_down,
	output reg [31:0] clk_div_count
);

always_ff @(posedge clk or negedge KEY) begin
    if (!KEY) begin
        clk_div_count <= 27000000 / 22000; // Reset to default
    end else if (speed_up) begin
        clk_div_count <= clk_div_count - 25; // Increase speed
    end else if (speed_down) begin
        clk_div_count <= clk_div_count + 25; // Decrease speed
    end
end
endmodule