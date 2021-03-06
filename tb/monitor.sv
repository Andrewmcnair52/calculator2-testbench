

class Monitor;

  bit debug = 0;
  
  Transaction t;
  
  virtual calc_if calc;   //virtual interface to amke our interface available in the class
  mailbox #(Transaction) monitor_mbx;     //get transactions from driver
  mailbox #(Transaction) check_mbx;       //send transactions to checker
  mailbox #(bit) next_trans_mbx;  //notify driver to run next command
  int num_transactions;
  
  covergroup cg_values with function sample (int array_index);
    C1_PARAM1: coverpoint t.c1_param1[array_index];
    C1_PARAM2: coverpoint t.c1_param2[array_index];
    C1_CMD:    coverpoint t.c1_cmd[array_index];
    C2_PARAM1: coverpoint t.c2_param1[array_index];
    C2_PARAM2: coverpoint t.c2_param2[array_index];
    C2_CMD:    coverpoint t.c1_cmd[array_index];
    C3_PARAM1: coverpoint t.c3_param1[array_index];
    C3_PARAM2: coverpoint t.c3_param2[array_index];
    C3_CMD:    coverpoint t.c1_cmd[array_index];
    C4_PARAM1: coverpoint t.c4_param1[array_index];
    C4_PARAM2: coverpoint t.c4_param2[array_index];
    C4_CMD:    coverpoint t.c1_cmd[array_index];
  endgroup

  covergroup cg_1_p1 with function sample (int array_index);
    C1_PARAM1: coverpoint t.c1_param1[array_index];
  endgroup;
  covergroup cg_1_p2 with function sample (int array_index);
    C1_PARAM2: coverpoint t.c1_param2[array_index];
  endgroup;
  covergroup cg_1_c with function sample (int array_index);
    C1_CMD: coverpoint t.c1_cmd[array_index];
  endgroup;

   covergroup cg_2_p1 with function sample (int array_index);
    C2_PARAM1: coverpoint t.c2_param1[array_index];
   endgroup;	
   covergroup cg_2_p2 with function sample (int array_index);
    C2_PARAM2: coverpoint t.c1_param2[array_index];
    endgroup;
   covergroup cg_2_c with function sample (int array_index);
    C2_CMD: coverpoint t.c2_cmd[array_index];
   endgroup;

   covergroup cg_3_p1 with function sample (int array_index);
    C3_PARAM1: coverpoint t.c3_param1[array_index];
   endgroup;	
   covergroup cg_3_p2 with function sample (int array_index);
    C3_PARAM2: coverpoint t.c3_param2[array_index];
   endgroup;
   covergroup cg_3_c with function sample (int array_index);
    C3_CMD: coverpoint t.c3_cmd[array_index];
   endgroup;

   covergroup cg_4_p1 with function sample (int array_index);
    C4_PARAM1: coverpoint t.c4_param1[array_index];
   endgroup;	
   covergroup cg_4_p2 with function sample (int array_index);
    C4_PARAM2: coverpoint t.c4_param2[array_index];
   endgroup;
   covergroup cg_4_c with function sample (int array_index);
    C4_CMD: coverpoint t.c4_cmd[array_index];
   endgroup;



  function new(virtual calc_if calc, mailbox #(Transaction) monitor_mbx, check_mbx, mailbox #(bit) next_trans_mbx, int num_transactions);
    this.calc = calc;                //connect virtual interface to our interface
    this.monitor_mbx = monitor_mbx;
    this.check_mbx = check_mbx;
    this.next_trans_mbx = next_trans_mbx;
    this.num_transactions = num_transactions;
    cg_values = new();
    cg_1_p1 = new();
    cg_1_p2 = new();
    cg_1_c = new();
    cg_2_p1 = new();
    cg_2_p2 = new();
    cg_2_c = new();
    cg_3_p1 = new();
    cg_3_p2 = new();
    cg_3_c = new();
    cg_4_p1 = new();
    cg_4_p2 = new();
    cg_4_c = new();
  endfunction

  task automatic run;  //run a single transaction
  
    int transaction_count = num_transactions;
    bit c1_received[4];
    bit c2_received[4];
    bit c3_received[4];
    bit c4_received[4];
    bit tmp = 1;
  
    while(transaction_count>0) begin
      
      //reset all the things
      c1_received = '{0,0,0,0};
      c2_received = '{0,0,0,0};
      c3_received = '{0,0,0,0};
      c4_received = '{0,0,0,0};
      
      //receive next transaction from driver
      monitor_mbx.get(t);
      
      if(debug==1) begin
        $display("\nmonitoring transaction: ");
        t.print();
        $display();
      end
      
      //sample coverage info
      foreach(t.c1_param1[i]) begin
        cg_1_p1.sample(i);
	cg_1_p2.sample(i);
	cg_1_c.sample(i);
	cg_2_p1.sample(i);
	cg_2_p2.sample(i);
	cg_2_c.sample(i);
	cg_3_p1.sample(i);
	cg_3_p2.sample(i);
	cg_3_c.sample(i);
	cg_4_p1.sample(i);
	cg_4_p2.sample(i);
	cg_4_c.sample(i);
        cg_values.sample(i);
      end

      //set recieved if no response expected
      for(int i=0; i<4; i++) begin
        if(t.c1_cmd[i] == 0) c1_received[i] = 1;
        if(t.c2_cmd[i] == 0) c1_received[i] = 1;
        if(t.c3_cmd[i] == 0) c1_received[i] = 1;
        if(t.c4_cmd[i] == 0) c1_received[i] = 1;
      end
      
      for(int i=0; i<21; i++) begin   //for loop to run tests, timeout after 20 clock cycles
        
        if(i==20) begin //timeout triggered
        
          if(debug==1) $display("timeout triggered");
        
          for (int j=0; j<4; j++) begin
            if(c1_received[j]==0) begin
              t.c1_out_data[j] = 32'h0;
              t.c1_out_resp[j] = 32'h0;
            end
            if(c2_received[j]==0) begin
              t.c2_out_data[j] = 32'h0;
              t.c2_out_resp[j] = 32'h0;
            end
            if(c3_received[j]==0) begin
              t.c3_out_data[j] = 32'h0;
              t.c3_out_resp[j] = 32'h0;
            end
            if(c4_received[j]==0) begin
              t.c4_out_data[j] = 32'h0;
              t.c4_out_resp[j] = 32'h0;
            end
          end
        
        end else if (c1_received[0] && c1_received[1] && c1_received[2] && c1_received[3] && c2_received[0] && c2_received[1] && c2_received[2] && c2_received[3] && c3_received[0] && c3_received[1] && c3_received[2] && c3_received[3] && c4_received[0] && c4_received[1] && c4_received[2] && c4_received[3]) begin
          //end condition: if every cmd that was supposed to respond did
          if(debug==1) $display("every test has responded, moving on ...");
          i = 21;
        end else begin  //else run test
        
          @(posedge calc.c_clk);
          if(debug==1) $display("clock_cycle: %0d", i);
          if(calc.out_resp1!=0 && c1_received[calc.out_tag1]==0) begin   //if response on channel 1 and we havnt already seen that tag
            if(debug==1) $display("  response on channel 1, tag %0d", calc.out_tag1);
            t.c1_out_resp[calc.out_tag1] = calc.out_resp1;
            t.c1_out_data[calc.out_tag1] = calc.out_data1;
            c1_received[calc.out_tag1] = 1;
          end
          if(calc.out_resp2!=0 && c2_received[calc.out_tag2]==0) begin  //if response on channel 2 and we havnt already seen that tag
          if(debug==1) $display("  response on channel 2, tag %0d", calc.out_tag2);
            t.c2_out_resp[calc.out_tag2] = calc.out_resp2;
            t.c2_out_data[calc.out_tag2] = calc.out_data2;
            c2_received[calc.out_tag2] = 1;
          end
          if(calc.out_resp3!=0 && c3_received[calc.out_tag3]==0) begin  //if response on channel 3 and we havnt already seen that tag
            if(debug==1) $display("  response on channel 3, tag %0d", calc.out_tag3);
            t.c3_out_resp[calc.out_tag3] = calc.out_resp3;
            t.c3_out_data[calc.out_tag3] = calc.out_data3;
            c3_received[calc.out_tag3] = 1;
          end
          if(calc.out_resp4!=0 && c4_received[calc.out_tag4]==0) begin  //if response on channel 4 and we havnt already seen that tag
            if(debug==1) $display("  response on channel 4, tag %0d", calc.out_tag4);
            t.c4_out_resp[calc.out_tag4] = calc.out_resp4;
            t.c4_out_data[calc.out_tag4] = calc.out_data4;
            c4_received[calc.out_tag4] = 1;
          end
        
        end //end else block: else run tests
      
      end //end of for loop: running tests
        
      check_mbx.put(t);         //send transaction to checker
      next_trans_mbx.put(tmp);  //tell driver to run next transaction
      transaction_count = transaction_count - 1;  //decrement counter
    
    end //end of while loop: counting transactions
    
    //after transactions are done running, print functional coverage
    $display("===============================================\nFunctional Coverage\n===============================================");
    $display();
    $display("input value coverage: %0.2f %%", cg_values.get_inst_coverage());
	$display("channel 1 parameter 1 coverage: %0.2f %%", cg_1_p1.get_inst_coverage());
	$display("channel 1 parameter 2 coverage: %0.2f %%", cg_1_p2.get_inst_coverage());
	$display("channel 1 command coverage: %0.2f %%", cg_1_c.get_inst_coverage());
	$display("channel 2 parameter 1 coverage: %0.2f %%", cg_2_p1.get_inst_coverage());
	$display("channel 2 parameter 2 coverage: %0.2f %%", cg_2_p2.get_inst_coverage());
	$display("channel 2 command coverage: %0.2f %%", cg_2_c.get_inst_coverage());
	$display("channel 3 parameter 1 coverage: %0.2f %%", cg_3_p1.get_inst_coverage());
	$display("channel 3 parameter 2 coverage: %0.2f %%", cg_3_p2.get_inst_coverage());
	$display("channel 3 command coverage: %0.2f %%", cg_3_c.get_inst_coverage());
	$display("channel 4 parameter 1 coverage: %0.2f %%", cg_4_p1.get_inst_coverage());
	$display("channel 4 parameter 2 coverage: %0.2f %%", cg_4_p2.get_inst_coverage());
	$display("channel 4 command coverage: %0.2f %%", cg_4_c.get_inst_coverage());
  endtask
  
endclass



















