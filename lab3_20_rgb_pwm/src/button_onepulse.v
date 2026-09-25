`timescale 1ns/1ps

module button_onepulse #(
parameter integer STABLE_CYCLES=1_000_000
) (
input wire clk,
rst_p,
button,
output reg pulse
);
(* ASYNC_REG="TRUE" *) reg button_meta,button_sync;
localparam integer W=(STABLE_CYCLES<2)?1:$clog2(STABLE_CYCLES);
reg [W-1:0] c;
reg accepted;

always @(posedge clk or posedge rst_p) if(rst_p) begin
    button_meta<=0;
    button_sync<=0;
end
else begin
    button_meta<=button;
    button_sync<=button_meta;
end

always @(posedge clk or posedge rst_p) if(rst_p) begin
    c<=0;
    accepted<=0;
    pulse<=0;
end
else begin
    pulse<=0;
    if(button_sync==accepted)c<=0;
    else if(c==STABLE_CYCLES-1)begin
        c<=0;
        accepted<=button_sync;
        pulse<=button_sync;
    end
    else c<=c+1'b1;
end

endmodule
