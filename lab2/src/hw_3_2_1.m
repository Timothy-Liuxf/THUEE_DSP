clear all; close all; clc;

path = "./resource/1/";
wavs = [ ...
    "data1081.wav"; ...
    "data1107.wav"; ...
    "data1140.wav"; ...
    "data1219.wav"; ...
    "data1234.wav"; ...
    "data1489.wav"; ...
    "data1507.wav"; ...
    "data1611.wav"; ...
    "data1942.wav"; ...
    "data1944.wav"; ...
    ];

[row_freqs, col_freqs] = get_key_freq();

files = path + wavs;

figure(1);
figure(2);
for i = 1 : 1 : length(files)
   [y, Fs] = audioread(files(i));
   len = length(y);
   half_len = floor(len / 2);
   time_in_sec = len / Fs;
   Y = abs(fft(y));
   figure(1);
   subplot(2, 5, i);
   plot((0 : 1 : len - 1) / time_in_sec, Y);
   title(char("wav: " + wavs(i)));
   xlabel('{\itf}/Hz');
   ylabel('|{\itY}(e^{j{\it\omega}})|');
   
   row_amp = zeros(size(row_freqs));
   for j = 1 : 1 : length(row_freqs)
      row_amp(j) = max(Y(round((row_freqs(j) - 10) * time_in_sec) : 1 : round((row_freqs(j) + 10) * time_in_sec)));
   end
   col_amp = zeros(size(col_freqs));
   for j = 1 : 1 : length(col_freqs)
      col_amp(j) = max(Y(round((col_freqs(j) - 10) * time_in_sec) : 1 : round((col_freqs(j) + 10) * time_in_sec)));
   end
   [row_val, idx_row] = max(row_amp);
   [col_val, idx_col] = max(col_amp);
   row_freq = row_freqs(idx_row);
   col_freq = col_freqs(idx_col);
   disp("The key of file: " + wavs(i) + " is: " + string(get_key(row_freq, col_freq)));
   figure(2);
   subplot(2, 5, i);
   plot((0 : 1 : half_len - 1) / time_in_sec, Y(1 : half_len));
   title(char("wav: " + wavs(i)));
   xlabel('{\itf}/Hz');
   ylabel('|{\itY}(e^{j{\it\omega}})|');
   hold on;
   plot(row_freq, row_val, 'o');
   plot(col_freq, col_val, 'o');
end
