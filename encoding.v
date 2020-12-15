module encoding(clk, conf_pulse, binary_num, hex_encoding);
input clk, conf_pulse;
input [3:0] binary_num;
output reg [6:0] hex_encoding;
parameter NUM0 = 7'h3f;
parameter NUM1 = 7'h06;
parameter NUM2 = 7'h5b;
parameter NUM3 = 7'h4f;
parameter NUM4 = 7'h66;          
parameter NUM5 = 7'h6d;
parameter NUM6 = 7'h7d;
parameter NUM7 = 7'h07;
parameter NUM8 = 7'h7f;
parameter NUM9 = 7'h6f;

always @(posedge clk, conf_pulse)
begin
    case(binary_num)
    4'b0000 : hex_encoding = NUM0;
    4'b0001 : hex_encoding = NUM1;
    4'b0010 : hex_encoding = NUM2;
    4'b0011 : hex_encoding = NUM3;
    4'b0100 : hex_encoding = NUM4;          
    4'b0101 : hex_encoding = NUM5;
    4'b0110 : hex_encoding = NUM6;
    4'b0111 : hex_encoding = NUM7;
    4'b1000 : hex_encoding = NUM8;
    4'b1001 : hex_encoding = NUM9;
    endcase
end
endmodule