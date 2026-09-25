`timescale 1ns/1ps

module tb_mmss_counter;
reg clk_50mhz=0,rst_p=1;
wire[3:0]mt,mo,st,so;
reg[3:0]digit;
wire[7:0]segments;
integer checks=0;

always #10 clk_50mhz=~clk_50mhz;
mmss_counter #(.CLK_HZ(2)) dut(.clk(clk_50mhz),.rst_p(rst_p),.minute_tens(mt),.minute_ones(mo),.second_tens(st),.second_ones(so));
sevenseg_decode dec(.digit(digit),.segments(segments));

task advance(input integer s);
begin
    repeat(s*2)@(posedge clk_50mhz);
    #1;
end
endtask task check(input integer a,b,c,d);
begin
    if(mt!==a||mo!==b||st!==c||so!==d)$fatal(1);
    checks=checks+1;
end
endtask initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb_mmss_counter);
    digit=0;
    #1;
    if(segments!==8'b1111_1100)$fatal(1);
    checks=checks+1;
    digit=9;
    #1;
    if(segments!==8'b1111_0110)$fatal(1);
    checks=checks+1;
    repeat(2)@(posedge clk_50mhz);
    rst_p=0;
    check(0,0,0,0);
    advance(10);
    check(0,0,1,0);
    advance(50);
    check(0,1,0,0);
    advance(3539);
    check(5,9,5,9);
    advance(1);
    check(0,0,0,0);
    $display("LAB3_MMSS_PASS checks=%0d",checks);
    $finish;
end

initial begin
    #200000;
    $fatal(1,"timeout");
end

endmodule