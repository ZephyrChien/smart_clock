module conf(set_stat, mod_time, conf_pulse, conf_stat, h_min_sec_once, h_min_sec_tracker);
input set_stat, mod_time;
output reg conf_pulse;
output reg [1:0] conf_stat;
output reg [23:0] h_min_sec_once;  //connect to inner clock
output reg [23:0] h_min_sec_tracker;  //connect to screen
reg [23:0] buffer;

// config time or alarm, depends on outside flags
// set_stat values:
// ->0 ->1 ->2 ->3
// ->done ->sec ->min ->h
always @(set_stat)
begin
    if(conf_stat == 3)
    // commit to clock
    begin
        conf_stat = 0; //could be omitted
        h_min_sec_once = buffer;
    end
    else
        conf_stat = conf_stat + 1;
end

always @(mod_time)
begin
    case(set_stat)
        //2'b00:
            // nothing to do
        2'b01:
            buffer[7:0] = self_increase(buffer[7:0]);
        2'b10:
            buffer[15:8] = self_increase(buffer[15:8]);
        2'b11:
            buffer[23:16] = self_increase(buffer[23:16]);
    endcase
    // send to screen
    h_min_sec_tracker = buffer;
    // trigger screen
    conf_pulse = ~conf_pulse;
end

// common func, import from clock.v
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