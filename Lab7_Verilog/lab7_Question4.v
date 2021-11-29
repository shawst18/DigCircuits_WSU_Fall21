//////////////////////////////////////////////////////////////////////////////////
// Module Name: lab 7
// show 1234 on 7-segment display
// Used a Nexys4 DDR device to test
// Adapted from Jenny example from class, originally tried a muxing solution with no success
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module topModule(
    input CLK100MHZ,
    output [7:0] AN,
    output CA,CB,CC,CD,CE,CF,CG,DP
    );
    
    wire [7:0] CAs;
    assign CA=CAs[7];
    assign CB=CAs[6];
    assign CC=CAs[5];
    assign CD=CAs[4];
    assign CE=CAs[3];
    assign CF=CAs[2];
    assign CG=CAs[1];
    assign DP=CAs[0];
    
    wire outgoing_CLK1KHZ;
    create_1KHZ_clock gate2 (CLK100MHZ,outgoing_CLK1KHZ);
    
    write_1234 gate1 (outgoing_CLK1KHZ,AN,CAs);
    
endmodule

module write_1234(input CLK,
    output reg [7:0] outAN,
    output reg [7:0] outCAs);

    reg [4:0] ctr=0;
    
    always @(posedge CLK) begin
        if(ctr==4'b0000) begin    
        end else if(ctr==4'b0011) begin
            outAN <= 8'b1111_0111;  // LED 4 (counting from right)
            outCAs <= 8'b1001_1111; // 1
        
        end else if(ctr==4'b0100) begin
            outAN <= 8'b1111_1011;  // LED 3 (counting from right)
            outCAs <= 8'b0010_0101; // 2, 3 and 6
        
        end else if(ctr==4'b0101) begin
            outAN <= 8'b1111_1101;  // LED 2 (counting from right)
            outCAs <= 8'b0000_1101; // 3
        
        end else if(ctr==4'b0110) begin
            outAN <= 8'b1111_1110;  // LED 1 (counting from right)
            outCAs <= 8'b1001_1001; // 4
        
        end else begin
            outAN <= 8'b1111_1111;
            outCAs <= 8'b1111_1111;
           
        end 
        
        // update the counter
        if(ctr==4'b1111) begin
            ctr <= 4'b0000;
        end else begin
            ctr <= ctr + 1;        
        end   
    end
    
endmodule

// creates 1000 Hz clock from a 100 MHz clock 
// 1000 Hz clock has a period of 0.001 seconds, which is equal to 1ms
// 100 MHz / 1000 Hz = 100 * 10^6 / 1000 = 100,000 cycles
// log_2(100,000) = 16.61, so 17 bits are needed for the counter
module create_1KHZ_clock(
    input incoming_CLK100MHZ,
    output reg outgoing_CLK1KHZ
    );
    
    reg [16:0] ctr=0;
    
    always @ (posedge incoming_CLK100MHZ) begin
        if(ctr==49_999) begin
            outgoing_CLK1KHZ <= 1'b0;
            ctr <= ctr + 1;            
        end else if(ctr==99_999) begin
            outgoing_CLK1KHZ <= 1'b1;
            ctr <= 0;
        end else begin
            ctr <= ctr + 1;
        end         
    end
endmodule