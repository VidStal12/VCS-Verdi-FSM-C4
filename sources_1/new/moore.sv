`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.09.2026 21:21:04
// Design Name: 
// Module Name: moore
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


module moore(
    input  logic       clk,
    input  logic       rst_n,
    input  logic       clutch_activo,
    input  logic [3:0] estado_siguiente,
    output logic [3:0] estado_actual,
    output logic [6:0] segmentos_moore
);

    // Flip-flops sincronizados
    registro_estados in_estados (
        .clk              (clk),
        .rst_n            (rst_n),
        .clutch_resultado (clutch_activo),
        .ns_in            (estado_siguiente),
        .ns_out           (estado_actual)
    );

    // Decodificador Moore 
    decoder_7_segmentos in_decoder_moore (
        .estado    (estado_actual),
        .segmentos (segmentos_moore)
    );

endmodule