//////////////////////////////////////////////////////////////////////////////////
// Module: seg
// Description: Drives a 4-digit 7-segment display, cycling through each digit to
//              display the given score using a multiplexing approach.
//////////////////////////////////////////////////////////////////////////////////
//module ( input logic[7:0] score, input logic clk, input logic reset, output logic [3:0] an, output logic [6:0] seg, output logic dp);
`timescale 1ns / 1ps

module ScoreDisplay (
    input wire [13:0] score,   // 14-bit score input to display four digits
    input wire clk,            // System clock
    input wire reset,          // Reset signal
    output reg [3:0] an = 4'b1111, // Anode control for the 4-digit display
    output reg [6:0] seg,      // 7-segment output
    output reg dp = 1'b1       // Decimal point control (default off)
);

    // Clock divider for multiplexing refresh
    reg [14:0] clk_divider = 0; // Wider divider to match slower refresh rate
    wire slowclk = clk_divider[14]; // Output slow clock
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            clk_divider <= 0;
        else
            clk_divider <= clk_divider + 1;
    end

    // Digit selector (2-bit for 4 digits)
    reg [1:0] digitSelect = 2'b00;

    always @(posedge slowclk or posedge reset) begin
        if (reset)
            digitSelect <= 2'b00;
        else
            digitSelect <= digitSelect + 1'b1;
    end

    // Drive anodes and segments based on digit selector
    always @(*) begin
        // Disable decimal point by default
        dp = 1'b1;

        case (digitSelect)
            2'b00: begin
                an = 4'b1110; // Enable first digit
                seg = digitToSegment(score % 10);
            end
            2'b01: begin
                an = 4'b1101; // Enable second digit
                seg = digitToSegment((score / 10) % 10);
            end
            2'b10: begin
                an = 4'b1011; // Enable third digit
                seg = digitToSegment((score / 100) % 10);
            end
            2'b11: begin
                an = 4'b0111; // Enable fourth digit
                seg = digitToSegment((score / 1000) % 10);
            end
            default: begin
                an = 4'b1111; // Disable all digits
                seg = 7'b1111111; // Turn off all segments
            end
        endcase
    end

    // Function to convert a 4-bit digit to 7-segment encoding
    function [6:0] digitToSegment(input [3:0] digit);
        case (digit)
            4'b0000: digitToSegment = 7'b1000000; // 0
            4'b0001: digitToSegment = 7'b1111001; // 1
            4'b0010: digitToSegment = 7'b0100100; // 2
            4'b0011: digitToSegment = 7'b0110000; // 3
            4'b0100: digitToSegment = 7'b0011001; // 4
            4'b0101: digitToSegment = 7'b0010010; // 5
            4'b0110: digitToSegment = 7'b0000010; // 6
            4'b0111: digitToSegment = 7'b1111000; // 7
            4'b1000: digitToSegment = 7'b0000000; // 8
            4'b1001: digitToSegment = 7'b0010000; // 9
            default: digitToSegment = 7'b1111111; // Off
        endcase
    endfunction
endmodule