clear all; close all; clc;

[x, Fs] = audioread('./resource/2/data.wav');

[row_freqs, col_freqs] = get_key_freq();
freqs = [row_freqs; col_freqs];
len = length(x);
time_in_sec = len / Fs;
n_piece_point = round(Fs * 0.1);
step = n_piece_point / 2;
n_piece = floor((len - n_piece_point) / step);
act_time_in_sec = time_in_sec * (n_piece_point + (n_piece - 1) * step) / len;
one_piece_time = n_piece_point / len * time_in_sec;

amp = zeros([n_piece, length(freqs)]);
for i = 1 : 1 : n_piece
    for j = 1 : 1 : length(freqs)
       k = round(freqs(j) * n_piece_point / Fs);
       omega = 2 * pi * k / n_piece_point;
       b = [1, -2 * cos(omega), 1];
       a = [1];
       v = filter(a, b, [x(1 + step * i : n_piece_point + step * i); 0]);
       amp(i, j) = abs(v(end) - exp(-j * k * 2 * pi / n_piece_point) * v(end - 1));
   end
end

t = linspace(0, act_time_in_sec, n_piece)' + zeros([n_piece, length(freqs)]);
f_grid = [1 : length(freqs)] + zeros([n_piece, length(freqs)]);
 
figure(1);
plot3(t, f_grid, amp, '-o');

title('STFT');
xlabel('{\itt}/s');
zlabel('|{\itH}(e^{j{\it\omega}})|');
ylabel('{\itf}/Hz');
yticks([1 : length(freqs)]);
ytick_strs = num2cell(string(freqs));
yticklabels(ytick_strs);

keys = char(zeros([n_piece, 0]));
key_vals = zeros([n_piece, 0]);
for i = 1 : 1 : n_piece
    [row_val, row_idx] = max(amp(i, 1 : length(row_freqs)));
	[col_val, col_idx] = max(amp(i, length(row_freqs) + 1 : end));
    row_min_val = min(amp(i, 1 : length(row_freqs)));
	col_min_val = min(amp(i, length(row_freqs) + 1 : end));
    row_freq = row_freqs(row_idx);
    col_freq = col_freqs(col_idx);
    rate = 0.8;
    if abs(row_val - row_min_val) < row_val * rate || abs(col_val - col_min_val) < col_val * rate ...
           || row_val < 10 || col_val < 10
        key = 'n';
        key_val = 16;
    else
        key = get_key(row_freq, col_freq);
        if key >= '0' && key <= '9'
            key_val = key - '0';
        elseif key >= 'A' && key <= 'D'
            key_val = key - 'A' + 10;
        elseif key == '*'
            key_val = 14;
        elseif key == '#'
            key_val = 15;
        else
            error('Unknown key');
        end
    end
    keys(i) = key;
    key_vals(i) = key_val;
end

figure(2);
plot(linspace(0, act_time_in_sec, n_piece), key_vals, '-*');
xlabel('{\itt}/s');
ylabel('key');
yticks([0 : 1 : 16]);
ytick_strs = num2cell(['0' : '9', 'A' : 'D', '*', '#']);
yticklabels({ytick_strs{1 : end}, 'null'});

