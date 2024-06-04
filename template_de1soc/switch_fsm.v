module Switch_FSM(
    input wire clk,
    input wire reset_n,
    input wire [9:0] SW, // Using SW switches for control
    output reg pause,
    output reg reverse,
    output reg restart,
	 output reg [2:0] state
);

    // FSM States
    parameter CHECK_SW = 3'b000;
    parameter STOP = 3'b001;
    parameter PLAY_FORWARD = 3'b010;
    parameter PLAY_BACKWARD = 3'b011;
    parameter RESTART = 3'b100;
    
    reg [2:0] next_state;
    reg next_pause, next_reverse, next_restart;
    
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= CHECK_SW;
        end else begin
            state <= next_state;
        end
    end
    
    always_comb begin
        case (state)
            CHECK_SW: begin
                if (SW[2]) begin // "D" for Pause
                    next_state = STOP;
                end else if (SW[3] || SW[4]) begin // "E" or "F" for Play Forward
                    next_state = PLAY_FORWARD;
                end else if (SW[5]) begin // "B" for Play Backward
                    next_state = PLAY_BACKWARD;
                end else if (SW[6]) begin // "R" for Restart
                    next_state = RESTART;
                end else begin
						next_state = CHECK_SW;
					 end
            end
            STOP: begin
                if (SW[3] || SW[4]) begin // "E" or "F" for Play Forward
                    next_state = PLAY_FORWARD;
                end else if (SW[5]) begin // "B" for Play Backward
                    next_state = PLAY_BACKWARD;
                end else if (SW[6]) begin // "R" for Restart
                    next_state = RESTART;
                end else begin
						next_state = STOP;
					 end
            end
            PLAY_FORWARD: begin
                if (SW[2]) begin // "D" for Pause
                    next_state = STOP;
                end else if (SW[6]) begin // "R" for Restart
                    next_state = RESTART;
                end else if (SW[5]) begin
						next_state = PLAY_BACKWARD;
					 end else begin
						next_state = PLAY_FORWARD;
					 end
            end
            PLAY_BACKWARD: begin
                if (SW[2]) begin // "D" for Pause
                    next_state = STOP;
                end else if (SW[6]) begin // "R" for Restart
                    next_state = RESTART;
                end else if (SW[3] || SW[4]) begin
							next_state = PLAY_FORWARD;
					end else begin
						next_state = PLAY_BACKWARD;
					 end
            end
            RESTART: begin
                next_state = CHECK_SW;
            end 
            default: begin
                next_state = CHECK_SW;
            end
        endcase
    end
    
    always_ff @(posedge clk or negedge reset_n) begin
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
            CHECK_SW: begin
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
