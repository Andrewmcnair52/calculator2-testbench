


module calc2_tb;

	
  bit 			  c_clk;
	bit [6:0]		reset;
	
	bit [3:0] 		req1_cmd_in;
	bit [31:0] 		req1_data_in;
	bit [1:0]     req1_tag_in;	
	bit [3:0] 		req2_cmd_in;
	bit [31:0] 		req2_data_in;
	bit [1:0]     req2_tag_in;	
	bit [3:0] 		req3_cmd_in;
	bit [31:0] 		req3_data_in;
	bit [1:0]     req3_tag_in;	
	bit [3:0] 		req4_cmd_in;
	bit [31:0] 		req4_data_in;
	bit [1:0]     req4_tag_in;	

	bit [1:0]		out_resp1;
	bit [31:0]	out_data1;
	bit [1:0]   out_tag1;
	bit [1:0]		out_resp2;
	bit [31:0]	out_data2;
	bit [1:0]   out_tag2;
	bit [1:0]		out_resp3;
	bit [31:0]	out_data3;
	bit [1:0]   out_tag3;
	bit [1:0]		out_resp4;
	bit [31:0]	out_data4;
	bit [1:0]   out_tag4;


initial begin

  //do stuff

end

calc1_top calc1_top(
	.c_clk(c_clk),
	.reset(reset),
	.req1_cmd_in(req1_cmd_in),
	.req1_data_in(req1_data_in),
	.req1_tag_in(req1_tag_in),
	.req2_cmd_in(req2_cmd_in),
	.req2_data_in(req2_data_in),
	.req2_tag_in(req2_tag_in),
	.req3_cmd_in(req3_cmd_in),
	.req3_data_in(req3_data_in),
	.req3_tag_in(req3_tag_in),
	.req4_cmd_in(req4_cmd_in),
	.req4_data_in(req4_data_in),
	.req4_tag_in(req4_tag_in),
	.out_resp1(out_resp1),
	.out_data1(out_data1),
	.out_tag1(out_tag1),
	.out_resp2(out_resp2),
	.out_data2(out_data2),
	.out_tag2(out_tag2),
	.out_resp3(out_resp3),
	.out_data3(out_data3),
	.out_tag3(out_tag3),
	.out_resp4(out_resp4),
	.out_data4(out_data4),
	.out_tag4(out_tag4)
);


//clock generator 50ns
initial begin
	forever
      #50ns c_clk=!c_clk;
end

endmodule
