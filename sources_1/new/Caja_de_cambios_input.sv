`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2026 19:56:54
// Design Name: 
// Module Name: Caja_de_cambios_input
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


module Caja_de_cambios_input(
input logic [1:0] palanca_accionada,
output logic [1:0] output_palanca
);

assign output_palanca=palanca_accionada;
endmodule
