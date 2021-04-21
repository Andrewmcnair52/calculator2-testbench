`include "tb/transaction.sv"
`include "tb/checker.sv"
`include "tb/driver.sv"
`include "tb/generator.sv"
`include "tb/monitor.sv"
`include "tb/calc_if.sv"

module calc2_tb;
	
	int num_tests = 20;
	
  bit c_clk = 0;        //initialize clock
  calc_if calc(c_clk);  //define calculator interface
  bit [31:0] p11, p12, p13, p14, p21, p22, p23, p24;
  bit [3:0] c1, c2, c3, c4;
  bit[3:0] command[4]='{4'h1,4'h2,4'h5,4'h6};
  bit [2:0] mode;
  
  mailbox #(Transaction) driver_mbx;      //mailbox for gen to send transactions to driver
  mailbox #(Transaction) monitor_mbx;     //mailbox for driver to send transactions to monitor
  mailbox #(Transaction) check_mbx;     //mailbox for monitor to send transactions to checker
  mailbox #(bit) next_trans_mbx;  //mailbox for monitor to notify driver that it is ready for next transaction
  
  //command inputs:
  //Add: 4'h1   Sub: 4'h2
  //SHL: 4'h5   SHR: 4'h6
  
  covergroup cg;
  cp_c1 : coverpoint c1 {bins one = {1};bins two = {2};bins five = {5};bins six = {6};}
  cp_c2 : coverpoint c2 {bins one = {1};bins two = {2};bins five = {5};bins six = {6};}
  cp_c3 : coverpoint c3 {bins one = {1};bins two = {2};bins five = {5};bins six = {6};}
  cp_c4 : coverpoint c4 {bins one = {1};bins two = {2};bins five = {5};bins six = {6};}
  endgroup
  
  


initial begin
  
  //put declarations before statments, or it errors
  Transaction t;
  Generator gen;
  Driver driver;
  Monitor monitor;
  Checker check;
  cg cg_inst;
  int i;
  
  $display(); //output seperator
  
  //initialize mailboxes
  driver_mbx = new();     //delivers transactions to driver
  monitor_mbx = new();    //delivers transactions to monitor
  check_mbx = new();      //delivers transactions to checker
  next_trans_mbx = new(); //notifies driver to run next transaction
  
  //generate tests
  gen = new(driver_mbx); //create generator
  
  //Generate random
   cg_inst = new();  

    for(i=0; i<num_tests; i++) begin
        t = new();
        if( !t.randomize()) begin
          $display("could not randomize");
          $finish;
        end else begin
          gen.add(t);
		      cg_inst.sample();
		    end
     end

  //run tests
  driver = new(calc, driver_mbx, monitor_mbx, next_trans_mbx, num_tests);
  monitor = new(calc, monitor_mbx, check_mbx, next_trans_mbx, num_tests);
  fork
    driver.run();   //Process-1
    monitor.run();  //Process-2
  join
  
  
  
  //check results
  check = new(check_mbx);
	check.run();
	
	//print output
	$display();
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





