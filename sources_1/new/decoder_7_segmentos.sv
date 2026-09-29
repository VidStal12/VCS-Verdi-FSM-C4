`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2026 20:51:59
// Design Name: 
// Module Name: decoder_7_segmentos
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


module decoder_7_segmentos(
input logic [3:0] estado,
output logic [6:0] segmentos
);
always_comb begin 
    if(estado[0]==1'b1)begin 
    segmentos=7'b0101011;
  end else begin 
    case(estado)
    4'b0000: segmentos = 7'b0101111;
    4'b0010: segmentos = 7'b1111001;
    4'b0100: segmentos = 7'b0100100;
    4'b0110: segmentos = 7'b0110000;
    4'b1000: segmentos = 7'b0011001;
    4'b1010: segmentos = 7'b0010010;
    4'b1100: segmentos = 7'b0000010;
    default: segmentos = 7'b1111111;
   endcase
 end
end
endmodule
