
class Transaction;  //class to store info for a single test

  bit[31:0] param1[4], param2[4], data_out[4], data_expected[4];
  bit[3:0] cmd[4];
  bit[1:0] tag[4], resp_expected[4], resp_out[4];
  int clock_cycles;
  
  function new( input bit[31:0] p11=32'h0, p12=32'h0, p13=32'h0, p14=32'h0, p21=32'h0, p22=32'h0, p23=32'h0, p24=32'h0, input bit[3:0] c1=4'h0, c2=4'h0, c3=4'h0, c4=4'h0, input bit[1:0] t1=2'h0, t2=2'h0, t3=2'h0, t4=2'h0, input int cc=10 );
      param1 = '{p11,p12,p13,p14};
      param2 = '{p21,p22,p23,p24};
      cmd = '{c1,c2,c3,c4};
      tag = '{t1,t2,t3,t4};
      clock_cycles = cc;
  endfunction
  
  function print(); //display test data for debugging purposes
    $display("param1: %h, %h, %h, %h", param1[0],param1[1],param1[2],param1[3]);
    $display("param2: %h, %h, %h, %h", param2[0],param2[1],param2[2],param2[3]);
    $display("cmd: %h, %h, %h, %h", cmd[0],cmd[1],cmd[2],cmd[3]);
    $display("tag: %h, %h, %h, %h", tag[0],tag[1],tag[2],tag[3]);
    $display("data_expec: %h, %h, %h, %h", data_expected[0],data_expected[1],data_expected[2],data_expected[3]);
    $display("resp_expec: %h, %h, %h, %h", resp_expected[0],resp_expected[1],resp_expected[2],resp_expected[3]);
    $display("data_out: %h, %h, %h, %h", data_out[0],data_out[1],data_out[2],data_out[3]);
    $display("resp_out: %h, %h, %h, %h", resp_out[0],resp_out[1],resp_out[2],resp_out[3]);
    $display("clock cycles: %0d", clock_cycles);
    $display();
  endfunction
  
  function setExpected; //set expected values(scoreboard)
  
    longint result, max = 64'h00000000FFFFFFFF;  //variables for overflow detection
  
    for(int i=0; i<4; i++) begin  //foreach channel
      
      if(cmd[i]==4'b0000) begin                    //no command
        //do nothing, expected values default to 0 which is expected for this case
      end else if(cmd[i]==4'b0001) begin           //addition
        data_expected[i] = param1[i] + param2[i];
        result = param1[i] + param2[i];
        if(result>max) begin
          resp_expected[i] = 2'b10;
        end else begin
          resp_expected[i] = 2'b01;
        end
      end else if(cmd[i]==4'b0010) begin           //subtraction
        data_expected[i] = param1[i] - param2[i];
        if(param1[i]<param2[i]) begin
          resp_expected[i] = 2'b10;
        end else begin
          resp_expected[i] = 2'b01;
        end
      end else if(cmd[i]==4'b0101) begin           //shift left
        data_expected[i] = param1[i] << param2[i];
        resp_expected[i] = 2'b01;
      end else if(cmd[i]==4'b0110) begin           //shift right
        data_expected[i] = param1[i] >> param2[i];
        resp_expected[i] = 2'b01;
      end else begin                                  //invalid command
        resp_expected[i] = 2'b10;
      end
      
    end    //end for loop
  endfunction

endclass
