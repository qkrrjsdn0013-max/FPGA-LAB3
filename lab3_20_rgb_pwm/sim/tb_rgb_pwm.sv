`timescale 1ns/1ps

module tb_rgb_pwm;
reg clk_50mhz=0,rst_p=1,button_r=0,button_g=0,button_b=0;
wire[3:0]led_r,led_g,led_b;
integer checks=0,i,hr,hg,hb;

always #10 clk_50mhz=~clk_50mhz;
lab3_rgb_pwm #(.CLK_HZ(1000),.PWM_HZ(100),.LEVELS(10),.DEBOUNCE_CYCLES(2))dut(.clk_50mhz(clk_50mhz),.rst_p(rst_p),.button_r(button_r),.button_g(button_g),.button_b(button_b),.led_r(led_r),.led_g(led_g),.led_b(led_b));

task pr;
begin
    button_r=1;
    repeat(6)@(posedge clk_50mhz);
    button_r=0;
    repeat(6)@(posedge clk_50mhz);
end
endtask task pg;
begin
    button_g=1;
    repeat(6)@(posedge clk_50mhz);
    button_g=0;
    repeat(6)@(posedge clk_50mhz);
end
endtask task pb;
begin
    button_b=1;
    repeat(6)@(posedge clk_50mhz);
    button_b=0;
    repeat(6)@(posedge clk_50mhz);
end
endtask task measure(input integer a,b,c);
begin
    wait(dut.r.count==0);
    hr=0;
    hg=0;
    hb=0;
    for(i=0;i<10;i=i+1)begin
        @(posedge clk_50mhz);
        #1;
        hr=hr+led_r[0];
        hg=hg+led_g[0];
        hb=hb+led_b[0];
    end
    if(hr!==a||hg!==b||hb!==c)$fatal(1);
    checks=checks+1;
end
endtask initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb_rgb_pwm);
    repeat(3)@(posedge clk_50mhz);
    rst_p=0;
    repeat(2)pr;
    repeat(5)pg;
    repeat(8)pb;
    measure(2,5,8);
    pr;
    measure(3,5,8);
    $display("LAB3_RGB_PWM_PASS checks=%0d",checks);
    $finish;
end

initial begin
    #30000;
    $fatal(1,"timeout");
end

endmodule
