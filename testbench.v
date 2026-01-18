
module scp_tb();
    reg clk,reset;
    Single_Cycle_Top dut(.clk(clk),.rst(reset));
    always #5 clk = ~clk;
    
 initial begin
        // Initialize
        clk = 0;
        reset = 1;
        // Run for some cycles
        #200;
        $stop;
    end

endmodule
