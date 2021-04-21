
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
  
  //add transactions to queue and set epxected
  function add( Transaction t );
    driver_mbx.put(t);
  endfunction
 function generate_random();
     int i;
     for(i=0;i<2;i++)begin
        p11=$urandom%500; p12=$urandom%500; p13=$urandom%500; p14=$urandom%500; p21=$urandom%500; p22=$urandom%500; p23=$urandom%500; p24=$urandom%500;
	c1=command[$urandom%4]; c2=command[$urandom%4]; c3=command[$urandom%4]; c4 =command[$urandom%4];
        t = new();
        t.add_c1(p11,p12,p13,p14,p21,p22,p23,p24,c1,c2,c3,c4);
        t.add_c2(p11,p12,p13,p14,p21,p22,p23,p24,c1,c2,c3,c4);
        t.add_c3(p11,p12,p13,p14,p21,p22,p23,p24,c1,c2,c3,c4);
        t.add_c4(p11,p12,p13,p14,p21,p22,p23,p24,c1,c2,c3,c4);
        add(t);
     end
	p11=$urandom%500; p12=$urandom%500; p13=$urandom%500; p14=$urandom%500; p21=$urandom%500; p22=$urandom%500; p23=$urandom%500; p24=$urandom%500;
        c1=4'h5; c2=command[$urandom%4]; c3=command[$urandom%4]; c4 =command[$urandom%4];
        t = new();
        t.add_c1(p11,p12,p13,p14,p21,p22,p23,p24,c1,c2,c3,c4);
        t.add_c2(p11,p12,p13,p14,p21,p22,p23,p24,c1,c2,c3,c4);
        t.add_c3(p11,p12,p13,p14,p21,p22,p23,p24,c1,c2,c3,c4);
        t.add_c4(p11,p12,p13,p14,p21,p22,p23,p24,c1,c2,c3,c4);
        add(t);
     endfunction;

  function total();
        total = t_amount;
  endfunction;

endclass
