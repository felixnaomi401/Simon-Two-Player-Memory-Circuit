//==============================================================================
// Datapath for Simon Project
//==============================================================================
 module SimonDatapath(
    // External Inputs 
    input clk,
    input level,                  // Live switch, latched on reset
    input [3:0] pattern,
    input rst,

    // Datapath Control Signals (From Controller to Datapath) 
    input seq_ctr_inc,
    input pbrd_ctr_inc,
    input led,
    input wr,

    // Datapath Outputs to Controller (From Datapath to Controller) 
    output reg lvl,               // Latched mode (0: easy, 1: hard)
    output reg continue,
    output reg correct,
    output reg legal,
    output reg [3:0] pattern_leds
);
    // Local Registers & Memory Connection 
    reg [5:0] seq_ctr, pbrd_ctr;
    wire [3:0] read_data;

    // Memory Instance (64-entry 4-bit Memory) 
    Memory mem(
        .clk(clk),
        .rst(rst),
        .r_addr(pbrd_ctr),
        .w_addr(seq_ctr),
        .w_data(pattern),
        .w_en(wr),
        .r_data(read_data)
    );

    reg last_led;
    reg playback_just_entered;

    // Sequential Logic 
    always @(posedge clk) begin
        last_led <= led;
        playback_just_entered <= (!last_led && led);

        if (rst) begin
            seq_ctr  <= 0;
            pbrd_ctr <= 0;
            lvl      <= level;
            // Prints AFTER assignment, so we see the new value
            $display("[DEBUG] Reset: lvl=%b (should match level=%b), time=%t", lvl, level, $time);
        end else begin
            if (seq_ctr_inc)
                seq_ctr <= seq_ctr + 1;
            if (playback_just_entered)
                pbrd_ctr <= 0;
            else if (pbrd_ctr_inc)
                pbrd_ctr <= (pbrd_ctr == seq_ctr - 1) ? 0 : pbrd_ctr + 1;
        end

        // Print the latched mode and current live level every clock
        $display("[DEBUG] CLK: lvl=%b, live level=%b, pattern=%b, legal=%b, time=%t",
            lvl, level, pattern, legal, $time);
    end

   // Combinational Outputs 
    always @(*) begin
        // Use only the latched mode
        legal    = (lvl == 1) ? 1'b1 : ((pattern[0] + pattern[1] + pattern[2] + pattern[3]) == 1);
        correct  = (pattern == read_data);
        continue = (pbrd_ctr < seq_ctr - 1);
        pattern_leds = led ? read_data : pattern;
    end
 endmodule
