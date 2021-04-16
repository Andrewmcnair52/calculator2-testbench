

class Agent;

  Generator gen;
  Driver driver;
  Checker check;

  function new(Generator g, Driver d, Checker c);
    this.gen = g;
    this.driver = d;
    this.check = c;
  endfunction
  
  task run_single(); //run transaction queue
  
    Transaction t;
  
    foreach(gen.trans_queue[i]) begin
      t = driver.run_single(gen.trans_queue[i]);
      ckeck.add(t);
    end
  endtask

endclass;
