
class Generator;  //class to generate transactions

  transaction trans_queue[$]; //transaction list
  
  //how we give generator tests? declare in constructor?
  //or maybe make it parse a huge list?
  //have a function here called from calc2_tb and create transactions here?
  
  function new(); //generator constructor
    //a temporary test transaction
    transaction t;
    t = new( .p11(32'h10), .p21(32'h11), .c1(4'h1), .t1(2'h2) );  //add 16+17 with tag=2
    t.setExpected();
    trans_queue.push_back(t);
  endfunction

endclass
