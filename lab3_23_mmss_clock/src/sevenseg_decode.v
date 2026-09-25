`timescale 1ns/1ps

module sevenseg_decode(input wire [3:0] digit,output reg [7:0] segments);

always @*
begin
    case(digit) 0:segments=8'b1111_1100;
    1:segments=8'b0110_0000;
    2:segments=8'b1101_1010;
    3:segments=8'b1111_0010;
    4:segments=8'b0110_0110;
    5:segments=8'b1011_0110;
    6:segments=8'b1011_1110;
    7:segments=8'b1110_0000;
    8:segments=8'b1111_1110;
    9:segments=8'b1111_0110;
    default:segments=0;
endcase

end

endmodule