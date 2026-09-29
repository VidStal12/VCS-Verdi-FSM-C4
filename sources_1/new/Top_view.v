`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2026 21:16:25
// Design Name: 
// Module Name: Top_view
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
`timescale 1ns / 1ps

module top_view(
    input  logic       clk,
    input  logic       rst_n,
    input  logic       clutch_cambio,
    input  logic [1:0] palanca_de_cambio,

    output logic [6:0] segmentos_moore,
    output logic [6:0] segmentos_mealy,
    output logic       led_error
);

    logic [3:0] estados_actuales;
    logic [3:0] estados_futuros;
    logic       clutch_activo;

    // Submódulo Mealy
    mealy in_mealy (
        .palanca_de_cambio (palanca_de_cambio),
        .clutch_cambio     (clutch_cambio),
        .estado_actual     (estados_actuales),
        .estado_siguiente  (estados_futuros),
        .segmentos_mealy   (segmentos_mealy),
        .led_error         (led_error),
        .clutch_activo     (clutch_activo)
    );

    // Submódulo Moore
    moore in_moore (
        .clk              (clk),
        .rst_n            (rst_n),
        .clutch_activo    (clutch_activo),
        .estado_siguiente (estados_futuros),
        .estado_actual    (estados_actuales),
        .segmentos_moore  (segmentos_moore)
    );

endmodule