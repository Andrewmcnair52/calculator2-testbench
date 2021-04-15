
`ifndef CALC_IF_DEFINE
`define CALC_IF_DEFINE

interface calc_if(input bit c_clk);

  logic     		reset = 0;
	
	logic [3:0] 		req1_cmd_in   = 4'h0;
	logic [31:0] 		req1_data_in  = 32'h0;
	logic [1:0]     req1_tag_in 	= 2'h0;
	logic [3:0] 		req2_cmd_in   = 4'h0;
	logic [31:0] 		req2_data_in  = 32'h0;
	logic [1:0]     req2_tag_in	  = 2'h0;
	logic [3:0] 		req3_cmd_in   = 4'h0;
	logic [31:0] 		req3_data_in  = 32'h0;
	logic [1:0]     req3_tag_in	  = 2'h0;
	logic [3:0] 		req4_cmd_in   = 4'h0;
	logic [31:0] 		req4_data_in  = 32'h0;
	logic [1:0]     req4_tag_in   = 2'h0;

	logic [1:0]		out_resp1;
	logic [31:0]	out_data1;
	logic [1:0]   out_tag1;
	logic [1:0]		out_resp2;
	logic [31:0]	out_data2;
	logic [1:0]   out_tag2;
	logic [1:0]		out_resp3;
	logic [31:0]	out_data3;
	logic [1:0]   out_tag3;
	logic [1:0]		out_resp4;
	logic [31:0]	out_data4;
	logic [1:0]   out_tag4;

endinterface: calc_if 

`endif
