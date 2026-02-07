 //==============================================================================
// Control Module for Simon Project
//==============================================================================
module SimonControl(
    // External Inputs 
    input clk,
    input rst,
    input lvl,

    // Datapath Inputs to Controller 
    input continue,
    input correct,
    input legal,

    // Datapath Control Outputs to Datapath 
    output reg seq_ctr_inc,
    output reg pbrd_ctr_inc,
    output reg led,
    output reg wr,
    output reg [2:0] mode_leds
);

    // FSM States 
    localparam STATE_INPUT   = 2'd0;
    localparam STATE_PLAYBACK= 2'd1;
    localparam STATE_REPEAT  = 2'd2;
    localparam STATE_DONE    = 2'd3;

    // Local Variables 
    reg [1:0] state, next_state;

    // Output Logic Based on State  
    always @(*) begin
        // Defaults
        seq_ctr_inc = 0;
        pbrd_ctr_inc = 0;
        led = 0;
        wr = 0;

        case (state)
            STATE_INPUT: begin
                mode_leds = 3'b001;
                wr = legal;           // Only write if legal pattern
                seq_ctr_inc = legal;  // Advance pattern sequence if legal
            end
            STATE_PLAYBACK: begin
                mode_leds = 3'b010;
                led = 1;
                pbrd_ctr_inc = 1;
            end
            STATE_REPEAT: begin
                mode_leds = 3'b100;
                pbrd_ctr_inc = 1;
            end
            STATE_DONE: begin
                mode_leds = 3'b111;
                led = 1;
                pbrd_ctr_inc = 1;
            end
        endcase
    end

    // Next State Logic/State Transition Logic
    always @(*) begin
        next_state = state;
        case(state)
            STATE_INPUT:    next_state = legal      ? STATE_PLAYBACK : STATE_INPUT;
            STATE_PLAYBACK: next_state = continue   ? STATE_PLAYBACK : STATE_REPEAT;
            STATE_REPEAT:   next_state = !correct   ? STATE_DONE     : (!continue ? STATE_INPUT : STATE_REPEAT);
            STATE_DONE:     next_state = STATE_DONE;
        endcase
    end

    // State Update Sequential Logic - with debug printing
    always @(posedge clk) begin
        if (rst) begin
            state <= STATE_INPUT;
            $display("[DEBUG] FSM rst: state=STATE_INPUT at %t", $time);
        end else begin
            state <= next_state;
            $display("[DEBUG] FSM clk: state=%d (%0s), next_state=%d (%0s), mode_leds=%b at %t",
                state, state_name(state),
                next_state, state_name(next_state),
                mode_leds, $time);
        end
    end

    // Helper to decode state as string
    function [39:0] state_name;
        input [1:0] st;
        case(st)
            STATE_INPUT:    state_name = "STATE_INPUT";
            STATE_PLAYBACK: state_name = "STATE_PLAYBACK";
            STATE_REPEAT:   state_name = "STATE_REPEAT";
            STATE_DONE:     state_name = "STATE_DONE";
            default:        state_name = "UNKNOWN";
        endcase
    endfunction

endmodule 




