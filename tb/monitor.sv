

class monitor;

  virtual calc_if calc;   //virtual interface to amke our interface available in the class
  mailbox #(Transaction) monitor_mbx;     //get transactions from driver
  mailbox #(Transaction) check_mbx;       //send transactions to checker
  mailbox #(Transaction) next_trans_mbx;  //notify driver to run next command
  int num_transactions;
  
  function new(virtual calc_if calc, mailbox #(Transaction) monitor_mbx, check_mbx, next_trans_mbx, int num_transactions);
    this.calc = calc;                //connect virtual interface to our interface
    this.monitor_mbx = monitor_mbx;
    this.check_mbx = check_mbx;
    this.next_trans_mbx = next_trans_mbx;
    this.score = score;
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
      
      //set recieved if no response expected
      for(int i=0; i<4; i++) begin
        if(c1_cmd[i] == 0) c1_received[i] = 1;
        if(c2_cmd[i] == 0) c1_received[i] = 1;
        if(c3_cmd[i] == 0) c1_received[i] = 1;
        if(c4_cmd[i] == 0) c1_received[i] = 1;
      end
      
      for(int i=0; i<21; i++) begin   //timeout after 20 clock cycles
        if(i==20) begin //timeout triggered
        
        end else if(c1_cmd[0]&&c1_cmd[1]&&c1_cmd[2]&&c1_cmd[3]&&c2_cmd[0]&&c2_cmd[1]&&c2_cmd[2]&&c2_cmd[3]&&c3_cmd[0]&&c3_cmd[1]&&c3_cmd[2]&&c3_cmd[3]&&c4_cmd[0]&&c4_cmd[1]&&c4_cmd[2]&&c4_cmd[3]&&) begin
          //end condition: if every cmd that was supposed to respond did
          i = 21;
        end else begin
        
          @(posedge calc.c_clk);
          if(calc.out_resp1!=0 && c1_cmd[calc.out_tag1]==0) begin   //if response on channel 1 and we havnt already seen that tag
            t.c1_out_resp[calc.out_tag1] = calc.out_resp1;
            t.c1_out_data[calc.out_tag1] = calc.out_data1;
            c1_cmd[calc.out_tag1] = 1;
          end
          if(calc.out_resp2!=0 && c2_cmd[calc.out_tag2]==0) begin  //if response on channel 2 and we havnt already seen that tag
            t.c2_out_resp[calc.out_tag2] = calc.out_resp2;
            t.c2_out_data[calc.out_tag2] = calc.out_data2;
            c1_cmd[calc.out_tag2] = 1;
          end
          if(calc.out_resp3!=0 && c3_cmd[calc.out_tag3]==0) begin  //if response on channel 3 and we havnt already seen that tag
            t.c3_out_resp[calc.out_tag3] = calc.out_resp3;
            t.c3_out_data[calc.out_tag3] = calc.out_data3;
            c1_cmd[calc.out_tag3] = 1;
          end
          if(calc.out_resp4!=0 && c4_cmd[calc.out_tag4]==0) begin  //if response on channel 4 and we havnt already seen that tag
            t.c4_out_resp[calc.out_tag4] = calc.out_resp4;
            t.c4_out_data[calc.out_tag4] = calc.out_data4;
            c1_cmd[calc.out_tag4] = 1;
          end
        
        end
      
      end //end of for loop: running tests
        
      check_mbx.put(t);         //send transaction to checker
      next_trans_mbx.out(tmp)   //tell driver to run next transaction
      transaction_count = transaction_count - 1;  //decrement counter
    
    end //end of while loop: counting transactions
  
  endtask
  
endclass



















