module screen(clk, conf_pulse, conf_stat, clock_time, conf_time, screen_time);
input clk, conf_pulse;
input [1:0] conf_stat;
input [23:0] clock_time, conf_time;
output reg [23:0] screen_time;

// user interface
// display hour-minute-second, refresh together with incoming clk
// use conf_time if configure time/alarm
always @(posedge clk)
begin
    if (!conf_stat)
    begin
        /**
        h = clock_time[23:16];
        min = clock_time[15:8];
        sec = clock_time[7:0];
        */
        screen_time = clock_time;
    end
end

always @(conf_pulse)
begin
    if (conf_stat)
    begin
        /**
        h = conf_time[23:16];
        min = conf_time[15:8];
        sec = conf_time[7:0];
        */
        screen_time = conf_time;
    end
end
endmodule
