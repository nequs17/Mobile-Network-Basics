clear;

c = 3e8;
f_MHz = 1800;
f_GHz = f_MHz / 1000;
wavelength = c / (f_MHz * 1e6);
h_BS = 50; 
h_MS = 3;  
w = 20;  
b = 30;  
distance_km = linspace(0.01, 20, 1000);
distance_m = distance_km * 1000;

PL_fspm = @(distance_m, f_MHz) 20 * log10((4 * pi * distance_m * f_MHz * 1e6) / c);

PL_umi_nlos = @(distance_m, f_GHz) 26 * log10(f_GHz) + 22.7 + 36.7 * log10(distance_m);

% PL_okumura_hata = @(distance_km, f_MHz, h_BS, h_MS) ...
%     46.3 + 33.9 * log10(f_MHz) - 13.82 * log10(h_BS) - ...
%     (3.2 * (log10(11.75 * h_MS))^2 - 4.97) + ...
%     (distance_km < 1) .* ((47.88 + 13.9 * log10(f_MHz) - 13.9 * log10(h_BS)) .* (1 / log10(50))) + ...
%     (distance_km >= 1) .* (44.9 - 6.55 * log10(f_MHz)) .* log10(distance_km);
    

% PL_cost231_hata_dense_urban = @(distance_km, f_MHz, h_BS, h_MS) ...
%     46.3 + 33.9 .* log10(f_MHz) - 13.82 .* log10(h_BS) - ...
%     (3.2 .* (log10(11.75 .* h_MS)).^2 - 4.97) + ...
%     ((distance_km < 1) .* ((47.88 + 13.9 .* log10(f_MHz) - 13.9 .* log10(h_BS)) .* (1 ./ log10(50)))) + ...
%     ((distance_km >= 1) .* ((44.9 - 6.55 .* log10(f_MHz)) .* log10(distance_km))) + 3;


COST231_Hata = zeros(size(distance_m));
for i = 1:length(distance_m)
    distance_km_temp = distance_m(i) * 10^-3;
    a_hms = 3.2 * (log10(11.75 * h_MS))^2 - 4.97;
    
    if distance_km_temp >= 1
        s = 44.9 - 6.55 * log10(f_GHz * 10^3);
    else
        s = (47.88 + 13.9 * log10(f_GHz * 10^3) - 13.9 * log10(h_BS)) * (1 / log10(50));
    end
    COST231_Hata(i) = 46.3 + 33.9 * log10(f_GHz * 10^3) - 13.82 * log10(h_BS) - a_hms + s * log10(distance_km_temp);
end

COST231_Hata_U = zeros(size(distance_m));
for i = 1:length(distance_m)
    distance_km_temp = distance_m(i) * 10^-3;
    a_hms = 3.2 * (log10(11.75 * h_MS))^2 - 4.97;
    
    if distance_km_temp >= 1
        s = 44.9 - 6.55 * log10(f_GHz * 10^3);
    else
        s = (47.88 + 13.9 * log10(f_GHz * 10^3) - 13.9 * log10(h_BS)) * (1 / log10(50));
    end
    COST231_Hata_U(i) = 46.3 + 33.9 * log10(f_GHz * 10^3) - 13.82 * log10(h_BS) - a_hms + s * log10(distance_km_temp) + 3;
end

FSPM = PL_fspm(distance_m, f_MHz);
UMILOS = PL_umi_nlos(distance_m, f_GHz);

walfish_ikegami_model = WalfishIkegamiModel(f_MHz, h_BS, h_MS, w, b);
WALFISH = arrayfun(@(d) walfish_ikegami_model.calculate_losses(d), distance_km);

% Построение графиков
figure;
plot(distance_km, COST231_Hata, 'DisplayName', 'COST231-Hata (Города)');
hold on;
plot(distance_km, COST231_Hata_U, 'DisplayName', 'COST231-Hata (Плотная застройка)');
hold on;
plot(distance_km, FSPM, 'DisplayName', 'FSPM (Свободное пространство)');
hold on;
plot(distance_km, UMILOS, 'DisplayName', 'UMiNLOS (Городская застройка)');
hold on;
plot(distance_km, WALFISH,'DisplayName', 'Walfish-Ikegami');

title('Зависимость величины потерь радиосигнала от расстояния');
xlabel('Расстояние между приемником и передатчиком (км)');
ylabel('Потери сигнала (дБ)');
grid on;
legend;