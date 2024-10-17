function quantization_test(y)
    fs = 1000;
    t = 0:1/fs:1; 

    original_signal = y(t); 

    bit_depths = [3, 4, 5, 6];

    for bits = bit_depths
        quantized_signal = quantize(original_signal, bits);
        
        Y = fft(original_signal);
        Y_quantized = fft(quantized_signal);
        
        amplitude_spectrum = abs(Y);
        amplitude_spectrum_quantized = abs(Y_quantized);
        
        quantization_error = original_signal - quantized_signal;
        mean_quantization_error = mean(abs(quantization_error));
        
        f = (0:length(original_signal)-1) * (fs / length(original_signal));
        
        figure;
        plot(f, amplitude_spectrum, 'b', 'DisplayName', 'Оригинальный сигнал');
        hold on;
        plot(f, amplitude_spectrum_quantized, 'r', 'DisplayName', sprintf('Квантованный сигнал (биты = %d)', bits));
        hold off;
        title(sprintf('Сравнение амплитудных спектров для %d бит', bits));
        xlabel('Частота (Гц)');
        ylabel('Амплитуда');
        xlim([0 fs/2]);
        legend show;
        grid on;
        
        fprintf('Средняя ошибка квантования для %d бит: %.4f\n', bits, mean_quantization_error);
    end
end

function quantized_signal = quantize(signal, bits)
    max_value = 1; % Максимальная амплитуда синусоиды
    min_value = -1; % Минимальная амплитуда синусоиды

    % Определите количество уровней квантования
    levels = 2^bits;

    % Масштабируйте сигнал для диапазона уровней
    scaled_signal = (signal - min_value) / (max_value - min_value) * (levels - 1);

    % Квантование сигналов
    quantized_scaled_signal = round(scaled_signal); % Округление до ближайшего уровня
    quantized_scaled_signal(quantized_scaled_signal >= levels) = levels - 1; % Ограничьте уровень
    quantized_signal = quantized_scaled_signal / (levels - 1) * (max_value - min_value) + min_value; % Обратное масштабирование
end
