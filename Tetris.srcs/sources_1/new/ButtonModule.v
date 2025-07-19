`timescale 1ns / 1ps

module ButtonModule( input wire btnU,
                     input wire btnD,
                     input wire btnL,
                     input wire btnR,
                     output wire up,
                     output wire down,
                     output wire left,
                     output wire right,
                     input clk );
                     
                     wire btnLdown, btnRdown, btnUdown, btnDdown;
                     wire gamePadLdown, gamePadRdown, gamePadDdown, gamePadUdown;
                     
                       // Debouncers
                     Debouncer debBL(
                       .clk( clk),
                       .PB( btnL),
                       .PB_down( btnLdown)
                     );
                   
                     Debouncer debBR(
                       .clk( clk),
                       .PB( btnR),
                       .PB_down( btnRdown)
                     );
                   
                     Debouncer debBD(
                       .clk( clk),
                       .PB( btnD),
                       .PB_down( btnDdown)
                     );
                   
                     Debouncer debBU(
                       .clk( clk),
                       .PB( btnU),
                       .PB_down( btnUdown)
                     );
                      
                      assign up = btnUdown;
                      assign down = btnDdown;
                      assign left = btnLdown;
                      assign right = btnRdown;
                     
endmodule