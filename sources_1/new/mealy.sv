`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.09.2026 21:17:57
// Design Name: 
// Module Name: mealy
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

module mealy(
    input  logic [1:0] palanca_de_cambio,
    input  logic       clutch_cambio,
    input  logic [3:0] estado_actual,
    output logic [3:0] estado_siguiente,
    output logic [6:0] segmentos_mealy,
    output logic       led_error,
    output logic       clutch_activo
);

    logic [1:0] palanca_cambios;

    // Buffer - palanca para accinar la caja 
    Caja_de_cambios_input in_caja (
        .palanca_accionada (palanca_de_cambio),
        .output_palanca    (palanca_cambios)
    );

    // Clutch
    Clutch in_clutch (
        .clutch_accion    (clutch_cambio),
        .clutch_resultado (clutch_activo)
    );

    // next state 
    next_state_logic in_next_state (
        .posicion_de_palanca (palanca_cambios),
        .current_state       (estado_actual),
        .next_state          (estado_siguiente)
    );

    // Alerta cuando hay cambio de velocidad 
    error_en_colocar_clutch in_error_vista (
        .palanca          (palanca_de_cambio),
        .clutch_resultado (clutch_activo),
        .shift_error      (led_error)
    );

    // Decodificador Mealy 
    decoder_7_segmentos in_decoder_mealy (
        .estado    (estado_siguiente),
        .segmentos (segmentos_mealy)
    );


endmodule
