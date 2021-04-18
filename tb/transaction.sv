
class Transaction;  //class to store info for a single test

  //channel 1, 4 tests
  bit[31:0] c1_param1[4], c1_param2[4], c1_out_data[4], c1_expected_data[4];
  bit[3:0] c1_cmd[4];
  bit[1:0] c1_out_resp[4], c1_expected_resp[4];
  
  //channel 2, 4 tests
  bit[31:0] c2_param1[4], c2_param2[4], c2_out_data[4], c2_expected_data[4];
  bit[3:0] c2_cmd[4];
  bit[1:0] c2_out_resp[4], c2_expected_resp[4];
  
  //channel 3, 4 tests
  bit[31:0] c3_param1[4], c3_param2[4], c3_out_data[4], c3_expected_data[4];
  bit[3:0] c3_cmd[4];
  bit[1:0] c3_out_resp[4], c3_expected_resp[4];
  
  //channel 4, 4 tests
  bit[31:0] c4_param1[4], c4_param2[4], c4_out_data[4], c4_expected_data[4];
  bit[3:0] c4_cmd[4];
  bit[1:0] c4_out_resp[4], c4_expected_resp[4];
  
  function print(); //display test data for debugging purposes
    $display("Ch1 param1: %h, %h, %h, %h", c1_param1[0],c1_param1[1],c1_param1[2],c1_param1[3]);
    $display("Ch1 param2: %h, %h, %h, %h", c1_param2[0],c1_param2[1],c1_param2[2],c1_param2[3]);
    $display("Ch1 cmd: %h, %h, %h, %h", c1_cmd[0],c1_cmd[1],c1_cmd[2],c1_cmd[3]);
    
    $display("Ch2 param1: %h, %h, %h, %h", c2_param1[0],c2_param1[1],c2_param1[2],c2_param1[3]);
    $display("Ch2 param2: %h, %h, %h, %h", c2_param2[0],c2_param2[1],c2_param2[2],c2_param2[3]);
    $display("Ch2 cmd: %h, %h, %h, %h", c2_cmd[0],c2_cmd[1],c2_cmd[2],c2_cmd[3]);
    
    $display("Ch3 param1: %h, %h, %h, %h", c3_param1[0],c3_param1[1],c3_param1[2],c3_param1[3]);
    $display("Ch3 param2: %h, %h, %h, %h", c3_param2[0],c3_param2[1],c3_param2[2],c3_param2[3]);
    $display("Ch3 cmd: %h, %h, %h, %h", c3_cmd[0],c3_cmd[1],c3_cmd[2],c3_cmd[3]);
    
    $display("Ch4 param1: %h, %h, %h, %h", c4_param1[0],c4_param1[1],c4_param1[2],c4_param1[3]);
    $display("Ch4 param2: %h, %h, %h, %h", c4_param2[0],c4_param2[1],c4_param2[2],c4_param2[3]);
    $display("Ch4 cmd: %h, %h, %h, %h", c4_cmd[0],c4_cmd[1],c4_cmd[2],c4_cmd[3]);
    $display();
  endfunction
  
  function add_c1(bit[31:0] p11=0,p12=0,p13=0,p14=0,p21=0,p22=0,p23=0,p24=0, bit[3:0] c1=0,c2=0,c3=0,c4=0);
    c1_param1 = '{ p11, p12, p13, p14 };
    c1_param2 = '{ p21, p22, p23, p24 };
    c1_cmd = '{ c1, c2, c3, c4 };
  endfunction
  
  function add_c2(bit[31:0] p11=0,p12=0,p13=0,p14=0,p21=0,p22=0,p23=0,p24=0, bit[3:0] c1=0,c2=0,c3=0,c4=0);
    c2_param1 = '{ p11, p12, p13, p14 };
    c2_param2 = '{ p21, p22, p23, p24 };
    c2_cmd = '{ c1, c2, c3, c4 };
  endfunction
  
  function add_c3(bit[31:0] p11=0,p12=0,p13=0,p14=0,p21=0,p22=0,p23=0,p24=0, bit[3:0] c1=0,c2=0,c3=0,c4=0);
    c3_param1 = '{ p11, p12, p13, p14 };
    c3_param2 = '{ p21, p22, p23, p24 };
    c3_cmd = '{ c1, c2, c3, c4 };
  endfunction
  
  function add_c4(bit[31:0] p11=0,p12=0,p13=0,p14=0,p21=0,p22=0,p23=0,p24=0, bit[3:0] c1=0,c2=0,c3=0,c4=0);
    c4_param1 = '{ p11, p12, p13, p14 };
    c4_param2 = '{ p21, p22, p23, p24 };
    c4_cmd = '{ c1, c2, c3, c4 };
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
