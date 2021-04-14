
class Generator;  //class to generate transactions

  transaction trans_queue[$]; //transaction list
  
  function new(); //generator constructor
    transaction t;
    t = new( .p11(32'h10), .p21(32'h11), .c1(4'h1), .t1(2'h2) );
    t.setExpected();
    trans_queue.push_back(t);
  endfunction

endclass
