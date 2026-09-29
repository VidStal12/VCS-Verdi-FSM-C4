`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2026 20:44:16
// Design Name: 
// Module Name: registro_estados
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


module registro_estados(
input logic clk,rst_n,clutch_resultado,
input logic [3:0] ns_in,
output logic [3:0] ns_out
 );
 always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin
        ns_out<=4'b0010;
    end else if (clutch_resultado) begin
        ns_out<=ns_in;
    end
  end
  
endmodule
