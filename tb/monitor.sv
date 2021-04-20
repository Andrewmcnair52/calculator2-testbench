

class Monitor;

  virtual calc_if calc;   //virtual interface to amke our interface available in the class
  mailbox #(Transaction) monitor_mbx;     //get transactions from driver
  mailbox #(Transaction) check_mbx;       //send transactions to checker
  mailbox #(bit) next_trans_mbx;  //notify driver to run next command
  int num_transactions;
  
  function new(virtual calc_if calc, mailbox #(Transaction) monitor_mbx, check_mbx, mailbox #(bit) next_trans_mbx, int num_transactions);
    this.calc = calc;                //connect virtual interface to our interface
    this.monitor_mbx = monitor_mbx;
    this.check_mbx = check_mbx;
    this.next_trans_mbx = next_trans_mbx;
    this.num_transactions = num_transactions;
  endfunction

  task automatic run;  //run a single transaction
  
    Transaction t;
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
      
      $display("monitoring transaction: ");
      t.print();
      $display();
      
      //set recieved if no response expected
      for(int i=0; i<4; i++) begin
        if(t.c1_cmd[i] == 0) c1_received[i] = 1;
        if(t.c2_cmd[i] == 0) c1_received[i] = 1;
        if(t.c3_cmd[i] == 0) c1_received[i] = 1;
        if(t.c4_cmd[i] == 0) c1_received[i] = 1;
      end
      
      for(int i=0; i<21; i++) begin   //for loop to run tests, timeout after 20 clock cycles
        
        if(i==20) begin //timeout triggered
        
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
          i = 21;
        end else begin  //else run test
        
          @(posedge calc.c_clk);
          $display("monitor: iteration %0d", i);
          if(calc.out_resp1!=0 && c1_received[calc.out_tag1]==0) begin   //if response on channel 1 and we havnt already seen that tag
            $display("response on channel 1, tag %0d", calc.out_tag1);
            t.c1_out_resp[calc.out_tag1] = calc.out_resp1;
            t.c1_out_data[calc.out_tag1] = calc.out_data1;
            c1_received[calc.out_tag1] = 1;
          end
          if(calc.out_resp2!=0 && c2_received[calc.out_tag2]==0) begin  //if response on channel 2 and we havnt already seen that tag
          $display("response on channel 2, tag %0d", calc.out_tag2);
            t.c2_out_resp[calc.out_tag2] = calc.out_resp2;
            t.c2_out_data[calc.out_tag2] = calc.out_data2;
            c2_received[calc.out_tag2] = 1;
          end
          if(calc.out_resp3!=0 && c3_received[calc.out_tag3]==0) begin  //if response on channel 3 and we havnt already seen that tag
            $display("response on channel 3, tag %0d", calc.out_tag3);
            t.c3_out_resp[calc.out_tag3] = calc.out_resp3;
            t.c3_out_data[calc.out_tag3] = calc.out_data3;
            c3_received[calc.out_tag3] = 1;
          end
          if(calc.out_resp4!=0 && t.c4_received[calc.out_tag4]==0) begin  //if response on channel 4 and we havnt already seen that tag
            $display("response on channel 4, tag %0d", calc.out_tag4);
            t.c4_out_resp[calc.out_tag4] = calc.out_resp4;
            t.c4_out_data[calc.out_tag4] = calc.out_data4;
            c4_received[calc.out_tag4] = 1;
          end
        
        end //end else block
      
      end //end of for loop: running tests
        
      check_mbx.put(t);         //send transaction to checker
      next_trans_mbx.put(tmp);  //tell driver to run next transaction
      transaction_count = transaction_count - 1;  //decrement counter
    
    end //end of while loop: counting transactions
  
  endtask
  
endclass



















