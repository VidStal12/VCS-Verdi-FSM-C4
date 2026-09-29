`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2026 20:06:18
// Design Name: 
// Module Name: next_state_logic
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


module next_state_logic(
input logic [1:0] posicion_de_palanca,
input logic [3:0] current_state,
output logic [3:0] next_state
);
// 1. Separate wires to sample the incoming registered state
    logic [2:0] q_gear;
    logic       q_neutral;

    assign q_gear    = current_state[3:1];
    assign q_neutral = current_state[0];

    // 2. Arithmetic calculated strictly from input wires (prevents combinational loops)
    logic [2:0] palanca_arriba;
    logic [2:0] palanca_abajo;

    assign palanca_arriba = q_gear + 3'd1;
    assign palanca_abajo  = q_gear - 3'd1; 

    // 3. Next-state variables (driven EXCLUSIVELY inside always_comb)
    logic [2:0] c_estado_palanca; 
    logic       c_palanca_neutro; 

    always_comb begin 
        case (posicion_de_palanca)
            2'b00: begin // Hold current gear
                c_estado_palanca = q_gear;
                c_palanca_neutro = q_neutral;
            end
            2'b01: begin // Shift to Neutral
                c_estado_palanca = q_gear;
                c_palanca_neutro = 1'b1;
            end
            2'b10: begin // Shift Up (+1)
                c_estado_palanca = palanca_arriba;
                c_palanca_neutro = 1'b0;
            end
            2'b11: begin // Shift Down (-1)
                c_estado_palanca = palanca_abajo;
                c_palanca_neutro = 1'b0;
            end
            default: begin
                c_estado_palanca = q_gear;
                c_palanca_neutro = q_neutral;
            end
        endcase
    end

    // 4. Concatenate into the 4-bit next_state bus
    assign next_state = {c_estado_palanca, c_palanca_neutro};   
endmodule
