% задание 1

f = 5;
phi = pi / 6;
A = 2;
t = 0:0.001:1;

y = A * cos(2 * pi * f * t + phi);

%2 задание: 5 гц ( по условию )

ytwo_fft = fft(y);
ntwo = length(ytwo_fft);
f_axistwo = (0:ntwo-1) * (f / ntwo); 


disp(['max_freq: ', num2str(round(max(f_axistwo))), ' Hz']);

%y_fft = fft(y_samples);
%n = length(y_fft);
%f_axis = (0:n-1)*(fs/n); 
%figure;
%plot(f_axis, abs(y_fft));
%xlabel('Frequency (Hz)');
%ylabel('Amplitude');
%title('5 exercise');

%3 задание: 2 * f = 2 * 5 = 10 гц ( теорема Котельникова )

%4 задание

fs = 40;
ts = 0:1/fs:1;

y_samples = A * cos(2 * pi * f * ts + phi);


%5 задание

y_fft = fft(y_samples);
n = length(y_fft);
f_axis = (0:n-1)*(f/n); 


spectrum_width = max(f_axis) - min(f_axis);
fprintf("Ширина спектра (в 4 раза увеличенная частота дискретизации): %.2f\n", spectrum_width);
fprintf('Занято памяти (Кб): %.2f\n', whos("y_fft").bytes / 1024);


%6 задание
figure;
plot(ts, y_samples, 'o-', 'DisplayName', 'Оцифрованный сигнал');

hold on;
plot(t, y, '--', 'DisplayName', 'Оригинальный сигнал');
xlabel("Time (s)");
ylabel("Amplitude");
title('6 exercise');