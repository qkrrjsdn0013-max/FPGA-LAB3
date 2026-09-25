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
localparam integer COUNT_WIDTH=(STABLE_CYCLES<2)?1:$clog2(STABLE_CYCLES);
reg [COUNT_WIDTH-1:0] stable_count;
reg accepted;

always @(posedge clk or posedge rst_p) begin
    if(rst_p) begin
        button_meta<=0;
        button_sync<=0;
    end
    else begin
        button_meta<=button;
        button_sync<=button_meta;
    end
end

always @(posedge clk or posedge rst_p) begin
    if(rst_p) begin
        stable_count<=0;
        accepted<=0;
        pulse<=0;
    end
    else begin
        pulse<=0;
        if(button_sync==accepted) stable_count<=0;
        else if(stable_count==STABLE_CYCLES-1) begin
            stable_count<=0;
            accepted<=button_sync;
            pulse<=button_sync;
        end
        else stable_count<=stable_count+1'b1;
    end
end

endmodule
