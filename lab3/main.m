
f1 = 1;
f2 = 5;
f3 = 9;

t = 0:0.01:1;

s1t = cos(2*pi*f1 * t);
s2t = cos(2*pi*f2 * t);
s3t = cos(2*pi*f3 * t);


at = 2 * s1t + 4 * s2t + s3t;
bt = s1t + s2t;

a = [0.3 0.2 -0.1 4.2 -2 1.5 0];
b = [0.3 4 -2.2 1.6 0.1 0.1 0.2];

corr = sum(at.*bt);
norm_corr = sum(at .* bt) / (sqrt(sum(at.^2)) * sqrt(sum(bt.^2)));

disp('Корреляция между сигналами a и b:');
disp(corr);
disp('Нормализованная корреляция между сигналами a и b:');
disp(norm_corr);


N = length(a);
max_corr = -Inf;
optimal_shift = 0;
correlation_values = zeros(1, N);
for shift = 0:N - 1
    b_shifted = circshift(b, shift);
    correlation_values(shift + 1) = sum(a .* b_shifted);

    if correlation_values(shift + 1) > max_corr
        max_corr = correlation_values(shift + 1);
        optimal_shift = shift;
    end

end
disp(['Оптимальный сдвиг: ', num2str(optimal_shift)]);

%%%%%%%%%%%%%%
figure(1);
subplot(2, 1, 1);
plot(a);
title('Сигнал a');
xlabel('Номер отсчета');
ylabel('Значение');

subplot(2, 1, 2);
plot(b);
title('Сигнал b');
xlabel('Номер отсчета');
ylabel('Значение');

figure(2);
plot(correlation_values);
title('Зависимость корреляции от сдвига');
xlabel('Сдвиг');
ylabel('Значение корреляции');

figure(3);
subplot(2, 1, 1);
plot(a);
title('Сигнал a');
xlabel('Номер отсчета');
ylabel('Значение');

subplot(2, 1, 2);
b_shifted_optimal = circshift(b, optimal_shift);
plot(b_shifted_optimal);
title(['Сигнал b, сдвинутый на ', num2str(optimal_shift), ' шагов']);
xlabel('Номер отсчета');
ylabel('Значение');