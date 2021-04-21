
class Generator;  //class to generate transactions

  Transaction t;                        //temporary transaction
  mailbox #(Transaction) driver_mbx;
  int command[4]='{1,2,5,6};
  bit [31:0] p11, p12, p13, p14, p21, p22, p23, p24;
  bit [3:0] c1, c2, c3, c4;
  int t_amount=2;  

  function new(mailbox #(Transaction) driver_mbx); //generator constructor
    this.driver_mbx = driver_mbx;
  endfunction
  
  //maual add transactions to queue for debugging
  function add( Transaction t );
    driver_mbx.put(t);
  endfunction
  
  //random transaction generation
  function generate_random(int num_tests);
     for(i=0; i<num_tests; i++) begin
        t = new();
        if( !t.randomize() ) begin
          $display("could not randomize");
          $finish;
        end else begin
          gen.add(t);
		      cg_inst.sample();
		    end
     end
  endfunction;

  function total();
        total = t_amount;
  endfunction;

endclass
