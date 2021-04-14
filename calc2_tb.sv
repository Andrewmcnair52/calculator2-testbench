`include "tb/transaction.sv"
`include "tb/generator.sv"
`include "tb/driver.sv"

module calc2_tb;
	
  bit 			  c_clk = 0;
	bit     		reset = 0;
	
	bit [3:0] 		req1_cmd_in   = 4'h0;
	bit [31:0] 		req1_data_in  = 32'h0;
	bit [1:0]     req1_tag_in 	= 2'h0;
	bit [3:0] 		req2_cmd_in   = 4'h0;
	bit [31:0] 		req2_data_in  = 32'h0;
	bit [1:0]     req2_tag_in	  = 2'h0;
	bit [3:0] 		req3_cmd_in   = 4'h0;
	bit [31:0] 		req3_data_in  = 32'h0;
	bit [1:0]     req3_tag_in	  = 2'h0;
	bit [3:0] 		req4_cmd_in   = 4'h0;
	bit [31:0] 		req4_data_in  = 32'h0;
	bit [1:0]     req4_tag_in   = 2'h0;

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

  //command inputs:
  //Add: 4'h1   Sub: 4'h2
  //SHL: 4'h5   SHR: 4'h6

initial begin
  
  //edclare things before statments, or it errors
  Generator gen;
  Transaction t;
  Driver d;
  
  $display(); //output seperator
  
  //a test case
  gen = new();                      //creates transaction in constructor
  t = gen.trans_queue.pop_back();   //retrieve transaction from generator
  d = new();                        //construct the driver
  d.run_single(t);                  //run the transaction       
  t.print();                        //print results saved in transaction
	
	$display(); //output seperator
	$finish;

end

calc2_top calc2_top(
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

//debug info
/*
  always @(negedge c_clk) begin
      $display("reset: %b   time: %t", reset, $time);
      $display("req1_cmd_in:  %h           out_resp1: %h", req1_cmd_in, out_resp1);
		  $display("req1_data_in: %h    out_data1: %h", req1_data_in, out_data1);
		  $display("req1_tag_in:  %h           out_tag1:  %h", req1_tag_in, out_tag1);
		  $display();
  end
*/

//=========================================================================================== Driver functions

 task automatic run_single(Transaction t);  //run a single transaction
  
    do_reset();
    @(posedge c_clk);           //load in command, param1, and tag
    req1_cmd_in   <= t.cmd[0];
    req1_data_in  <= t.param1[0];
    req1_tag_in   <= t.tag[0];
    req2_cmd_in   <= t.cmd[1];
    req2_data_in  <= t.param1[1];
    req2_tag_in   <= t.tag[1];
    req3_cmd_in   <= t.cmd[2];
    req3_data_in  <= t.param1[2];
    req3_tag_in   <= t.tag[2];
    req4_cmd_in   <= t.cmd[3];
    req4_data_in  <= t.param1[3];
    req4_tag_in   <= t.tag[3];
  
    @(posedge c_clk);             //load in param2
    req1_data_in  <= t.param2[0];
    req2_data_in  <= t.param2[1];
    req3_data_in  <= t.param2[2];
    req4_data_in  <= t.param2[3];
  
    @(negedge c_clk);             //clear all inputs
    req1_cmd_in   <= 4'h0;
    req1_data_in  <= 32'h0;
    req1_tag_in   <= 2'h0;
    req2_cmd_in   <= 4'h0;
    req2_data_in  <= 32'h0;
    req2_tag_in   <= 2'h0;
    req3_cmd_in   <= 4'h0;
    req3_data_in  <= 32'h0;
    req3_tag_in   <= 2'h0;
    req4_cmd_in   <= 4'h0;
    req4_data_in  <= 32'h0;
    req4_tag_in   <= 2'h0;
  
    for(int i=0; i<t.clock_cycles; i++) begin		//give it specified number of clock cycles to respond
	  	@(posedge c_clk);
	  	if (out_tag1 == t.tag[0]) begin   //channel 1
	  	  $display("channel 1 response after %0d cycles", i+1);
	  	  t.data_out[0] = out_data1;
	  	  t.resp_out[0] = out_resp1;
	  	end
	  	if (out_tag2 == t.tag[1]) begin   //channel 2
	  	  $display("channel 2 response after %0d cycles", i+1);
	  	  t.data_out[1] = out_data2;
	  	  t.resp_out[1] = out_resp2;
	  	end
	  	if (out_tag3 == t.tag[2]) begin   //channel 3
	  	  $display("channel 3 response after %0d cycles", i+1);
	  	  t.data_out[2] = out_data3;
	  	  t.resp_out[2] = out_resp3;
	  	end
	  	if (out_tag4 == t.tag[3]) begin   //channel 4
	  	  $display("channel 4 response after %0d cycles", i+1);
	  	  t.data_out[3] = out_data4;
	  	  t.resp_out[3] = out_resp4;
	  	end
	  end

  endtask



  task do_reset;	//reset the device
    begin
      repeat(3) begin
        @(posedge c_clk);
        reset = 1;
	    end
	    @(posedge c_clk) reset = 0;
	  end
  endtask

endmodule





