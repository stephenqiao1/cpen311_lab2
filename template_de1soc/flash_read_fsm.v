module Flash_Read_FSM (
	input wire clk,
	input wire start_read,
	input wire flash_mem_waitrequest,
	input wire flash_mem_readdatavalid,
	output reg flash_mem_read,
	output reg [31:0] read_data,
	output reg read_done,
	output reg [2:0] state
);

	// FSM States
	parameter IDLE = 3'b000;
	parameter READ = 3'b001;
	parameter WAIT = 3'b010;
	parameter CHECK_VALID = 3'b011;
	parameter OUTPUT = 3'b100;
	
	reg [2:0] next_state;
	reg next_flash_mem_read, next_read_done;
	
	always_ff @(posedge clk) begin
		if (!start_read) begin
			state <= IDLE;
		end else begin
		case (state)
			IDLE: begin
				if (start_read) begin
					state <= READ;
				end else begin
					state <= IDLE;
				end
			end
			READ: begin
				if (flash_mem_waitrequest) begin
					state <= WAIT;
				end else begin
					state <= READ;
				end
			end
			WAIT: begin
				if (!flash_mem_waitrequest) begin
					state <= CHECK_VALID;
				end else begin
					state <= WAIT;
				end
			end
			CHECK_VALID: begin
				if (!flash_mem_readdatavalid) begin
					state <= OUTPUT;
				end else begin
					state <= IDLE;
				end
			end
			OUTPUT: begin
				if (read_done) begin
					state <= IDLE;
				end else begin
					state <= OUTPUT;
				end
			end
			default: begin
				state <= IDLE;
			end
		endcase
	end
end
	
	
	always_ff @(posedge clk) begin
		if (!start_read) begin
			flash_mem_read <= 1'b0;
			read_done <= 1'b0;
		end else begin
			case (state)
			IDLE: begin
				flash_mem_read <= 1'b1;
				read_done <= 1'b0;
			end
			READ: begin
				flash_mem_read <= 1'b0;
				read_done <= 1'b0;
			end
			WAIT: begin
				flash_mem_read <= 1'b0;
				read_done <= 1'b0;
			end
			CHECK_VALID: begin
				flash_mem_read <= 1'b0;
				read_done <= 1'b0;
			end
			OUTPUT: begin
				flash_mem_read <= 1'b0;
				read_done <= 1'b1;
			end
			default: begin
				flash_mem_read <= 1'b0;
				read_done <= 1'b0;
			end
			endcase
		end
	end

endmodule