classdef WalfishIkegamiModel
    properties
        f, h_bs, h_ms, w, b
    end
    methods
        function obj = WalfishIkegamiModel(f, h_bs, h_ms, w, b)
            obj.f = f;
            obj.h_bs = h_bs;
            obj.h_ms = h_ms;
            obj.w = w;
            obj.b = b;
        end
        function L = calculate_los_losses(obj, d)
            L = 42.6 + 20 * log10(obj.f) + 26 * log10(d);
        end
        function L = calculate_non_los_losses(obj, d)
            L0 = 32.44 + 20 * log10(obj.f) + 20 * log10(d);
            [L1, L2] = obj.calculate_non_los_L1_L2(d);
            L = L0 + L1 + L2;
        end
        function [L1, L2] = calculate_non_los_L1_L2(obj, d)
            delta_h = obj.h_bs - obj.h_ms;
            phi = 30;
            L11 = -18 * log10(1 + obj.h_bs - delta_h);
            ka = obj.calculate_ka(delta_h);
            kd = obj.calculate_kd(delta_h);
            kf = -4 + 0.7 * (obj.f / 925 - 1);
            L1 = L11 + ka + kd * log10(d) + kf * log10(obj.f) - 9 * log10(obj.b);
            L2 = obj.calculate_L2(phi, delta_h);
        end
        function ka = calculate_ka(obj, delta_h)
            ka = 54 - 0.8 * (obj.h_bs - delta_h);
        end
        function kd = calculate_kd(obj, delta_h)
            kd = 18 - 15 * (obj.h_bs - delta_h) / delta_h;
        end
        function L2 = calculate_L2(obj, phi, delta_h)
            if phi < 35
                L2 = -16.9 - 10 * log10(obj.w) + 10 * log10(obj.f) + 20 * log10(delta_h);
            elseif phi >= 35 && phi < 55
                L2 = -16.9 - 10 * log10(obj.w) + 10 * log10(obj.f) + 20 * log10(delta_h) - 10 + 0.354 * phi;
            else
                L2 = -16.9 - 10 * log10(obj.w) + 10 * log10(obj.f) + 20 * log10(delta_h) + 4.0 - 0.114 * phi;
            end
        end
        function L = calculate_losses(obj, d)
            if d <= 0.5
                L = obj.calculate_los_losses(d);
            else
                L = obj.calculate_non_los_losses(d);
            end
        end
    end
end