`timescale 1ns/1ps

module lab3_led_pwm #(
parameter integer CLK_HZ=50_000_000,
PWM_HZ=1_000,
LEVELS=10,
DEBOUNCE_CYCLES=1_000_000
) (
input wire clk_50mhz,
rst_p,
button,
output wire [7:0] led
);
wire press,pwm;
reg [3:0] level;
button_onepulse #(.STABLE_CYCLES(DEBOUNCE_CYCLES)) u_button(.clk(clk_50mhz),.rst_p(rst_p),.button(button),.pulse(press));

always @(posedge clk_50mhz or posedge rst_p) if(rst_p) level<=0;
else if(press) level<=(level==LEVELS)?0:level+1'b1;
pwm_channel #(.PERIOD_CYCLES(CLK_HZ/PWM_HZ),.LEVELS(LEVELS)) u_pwm(.clk(clk_50mhz),.rst_p(rst_p),.level(level),.pwm(pwm));

assign led={8{pwm}};

endmodule
