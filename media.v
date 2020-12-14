module media(clk, on_the_hour, on_alarm, clock_time, audio);
input clk, on_the_hour, on_alarm;
input [23:0]clock_time;
output reg audio; //
output reg [5:0] xtime; // ring x times

// TODO: define custom audio output here
always @(clk, posedge on_the_hour, posedge on_alarm)
begin
    // ring x times at x'o clock
    // if audio is ff, directly assign 0 to its flag here
    if (on_the_hour)
    begin
        audio = 1;
        xtime = clock_time[23:20]*10 + clock_time[19:16];
    end
    if (on_alarm)
        audio = 1;
        /**
        TODO: need enhancement
        */
    if (xtime)
    begin
        audio = 1;
        xtime = xtime - 1;
    end 
    else audio = 0;
end
endmodule