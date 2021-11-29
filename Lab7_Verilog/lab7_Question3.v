`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: lab6
// Add 2 4-bit numbers (inputed on switches) and output the sum on a 7-segment LED display
// Used a Nexys4 DDR device to test
//////////////////////////////////////////////////////////////////////////////////

//Main Module adding 

module topModule(
    input CLK100MHZ,
    output [7:0] LED
    );
    
        // set up the 1HZ clock
    wire CLK_1HZ;
    clk_1Hz gate1( CLK100MHZ, CLK_1HZ);

    // set up a counter
    wire [7:0] sum;
    count_ticks gate2(CLK_1HZ, sum[7:0]);
    
    assign LED[7:0] = sum[7:0];

endmodule 

    // creates 1HZ clock from a 100MHZ clock
    // 1HZ clock has a period of 1 second = 1000ms
    // 100MHz is 100,000,000 cycles
    // log2(10,0000,000) = 26.6, so 27 bits needed for counter
    
module clk_1Hz(
    input incoming_CLK100MHZ,
    output reg outgoing_CLK
    );
    

    reg[27:0] ctr;
    
    always @ (posedge incoming_CLK100MHZ) begin
        if (ctr == 49_999_999) begin
            outgoing_CLK <= 1'b1;
            ctr <= ctr + 1;            
        end
        else if (ctr == 99_999_999) begin
            outgoing_CLK <= 1'b0;
            ctr <= 0;
        end
        else begin
            ctr <= ctr + 1;
        end
    end
endmodule


module     count_ticks( 
    input CLK_IN, 
    output reg [7:0] sum_out
    );
    
    always @(posedge CLK_IN) begin
        sum_out <= sum_out + 8'b0000_0001;
    end
        
endmodule
   