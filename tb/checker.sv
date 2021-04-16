
class Checker;

  Transaction transQ[$];
  string message_queue[$];
  string message;
  
  int errorCnt=0, successCnt=0; 

  function add(Transaction t);
    transQ.push_back(t);
  endfunction
  
  function run();
    foreach(transQ[i]) begin           //for each transaction
      for(int j=0; j<4; j++) begin          //loop through channels
        
        if(transQ[i].resp_out[j]!=transQ[i].resp_expected[j] || transQ[i].data_out[j] != transQ[i].data_expected[j]) begin   //check response and data
          $sformat(message, "channel %0d: sent %0d %s %0d, received data %0d with resp %0d, expected data %0d with resp %0d", j, transQ[i].param1[j], resolve_op(transQ[i].cmd[j]), transQ[i].param2[j], transQ[i].data_out[j], transQ[i].resp_out[j], transQ[i].data_expected[j], transQ[i].resp_expected[j]);
          message_queue.push_back(message);
          errorCnt = errorCnt + 1;
        end else begin  //if data and response are good, success!
          successCnt = successCnt + 1;
        end
        
      end //end channel loop
    end //end transaction loop
  endfunction
  
  function print_transactions();
    foreach(transQ[i]) begin
      transQ[i].print();
      $display();
    end
  endfunction
  
  function print_summary();
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


endclass



