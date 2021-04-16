
class Checker;

  Transaction trans_queue[$];

  function add(Transaction t);
    trans_queue.push_back(t);
  endfunction
  
  function print();
    foreach(trans_queue[i]) begin
      trans_queue[i].print();
      $display();
    end
  endfunction


endclass



