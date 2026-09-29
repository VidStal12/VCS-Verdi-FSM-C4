`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.09.2026 00:47:46
// Design Name: 
// Module Name: testbench1
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

module Testbench1;

    
    logic        clk;
    logic        rst_n;
    logic        clutch_cambio;
    logic [1:0]  palanca_de_cambio;

    logic [6:0]  segmentos_moore;
    logic [6:0]  segmentos_mealy;
    logic        led_error;

    Top_view uut (
        .clk                (clk),
        .rst_n              (rst_n),
        .clutch_cambio      (clutch_cambio),
        .palanca_de_cambio  (palanca_de_cambio),
        .segmentos_moore    (segmentos_moore),
        .segmentos_mealy    (segmentos_mealy),
        .led_error          (led_error)
    );

    always #5 clk = ~clk;

    function string decodificar_segmentos(input logic [6:0] seg);
        case (seg)
            7'b0101011: return "NEUTRO (N)";
            7'b1111001: return "MARCHA 1";
            7'b0100100: return "MARCHA 2";
            7'b0110000: return "MARCHA 3";
            7'b0011001: return "MARCHA 4";
            7'b0010010: return "MARCHA 5";
            7'b0000010: return "MARCHA 6";
            7'b0101111: return "POSICION 0";
            default:    return "DESCONOCIDO";
        endcase
    endfunction

    task accion_cambio(input logic [1:0] cmd, input logic clutch, input int ciclos);
        begin
            @(negedge clk);
            palanca_de_cambio = cmd;
            clutch_cambio     = clutch;
            repeat(ciclos) @(posedge clk);
            // Liberar palanca a posición neutral/hold tras la maniobra
            @(negedge clk);
            palanca_de_cambio = 2'b00;
            clutch_cambio     = 1'b0;
            @(posedge clk);
        end
    endtask

    initial begin
        // Configuración inicial
        clk               = 0;
        rst_n             = 0;
        clutch_cambio     = 0;
        palanca_de_cambio = 2'b00;

        $display("==========================================================");
        $display("   INICIO DE SIMULACIÓN - CAJA DE CAMBIOS SECUENCIAL");
        $display("==========================================================");

        #15;
        rst_n = 1; // Liberar reset
        @(posedge clk);
        $display("[T=%0t ns] [TEST 1] Reset liberado. Estado Moore actual: %s", 
                 $time, decodificar_segmentos(segmentos_moore));
        
        if (segmentos_moore == 7'b1111001)
            $display("  -> OK: Estado inicial correcto en Marcha 1.");
        else
            $error("  -> FALLO: Estado inicial incorrecto.");

        $display("\n[TEST 2] Intentando subir marcha sin pisar embrague (Shift Up, Clutch=0)...");
        @(negedge clk);
        palanca_de_cambio = 2'b10; // Subir marcha
        clutch_cambio     = 1'b0;  // Sin embrague
        #1;
        if (led_error == 1'b1)
            $display("  -> OK: led_error activado correctamente.");
        else
            $error("  -> FALLO: led_error debio encenderse.");

        @(posedge clk);
        #1;
        // El estado registrado no debe cambiar porque el registro no habilita carga
        if (segmentos_moore == 7'b1111001)
            $display("  -> OK: La marcha NO cambio en el registro Moore (Protegido por embrague).");
        else
            $error("  -> FALLO: La marcha cambio sin embrague.");

        // Regresar palanca a reposo
        @(negedge clk);
        palanca_de_cambio = 2'b00;
        #1;
        if (led_error == 1'b0)
            $display("  -> OK: led_error se apago al soltar la palanca.");

        $display("\n[TEST 3] Subiendo marchas con embrague presionado...");
        for (int i = 2; i <= 6; i++) begin
            @(negedge clk);
            palanca_de_cambio = 2'b10; // Subir
            clutch_cambio     = 1'b1;  // Embrague ON
            #2;
            $display("[T=%0t ns] Entrada=UP | Mealy (Futuro): %s | Moore (Actual): %s", 
                     $time, decodificar_segmentos(segmentos_mealy), decodificar_segmentos(segmentos_moore));
            
            @(posedge clk); // Se registra el nuevo estado
            #1;
            $display("[T=%0t ns] Flanco de Reloj | Moore actualizado a: %s", 
                     $time, decodificar_segmentos(segmentos_moore));

            // Retornar palanca a 00 entre cada cambio
            @(negedge clk);
            palanca_de_cambio = 2'b00;
            clutch_cambio     = 1'b0;
            @(posedge clk);
        end

        $display("\n[TEST 4] Colocando Neutro (palanca = 2'b01)...");
        accion_cambio(2'b01, 1'b1, 1);
        #1;
        $display("[T=%0t ns] Estado tras neutro: %s", $time, decodificar_segmentos(segmentos_moore));
        if (segmentos_moore == 7'b0101011)
            $display("  -> OK: Se activo correctamente la pantalla de Neutro.");
        else
            $error("  -> FALLO: No se mostro neutro.");

        $display("\n[TEST 5] Saliendo de Neutro con cambio arriba (+1)...");
        accion_cambio(2'b10, 1'b1, 1);
        #1;
        $display("[T=%0t ns] Estado tras salir de neutro: %s", $time, decodificar_segmentos(segmentos_moore));

        $display("\n[TEST 6] Reduciendo marchas consecutivas...");
        repeat (3) begin
            @(negedge clk);
            palanca_de_cambio = 2'b11; // Bajar marcha
            clutch_cambio     = 1'b1;
            @(posedge clk);
            #1;
            $display("[T=%0t ns] Reduccion aplicada | Estado actual: %s", 
                     $time, decodificar_segmentos(segmentos_moore));
            @(negedge clk);
            palanca_de_cambio = 2'b00;
            clutch_cambio     = 1'b0;
            @(posedge clk);
        end

        $display("\n[TEST 7] Aplicando Reset en caliente...");
        @(negedge clk);
        rst_n = 0;
        #2;
        if (segmentos_moore == 7'b1111001)
            $display("  -> OK: Reinicio exitoso directo a Marcha 1.");
        else
            $error("  -> FALLO: Fallo en reset en caliente.");
        
        rst_n = 1;
        #20;

        $finish;
    end

    // Monitor continuo de cambios críticos
    initial begin
        $monitor("[MONITOR T=%0t] Palanca=%b Clutch=%b | Err=%b | MealySeg=%b MooreSeg=%b", 
                 $time, palanca_de_cambio, clutch_cambio, led_error, segmentos_mealy, segmentos_moore);
    end


endmodule
