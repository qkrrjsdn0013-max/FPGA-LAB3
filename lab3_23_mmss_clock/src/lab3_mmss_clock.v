`timescale 1ns/1ps

module lab3_mmss_clock #(
parameter integer CLK_HZ=50_000_000,
SCAN_HZ=4_000
) (
input wire clk_50mhz,
rst_p,
output reg [7:0] seg_data,
seg_com
);
wire [3:0] mt,mo,st,so;
wire [7:0] a,b,c,d;
localparam integer N=CLK_HZ/SCAN_HZ,W=(N<2)?1:$clog2(N);
reg [W-1:0] count;
reg [1:0] sel;
mmss_counter #(.CLK_HZ(CLK_HZ)) u_counter(.clk(clk_50mhz),.rst_p(rst_p),.minute_tens(mt),.minute_ones(mo),.second_tens(st),.second_ones(so));
sevenseg_decode x(.digit(mt),.segments(a));
sevenseg_decode y(.digit(mo),.segments(b));
sevenseg_decode z(.digit(st),.segments(c));
sevenseg_decode q(.digit(so),.segments(d));

always @(posedge clk_50mhz or posedge rst_p) if(rst_p)begin
    count<=0;
    sel<=0;
end
else if(count==N-1)begin
    count<=0;
    sel<=sel+1'b1;
end
else count<=count+1'b1;

always @* begin
    seg_com=8'hff;
    seg_data=0;
    case(sel)0:begin
        seg_com=8'b1111_0111;
        seg_data=a;
    end
    1:begin
        seg_com=8'b1111_1011;
        seg_data=b|1;
    end
    2:begin
        seg_com=8'b1111_1101;
        seg_data=c;
    end
    default:begin
        seg_com=8'b1111_1110;
        seg_data=d;
    end
endcase
end

endmodule