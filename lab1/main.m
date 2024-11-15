% задание 1

f = 5;
phi = pi / 6;
A = 2;
t = 0:0.001:1;

y = A * cos(2 * pi * f * t + phi);

figure;
plot(t,y);
xlabel("Time (s)");
ylabel("Amplitude");
grid on;
title('1 exercise');

%2 задание: 5 гц ( по условию )

ytwo_fft = fft(y);
ntwo = length(ytwo_fft);
f_axistwo = (0:ntwo-1) * (f / ntwo); 

figure;
plot(f_axistwo, abs(ytwo_fft));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Exercise 2');

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

fs = 10;
ts = 0:1/fs:1;

y_samples = A * cos(2 * pi * f * ts + phi);

figure;
plot(ts,y_samples);
xlabel("Time (s)");
ylabel("Amplitude");
title('4 exercise');

%5 задание

y_fft = fft(y_samples);
n = length(y_fft);
f_axis = (0:n-1)*(f/n); 
figure;
plot(f_axis, abs(y_fft));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('5 exercise');

fprintf("Ширина спектра: %.2f\n", max(y_fft(:)));
fprintf('Занято памяти (Кб): %.2f\n', whos("y_fft").bytes / 1024);


%6 задание
figure;
plot(ts, y_samples, 'o-', 'DisplayName', 'Оцифрованный сигнал');

hold on;
plot(t, y, '--', 'DisplayName', 'Оригинальный сигнал');
xlabel("Time (s)");
ylabel("Amplitude");
title('6 exercise');

%7 задание
fs_new = 4 * fs;
t_new = 0:1/fs_new:1;

y_samples_new = A * sin(2 * pi * f * t_new + phi);

y_fft_new = fft(y_samples_new);
n_new = length(y_samples_new);
f_axis_new = (0:n_new-1)*(fs_new/n_new);

figure;
plot(f_axis_new, abs(y_fft_new));
title('7 exercise');

%8 Audacity
% 14642 гц
% 29284 гц
%
%
%
%
%
%
%
%

%9 задание

F_Audacity = 14642;

[y, Fs] = audioread('somesound.mp3');

figure;

plot(y);
xlabel("Time (s)");
ylabel("Amplitude");
title('8 exercise');

%10 задание

fprintf('%.2f\n',length(y) / 13)
fprintf('%.2f\n',Fs)

%11 задание
figure;
y1=downsample(y, 10);
zvuk = audioplayer(y1,Fs/10); 
%play(zvuk);
plot(y1); 
title('11 exercise');

%12 задание
Y_original = fft(y);
Y_downsampled = fft(y1);

figure;
subplot(2,1,1);
plot(abs(Y_original));
title('Амплитудный спектр оригинального сигнала');

subplot(2,1,2);
plot(abs(Y_downsampled));
title('Амплитудный спектр прореженного сигнала');

%13 задание 

y = A * cos(2 * pi * f * t + phi);

function y_quantized = quantize_signal(y, bits)
    levels = 2^bits - 1; 
    y_min = min(y);
    y_max = max(y);
    y_norm = (y - y_min) / (y_max - y_min); 
    y_quantized = round(y_norm * levels); 
    y_quantized = y_quantized / levels;
    y_quantized = y_quantized * (y_max - y_min) + y_min;
end

bit_depths = [3, 4, 5, 6];

for bits = bit_depths
    quantized_signal = quantize_signal(y , bits);
            
    Y = fft(y);
    Y_quantized = fft(quantized_signal);
            
    amplitude_spectrum = abs(Y);
    amplitude_spectrum_quantized = abs(Y_quantized);
        
    quantization_error = y - quantized_signal;
    mean_quantization_error = mean(abs(quantization_error));
        
    f = (0:length(y)-1) * (fs / length(y));
        
    figure;
    plot(f, amplitude_spectrum, 'b', 'DisplayName', 'Оригинальный сигнал');
    hold on;
    plot(f, amplitude_spectrum_quantized, 'r', 'DisplayName', 'Квантованный сигнал');
    hold off;
    title(sprintf('Сравнение амплитудных спектров для %d бит', bits));
    xlabel('Частота (Гц)');
    ylabel('Амплитуда');
    xlim([0 fs/2]);
    legend show;
    grid on;
        
    fprintf('Средняя ошибка квантования для %d бит: %.4f\n', bits, mean_quantization_error);
end