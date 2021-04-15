
class Driver; //runs code on DUT by manipulating inputs

  task automatic run_single(Transaction t);  //run a single transaction
  
    do_reset();
    @(posedge calc_if.c_clk);           //load in command, param1, and tag
    calc_if.req1_cmd_in   <= t.cmd[0];
    calc_if.req1_data_in  <= t.param1[0];
    calc_if.req1_tag_in   <= t.tag[0];
    calc_if.req2_cmd_in   <= t.cmd[1];
    calc_if.req2_data_in  <= t.param1[1];
    calc_if.req2_tag_in   <= t.tag[1];
    calc_if.req3_cmd_in   <= t.cmd[2];
    calc_if.req3_data_in  <= t.param1[2];
    calc_if.req3_tag_in   <= t.tag[2];
    calc_if.req4_cmd_in   <= t.cmd[3];
    calc_if.req4_data_in  <= t.param1[3];
    calc_if.req4_tag_in   <= t.tag[3];
  
    @(posedge calc_if.c_clk);             //load in param2
    calc_if.req1_data_in  <= t.param2[0];
    calc_if.req2_data_in  <= t.param2[1];
    calc_if.req3_data_in  <= t.param2[2];
    calc_if.req4_data_in  <= t.param2[3];
  
    @(negedge calc_if.c_clk);             //clear all inputs
    calc_if.req1_cmd_in   <= 4'h0;
    calc_if.req1_data_in  <= 32'h0;
    calc_if.req1_tag_in   <= 2'h0;
    calc_if.req2_cmd_in   <= 4'h0;
    calc_if.req2_data_in  <= 32'h0;
    calc_if.req2_tag_in   <= 2'h0;
    calc_if.req3_cmd_in   <= 4'h0;
    calc_if.req3_data_in  <= 32'h0;
    calc_if.req3_tag_in   <= 2'h0;
    calc_if.req4_cmd_in   <= 4'h0;
    calc_if.req4_data_in  <= 32'h0;
    calc_if.req4_tag_in   <= 2'h0;
  
    for(int i=0; i<t.clock_cycles; i++) begin		//give it specified number of clock cycles to respond
	  	@(posedge c_clk);
	  	if (calc_if.out_tag1 == t.tag[0]) begin   //channel 1
	  	  $display("channel 1 response after %0d cycles", i+1);
	  	  t.data_out[0] = calc_if.out_data1;
	  	  t.resp_out[0] = calc_if.out_resp1;
	  	end
	  	if (calc_if.out_tag2 == t.tag[1]) begin   //channel 2
	  	  $display("channel 2 response after %0d cycles", i+1);
	  	  t.data_out[1] = calc_if.out_data2;
	  	  t.resp_out[1] = calc_if.out_resp2;
	  	end
	  	if (calc_if.out_tag3 == t.tag[2]) begin   //channel 3
	  	  $display("channel 3 response after %0d cycles", i+1);
	  	  t.data_out[2] = calc_if.out_data3;
	  	  t.resp_out[2] = calc_if.out_resp3;
	  	end
	  	if (calc_if.out_tag4 == t.tag[3]) begin   //channel 4
	  	  $display("channel 4 response after %0d cycles", i+1);
	  	  t.data_out[3] = calc_if.out_data4;
	  	  t.resp_out[3] = calc_if.out_resp4;
	  	end
	  end

  endtask



  task do_reset;	//reset the device
    begin
      repeat(3) begin
        @(posedge calc_if.c_clk);
        calc_if.reset = 1;
	    end
	    @(posedge calc_if.c_clk) calc_if.reset = 0;
	  end
  endtask



endclass


