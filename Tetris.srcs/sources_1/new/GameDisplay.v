`timescale 1ns / 1ps

module GameDisplay(
  input wire dclk,		//pixel clock: 25MHz
  input wire clr,			//asynchronous reset
  output wire hsync,		//horizontal sync out
  output wire vsync,		//vertical sync out
  output reg [3:0] red,	//red vga output
  output reg [3:0] green, //green vga output
  output reg [3:0] blue,	//blue vga output

  input wire [287:0] inputGrid,
  input wire [9:0] posX1,
  input wire [9:0] posY1,
  input wire [9:0] posX2,
  input wire [9:0] posY2,
  input wire [9:0] posX3,
  input wire [9:0] posY3,
  input wire [9:0] posX4,
  input wire [9:0] posY4,
  input wire gameOver
);

  // video structure constants
  parameter hpixels = 800;// horizontal pixels per line
  parameter vlines = 521; // vertical lines per frame
  parameter hpulse = 96; 	// hsync pulse length
  parameter vpulse = 2; 	// vsync pulse length
  parameter hbp = 144; 	// end of horizontal back porch
  parameter hfp = 784; 	// beginning of horizontal front porch
  parameter vbp = 31; 	// end of vertical back porch
  parameter vfp = 511; 	// beginning of vertical front porch
  // active horizontal video is therefore: 784 - 144 = 640
  // active vertical video is therefore: 511 - 31 = 480

  // registers for storing the horizontal & vertical counters
  reg [9:0] hc;
  reg [9:0] vc;

  reg [287:0] grid ;
  reg [287:0] overGrid ;
  integer i, j;
  
  always @(posedge dclk or posedge clr)
  begin
  
     // reset condition
    if (clr == 1) begin
        for ( i = 0; i < 24; i = i + 1)
          for ( j = 0; j < 12; j = j + 1)
            overGrid[i*12+j] = 1;
        
        // B
        overGrid[4*12+2] = 0;
        overGrid[5*12+2] = 0;
        overGrid[6*12+2] = 0;
        overGrid[7*12+2] = 0;
        overGrid[8*12+2] = 0;
        overGrid[9*12+2] = 0;
        overGrid[10*12+2] = 0;
        
        overGrid[4*12+3] = 0;
        overGrid[7*12+3] = 0;
        overGrid[10*12+3] = 0;
        
        overGrid[4*12+4] = 0;
        overGrid[7*12+4] = 0;
        overGrid[10*12+4] = 0;
        
        overGrid[5*12+5] = 0;
        overGrid[6*12+5] = 0;
        overGrid[8*12+5] = 0;
        overGrid[9*12+5] = 0;
        
        // e
        overGrid[6*12+7] = 0;
        overGrid[7*12+7] = 0;
        overGrid[8*12+7] = 0;
        overGrid[9*12+7] = 0;
        overGrid[10*12+7] = 0;
        
        overGrid[6*12+8] = 0;
        overGrid[8*12+8] = 0;
        overGrid[10*12+8] = 0;
        
        overGrid[6*12+9] = 0;
        overGrid[7*12+9] = 0;
        overGrid[8*12+9] = 0;
        overGrid[10*12+9] = 0;
        
        // C
        overGrid[15*12+2] = 0;
        overGrid[16*12+2] = 0;
        overGrid[17*12+2] = 0;
        overGrid[18*12+2] = 0;
        overGrid[19*12+2] = 0;
        
        overGrid[14*12+3] = 0;
        overGrid[20*12+3] = 0;
        
        overGrid[14*12+4] = 0;
        overGrid[20*12+4] = 0;
        
        overGrid[15*12+5] = 0;
        overGrid[19*12+5] = 0;
        
        // h
        overGrid[14*12+7] = 0;
        overGrid[15*12+7] = 0;
        overGrid[16*12+7] = 0;
        overGrid[17*12+7] = 0;
        overGrid[18*12+7] = 0;
        overGrid[19*12+7] = 0;
        overGrid[20*12+7] = 0;
        
        overGrid[17*12+8] = 0;
        
        overGrid[18*12+9] = 0;
        overGrid[19*12+9] = 0;
        overGrid[20*12+9] = 0;

        grid <= inputGrid;
      end else begin
        if ( gameOver)
            grid <= overGrid;
        else
            grid <= inputGrid;
      end
  end

  always @(posedge dclk or posedge clr)
    begin
      // reset condition
      if (clr == 1)
        begin
          hc <= 0;
          vc <= 0;
        end
      else begin
        if (hc < hpixels - 1)
          hc <= hc + 1;
        else begin
          hc <= 0;
          if (vc < vlines - 1)
            vc <= vc + 1;
          else begin
            vc <= 0;
          end
        end
      end
    end

  assign hsync = (hc < hpulse) ? 0:1;
  assign vsync = (vc < vpulse) ? 0:1;

  always @(*) begin
    // first check if we're within vertical active video range
    if (vc >= vbp + 5 && vc < 475) begin // vbp + 5 and vfp - 20 because display glitch
      // GENERATED CODE BEGINS HERE

      if (vc > 40 &&  vc < 60) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 2 && posX1 == 1) || ( posY2 == 2 && posX2 == 1) || ( posY3 == 2 && posX3 == 1) || ( posY4 == 2 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[2*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 2 && posX1 == 2) || ( posY2 == 2 && posX2 == 2) || ( posY3 == 2 && posX3 == 2) || ( posY4 == 2 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[2*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 2 && posX1 == 3) || ( posY2 == 2 && posX2 == 3) || ( posY3 == 2 && posX3 == 3) || ( posY4 == 2 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[2*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 2 && posX1 == 4) || ( posY2 == 2 && posX2 == 4) || ( posY3 == 2 && posX3 == 4) || ( posY4 == 2 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[2*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 2 && posX1 == 5) || ( posY2 == 2 && posX2 == 5) || ( posY3 == 2 && posX3 == 5) || ( posY4 == 2 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[2*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 2 && posX1 == 6) || ( posY2 == 2 && posX2 == 6) || ( posY3 == 2 && posX3 == 6) || ( posY4 == 2 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[2*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 2 && posX1 == 7) || ( posY2 == 2 && posX2 == 7) || ( posY3 == 2 && posX3 == 7) || ( posY4 == 2 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[2*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 2 && posX1 == 8) || ( posY2 == 2 && posX2 == 8) || ( posY3 == 2 && posX3 == 8) || ( posY4 == 2 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[2*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 2 && posX1 == 9) || ( posY2 == 2 && posX2 == 9) || ( posY3 == 2 && posX3 == 9) || ( posY4 == 2 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[2*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 2 && posX1 == 10) || ( posY2 == 2 && posX2 == 10) || ( posY3 == 2 && posX3 == 10) || ( posY4 == 2 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[2*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 60 &&  vc < 80) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 3 && posX1 == 1) || ( posY2 == 3 && posX2 == 1) || ( posY3 == 3 && posX3 == 1) || ( posY4 == 3 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[3*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 3 && posX1 == 2) || ( posY2 == 3 && posX2 == 2) || ( posY3 == 3 && posX3 == 2) || ( posY4 == 3 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[3*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 3 && posX1 == 3) || ( posY2 == 3 && posX2 == 3) || ( posY3 == 3 && posX3 == 3) || ( posY4 == 3 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[3*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 3 && posX1 == 4) || ( posY2 == 3 && posX2 == 4) || ( posY3 == 3 && posX3 == 4) || ( posY4 == 3 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[3*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 3 && posX1 == 5) || ( posY2 == 3 && posX2 == 5) || ( posY3 == 3 && posX3 == 5) || ( posY4 == 3 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[3*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 3 && posX1 == 6) || ( posY2 == 3 && posX2 == 6) || ( posY3 == 3 && posX3 == 6) || ( posY4 == 3 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[3*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 3 && posX1 == 7) || ( posY2 == 3 && posX2 == 7) || ( posY3 == 3 && posX3 == 7) || ( posY4 == 3 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[3*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 3 && posX1 == 8) || ( posY2 == 3 && posX2 == 8) || ( posY3 == 3 && posX3 == 8) || ( posY4 == 3 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[3*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 3 && posX1 == 9) || ( posY2 == 3 && posX2 == 9) || ( posY3 == 3 && posX3 == 9) || ( posY4 == 3 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[3*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 3 && posX1 == 10) || ( posY2 == 3 && posX2 == 10) || ( posY3 == 3 && posX3 == 10) || ( posY4 == 3 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[3*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 80 &&  vc < 100) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 4 && posX1 == 1) || ( posY2 == 4 && posX2 == 1) || ( posY3 == 4 && posX3 == 1) || ( posY4 == 4 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[4*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 4 && posX1 == 2) || ( posY2 == 4 && posX2 == 2) || ( posY3 == 4 && posX3 == 2) || ( posY4 == 4 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[4*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 4 && posX1 == 3) || ( posY2 == 4 && posX2 == 3) || ( posY3 == 4 && posX3 == 3) || ( posY4 == 4 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[4*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 4 && posX1 == 4) || ( posY2 == 4 && posX2 == 4) || ( posY3 == 4 && posX3 == 4) || ( posY4 == 4 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[4*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 4 && posX1 == 5) || ( posY2 == 4 && posX2 == 5) || ( posY3 == 4 && posX3 == 5) || ( posY4 == 4 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[4*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 4 && posX1 == 6) || ( posY2 == 4 && posX2 == 6) || ( posY3 == 4 && posX3 == 6) || ( posY4 == 4 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[4*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 4 && posX1 == 7) || ( posY2 == 4 && posX2 == 7) || ( posY3 == 4 && posX3 == 7) || ( posY4 == 4 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[4*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 4 && posX1 == 8) || ( posY2 == 4 && posX2 == 8) || ( posY3 == 4 && posX3 == 8) || ( posY4 == 4 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[4*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 4 && posX1 == 9) || ( posY2 == 4 && posX2 == 9) || ( posY3 == 4 && posX3 == 9) || ( posY4 == 4 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[4*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 4 && posX1 == 10) || ( posY2 == 4 && posX2 == 10) || ( posY3 == 4 && posX3 == 10) || ( posY4 == 4 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[4*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 100 &&  vc < 120) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 5 && posX1 == 1) || ( posY2 == 5 && posX2 == 1) || ( posY3 == 5 && posX3 == 1) || ( posY4 == 5 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[5*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 5 && posX1 == 2) || ( posY2 == 5 && posX2 == 2) || ( posY3 == 5 && posX3 == 2) || ( posY4 == 5 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[5*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 5 && posX1 == 3) || ( posY2 == 5 && posX2 == 3) || ( posY3 == 5 && posX3 == 3) || ( posY4 == 5 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[5*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 5 && posX1 == 4) || ( posY2 == 5 && posX2 == 4) || ( posY3 == 5 && posX3 == 4) || ( posY4 == 5 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[5*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 5 && posX1 == 5) || ( posY2 == 5 && posX2 == 5) || ( posY3 == 5 && posX3 == 5) || ( posY4 == 5 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[5*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 5 && posX1 == 6) || ( posY2 == 5 && posX2 == 6) || ( posY3 == 5 && posX3 == 6) || ( posY4 == 5 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[5*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 5 && posX1 == 7) || ( posY2 == 5 && posX2 == 7) || ( posY3 == 5 && posX3 == 7) || ( posY4 == 5 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[5*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 5 && posX1 == 8) || ( posY2 == 5 && posX2 == 8) || ( posY3 == 5 && posX3 == 8) || ( posY4 == 5 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[5*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 5 && posX1 == 9) || ( posY2 == 5 && posX2 == 9) || ( posY3 == 5 && posX3 == 9) || ( posY4 == 5 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[5*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 5 && posX1 == 10) || ( posY2 == 5 && posX2 == 10) || ( posY3 == 5 && posX3 == 10) || ( posY4 == 5 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[5*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 120 &&  vc < 140) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 6 && posX1 == 1) || ( posY2 == 6 && posX2 == 1) || ( posY3 == 6 && posX3 == 1) || ( posY4 == 6 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[6*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 6 && posX1 == 2) || ( posY2 == 6 && posX2 == 2) || ( posY3 == 6 && posX3 == 2) || ( posY4 == 6 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[6*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 6 && posX1 == 3) || ( posY2 == 6 && posX2 == 3) || ( posY3 == 6 && posX3 == 3) || ( posY4 == 6 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[6*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 6 && posX1 == 4) || ( posY2 == 6 && posX2 == 4) || ( posY3 == 6 && posX3 == 4) || ( posY4 == 6 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[6*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 6 && posX1 == 5) || ( posY2 == 6 && posX2 == 5) || ( posY3 == 6 && posX3 == 5) || ( posY4 == 6 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[6*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 6 && posX1 == 6) || ( posY2 == 6 && posX2 == 6) || ( posY3 == 6 && posX3 == 6) || ( posY4 == 6 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[6*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 6 && posX1 == 7) || ( posY2 == 6 && posX2 == 7) || ( posY3 == 6 && posX3 == 7) || ( posY4 == 6 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[6*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 6 && posX1 == 8) || ( posY2 == 6 && posX2 == 8) || ( posY3 == 6 && posX3 == 8) || ( posY4 == 6 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[6*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 6 && posX1 == 9) || ( posY2 == 6 && posX2 == 9) || ( posY3 == 6 && posX3 == 9) || ( posY4 == 6 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[6*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 6 && posX1 == 10) || ( posY2 == 6 && posX2 == 10) || ( posY3 == 6 && posX3 == 10) || ( posY4 == 6 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[6*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 140 &&  vc < 160) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 7 && posX1 == 1) || ( posY2 == 7 && posX2 == 1) || ( posY3 == 7 && posX3 == 1) || ( posY4 == 7 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[7*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 7 && posX1 == 2) || ( posY2 == 7 && posX2 == 2) || ( posY3 == 7 && posX3 == 2) || ( posY4 == 7 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[7*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 7 && posX1 == 3) || ( posY2 == 7 && posX2 == 3) || ( posY3 == 7 && posX3 == 3) || ( posY4 == 7 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[7*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 7 && posX1 == 4) || ( posY2 == 7 && posX2 == 4) || ( posY3 == 7 && posX3 == 4) || ( posY4 == 7 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[7*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 7 && posX1 == 5) || ( posY2 == 7 && posX2 == 5) || ( posY3 == 7 && posX3 == 5) || ( posY4 == 7 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[7*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 7 && posX1 == 6) || ( posY2 == 7 && posX2 == 6) || ( posY3 == 7 && posX3 == 6) || ( posY4 == 7 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[7*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 7 && posX1 == 7) || ( posY2 == 7 && posX2 == 7) || ( posY3 == 7 && posX3 == 7) || ( posY4 == 7 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[7*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 7 && posX1 == 8) || ( posY2 == 7 && posX2 == 8) || ( posY3 == 7 && posX3 == 8) || ( posY4 == 7 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[7*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 7 && posX1 == 9) || ( posY2 == 7 && posX2 == 9) || ( posY3 == 7 && posX3 == 9) || ( posY4 == 7 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[7*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 7 && posX1 == 10) || ( posY2 == 7 && posX2 == 10) || ( posY3 == 7 && posX3 == 10) || ( posY4 == 7 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[7*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 160 &&  vc < 180) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 8 && posX1 == 1) || ( posY2 == 8 && posX2 == 1) || ( posY3 == 8 && posX3 == 1) || ( posY4 == 8 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[8*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 8 && posX1 == 2) || ( posY2 == 8 && posX2 == 2) || ( posY3 == 8 && posX3 == 2) || ( posY4 == 8 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[8*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 8 && posX1 == 3) || ( posY2 == 8 && posX2 == 3) || ( posY3 == 8 && posX3 == 3) || ( posY4 == 8 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[8*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 8 && posX1 == 4) || ( posY2 == 8 && posX2 == 4) || ( posY3 == 8 && posX3 == 4) || ( posY4 == 8 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[8*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 8 && posX1 == 5) || ( posY2 == 8 && posX2 == 5) || ( posY3 == 8 && posX3 == 5) || ( posY4 == 8 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[8*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 8 && posX1 == 6) || ( posY2 == 8 && posX2 == 6) || ( posY3 == 8 && posX3 == 6) || ( posY4 == 8 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[8*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 8 && posX1 == 7) || ( posY2 == 8 && posX2 == 7) || ( posY3 == 8 && posX3 == 7) || ( posY4 == 8 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[8*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 8 && posX1 == 8) || ( posY2 == 8 && posX2 == 8) || ( posY3 == 8 && posX3 == 8) || ( posY4 == 8 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[8*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 8 && posX1 == 9) || ( posY2 == 8 && posX2 == 9) || ( posY3 == 8 && posX3 == 9) || ( posY4 == 8 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[8*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 8 && posX1 == 10) || ( posY2 == 8 && posX2 == 10) || ( posY3 == 8 && posX3 == 10) || ( posY4 == 8 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[8*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 180 &&  vc < 200) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 9 && posX1 == 1) || ( posY2 == 9 && posX2 == 1) || ( posY3 == 9 && posX3 == 1) || ( posY4 == 9 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[9*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 9 && posX1 == 2) || ( posY2 == 9 && posX2 == 2) || ( posY3 == 9 && posX3 == 2) || ( posY4 == 9 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[9*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 9 && posX1 == 3) || ( posY2 == 9 && posX2 == 3) || ( posY3 == 9 && posX3 == 3) || ( posY4 == 9 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[9*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 9 && posX1 == 4) || ( posY2 == 9 && posX2 == 4) || ( posY3 == 9 && posX3 == 4) || ( posY4 == 9 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[9*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 9 && posX1 == 5) || ( posY2 == 9 && posX2 == 5) || ( posY3 == 9 && posX3 == 5) || ( posY4 == 9 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[9*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 9 && posX1 == 6) || ( posY2 == 9 && posX2 == 6) || ( posY3 == 9 && posX3 == 6) || ( posY4 == 9 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[9*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 9 && posX1 == 7) || ( posY2 == 9 && posX2 == 7) || ( posY3 == 9 && posX3 == 7) || ( posY4 == 9 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[9*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 9 && posX1 == 8) || ( posY2 == 9 && posX2 == 8) || ( posY3 == 9 && posX3 == 8) || ( posY4 == 9 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[9*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 9 && posX1 == 9) || ( posY2 == 9 && posX2 == 9) || ( posY3 == 9 && posX3 == 9) || ( posY4 == 9 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[9*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 9 && posX1 == 10) || ( posY2 == 9 && posX2 == 10) || ( posY3 == 9 && posX3 == 10) || ( posY4 == 9 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[9*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 200 &&  vc < 220) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 10 && posX1 == 1) || ( posY2 == 10 && posX2 == 1) || ( posY3 == 10 && posX3 == 1) || ( posY4 == 10 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[10*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 10 && posX1 == 2) || ( posY2 == 10 && posX2 == 2) || ( posY3 == 10 && posX3 == 2) || ( posY4 == 10 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[10*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 10 && posX1 == 3) || ( posY2 == 10 && posX2 == 3) || ( posY3 == 10 && posX3 == 3) || ( posY4 == 10 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[10*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 10 && posX1 == 4) || ( posY2 == 10 && posX2 == 4) || ( posY3 == 10 && posX3 == 4) || ( posY4 == 10 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[10*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 10 && posX1 == 5) || ( posY2 == 10 && posX2 == 5) || ( posY3 == 10 && posX3 == 5) || ( posY4 == 10 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[10*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 10 && posX1 == 6) || ( posY2 == 10 && posX2 == 6) || ( posY3 == 10 && posX3 == 6) || ( posY4 == 10 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[10*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 10 && posX1 == 7) || ( posY2 == 10 && posX2 == 7) || ( posY3 == 10 && posX3 == 7) || ( posY4 == 10 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[10*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 10 && posX1 == 8) || ( posY2 == 10 && posX2 == 8) || ( posY3 == 10 && posX3 == 8) || ( posY4 == 10 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[10*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 10 && posX1 == 9) || ( posY2 == 10 && posX2 == 9) || ( posY3 == 10 && posX3 == 9) || ( posY4 == 10 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[10*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 10 && posX1 == 10) || ( posY2 == 10 && posX2 == 10) || ( posY3 == 10 && posX3 == 10) || ( posY4 == 10 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[10*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 220 &&  vc < 240) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 11 && posX1 == 1) || ( posY2 == 11 && posX2 == 1) || ( posY3 == 11 && posX3 == 1) || ( posY4 == 11 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[11*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 11 && posX1 == 2) || ( posY2 == 11 && posX2 == 2) || ( posY3 == 11 && posX3 == 2) || ( posY4 == 11 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[11*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 11 && posX1 == 3) || ( posY2 == 11 && posX2 == 3) || ( posY3 == 11 && posX3 == 3) || ( posY4 == 11 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[11*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 11 && posX1 == 4) || ( posY2 == 11 && posX2 == 4) || ( posY3 == 11 && posX3 == 4) || ( posY4 == 11 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[11*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 11 && posX1 == 5) || ( posY2 == 11 && posX2 == 5) || ( posY3 == 11 && posX3 == 5) || ( posY4 == 11 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[11*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 11 && posX1 == 6) || ( posY2 == 11 && posX2 == 6) || ( posY3 == 11 && posX3 == 6) || ( posY4 == 11 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[11*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 11 && posX1 == 7) || ( posY2 == 11 && posX2 == 7) || ( posY3 == 11 && posX3 == 7) || ( posY4 == 11 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[11*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 11 && posX1 == 8) || ( posY2 == 11 && posX2 == 8) || ( posY3 == 11 && posX3 == 8) || ( posY4 == 11 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[11*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 11 && posX1 == 9) || ( posY2 == 11 && posX2 == 9) || ( posY3 == 11 && posX3 == 9) || ( posY4 == 11 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[11*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 11 && posX1 == 10) || ( posY2 == 11 && posX2 == 10) || ( posY3 == 11 && posX3 == 10) || ( posY4 == 11 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[11*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 240 &&  vc < 260) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 12 && posX1 == 1) || ( posY2 == 12 && posX2 == 1) || ( posY3 == 12 && posX3 == 1) || ( posY4 == 12 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[12*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 12 && posX1 == 2) || ( posY2 == 12 && posX2 == 2) || ( posY3 == 12 && posX3 == 2) || ( posY4 == 12 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[12*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 12 && posX1 == 3) || ( posY2 == 12 && posX2 == 3) || ( posY3 == 12 && posX3 == 3) || ( posY4 == 12 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[12*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 12 && posX1 == 4) || ( posY2 == 12 && posX2 == 4) || ( posY3 == 12 && posX3 == 4) || ( posY4 == 12 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[12*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 12 && posX1 == 5) || ( posY2 == 12 && posX2 == 5) || ( posY3 == 12 && posX3 == 5) || ( posY4 == 12 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[12*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 12 && posX1 == 6) || ( posY2 == 12 && posX2 == 6) || ( posY3 == 12 && posX3 == 6) || ( posY4 == 12 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[12*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 12 && posX1 == 7) || ( posY2 == 12 && posX2 == 7) || ( posY3 == 12 && posX3 == 7) || ( posY4 == 12 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[12*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 12 && posX1 == 8) || ( posY2 == 12 && posX2 == 8) || ( posY3 == 12 && posX3 == 8) || ( posY4 == 12 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[12*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 12 && posX1 == 9) || ( posY2 == 12 && posX2 == 9) || ( posY3 == 12 && posX3 == 9) || ( posY4 == 12 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[12*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 12 && posX1 == 10) || ( posY2 == 12 && posX2 == 10) || ( posY3 == 12 && posX3 == 10) || ( posY4 == 12 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[12*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 260 &&  vc < 280) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 13 && posX1 == 1) || ( posY2 == 13 && posX2 == 1) || ( posY3 == 13 && posX3 == 1) || ( posY4 == 13 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[13*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 13 && posX1 == 2) || ( posY2 == 13 && posX2 == 2) || ( posY3 == 13 && posX3 == 2) || ( posY4 == 13 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[13*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 13 && posX1 == 3) || ( posY2 == 13 && posX2 == 3) || ( posY3 == 13 && posX3 == 3) || ( posY4 == 13 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[13*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 13 && posX1 == 4) || ( posY2 == 13 && posX2 == 4) || ( posY3 == 13 && posX3 == 4) || ( posY4 == 13 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[13*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 13 && posX1 == 5) || ( posY2 == 13 && posX2 == 5) || ( posY3 == 13 && posX3 == 5) || ( posY4 == 13 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[13*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 13 && posX1 == 6) || ( posY2 == 13 && posX2 == 6) || ( posY3 == 13 && posX3 == 6) || ( posY4 == 13 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[13*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 13 && posX1 == 7) || ( posY2 == 13 && posX2 == 7) || ( posY3 == 13 && posX3 == 7) || ( posY4 == 13 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[13*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 13 && posX1 == 8) || ( posY2 == 13 && posX2 == 8) || ( posY3 == 13 && posX3 == 8) || ( posY4 == 13 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[13*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 13 && posX1 == 9) || ( posY2 == 13 && posX2 == 9) || ( posY3 == 13 && posX3 == 9) || ( posY4 == 13 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[13*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 13 && posX1 == 10) || ( posY2 == 13 && posX2 == 10) || ( posY3 == 13 && posX3 == 10) || ( posY4 == 13 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[13*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 280 &&  vc < 300) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 14 && posX1 == 1) || ( posY2 == 14 && posX2 == 1) || ( posY3 == 14 && posX3 == 1) || ( posY4 == 14 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[14*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 14 && posX1 == 2) || ( posY2 == 14 && posX2 == 2) || ( posY3 == 14 && posX3 == 2) || ( posY4 == 14 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[14*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 14 && posX1 == 3) || ( posY2 == 14 && posX2 == 3) || ( posY3 == 14 && posX3 == 3) || ( posY4 == 14 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[14*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 14 && posX1 == 4) || ( posY2 == 14 && posX2 == 4) || ( posY3 == 14 && posX3 == 4) || ( posY4 == 14 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[14*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 14 && posX1 == 5) || ( posY2 == 14 && posX2 == 5) || ( posY3 == 14 && posX3 == 5) || ( posY4 == 14 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[14*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 14 && posX1 == 6) || ( posY2 == 14 && posX2 == 6) || ( posY3 == 14 && posX3 == 6) || ( posY4 == 14 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[14*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 14 && posX1 == 7) || ( posY2 == 14 && posX2 == 7) || ( posY3 == 14 && posX3 == 7) || ( posY4 == 14 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[14*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 14 && posX1 == 8) || ( posY2 == 14 && posX2 == 8) || ( posY3 == 14 && posX3 == 8) || ( posY4 == 14 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[14*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 14 && posX1 == 9) || ( posY2 == 14 && posX2 == 9) || ( posY3 == 14 && posX3 == 9) || ( posY4 == 14 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[14*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 14 && posX1 == 10) || ( posY2 == 14 && posX2 == 10) || ( posY3 == 14 && posX3 == 10) || ( posY4 == 14 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[14*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 300 &&  vc < 320) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 15 && posX1 == 1) || ( posY2 == 15 && posX2 == 1) || ( posY3 == 15 && posX3 == 1) || ( posY4 == 15 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[15*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 15 && posX1 == 2) || ( posY2 == 15 && posX2 == 2) || ( posY3 == 15 && posX3 == 2) || ( posY4 == 15 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[15*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 15 && posX1 == 3) || ( posY2 == 15 && posX2 == 3) || ( posY3 == 15 && posX3 == 3) || ( posY4 == 15 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[15*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 15 && posX1 == 4) || ( posY2 == 15 && posX2 == 4) || ( posY3 == 15 && posX3 == 4) || ( posY4 == 15 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[15*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 15 && posX1 == 5) || ( posY2 == 15 && posX2 == 5) || ( posY3 == 15 && posX3 == 5) || ( posY4 == 15 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[15*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 15 && posX1 == 6) || ( posY2 == 15 && posX2 == 6) || ( posY3 == 15 && posX3 == 6) || ( posY4 == 15 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[15*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 15 && posX1 == 7) || ( posY2 == 15 && posX2 == 7) || ( posY3 == 15 && posX3 == 7) || ( posY4 == 15 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[15*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 15 && posX1 == 8) || ( posY2 == 15 && posX2 == 8) || ( posY3 == 15 && posX3 == 8) || ( posY4 == 15 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[15*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 15 && posX1 == 9) || ( posY2 == 15 && posX2 == 9) || ( posY3 == 15 && posX3 == 9) || ( posY4 == 15 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[15*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 15 && posX1 == 10) || ( posY2 == 15 && posX2 == 10) || ( posY3 == 15 && posX3 == 10) || ( posY4 == 15 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[15*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 320 &&  vc < 340) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 16 && posX1 == 1) || ( posY2 == 16 && posX2 == 1) || ( posY3 == 16 && posX3 == 1) || ( posY4 == 16 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[16*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 16 && posX1 == 2) || ( posY2 == 16 && posX2 == 2) || ( posY3 == 16 && posX3 == 2) || ( posY4 == 16 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[16*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 16 && posX1 == 3) || ( posY2 == 16 && posX2 == 3) || ( posY3 == 16 && posX3 == 3) || ( posY4 == 16 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[16*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 16 && posX1 == 4) || ( posY2 == 16 && posX2 == 4) || ( posY3 == 16 && posX3 == 4) || ( posY4 == 16 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[16*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 16 && posX1 == 5) || ( posY2 == 16 && posX2 == 5) || ( posY3 == 16 && posX3 == 5) || ( posY4 == 16 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[16*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 16 && posX1 == 6) || ( posY2 == 16 && posX2 == 6) || ( posY3 == 16 && posX3 == 6) || ( posY4 == 16 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[16*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 16 && posX1 == 7) || ( posY2 == 16 && posX2 == 7) || ( posY3 == 16 && posX3 == 7) || ( posY4 == 16 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[16*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 16 && posX1 == 8) || ( posY2 == 16 && posX2 == 8) || ( posY3 == 16 && posX3 == 8) || ( posY4 == 16 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[16*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 16 && posX1 == 9) || ( posY2 == 16 && posX2 == 9) || ( posY3 == 16 && posX3 == 9) || ( posY4 == 16 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[16*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 16 && posX1 == 10) || ( posY2 == 16 && posX2 == 10) || ( posY3 == 16 && posX3 == 10) || ( posY4 == 16 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[16*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 340 &&  vc < 360) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 17 && posX1 == 1) || ( posY2 == 17 && posX2 == 1) || ( posY3 == 17 && posX3 == 1) || ( posY4 == 17 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[17*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 17 && posX1 == 2) || ( posY2 == 17 && posX2 == 2) || ( posY3 == 17 && posX3 == 2) || ( posY4 == 17 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[17*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 17 && posX1 == 3) || ( posY2 == 17 && posX2 == 3) || ( posY3 == 17 && posX3 == 3) || ( posY4 == 17 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[17*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 17 && posX1 == 4) || ( posY2 == 17 && posX2 == 4) || ( posY3 == 17 && posX3 == 4) || ( posY4 == 17 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[17*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 17 && posX1 == 5) || ( posY2 == 17 && posX2 == 5) || ( posY3 == 17 && posX3 == 5) || ( posY4 == 17 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[17*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 17 && posX1 == 6) || ( posY2 == 17 && posX2 == 6) || ( posY3 == 17 && posX3 == 6) || ( posY4 == 17 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[17*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 17 && posX1 == 7) || ( posY2 == 17 && posX2 == 7) || ( posY3 == 17 && posX3 == 7) || ( posY4 == 17 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[17*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 17 && posX1 == 8) || ( posY2 == 17 && posX2 == 8) || ( posY3 == 17 && posX3 == 8) || ( posY4 == 17 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[17*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 17 && posX1 == 9) || ( posY2 == 17 && posX2 == 9) || ( posY3 == 17 && posX3 == 9) || ( posY4 == 17 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[17*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 17 && posX1 == 10) || ( posY2 == 17 && posX2 == 10) || ( posY3 == 17 && posX3 == 10) || ( posY4 == 17 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[17*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 360 &&  vc < 380) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 18 && posX1 == 1) || ( posY2 == 18 && posX2 == 1) || ( posY3 == 18 && posX3 == 1) || ( posY4 == 18 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[18*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 18 && posX1 == 2) || ( posY2 == 18 && posX2 == 2) || ( posY3 == 18 && posX3 == 2) || ( posY4 == 18 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[18*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 18 && posX1 == 3) || ( posY2 == 18 && posX2 == 3) || ( posY3 == 18 && posX3 == 3) || ( posY4 == 18 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[18*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 18 && posX1 == 4) || ( posY2 == 18 && posX2 == 4) || ( posY3 == 18 && posX3 == 4) || ( posY4 == 18 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[18*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 18 && posX1 == 5) || ( posY2 == 18 && posX2 == 5) || ( posY3 == 18 && posX3 == 5) || ( posY4 == 18 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[18*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 18 && posX1 == 6) || ( posY2 == 18 && posX2 == 6) || ( posY3 == 18 && posX3 == 6) || ( posY4 == 18 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[18*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 18 && posX1 == 7) || ( posY2 == 18 && posX2 == 7) || ( posY3 == 18 && posX3 == 7) || ( posY4 == 18 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[18*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 18 && posX1 == 8) || ( posY2 == 18 && posX2 == 8) || ( posY3 == 18 && posX3 == 8) || ( posY4 == 18 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[18*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 18 && posX1 == 9) || ( posY2 == 18 && posX2 == 9) || ( posY3 == 18 && posX3 == 9) || ( posY4 == 18 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[18*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 18 && posX1 == 10) || ( posY2 == 18 && posX2 == 10) || ( posY3 == 18 && posX3 == 10) || ( posY4 == 18 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[18*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 380 &&  vc < 400) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 19 && posX1 == 1) || ( posY2 == 19 && posX2 == 1) || ( posY3 == 19 && posX3 == 1) || ( posY4 == 19 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[19*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 19 && posX1 == 2) || ( posY2 == 19 && posX2 == 2) || ( posY3 == 19 && posX3 == 2) || ( posY4 == 19 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[19*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 19 && posX1 == 3) || ( posY2 == 19 && posX2 == 3) || ( posY3 == 19 && posX3 == 3) || ( posY4 == 19 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[19*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 19 && posX1 == 4) || ( posY2 == 19 && posX2 == 4) || ( posY3 == 19 && posX3 == 4) || ( posY4 == 19 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[19*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 19 && posX1 == 5) || ( posY2 == 19 && posX2 == 5) || ( posY3 == 19 && posX3 == 5) || ( posY4 == 19 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[19*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 19 && posX1 == 6) || ( posY2 == 19 && posX2 == 6) || ( posY3 == 19 && posX3 == 6) || ( posY4 == 19 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[19*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 19 && posX1 == 7) || ( posY2 == 19 && posX2 == 7) || ( posY3 == 19 && posX3 == 7) || ( posY4 == 19 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[19*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 19 && posX1 == 8) || ( posY2 == 19 && posX2 == 8) || ( posY3 == 19 && posX3 == 8) || ( posY4 == 19 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[19*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 19 && posX1 == 9) || ( posY2 == 19 && posX2 == 9) || ( posY3 == 19 && posX3 == 9) || ( posY4 == 19 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[19*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 19 && posX1 == 10) || ( posY2 == 19 && posX2 == 10) || ( posY3 == 19 && posX3 == 10) || ( posY4 == 19 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[19*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 400 &&  vc < 420) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 20 && posX1 == 1) || ( posY2 == 20 && posX2 == 1) || ( posY3 == 20 && posX3 == 1) || ( posY4 == 20 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[20*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 20 && posX1 == 2) || ( posY2 == 20 && posX2 == 2) || ( posY3 == 20 && posX3 == 2) || ( posY4 == 20 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[20*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 20 && posX1 == 3) || ( posY2 == 20 && posX2 == 3) || ( posY3 == 20 && posX3 == 3) || ( posY4 == 20 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[20*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 20 && posX1 == 4) || ( posY2 == 20 && posX2 == 4) || ( posY3 == 20 && posX3 == 4) || ( posY4 == 20 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[20*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 20 && posX1 == 5) || ( posY2 == 20 && posX2 == 5) || ( posY3 == 20 && posX3 == 5) || ( posY4 == 20 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[20*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 20 && posX1 == 6) || ( posY2 == 20 && posX2 == 6) || ( posY3 == 20 && posX3 == 6) || ( posY4 == 20 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[20*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 20 && posX1 == 7) || ( posY2 == 20 && posX2 == 7) || ( posY3 == 20 && posX3 == 7) || ( posY4 == 20 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[20*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 20 && posX1 == 8) || ( posY2 == 20 && posX2 == 8) || ( posY3 == 20 && posX3 == 8) || ( posY4 == 20 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[20*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 20 && posX1 == 9) || ( posY2 == 20 && posX2 == 9) || ( posY3 == 20 && posX3 == 9) || ( posY4 == 20 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[20*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 20 && posX1 == 10) || ( posY2 == 20 && posX2 == 10) || ( posY3 == 20 && posX3 == 10) || ( posY4 == 20 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[20*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 420 &&  vc < 440) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 21 && posX1 == 1) || ( posY2 == 21 && posX2 == 1) || ( posY3 == 21 && posX3 == 1) || ( posY4 == 21 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[21*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 21 && posX1 == 2) || ( posY2 == 21 && posX2 == 2) || ( posY3 == 21 && posX3 == 2) || ( posY4 == 21 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[21*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 21 && posX1 == 3) || ( posY2 == 21 && posX2 == 3) || ( posY3 == 21 && posX3 == 3) || ( posY4 == 21 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[21*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 21 && posX1 == 4) || ( posY2 == 21 && posX2 == 4) || ( posY3 == 21 && posX3 == 4) || ( posY4 == 21 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[21*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 21 && posX1 == 5) || ( posY2 == 21 && posX2 == 5) || ( posY3 == 21 && posX3 == 5) || ( posY4 == 21 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[21*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 21 && posX1 == 6) || ( posY2 == 21 && posX2 == 6) || ( posY3 == 21 && posX3 == 6) || ( posY4 == 21 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[21*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 21 && posX1 == 7) || ( posY2 == 21 && posX2 == 7) || ( posY3 == 21 && posX3 == 7) || ( posY4 == 21 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[21*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 21 && posX1 == 8) || ( posY2 == 21 && posX2 == 8) || ( posY3 == 21 && posX3 == 8) || ( posY4 == 21 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[21*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 21 && posX1 == 9) || ( posY2 == 21 && posX2 == 9) || ( posY3 == 21 && posX3 == 9) || ( posY4 == 21 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[21*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 21 && posX1 == 10) || ( posY2 == 21 && posX2 == 10) || ( posY3 == 21 && posX3 == 10) || ( posY4 == 21 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[21*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
          red   = 4'b0000;
          green = 4'b0000;
          blue  = 4'b0000;
        end
      end
      else if (vc > 440 &&  vc < 460) begin
        if (hc >360 &&  hc <380) begin
          if ( ( posY1 == 22 && posX1 == 1) || ( posY2 == 22 && posX2 == 1) || ( posY3 == 22 && posX3 == 1) || ( posY4 == 22 && posX4 == 1)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[22*12+1]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >380 &&  hc <400) begin
          if ( ( posY1 == 22 && posX1 == 2) || ( posY2 == 22 && posX2 == 2) || ( posY3 == 22 && posX3 == 2) || ( posY4 == 22 && posX4 == 2)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[22*12+2]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >400 &&  hc <420) begin
          if ( ( posY1 == 22 && posX1 == 3) || ( posY2 == 22 && posX2 == 3) || ( posY3 == 22 && posX3 == 3) || ( posY4 == 22 && posX4 == 3)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[22*12+3]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >420 &&  hc <440) begin
          if ( ( posY1 == 22 && posX1 == 4) || ( posY2 == 22 && posX2 == 4) || ( posY3 == 22 && posX3 == 4) || ( posY4 == 22 && posX4 == 4)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[22*12+4]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >440 &&  hc <460) begin
          if ( ( posY1 == 22 && posX1 == 5) || ( posY2 == 22 && posX2 == 5) || ( posY3 == 22 && posX3 == 5) || ( posY4 == 22 && posX4 == 5)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[22*12+5]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >460 &&  hc <480) begin
          if ( ( posY1 == 22 && posX1 == 6) || ( posY2 == 22 && posX2 == 6) || ( posY3 == 22 && posX3 == 6) || ( posY4 == 22 && posX4 == 6)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[22*12+6]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >480 &&  hc <500) begin
          if ( ( posY1 == 22 && posX1 == 7) || ( posY2 == 22 && posX2 == 7) || ( posY3 == 22 && posX3 == 7) || ( posY4 == 22 && posX4 == 7)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[22*12+7]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >500 &&  hc <520) begin
          if ( ( posY1 == 22 && posX1 == 8) || ( posY2 == 22 && posX2 == 8) || ( posY3 == 22 && posX3 == 8) || ( posY4 == 22 && posX4 == 8)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[22*12+8]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >520 &&  hc <540) begin
          if ( ( posY1 == 22 && posX1 == 9) || ( posY2 == 22 && posX2 == 9) || ( posY3 == 22 && posX3 == 9) || ( posY4 == 22 && posX4 == 9)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[22*12+9]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else     if (hc >540 &&  hc <560) begin
          if ( ( posY1 == 22 && posX1 == 10) || ( posY2 == 22 && posX2 == 10) || ( posY3 == 22 && posX3 == 10) || ( posY4 == 22 && posX4 == 10)) begin
            red   = 4'b1111;
            green = 4'b0000;
            blue  = 4'b0000;
          end
          else if ( grid[22*12+10]) begin
            red   = 4'b0000;
            green = 4'b1111;
            blue  = 4'b0000;
          end
          else begin
            red   = 4'b1111;
            green = 4'b1111;
            blue  = 4'b1111;
          end
        end
        else begin
              red   = 4'b0000;
              green = 4'b0000;
              blue  = 4'b0000;
        end
      end
      // GENERATED CODE ENDS HERE
      // black lines between squares
      else begin
        red   = 4'b0000;
        green = 4'b0000;
        blue  = 4'b0000;
      end
    end
    // outside active vertical range so display black
    else begin
      red   = 4'b0000;
      green = 4'b0000;
      blue  = 4'b0000;
    end
  end

endmodule