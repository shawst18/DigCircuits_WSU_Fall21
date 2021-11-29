`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: lab6
// input 6 switches display number in hexadecimal on 2 LED display outputs
// Used a Nexys4 DDR device to test
//////////////////////////////////////////////////////////////////////////////////

//Main Module adding 

module topModule1(
    input CLK100MHZ,
    input [5:0] SW,
    output [7:0] AN,
    output CA,CB,CC,CD,CE,CF,CG,DP
    );
    
    wire [7:0] CAs;
    wire [7:0] CAs_1;
    wire [7:0] CAs_2;
    wire [7:0] CAs_3;
    wire [5:0] SWs;
    wire CLK1KHZ;
    
    assign SWs [5:0] = SW [5:0];
    
    assign CAs[0] = 1'b0;
    
    assign CA=~CAs[7];
    assign CB=~CAs[6];
    assign CC=~CAs[5];
    assign CD=~CAs[4];
    assign CE=~CAs[3];
    assign CF=~CAs[2];
    assign CG=~CAs[1];
    assign DP=~CAs[0];
    
    create_1KHZ_clock gate0 (CLK100MHZ, CLK1KHZ);
    generate_7seg_bits gate1 (SW[3], SW[2], SW[1], SW[0], CAs_1[7], CAs_1[6], CAs_1[5], CAs_1[4], CAs_1[3], CAs_1[2], CAs_1[1]);
    generate_7seg_bits gate2 (1'b0, 1'b0, SW[5], SW[4], CAs_2[7], CAs_2[6], CAs_2[5], CAs_2[4], CAs_2[3], CAs_2[2], CAs_2[1]);
    write_2_hexa gate3 (CLK1KHZ, CAs_1[7:0], CAs_2[7:0], AN[7:0], CAs[7:0]);

endmodule 

module write_2_hexa(
    input CLK,
    input wire [7:0] inCAs_1,
    input wire [7:0] inCAs_2,
    output reg [7:0] outAN,
    output reg [7:0] outCAs
    );

    reg ctr = 1'b0;
    
    always @(posedge CLK) begin
        if(ctr==1'b0) begin
            outAN [7:0] <= 8'b1111_1110;  // LED 1 (counting from right)
            outCAs [7:0] <= inCAs_1 [7:0];
        end 
        else if(ctr==1'b1) begin
            outAN [7:0] <= 8'b1111_1101;  // LED 2 (counting from right)
            outCAs [7:0] <= inCAs_2 [7:0];
        end  
        
        // update the counter
        if(ctr==1'b1) begin
            ctr <= 1'b0;
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


// This 7-segment display driver can be useful for Lab 8, problem 5
//
// Input is the 4-bit number s3 s2 s1 a0
// Output is the (active-HIGH) 7-segment display digits da,db,dc,dd,de,df,dg
// reminder, Nexys4DDR display digits are active-LOW, so you'll need to invert them at some point
// one approach is to generate 7 karnaugh maps
module generate_7seg_bits(
    input s3,
    input s2,
    input s1,
    input s0, 
    output da,
    output db,
    output dc,
    output dd,
    output de,
    output df,
    output dg);

    // this would be more compact with a Karnaugh map for each segment da - dg
    // writing this way for readability 
    wire zero, one, two, three, four, five, six, seven, eight, nine;
    assign zero     = ~s3&~s2&~s1&~s0;
    assign one      = ~s3&~s2&~s1& s0;
    assign two      = ~s3&~s2& s1&~s0;
    assign three    = ~s3&~s2& s1& s0;
    assign four     = ~s3& s2&~s1&~s0;
    assign five     = ~s3& s2&~s1& s0;
    assign six      = ~s3& s2& s1&~s0;
    assign seven    = ~s3& s2& s1& s0;
    assign eight    =  s3&~s2&~s1&~s0;
    assign nine     =  s3&~s2&~s1& s0;
    assign ten      =  s3&~s2& s1&~s0; 
    assign eleven   =  s3&~s2& s1& s0; 
    assign twelve   =  s3& s2&~s1&~s0; 
    assign thirteen =  s3& s2&~s1& s0; 
    assign fourteen =  s3& s2& s1&~s0; 
    assign fifteen  =  s3& s2& s1& s0; 
    
    assign da = zero | two | three | five | six | seven | eight | nine | ten | fourteen | fifteen;
    assign db = zero | one | two | three | four | seven | eight | nine | ten | thirteen;
    assign dc = zero | one | three | four | five | six | seven | eight | nine | ten | eleven | thirteen ;
    assign dd = zero | two | three | five | six | eight | eleven | twelve | thirteen | fourteen ;
    assign de = zero | two | six | eight | ten | eleven | twelve | thirteen | fourteen | fifteen ;
    assign df = zero | four | five | six | eight | nine | ten | eleven | fourteen | fifteen ;
    assign dg = two | three | four | five | six | eight | nine | ten | eleven | twelve | thirteen | fourteen | fifteen ;
    
endmodule