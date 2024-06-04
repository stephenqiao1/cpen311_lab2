module Keyboard_FSM(
	input wire clk,
	input wire reset_n,
	input wire [7:0] ascii_code,
	output reg pause,
	output reg reverse,
	output reg restart
);

	// FSM States
	parameter CHECK_KEY = 3'b000;
	parameter STOP = 3'b001;
	parameter PLAY_FORWARD = 3'b010;
	parameter PLAY_BACKWARD = 3'b011;
	parameter RESTART = 3'b100;
	
	reg [2:0] state, next_state;
	reg next_pause, next_reverse, next_restart;
	
	always_ff @(posedge clk, negedge reset_n) begin
		if (!reset_n) begin
			state <= CHECK_KEY;
		end else begin
			state <= next_state;
		end
	end
	
	always_comb begin
		case (state)
			CHECK_KEY: begin
				if (ascii_code == 8'h44) begin // "D"
					next_state = STOP;
				end else if ((ascii_code == 8'h45) | (ascii_code == 8'h46)) begin // "E" or "F"
					next_state = PLAY_FORWARD;
				end else if (ascii_code == 8'h42) begin // "B"
					next_state = PLAY_BACKWARD;
				end else if (ascii_code == 8'h52) begin // "R"
					next_state = RESTART;
				end else begin
					next_state = CHECK_KEY;
				end
			end
			STOP: begin
				if ((ascii_code == 8'h45) | (ascii_code == 8'h46)) begin // "E" or "F"
					next_state = PLAY_FORWARD;
				end else if (ascii_code == 8'h42) begin // "B"
					next_state = PLAY_BACKWARD;
				end else if (ascii_code == 8'h52) begin // "R"
					next_state = RESTART;
				end else begin
					next_state = STOP;
				end
			end
			PLAY_FORWARD: begin
				if (ascii_code == 8'h44) begin // "D"
					next_state = STOP;
				end else if (ascii_code == 8'h52) begin // "R"
					next_state = RESTART;
				end else if (ascii_code == 8'h42) begin
					next_state = PLAY_BACKWARD;
				end else begin
					next_state = PLAY_FORWARD;
				end
			end
			PLAY_BACKWARD: begin
				if (ascii_code == 8'h44) begin // "D"
					next_state = STOP;
				end else if (ascii_code == 8'h52) begin // "R"
					next_state = RESTART;
				end else if ((ascii_code == 8'h45) | (ascii_code == 8'h46)) begin // "E" or "F"
					next_state = PLAY_FORWARD;
				end else begin
					next_state = PLAY_BACKWARD;
				end
			end
			RESTART: begin
				next_state = CHECK_KEY;
			end 
			default: begin
				next_state = CHECK_KEY;
			end
		endcase
	end
	
	always_ff @(posedge clk, negedge reset_n) begin
		if (!reset_n) begin
			pause <= 1'b0;
			reverse <= 1'b0;
			restart <= 1'b0;
		end else begin
			pause <= next_pause;
			reverse <= next_reverse;
			restart <= next_restart;
		end
	end
	
	always_comb begin
		case (state)
			CHECK_KEY: begin
				next_pause = 1'b0;
				next_reverse = 1'b0;
				next_restart = 1'b0;
			end
			STOP: begin
				next_pause = 1'b1;
				next_reverse = 1'b0;
				next_restart = 1'b0;
			end
			PLAY_FORWARD: begin
				next_pause = 1'b0;
				next_reverse = 1'b0;
				next_restart = 1'b0;
			end
			PLAY_BACKWARD: begin
				next_pause = 1'b0;
				next_reverse = 1'b1;
				next_restart = 1'b0;
			end
			RESTART: begin
				next_pause = 1'b0;
				next_reverse = 1'b0;
				next_restart = 1'b1;
			end
			default: begin
				next_pause = 1'b0;
				next_reverse = 1'b0;
				next_restart = 1'b0;
			end
		endcase
		end
endmodule