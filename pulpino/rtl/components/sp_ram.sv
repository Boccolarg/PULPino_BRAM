// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the â€œLicenseâ€ ); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an â€œAS ISâ€  BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

`include "/pulpino/rtl/components/BRAM_mod.sv"

module sp_ram
  #(
    parameter ADDR_WIDTH = 15,
    parameter DATA_WIDTH = 32,
    parameter NUM_WORDS  = 32768
  )(
    // Clock and Reset
    input  logic                    clk,

    input  logic                    en_i,
    input  logic [ADDR_WIDTH-1:0]   addr_i,
    input  logic [DATA_WIDTH-1:0]   wdata_i,
    output logic [DATA_WIDTH-1:0]   rdata_o,
    input  logic                    we_i,
    input  logic [DATA_WIDTH/8-1:0] be_i
  );

  localparam words = NUM_WORDS/(DATA_WIDTH/8);
  
  logic [DATA_WIDTH/8-1:0][7:0] wdata;
  logic [DATA_WIDTH/8-1:0][7:0] rdata;

  genvar w;
  generate for(w = 0; w < DATA_WIDTH/8; w++)
    begin
      assign wdata[w] = wdata_i[(w+1)*8-1:w*8];
    end
  endgenerate
  
  genvar i;
  generate
      for (i = 0; i < DATA_WIDTH/8; i = i + 1) begin
          BRAM_mod #(
                .ADDR_WIDTH($clog2(words)),
                .DATA_WIDTH(8),
                .NUM_WORDS(words)
            ) bram (
                .clk_i(clk),
                .en_i(en_i),
                .addr_i(addr_i[ADDR_WIDTH-1:$clog2(DATA_WIDTH/8)]),
                .wdata_i(wdata[i]),
                .rdata_o(rdata[i]),
                .we_i(we_i & be_i[i])
            );
       end
    
    endgenerate
    
    assign rdata_o = rdata;
  

endmodule
