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
freqs = [row_freqs; col_freqs];

files = path + wavs;

figure(1);
for i = 1 : 1 : length(files)
   [x, Fs] = audioread(files(i));
   len = length(x);
   time_in_sec = len / Fs;
   amp = zeros(size(freqs));
   for j = 1 : 1 : length(freqs)
       k = round(freqs(j) * len / Fs);
       omega = 2 * pi * k / len;
       b = [1, -2 * cos(omega), 1];
       a = [1];
       v = filter(a, b, [x; 0]);
       amp(j) = abs(v(end) - exp(-j * k * 2 * pi / len) * v(end - 1));
   end
   subplot(2, 5, i);
   stem(amp);
   title(char("wav: " + wavs(i)));
   ylabel('|{\itH}(e^{j{\it\omega}})|');
   [~, row_idx] = max(amp(1 : length(row_freqs)));
   [~, col_idx] = max(amp(length(row_freqs) + 1 : end));
   row_freq = row_freqs(row_idx);
   col_freq = col_freqs(col_idx);
   disp("The key of file: " + wavs(i) + " is: " + string(get_key(row_freq, col_freq)));
end
