

class Generator;  //class to generate transactions

  Transaction t;
  Transaction trans_queue[$]; //transaction list
  
  function new(); //generator constructor
    //a temporary test transaction
    t = new( .p11(32'h10), .p21(32'h11), .c1(4'h1), .t1(2'h2) );  //add 16+17 with tag=2
    t.setExpected();
    trans_queue.push_back(t);
  endfunction
  
  function run(); //run transaction queue
    foreach(trans_queue[i]) begin
    
    end
  endfunction



endclass
