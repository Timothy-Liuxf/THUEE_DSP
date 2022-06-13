clear all; close all; clc;

[x, Fs] = audioread('./resource/2/data.wav');

[row_freqs, col_freqs] = get_key_freq();
len = length(x);
time_in_sec = len / Fs;
n_piece_point = round(Fs * 0.1);
step = n_piece_point / 2;
n_piece = floor((len - n_piece_point) / step);
act_time_in_sec = time_in_sec * (n_piece_point + (n_piece - 1) * step) / len;
one_piece_time = n_piece_point / len * time_in_sec;

amp = zeros([n_piece_point, n_piece]);
for i = 1 : 1 : n_piece
    amp(1 : end, i) = abs(fft(x(1 + step * i : n_piece_point + step * i)));
end

[t, freq] = meshgrid(linspace(0, act_time_in_sec, n_piece), ...
                     linspace(0, len / time_in_sec, n_piece_point));
figure(1);
mesh(t, freq, amp);
title('STFT');
xlabel('{\itt}/s');
ylabel('{\it\omega}/Hz');
zlabel('|{\itH}(e^{j{\it\omega}})|');

key_vals = zeros([1, n_piece]);
for i = 1 : 1 : n_piece
   row_amp = zeros(size(row_freqs));
   for j = 1 : 1 : length(row_freqs)
      row_amp(j) = max(amp(round((row_freqs(j) - 20) * one_piece_time) : 1 : round((row_freqs(j) + 20) * one_piece_time), i));
   end
   col_amp = zeros(size(col_freqs));
   for j = 1 : 1 : length(col_freqs)
      col_amp(j) = max(amp(round((col_freqs(j) - 20) * one_piece_time) : 1 : round((col_freqs(j) + 20) * one_piece_time), i));
   end
   [row_val, idx_row] = max(row_amp);
   [col_val, idx_col] = max(col_amp);
   row_min_val = min(row_amp);
   col_min_val = min(col_amp);
   row_freq = row_freqs(idx_row);
   col_freq = col_freqs(idx_col);
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
   %{
   disp(string(row_freq) + " : " + string(row_val) + ...
       " | " + string(col_freq) + " : " + string(col_val) + ...
       " | " + string(key));
   %}
   key_vals(i) = key_val;
end

figure(2);
plot(linspace(0, act_time_in_sec, n_piece), key_vals, '-*');
xlabel('{\itt}/s');
ylabel('key');
yticks([0 : 1 : 16]);
ytick_strs = num2cell(['0' : '9', 'A' : 'D', '*', '#']);
yticklabels({ytick_strs{1 : end}, 'null'});
