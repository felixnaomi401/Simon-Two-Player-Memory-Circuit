//==============================================================================
//  Simon Module (connecting Datapath and Control) 
//=
module Simon(
    input        pclk,
    input        rst,
    input        level,
    input  [3:0] pattern,

    output [3:0] pattern_leds,
    output [2:0] mode_leds
);

    // Internal wires connecting Datapath and Control
    wire seq_ctr_inc;
    wire pbrd_ctr_inc;
    wire led;
    wire wr;

    wire lvl;
    wire continue;
    wire correct;
    wire legal;

    // Datapath instantiation
    SimonDatapath dpath(
        .clk(pclk),
        .level(level),
        .pattern(pattern),
        .rst(rst),
        .seq_ctr_inc(seq_ctr_inc),
        .pbrd_ctr_inc(pbrd_ctr_inc),
        .led(led),
        .wr(wr),
        .lvl(lvl),
        .continue(continue),
        .correct(correct),
        .legal(legal),
        .pattern_leds(pattern_leds)
    );

    // Control instantiation
    SimonControl ctrl(
        .clk(pclk),
        .rst(rst),
        .lvl(lvl),
        .continue(continue),
        .correct(correct),
        .legal(legal),
        .seq_ctr_inc(seq_ctr_inc),
        .pbrd_ctr_inc(pbrd_ctr_inc),
        .led(led),
        .wr(wr),
        .mode_leds(mode_leds)
    );

endmodule






