function [y, f1, f2] = get_key_sound(x, Fs, time_in_second)
[row_freqs, col_freqs] = get_key_freq();

switch x
case { '1', '2', '3' }
    f1 = row_freqs(1);
    f2 = col_freqs(x - '0');
case 'A'
    f1 = row_freqs(1);
    f2 = col_freqs(4);
case { '4', '5', '6' }
    f1 = row_freqs(2);
    f2 = col_freqs(x - 3 - '0');
case 'B'
    f1 = row_freqs(2);
    f2 = col_freqs(4);
case { '7', '8', '9' }
    f1 = row_freqs(3);
    f2 = col_freqs(x - 6 - '0');
case 'C'
    f1 = row_freqs(3);
    f2 = col_freqs(4);
case '*'
    f1 = row_freqs(4);
    f2 = col_freqs(1);
case '0'
    f1 = row_freqs(4);
    f2 = col_freqs(2);
case '#'
    f1 = row_freqs(4);
    f2 = col_freqs(3);
case 'D'
    f1 = row_freqs(4);
    f2 = col_freqs(4);
otherwise
    error('Input illegal!');
end

y = get_sin(f1, Fs, time_in_second) + get_sin(f2, Fs, time_in_second);

end

