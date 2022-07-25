`timescale 1ns / 1ps

module BRAM_mod  #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8,
    parameter NUM_WORDS  = 256
    )
    (
    // Clock and Reset
    input  logic                    clk_i,

    input  logic                    en_i,
    input  logic [ADDR_WIDTH-1:0]   addr_i,
    input  logic [DATA_WIDTH-1:0]   wdata_i,
    output logic [DATA_WIDTH-1:0]   rdata_o,
    input  logic                    we_i
    );

logic [DATA_WIDTH-1:0] reg_array [NUM_WORDS-1:0];

integer i;
initial begin
    for( i = 0; i < NUM_WORDS-1; i = i + 1 ) begin
        reg_array[i] <= 0;
    end
end

always @(posedge(clk_i)) begin
    if( we_i & en_i ) begin
        reg_array[addr_i] <= wdata_i;
    end

    rdata_o <= reg_array[addr_i];
end
endmodule  
