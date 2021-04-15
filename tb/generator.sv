`include "tb/driver.sv"

class Generator;  //class to generate transactions

  Transaction t;
  Transaction trans_queue[$]; //transaction list
  
  function new(); //generator constructor
  
  endfunction
  
  function run(Driver d); //run transaction queue
    foreach(trans_queue[i]) begin
      d.run_single(trans_queue[i]);
    end
  endfunction
  
  //add transactions to queue and set epxected
  function add( input bit[31:0] p11=32'h0, p12=32'h0, p13=32'h0, p14=32'h0, p21=32'h0, p22=32'h0, p23=32'h0, p24=32'h0, input bit[3:0] c1=4'h0, c2=4'h0, c3=4'h0, c4=4'h0, input bit[1:0] t1=2'h0, t2=2'h0, t3=2'h0, t4=2'h0, input int cc=10 );
    t = new(p11,p12,p13,p14,p21,p22,p23,p24,c1,c2,c3,c4,t1,t2,t3,t4,cc);
    t.setExpected();
    trans_queue.push_back(t);
  endfunction

endclass
