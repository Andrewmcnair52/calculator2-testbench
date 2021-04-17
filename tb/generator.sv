
class Generator;  //class to generate transactions

  Transaction t;                        //temporary transaction
  Transaction trans_queue[$];           //transaction list
  
  mailbox mbx;  //mailboox for continuous transactions
  
  function new(); //generator constructor
    mbx = new(5);
  endfunction
  
  //add transactions to queue and set epxected
  function add_single( input bit[31:0] p11=32'h0, p12=32'h0, p13=32'h0, p14=32'h0, p21=32'h0, p22=32'h0, p23=32'h0, p24=32'h0, input bit[3:0] c1=4'h0, c2=4'h0, c3=4'h0, c4=4'h0);
    t = new(p11,p12,p13,p14,p21,p22,p23,p24,c1,c2,c3,c4);
    t.setExpected();
    trans_queue.push_back(t);
  endfunction
  
  function add_continuous( input bit[31:0] p11=32'h0, p12=32'h0, p13=32'h0, p14=32'h0, p21=32'h0, p22=32'h0, p23=32'h0, p24=32'h0, input bit[3:0] c1=4'h0, c2=4'h0, c3=4'h0, c4=4'h0);
    t = new(p11,p12,p13,p14,p21,p22,p23,p24,c1,c2,c3,c4);
    t.setExpected();
    mbx.put(t);
  endfunction

endclass
