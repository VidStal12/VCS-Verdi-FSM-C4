`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2026 21:04:28
// Design Name: 
// Module Name: error_en_colocar_clutch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module error_en_colocar_clutch(input logic [1:0] palanca,
input logic  clutch_resultado,
output logic shift_error );
 
 assign shift_error=(|palanca)& (~clutch_resultado);
 
endmodule
