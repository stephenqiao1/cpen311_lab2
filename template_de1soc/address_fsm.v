module Address_FSM(
	input wire clk_50M,
	input wire clk_22K,
	input wire reset_n,
	input wire read_done,
	input wire pause,
	input wire reverse,
	input wire restart,
	input wire [31:0] read_data,
	output reg start_read,
	output reg [15:0] audio_sample,
	output reg [22:0] flash_mem_address,
	output reg [3:0] state
);

	parameter START = 4'b0000;
	parameter SET_ADDR = 4'b0001;
	parameter READ_FSM = 4'b0010;
	parameter ODD_AUDIO = 4'b0011;
	parameter EVEN_AUDIO = 4'b0100;
	parameter CHANGE_ADDR = 4'b0101;
	parameter INCREMENT = 4'b0110;
	parameter DECREMENT = 4'b0111;
	parameter RESTART = 4'b1000;
	parameter FINISHED = 4'b1001;
	
	reg [3:0] next_state;
	reg [22:0] address_counter;
	wire clk_22kHz_edge;
	
	// Edge detection
	Edge_Detector edge_detector (
		.clk(clk_50M),
		.signal(clk_22K),
		.rising_edge(clk_22kHz_edge)
	);

	always_ff @(posedge clk_50M, negedge reset_n) begin
		if (!reset_n) begin
			state <= START;	
			address_counter <= 23'b0;
			flash_mem_address <= 23'b0;
			audio_sample <= 16'b0;
			start_read <= 1'b0;
		end else begin
			state <= next_state;
			
			if (state == DECREMENT) begin
				address_counter <= address_counter - 1;
				if (address_counter < 23'd0) begin
					address_counter <= 23'd524287;
				end
			end else if (state == INCREMENT) begin
				address_counter <= address_counter + 1;
				if (address_counter > 23'd524287) begin
					address_counter <= 0;
				end
			end
			
			if (state == RESTART) begin
				address_counter <= 0;
			end
			
			if (state == SET_ADDR) begin
				flash_mem_address <= address_counter;
			end

			// Capture audio sample
			if (state == ODD_AUDIO) begin
				audio_sample <= read_data[31:16];
			end else if (state == EVEN_AUDIO) begin
				audio_sample <= read_data[15:0];
			end
		
			start_read <= (state == READ_FSM);
		end
	end

	always_comb begin
		case (state)
			START: begin
				if (pause) begin
					next_state = START;
				end else begin
					next_state = SET_ADDR;
				end
			end
			SET_ADDR: begin
				if (clk_22kHz_edge) begin
					next_state = READ_FSM;
				end else begin
					next_state = SET_ADDR;
				end
			end
			READ_FSM: begin
				if ((address_counter[0] == 1'b0) & read_done) begin
					next_state = EVEN_AUDIO;
				end else if ((address_counter[0] == 1'b1) & read_done) begin
					next_state = ODD_AUDIO;
				end else begin
					next_state = READ_FSM;
				end
			end
			ODD_AUDIO, EVEN_AUDIO: begin
				next_state = CHANGE_ADDR;
			end
			CHANGE_ADDR: begin
				if (reverse & !restart) begin
					next_state = DECREMENT;
				end else if (!reverse & !restart) begin
					next_state = INCREMENT;
				end else begin
					next_state = RESTART;
				end
			end
			INCREMENT, DECREMENT, RESTART: begin
				next_state = FINISHED;
			end
			FINISHED: begin
				next_state = START;
			end
			default: begin
				next_state = START;
			end
		endcase
	end

endmodule