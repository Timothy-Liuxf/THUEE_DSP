clear all; close all; clc;

time_in_second = 0.5;
Fs = 8000;

while true
    x = input('x = ', 's');
    if x == 'q' || x == 'Q'
        break;
    end
    [y f1 f2] = get_key_sound(x, Fs, time_in_second);
    % sound(y);
    figure;
    plot(linspace(0, time_in_second, length(y)), y);
    title(char("key: " + string(x) + "; freq: \{ " + string(f1) + ", " + string(f2) + " \} Hz"));
    xlabel('{\itt}/s');
    ylabel('{\itA}');
end
