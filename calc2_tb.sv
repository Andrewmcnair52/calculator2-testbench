`include "tb/transaction.sv"
`include "tb/generator.sv"
`include "tb/driver.sv"
`include "tb/calc_if.sv"

module calc2_tb;
	
	//initialize clock
  bit c_clk = 0;
  
  //define calculator interface
  calc_if(c_clk);

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
	.c_clk(calc_if.c_clk),
	.reset(calc_if.reset),
	.req1_cmd_in(calc_if.req1_cmd_in),
	.req1_data_in(calc_if.req1_data_in),
	.req1_tag_in(calc_if.req1_tag_in),
	.req2_cmd_in(calc_if.req2_cmd_in),
	.req2_data_in(calc_if.req2_data_in),
	.req2_tag_in(calc_if.req2_tag_in),
	.req3_cmd_in(calc_if.req3_cmd_in),
	.req3_data_in(calc_if.req3_data_in),
	.req3_tag_in(calc_if.req3_tag_in),
	.req4_cmd_in(calc_if.req4_cmd_in),
	.req4_data_in(calc_if.req4_data_in),
	.req4_tag_in(calc_if.req4_tag_in),
	.out_resp1(calc_if.out_resp1),
	.out_data1(calc_if.out_data1),
	.out_tag1(calc_if.out_tag1),
	.out_resp2(calc_if.out_resp2),
	.out_data2(calc_if.out_data2),
	.out_tag2(calc_if.out_tag2),
	.out_resp3(calc_if.out_resp3),
	.out_data3(calc_if.out_data3),
	.out_tag3(calc_if.out_tag3),
	.out_resp4(calc_if.out_resp4),
	.out_data4(calc_if.out_data4),
	.out_tag4(calc_if.out_tag4)
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

endmodule





