
class Generator;  //class to generate transactions

  Transaction t;                        //temporary transaction
  Transaction trans_queue[$];           //transaction list
  
  function new(); //generator constructor
  
  endfunction
  
  //add transactions to queue and set epxected
  function add( input bit[31:0] p11=32'h0, p12=32'h0, p13=32'h0, p14=32'h0, p21=32'h0, p22=32'h0, p23=32'h0, p24=32'h0, input bit[3:0] c1=4'h0, c2=4'h0, c3=4'h0, c4=4'h0, input int cc=10 );
    t = new(p11,p12,p13,p14,p21,p22,p23,p24,c1,c2,c3,c4,cc);
    t.setExpected();
    trans_queue.push_back(t);
  endfunction

  function generate_random(int amount);
     int i;
     for(i=0;i<amount;i++)begin
	bit[31:0] p11=$urandom%500, p12=$urandom%500, p13=$urandom%500, p14=$urandom%500, p21=$urandom%500, p22=$urandom%500, p23=$urandom%500, p24=$urandom%500;
	bit[3:0] c1=$urandom%16, c2=$urandom%16, c3=$urandom%16, c4=$urandom%16;
	int cc=10;
	t = new(p11,p12,p13,p14,p21,p22,p23,p24,c1,c2,c3,c4,cc);
   	t.setExpected();
    	trans_queue.push_back(t);
	end
  endfunction;
endclass
