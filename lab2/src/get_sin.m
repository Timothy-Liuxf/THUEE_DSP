function y = get_sin(freq, Fs, time_in_second)
    omega = freq / Fs * 2 * pi;
    n_points = round(Fs * time_in_second);
    yc = zeros([n_points, 1]);
    ys = zeros([n_points, 1]);
    cw = cos(omega);
    sw = sin(omega);
    yc(1) = cw;
    ys(1) = -sw;
    for i = 2 : 1 : n_points
        yc(i) = cw * yc(i - 1) - sw * ys(i - 1);
        ys(i) = sw * yc(i - 1) + cw * ys(i - 1);
    end
    y = yc;
end
