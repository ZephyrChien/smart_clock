module clock(clk, rst_n, pause_n, set_time_n, set_alarm_n, up_time, h_min_sec, on_the_hour, on_alarm);
input clk, rst_n, pause_n, set_time_n, set_alarm_n;
input [23:0] up_time; // upstream time
output reg on_the_hour, on_alarm;
output reg [23:0] h_min_sec; // [23:16]h, [15:8]min, [7:0]sec
reg [3:0]ctx; // ctx[0,1,2]=[ctx_sec, ctx_min, ctx_h], ctx[3] triggers time modification
reg [23:0] alarm_time;
// handle clk and set flags
always @(posedge clk, negedge rst_n, negedge set_time_n, negedge set_alarm_n)
begin
    // clear flags
    on_the_hour = 0;
    on_alarm = 0;
    // handle other signals
    if(~rst_n)
        ctx[0] = 0;
        ctx[1] = 0;
        ctx[2] = 0;
        h_min_sec = 0;
    if(~set_time_n)
        ctx[0] = 0;
        ctx[1] = 0;
        ctx[2] = 0;
        h_min_sec = up_time;
    if(~set_alarm_n)
        alarm_time = up_time;
    if(h_min_sec + 1 == alarm_time)
        on_alarm = 1;
    // set h-min-sec flags
    if(~ctx[0] && h_min_sec[7:0] == 8'b01011001)
        ctx[0] = 1;
    if(~ctx[1] && h_min_sec[15:8] == 8'b01011001)
        ctx[1] = 1;
    if(~ctx[2] && h_min_sec[23:16] == 8'b00100011)
        ctx[2] = 1;
    // avoid race, sacrifice signal quality
    if (~pause_n)
        ctx[3] = ~ctx[3];
end

// modify time
always @(ctx[3])
begin
    case(ctx)
        3'b001:
            begin
                ctx[0] = 0;
                h_min_sec[7:0] = 0;
                h_min_sec[15:8] = self_increase(h_min_sec[15:8]);
            end
        3'b011:
            begin
                ctx[0] = 0;
                ctx[1] = 0;
                h_min_sec[7:0] = 0;
                h_min_sec[15:8] = 0;
                h_min_sec[23:16] = self_increase(h_min_sec[23:16]);
                on_the_hour = 1;
            end
        3'b111:
            begin
                ctx[0] = 0;
                ctx[1] = 0;
                ctx[2] = 0;
                h_min_sec[7:0] = 0;
                h_min_sec[15:8] = 0;
                h_min_sec[23:16] = 0;
                on_the_hour = 1;
            end
        default: h_min_sec[7:0] = self_increase(h_min_sec[7:0]);
    endcase
end

function [7:0] self_increase;
input [7:0] self;
begin
    if(self[3:0] == 9)
    begin
        self_increase[3:0] = 0;
        self_increase[7:4] = self[7:4] + 1;
    end
    else
    begin
        self_increase[3:0] = self[3:0] + 1;
        self_increase[7:4] = self[7:4];
    end
end
endfunction
endmodule