   always begin
      #100;
      clk = ~clk;
   end

   task tick;
      @(posedge clk);
      #1;
   endtask // tick

   task tock;
      @(negedge clk);
      #1;
   endtask // tock
