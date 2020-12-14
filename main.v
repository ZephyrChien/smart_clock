module main(clk, rst_n, pause_n, set_time_n, set_alarm_n, h, min, sec, audio);
input clk, rst_n, pause_n, set_time_n, set_alarm_n, mod_time_n;
output [7:0] h, min, sec;
output audio;
wire on_the_hour, on_alarm, conf_pulse, set_time_or_alarm;
wire [1:0] conf_stat;
wire [23:0] clock_time, conf_time, conf_time_tracker;

assign set_stat = ~(set_time_n & set_alarm_n);

conf c(set_stat, ~mod_time_n, conf_pulse, conf_stat, conf_time, conf_time_tracker);
clock t(clk, rst_n, pause_n, set_time_n, set_alarm_n, conf_time ,clock_time, on_the_hour, on_alarm);
screen x(clk, conf_pulse, conf_stat, clock_time, conf_time_tracker, h, min, sec);
media v(clk, on_the_hour, on_alarm, clock_time, audio);
endmodule