`timescale 1ns / 1ps

module TetrisTopModule(
  input wire clk,			//master clock = 100MHz
  input wire clr,			//center pushbutton for reset
  output wire [6:0] seg,	//7-segment display LEDs
  output wire [3:0] an,	    //7-segment display anode enable
  output wire [3:0] red,	//red vga output - 3 bits
  output wire [3:0] green,  //green vga output - 3 bits
  output wire [3:0] blue,	//blue vga output - 2 bits
  output wire hsync,		//horizontal sync out
  output wire vsync,		//vertical sync out

  // buttons and switches
  input wire btnU,	
  input wire btnD,
  input wire btnL,
  input wire btnR
);


  wire dclk;                            // VGA display clock interconnect
  wire logicclk;                        // Game logic clock interconnect
  wire up, down, left, right;

  // Game data interconnect wires
  wire [287:0] grid;
  wire [9:0] posX1;
  wire [9:0] posY1;
  wire [9:0] posX2;
  wire [9:0] posY2;
  wire [9:0] posX3;
  wire [9:0] posY3;
  wire [9:0] posX4;
  wire [9:0] posY4;
  
  wire [2:0] NextBlock;
  wire [13:0] score;
  wire gameOver;
    
  // use clk wizard ip, out1 25.175 mhz, out2 30mhz
   vgaCLKDIV clkDivider (
        .clk_in1(clk),
        .clk_out1(dclk),
        .clk_out2(logicclk),
        .reset(clr)
   );
   
    // Linear Feedback Shift Register (LFSR) Random Generate
    RandomGen rand_NextBlock (
        .clk(dclk),
        .reset(clr),
        .rnd(NextBlock)
    );
    
  ButtonModule buttons( btnU, btnD, btnL, btnR, up, down, left, right, logicclk);

  GameLogicV2 gl(
    .clk(dclk),
    .reset(clr),
    .outGrid(grid),
    .x1(posX1),
    .y1(posY1),
    .x2(posX2),
    .y2(posY2),
    .x3(posX3),
    .y3(posY3),
    .x4(posX4),
    .y4(posY4),
    .right(right),
    .left(left),
    .down(down),
    .up(up),
    .stop(stop),
    .nextBlockRand( NextBlock),
    .gameOver( gameOver),
    .score( score)
  );

  // VGA controller
  GameDisplay display(
    .dclk(dclk),
    .clr(clr),
    .hsync(hsync),
    .vsync(vsync),
    .red(red),
    .green(green),
    .blue(blue),
    .inputGrid(grid),
    .posX1(posX1),
    .posY1(posY1),
    .posX2(posX2),
    .posY2(posY2),
    .posX3(posX3),
    .posY3(posY3),
    .posX4(posX4),
    .posY4(posY4),
    .gameOver( gameOver) 
  );
  
  ScoreDisplay score7Seg( .score( score), .clk(logicclk), .reset(clr), .an(an), .seg(seg));

endmodule