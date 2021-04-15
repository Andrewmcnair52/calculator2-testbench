`include "tb/transaction.sv"
`include "tb/driver.sv"
`include "tb/generator.sv"
`include "tb/calc_if.sv"

module calc2_tb;
	
	//initialize clock
  bit c_clk = 0;
  
  //define calculator interface
  calc_if calc(c_clk);

  //command inputs:
  //Add: 4'h1   Sub: 4'h2
  //SHL: 4'h5   SHR: 4'h6

initial begin
  
  //put declarations before statments, or it errors
  Generator gen;
  Transaction t;
  Driver d;
  
  $display(); //output seperator
  
  //a test case
  gen = new();    //create generator
  d = new(calc);  //construct the driver, give it handler for interface
  
  //sample add transaction to generator and run
  gen.add( .p11(32'h22), .p21(32'h3), .c1(4'h2), .t1(2'h2) );  //22-3 on tag2 
  gen.run_queue(d);     //run transactions with driver
	
	$display(); //output seperator
	$finish;

end

calc2_top calc2_top(
	.c_clk(calc.c_clk),
	.reset(calc.reset),
	.req1_cmd_in(calc.req1_cmd_in),
	.req1_data_in(calc.req1_data_in),
	.req1_tag_in(calc.req1_tag_in),
	.req2_cmd_in(calc.req2_cmd_in),
	.req2_data_in(calc.req2_data_in),
	.req2_tag_in(calc.req2_tag_in),
	.req3_cmd_in(calc.req3_cmd_in),
	.req3_data_in(calc.req3_data_in),
	.req3_tag_in(calc.req3_tag_in),
	.req4_cmd_in(calc.req4_cmd_in),
	.req4_data_in(calc.req4_data_in),
	.req4_tag_in(calc.req4_tag_in),
	.out_resp1(calc.out_resp1),
	.out_data1(calc.out_data1),
	.out_tag1(calc.out_tag1),
	.out_resp2(calc.out_resp2),
	.out_data2(calc.out_data2),
	.out_tag2(calc.out_tag2),
	.out_resp3(calc.out_resp3),
	.out_data3(calc.out_data3),
	.out_tag3(calc.out_tag3),
	.out_resp4(calc.out_resp4),
	.out_data4(calc.out_data4),
	.out_tag4(calc.out_tag4)
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





