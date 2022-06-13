clear all; close all; clc;

keys = [ ...
    '1', '2', '3', 'A'; ...
    '4', '5', '6', 'B'; ...
    '7', '8', '9', 'C'; ...
    '*', '0', '#', 'D'];

time_in_second = 0.5;
Fs = 8000;

figure(1);
for i = 1 : 1 : 4
    for j = 1 : 1 : 4
        % x = input('input x: ', 's');
        x = keys(i, j);
        [y f1 f2] = get_key_sound(x, Fs, time_in_second);
        % sound(y);
        subplot(4, 4, (i - 1) * 4 + j);
        plot(linspace(0, time_in_second, length(y)), y);
        title(char("key: " + string(x) + "; freq: \{ " + string(f1) + ", " + string(f2) + " \} Hz"));
        xlabel('{\itt}/s');
        ylabel('{\itA}');
    end
end
