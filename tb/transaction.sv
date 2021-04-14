
class transaction;

  bit[31:0] param1[4], param2[4], data_out[4], data_expected[4];
  bit[3:0] cmd_in[4], resp_out[4];
  bit[1:0] tag[4];
  int clock_cycles;
  
  function new( input bit[31:0] p11=32'h0, p12=32'h0, p13=32'h0, p14=32'h0, input bit[31:0] p21=32'h0, p22=32'h0, p23=32'h0, p24=32'h0, input bit[3:0] c1=4'h0, c2=4'h0, c3=4'h0, c4=4'h0, input bit[1:0] t1=2'h0, t2=2'h0, t3=2'h0, t4=2'h0, input int cc=10 );
      param1 = '{p11,p12,p13,p14};
      param2 = '{p21,p22,p23,p24};
      cmd_in = '{c1,c2,c3,c4};
      tag = '{t1,t2,t3,t4};
      clock_cycles = cc;
  endfunction
  
  function print();
    $display("param1: %h, %h, %h, %h", param1[0],param1[1],param1[2],param1[3]);
    $display("param2: %h, %h, %h, %h", param2[0],param2[1],param2[2],param2[3]);
    $display("cmd: %h, %h, %h, %h", cmd_in[0],cmd_in[1],cmd_in[2],cmd_in[3]);
    $display("tag: %h, %h, %h, %h", tag[0],tag[1],tag[2],tag[3]);
    $display("clock cycles: %0d", clock_cycles);
    $display();
  endfunction

endclass
