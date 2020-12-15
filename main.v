module main(clk, rst_n, pause_n, set_time_n, set_alarm_n,
    h_tens, h_onces, min_tens, min_onces, sec_tens, sec_onces, 
    audio);
input clk, rst_n, pause_n, set_time_n, set_alarm_n, mod_time_n;
output [6:0] h_tens, h_onces, min_tens, min_onces, sec_tens, sec_onces;
output audio;

/**
main.v
├── conf.v
├── clock.v
├── media.v
├── screen.v
└── encoding.v
*/
wire on_the_hour, on_alarm, conf_pulse, set_time_or_alarm;
wire [1:0] conf_stat;
wire [23:0] clock_time, conf_time, conf_time_tracker, screen_time;

assign set_stat = ~(set_time_n & set_alarm_n);

conf c(set_stat, ~mod_time_n, conf_pulse, conf_stat, conf_time, conf_time_tracker);
clock t(clk, rst_n, pause_n, set_time_n, set_alarm_n, conf_time ,clock_time, on_the_hour, on_alarm);
media v(clk, on_the_hour, on_alarm, clock_time, audio);
screen x(clk, conf_pulse, conf_stat, clock_time, conf_time_tracker, screen_time);
encoding e5(clk, conf_pulse, screen_time[23:20], h_tens);
encoding e4(clk, conf_pulse, screen_time[19:16], h_onces);
encoding e3(clk, conf_pulse, screen_time[15:12], min_tens);
encoding e2(clk, conf_pulse, screen_time[11:8], min_onces);
encoding e1(clk, conf_pulse, screen_time[7:4], sec_tens);
encoding e0(clk, conf_pulse, screen_time[3:0], sec_onces);
endmodule