`timescale 1ns/1ps

module lab3_rgb_pwm #(
parameter integer CLK_HZ=50_000_000,
PWM_HZ=1_000,
LEVELS=10,
DEBOUNCE_CYCLES=1_000_000
) (
input wire clk_50mhz,
rst_p,
button_r,
button_g,
button_b,
output wire [3:0] led_r,
led_g,
led_b
);
wire pr,pg,pb,wr,wg,wb;
reg [3:0] lr,lg,lb;
button_onepulse #(.STABLE_CYCLES(DEBOUNCE_CYCLES)) br(.clk(clk_50mhz),.rst_p(rst_p),.button(button_r),.pulse(pr));
button_onepulse #(.STABLE_CYCLES(DEBOUNCE_CYCLES)) bg(.clk(clk_50mhz),.rst_p(rst_p),.button(button_g),.pulse(pg));
button_onepulse #(.STABLE_CYCLES(DEBOUNCE_CYCLES)) bb(.clk(clk_50mhz),.rst_p(rst_p),.button(button_b),.pulse(pb));

always @(posedge clk_50mhz or posedge rst_p) if(rst_p)begin
    lr<=0;
    lg<=0;
    lb<=0;
end
else begin
    if(pr)lr<=(lr==LEVELS)?0:lr+1'b1;
    if(pg)lg<=(lg==LEVELS)?0:lg+1'b1;
    if(pb)lb<=(lb==LEVELS)?0:lb+1'b1;
end
pwm_channel #(.PERIOD_CYCLES(CLK_HZ/PWM_HZ),.LEVELS(LEVELS)) r(.clk(clk_50mhz),.rst_p(rst_p),.level(lr),.pwm(wr));
pwm_channel #(.PERIOD_CYCLES(CLK_HZ/PWM_HZ),.LEVELS(LEVELS)) g(.clk(clk_50mhz),.rst_p(rst_p),.level(lg),.pwm(wg));
pwm_channel #(.PERIOD_CYCLES(CLK_HZ/PWM_HZ),.LEVELS(LEVELS)) b(.clk(clk_50mhz),.rst_p(rst_p),.level(lb),.pwm(wb));
assign led_r={4{wr}};
assign led_g={4{wg}};
assign led_b={4{wb}};
endmodule