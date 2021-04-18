
class Generator;  //class to generate transactions

  Transaction t;                        //temporary transaction
  mailbox #(Transaction) driver_mbx;
  
  function new(mailbox #(Transaction) driver_mbx); //generator constructor
    this.driver_mbx = driver_mbx;
  endfunction
  
  //add transactions to queue and set epxected
  function add( Transaction t );
    driver_mbx.put(t);
  endfunction
endclass
