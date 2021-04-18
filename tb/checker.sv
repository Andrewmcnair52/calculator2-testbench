
class Checker;

  mailbox #(Transaction) check_mbx;   //receives transactions from monitor
  string message_queue[$];
  string message;
  
  int errorCnt=0, successCnt=0; 
  
  
  
  function new(mailbox #(Transaction) check_mbx);
    this.check_mbx = check_mbx;
  endfunction
  
  
  
  function run();
  
    Transaction t;
  
    while(check_mbx.num() > 0) begin
    
      check_mbx.get(t); //get transaction
      t.set_expected;   //set expected values
      
      for(int i=0; i<4; i++) begin  //for each test in transaction
      
        //check channel 1
        if(t.c1_out_resp[i]!=t.c1_expected_resp[i] || t.c1_out_data[i]!=t.c1_expected_data[i]) begin
        $sformat(message, "error on channel 1: sent %0d %s %0d, received data %0d with resp %0d, expected data %0d with resp %0d", t.c1_param1[i], resolve_op(t.c1_cmd[i]), t.c1_param2[i], t.c1_out_data[i], t.c1_out_resp[i], t.c1_expected_data[i], t.c1_expected_resp[i]);
        message_queue.push_back(message);
        errorCnt = errorCnt + 1;
        end else begin  //if data and response are good, success!
          successCnt = successCnt + 1;
        end
        
        //check channel 2
        if(t.c2_out_resp[i]!=t.c2_expected_resp[i] || t.c2_out_data[i]!=t.c2_expected_data[i]) begin
        $sformat(message, "error on channel 2: sent %0d %s %0d, received data %0d with resp %0d, expected data %0d with resp %0d", t.c2_param1[i], resolve_op(t.c2_cmd[i]), t.c2_param2[i], t.c2_out_data[i], t.c2_out_resp[i], t.c2_expected_data[i], t.c2_expected_resp[i]);
        message_queue.push_back(message);
        errorCnt = errorCnt + 1;
        end else begin  //if data and response are good, success!
          successCnt = successCnt + 1;
        end
        
        //check channel 3
        if(t.c3_out_resp[i]!=t.c3_expected_resp[i] || t.c3_out_data[i]!=t.c3_expected_data[i]) begin
        $sformat(message, "error on channel 3: sent %0d %s %0d, received data %0d with resp %0d, expected data %0d with resp %0d", t.c3_param1[i], resolve_op(t.c3_cmd[i]), t.c3_param2[i], t.c3_out_data[i], t.c3_out_resp[i], t.c3_expected_data[i], t.c3_expected_resp[i]);
        message_queue.push_back(message);
        errorCnt = errorCnt + 1;
        end else begin  //if data and response are good, success!
          successCnt = successCnt + 1;
        end
        
        //check channel 4
        if(t.c4_out_resp[i]!=t.c4_expected_resp[i] || t.c4_out_data[i]!=t.c4_expected_data[i]) begin
        $sformat(message, "error on channel 4: sent %0d %s %0d, received data %0d with resp %0d, expected data %0d with resp %0d", t.c4_param1[i], resolve_op(t.c4_cmd[i]), t.c4_param2[i], t.c4_out_data[i], t.c4_out_resp[i], t.c4_expected_data[i], t.c4_expected_resp[i]);
        message_queue.push_back(message);
        errorCnt = errorCnt + 1;
        end else begin  //if data and response are good, success!
          successCnt = successCnt + 1;
        end
      
      end //end for loop: iterating through tests in transaction
    
      message_queue.push_back(" "); //line seperator between transactions
    
    end //end while loop" iterating through mbx
    
  endfunction
  
  
  
  function print_summary();
  
  $display("===============================================\nSUMMARY\n===============================================\n");
  $display("errors: %0d   successes: %0d\n", errorCnt, successCnt);
  
    foreach(message_queue[i]) begin
      $display(message_queue[i]);
    end
  endfunction
  
  
  
  function string resolve_op(bit[3:0] in);
    if(in==1) begin
      return "+";
    end else if(in==2) begin
      return "-";
    end else if(in==5) begin
      return "<<";
    end else if(in==6) begin
      return ">>";
    end else begin
      return "NONE";
    end
  endfunction
  
  
  
  function set_expected(ref Transaction t);
    
    longint result, max = 64'h00000000FFFFFFFF;  //variables for overflow detection
    
    for(int i=0; i<4; i++) begin  //for each test
      
      if(t.c1_cmd[i]==4'b0000) begin                 //no command
        t.c1_expected_data[i] = 32'h0;
        t.c1_expected_resp[i] = 2'h0;
      end else if(t.c1_cmd[i]==4'b0001) begin           //addition
        t.c1_expected_data[i] = t.c1_param1[i] + c1_param2[i];
        result = t.c1_param1[i] + t.c1_param2[i];
        if(result>max) begin
          t.c1_expected_resp[i] = 2'b10;
        end else begin
          t.c1_expected_resp[i] = 2'b01;
        end
      end else if(t.c1_cmd[i]==4'b0010) begin           //subtraction
        t.c1_expected_data[i] = t.c1_param1[i] - c1_param2[i];
        if(t.c1_param1[i]<t.c1_param2[i]) begin
          t.c1_expected_resp[i] = 2'b10;
        end else begin
          t.c1_expected_resp[i] = 2'b01;
        end
      end else if(t.c1_cmd[i]==4'b0101) begin           //shift left
        t.c1_expected_data[i] = t.c1_param1[i] << t.c1_param2[i];
        t.c1_expected_resp[i] = 2'b01;
      end else if(t.c1_cmd[i]==4'b0110) begin           //shift right
        t.c1_expected_data[i] = t.c1_param1[i] >> t.c1_param2[i];
        t.c1_expected_resp[i] = 2'b01;
      end else begin                               //invalid command
        t.c1_expected_resp[i] = 2'b10;
      end
      
      if(t.c2_cmd[i]==4'b0000) begin                 //no command
        t.c2_expected_data[i] = 32'h0;
        t.c2_expected_resp[i] = 2'h0;
      end else if(t.c2_cmd[i]==4'b0001) begin           //addition
        t.c2_expected_data[i] = t.c2_param1[i] + c2_param2[i];
        result = t.c2_param1[i] + t.c2_param2[i];
        if(result>max) begin
          t.c2_expected_resp[i] = 2'b10;
        end else begin
          t.c2_expected_resp[i] = 2'b01;
        end
      end else if(t.c2_cmd[i]==4'b0010) begin           //subtraction
        t.c2_expected_data[i] = t.c2_param1[i] - c2_param2[i];
        if(t.c2_param1[i]<t.c2_param2[i]) begin
          t.c2_expected_resp[i] = 2'b10;
        end else begin
          t.c2_expected_resp[i] = 2'b01;
        end
      end else if(t.c2_cmd[i]==4'b0101) begin           //shift left
        t.c2_expected_data[i] = t.c2_param1[i] << t.c2_param2[i];
        t.c2_expected_resp[i] = 2'b01;
      end else if(t.c2_cmd[i]==4'b0110) begin           //shift right
        t.c2_expected_data[i] = t.c2_param1[i] >> t.c2_param2[i];
        t.c2_expected_resp[i] = 2'b01;
      end else begin                               //invalid command
        t.c2_expected_resp[i] = 2'b10;
      end
      
      if(t.c3_cmd[i]==4'b0000) begin                 //no command
        t.c3_expected_data[i] = 32'h0;
        t.c3_expected_resp[i] = 2'h0;
      end else if(t.c3_cmd[i]==4'b0001) begin           //addition
        t.c3_expected_data[i] = t.c3_param1[i] + c3_param2[i];
        result = t.c3_param1[i] + t.c3_param2[i];
        if(result>max) begin
          t.c3_expected_resp[i] = 2'b10;
        end else begin
          t.c3_expected_resp[i] = 2'b01;
        end
      end else if(t.c3_cmd[i]==4'b0010) begin           //subtraction
        t.c3_expected_data[i] = t.c3_param1[i] - c3_param2[i];
        if(t.c3_param1[i]<t.c3_param2[i]) begin
          t.c3_expected_resp[i] = 2'b10;
        end else begin
          t.c3_expected_resp[i] = 2'b01;
        end
      end else if(t.c3_cmd[i]==4'b0101) begin           //shift left
        t.c3_expected_data[i] = t.c3_param1[i] << t.c3_param2[i];
        t.c3_expected_resp[i] = 2'b01;
      end else if(t.c3_cmd[i]==4'b0110) begin           //shift right
        t.c3_expected_data[i] = t.c3_param1[i] >> t.c3_param2[i];
        t.c3_expected_resp[i] = 2'b01;
      end else begin                               //invalid command
        t.c3_expected_resp[i] = 2'b10;
      end
      
      if(t.c4_cmd[i]==4'b0000) begin                 //no command
        t.c4_expected_data[i] = 32'h0;
        t.c4_expected_resp[i] = 2'h0;
      end else if(t.c4_cmd[i]==4'b0001) begin           //addition
        t.c4_expected_data[i] = t.c4_param1[i] + c4_param2[i];
        result = t.c4_param1[i] + t.c4_param2[i];
        if(result>max) begin
          t.c4_expected_resp[i] = 2'b10;
        end else begin
          t.c4_expected_resp[i] = 2'b01;
        end
      end else if(t.c4_cmd[i]==4'b0010) begin           //subtraction
        t.c4_expected_data[i] = t.c4_param1[i] - c4_param2[i];
        if(t.c4_param1[i]<t.c4_param2[i]) begin
          t.c4_expected_resp[i] = 2'b10;
        end else begin
          t.c4_expected_resp[i] = 2'b01;
        end
      end else if(t.c4_cmd[i]==4'b0101) begin           //shift left
        t.c4_expected_data[i] = t.c4_param1[i] << t.c4_param2[i];
        t.c4_expected_resp[i] = 2'b01;
      end else if(t.c4_cmd[i]==4'b0110) begin           //shift right
        t.c4_expected_data[i] = t.c4_param1[i] >> t.c4_param2[i];
        t.c4_expected_resp[i] = 2'b01;
      end else begin                               //invalid command
        t.c4_expected_resp[i] = 2'b10;
      end
      
    end //end for loop
    
  endfunction
 


endclass































