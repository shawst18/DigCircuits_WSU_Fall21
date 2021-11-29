`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: lab6
// Add 2 4-bit numbers (inputed on switches) and output the sum on a 7-segment LED display
// Used a Nexys4 DDR device to test
//////////////////////////////////////////////////////////////////////////////////

//Main Module adding 

module topModule(
    input CLK100MHZ,
    output [0:1] LED
    );
    wire a0, a1;
    
    assign LED[0] = a0;
    assign LED[1] = a1;
    
    drive_LED_s gate1 (CLK100MHZ, a0);
    drive_LED_ms gate2 (CLK100MHZ, a1);

endmodule 

module drive_LED_s(
    input CLK,
    output reg out
    );
    
    reg [29:0] ctr=0;
    
    always @ (posedge CLK) begin
        if(ctr==100_000_000) begin
            out <= 1'b1;
            ctr <= ctr + 1;            
        end else if(ctr==300_000_000) begin
            out <= 1'b0;
            ctr <= 0;
        end else begin
            ctr <= ctr + 1;
        end         
    end
    
endmodule
    
module drive_LED_ms(
    input CLK,
    output reg out
    );
    
    reg [19:0] ctr=0;
    
    always @ (posedge CLK) begin
        if(ctr==100_000) begin
            out <= 1'b0;
            ctr <= ctr + 1;            
        end else if(ctr==300_000) begin
            out <= 1'b1;
            ctr <= 0;
        end else begin
            ctr <= ctr + 1;
        end         
    end
    
endmodule