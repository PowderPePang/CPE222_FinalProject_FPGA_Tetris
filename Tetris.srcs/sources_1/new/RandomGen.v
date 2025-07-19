module RandomGen(
    input wire clk,         // Clock input
    input wire reset,       // Reset input
    output wire [2:0] rnd  // Random 16-bit number output
);
    reg [15:0] lfsr;        // 16-bit shift register
    wire feedback;

    // Feedback is the XOR of specific taps (polynomial for 16-bit LFSR: x^16 + x^14 + x^13 + x^11 + 1)
    assign feedback = lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 16'h1; // Initial seed value (must not be 0)
        end else begin
            lfsr <= {lfsr[14:0], feedback}; // Shift left and insert feedback
        end
    end

    assign rnd = lfsr[2:0]; // Assign LFSR value to output
    
endmodule
