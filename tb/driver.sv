
class driver; //runs code on DUT by manipulating inputs

  task automatic run_single(transaction t);  //run a single transaction
  
    do_reset();
    @(posedge c_clk);
    req1_cmd_in   <= t.cmd[0];
    req1_data_in  <= t.param1[0];
    req1_tag_in   <= t.tag[0];
  
    @(posedge c_clk);
    req1_data_in  <= 32'h20;
  
    @(negedge c_clk);
    req1_cmd_in   <= 4'h0;    //clear inputs
    req1_data_in  <= 32'h0;
    req1_tag_in   <= 2'h0;
  
    for(int i=0; i<10; i++) begin		//give it 10 cycles to respond
	  	@(posedge c_clk);
	  	if(i == 9) begin
	  		$display("no response");
	  	  $display("out_resp1: %h", out_resp1);
	  	  $display("out_data1: %h", out_data1);
	  	  $display("out_tag1: %h", out_tag1);
	  	end
	  	else if (out_resp1 != 0) begin
	  	  $display("response after %0d cycles", i+1);
	  	  $display("out_resp1: %h", out_resp1);
	  	  $display("out_data1: %h", out_data1);
	  	  $display("out_tag1: %h", out_tag1);
	  		i = 10;
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



endclass


