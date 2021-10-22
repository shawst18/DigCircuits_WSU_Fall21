`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: lab6
// Add 2 4-bit numbers (inputed on switches) and output the sum on a 7-segment LED display
// Used a Nexys4 DDR device to test
//////////////////////////////////////////////////////////////////////////////////

//Main Module adding 

module topModule(
    input [7:0] SW,
    output [3:0] LED,
    output CA,
    output CB,
    output CC,
    output CD,
    output CE,
    output CF,
    output CG
    );
    wire a3, a2, a1, a0, b3, b2, b1, b0;
    wire s3, s2, s1, s0, carry0, carry1, carry2, cout;

    // global inputs
    assign a0 = SW[0];
    assign a1 = SW[1];
    assign a2 = SW[2];
    assign a3 = SW[3];
    assign b0 = SW[4];
    assign b1 = SW[5];
    assign b2 = SW[6];
    assign b3 = SW[7];

    // global outputs
    assign LED[0] = s0;
    assign LED[1] = s1;
    assign LED[2] = s2;
    assign LED[3] = s3;

    assign LED[4] = cout;

    fulladder adds0(a0,b0,0,carry0,s0);
    fulladder adds1(a1,b1,carry0, carry1, s1);
    fulladder adds2(a2,b2,carry1, carry2, s2);
    fulladder adds3(a3,b3,carry2, cout, s3);
    ledDriver Out1(s3, s2, s1, s0, CA, CB, CC, CD, CE, CF, CG);

endmodule 

//Module for a 1bit x 1bit adder

module fulladder(
    input a,
    input b,
    input c_in,
    output c_out,
    output sum
    );
    assign c_out = (a&b)|(c_in&b)|(c_in&a);
    assign sum = (~a&~b&c_in)|(~a&b&~c_in)|(a&b&c_in)|(a&~b&~c_in);
endmodule

//LED driver with 4 inputs, outputs to 7 outputs (7 segment display)

module ledDriver(
    input A,
    input B,
    input C,
    input D,
    output a,
    output b,
    output c,
    output d,
    output e,
    output f,
    output g
    );
    
    // Define Intermediate Wires for each number we want to display
    wire x0, x1, x2, x3, x4, x5, x6, x7, x8, x9;
    
    // Define the case that we want to display each number given the 4-bit input (convert 4-bit to defined whole #)
    assign x0 = (~A)&(~B)&(~C)&(~D);
    assign x1 = (~A)&(~B)&(~C)&(D);
    assign x2 = (~A)&(~B)&(C)&(~D);
    assign x3 = (~A)&(~B)&(C)&(D);
    assign x4 = (~A)&(B)&(~C)&(~D);
    assign x5 = (~A)&(B)&(~C)&(D);
    assign x6 = (~A)&(B)&(C)&(~D);
    assign x7 = (~A)&(B)&(C)&(D);
    assign x8 = (A)&(~B)&(~C)&(~D);
    assign x9 = (A)&(~B)&(~C)&(D);
    
    // Define when each segment of display lights up (for which numbers from 0 to 9 should each of the 7 segments turn on?)
    assign a = ~(x0|x2|x3|x5|x6|x7|x8|x9);
    assign b = ~(x0|x1|x2|x3|x4|x7|x8|x9);
    assign c = ~(x0|x1|x3|x4|x5|x6|x7|x8|x9);
    assign d = ~(x0|x2|x3|x5|x6|x8|x9);
    assign e = ~(x0|x2|x6|x8);
    assign f = ~(x0|x4|x5|x6|x8|x9);
    assign g = ~(x2|x3|x4|x5|x6|x8|x9);
endmodule