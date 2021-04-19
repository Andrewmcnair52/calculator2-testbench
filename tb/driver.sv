
class Driver; //runs code on DUT by manipulating inputs

  virtual calc_if calc;   //virtual interface to amke our interface available in the class
  mailbox #(Transaction) driver_mbx;      //get transaction from generator
  mailbox #(Transaction) monitor_mbx;     //send transaction to monitor
  mailbox #(bit) next_trans_mbx;  //receive notifications from monitor
  int num_transactions;
  
  function new(virtual calc_if calc, mailbox #(Transaction) driver_mbx, monitor_mbk, mailbox #(bit) next_trans_mbx, int num_transactions);
    this.calc = calc;                //connect virtual interface to our interface
    this.driver_mbx = driver_mbx;
    this.monitor_mbx = monitor_mbx;
    this.next_trans_mbx = next_trans_mbx;
    this.num_transactions = num_transactions;
  endfunction

  task automatic run;  //run driver
  
    Transaction t;
    bit[1:0] tag = 2'b00;
    bit tmp;
    
    do_reset();
    
    while(num_transactions>0) begin
    
      
      driver_mbx(t);      //get next transaction to run from mailbox
      monitor_mbx.put(t); //send transaction to monitor
    
      for(int i=0; i<4; i++) begin  //run all 4 transactions
        
        @(posedge calc.c_clk);           //load in command, param1, and tag
        calc.req1_cmd_in   <= t.c1_cmd[i];
        calc.req1_data_in  <= t.c1_param1[i];
        calc.req1_tag_in   <= i;
        calc.req2_cmd_in   <= t.c2_cmd[i];
        calc.req2_data_in  <= t.c2_param1[i];
        calc.req2_tag_in   <= i;
        calc.req3_cmd_in   <= t.c3_cmd[i];
        calc.req3_data_in  <= t.c3_param1[i];
        calc.req3_tag_in   <= i;
        calc.req4_cmd_in   <= t.c4_cmd[i];
        calc.req4_data_in  <= t.c4_param1[i];
        calc.req4_tag_in   <= i;
        
        @(posedge calc.c_clk);    //load in param2, clear cmd and tag
        calc.req1_cmd_in   <= 4'h0;
        calc.req1_data_in  <= t.c1_param2[i];
        calc.req1_tag_in   <= 2'h0;
        calc.req2_cmd_in   <= 4'h0;
        calc.req2_data_in  <= t.c2_param2[i];
        calc.req2_tag_in   <= 2'h0;
        calc.req3_cmd_in   <= 4'h0;
        calc.req3_data_in  <= t.c3_param2[i];
        calc.req3_tag_in   <= 2'h0;
        calc.req4_cmd_in   <= 4'h0;
        calc.req4_data_in  <= t.c4_param2[i];
        calc.req4_tag_in   <= 2'h0;
      
      end // end for loop
      
      num_transactions = num_transactions - 1;
      next_trans_mbx.get(tmp);  //wait for notification from monitor to proceed
      
    end

  endtask

  task do_reset;	//reset the device
    begin
      repeat(3) begin
        @(posedge calc.c_clk);
        calc.reset = 1;
	    end
	    @(posedge calc.c_clk) calc.reset = 0;
	  end
  endtask



endclass


