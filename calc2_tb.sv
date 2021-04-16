`include "tb/transaction.sv"
`include "tb/checker.sv"
`include "tb/driver.sv"
`include "tb/generator.sv"
`include "tb/agent.sv"
`include "tb/calc_if.sv"

module calc2_tb;
	
	
  bit c_clk = 0;        //initialize clock
  calc_if calc(c_clk);  //define calculator interface

  //command inputs:
  //Add: 4'h1   Sub: 4'h2
  //SHL: 4'h5   SHR: 4'h6

initial begin
  
  //put declarations before statments, or it errors
  Generator gen;
  Driver driver;
  Checker check;
  Agent agent;
  
  $display(); //output seperator
  
  //generate tests
  gen = new(); //create generator
  gen.add( .p11(32'h56), .p21(32'h103), .c1(4'h1), .p12(32'h56), .p22(32'h103), .c2(4'h1), .p13(32'h56), .p23(32'h103), .c3(4'h1), .p14(32'h56), .p24(32'h103), .c4(4'h1) );
  gen.add( .p11(32'h158), .p21(32'h12), .c1(4'h2), .p12(32'h158), .p22(32'h12), .c2(4'h2), .p13(32'h158), .p23(32'h12), .c3(4'h2), .p14(32'h158), .p24(32'h12), .c4(4'h2) );
  
  //initialize
  driver = new(calc);                 //create driver
  check = new();                     //create checker
  agent = new(gen, driver, check);   //create agent
  
	agent.run_single();
	check.run();
	check.print_summary();
	
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





