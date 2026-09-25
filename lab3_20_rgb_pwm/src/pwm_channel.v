`timescale 1ns/1ps

module pwm_channel #(
parameter integer PERIOD_CYCLES=50_000,
LEVELS=10
) (
input wire clk,
rst_p,
input wire [3:0] level,
output reg pwm
);
localparam integer W=(PERIOD_CYCLES<2)?1:$clog2(PERIOD_CYCLES);
reg [W-1:0] count;
integer threshold;

always @* threshold=(level>=LEVELS)?PERIOD_CYCLES:(PERIOD_CYCLES*level)/LEVELS;

always @(posedge clk or posedge rst_p) if(rst_p) begin
    count<=0;
    pwm<=0;
end
else begin
    pwm<=count<threshold;
    if(count==PERIOD_CYCLES-1)count<=0;
    else count<=count+1'b1;
end

endmodule
