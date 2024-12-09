clear all
close all
clc
% Filtre de Kalman
% Paramètres du signal
fs = 100;
t = 0:1/fs:5;
f = 1;
s = sin(2*pi*f*t);
sigma_n = 0.5;
n = sigma_n * randn(size(t));
y = s + n;
figure;
subplot(311)
plot(t, y, 'r', t, s, 'k');
legend('Mesures bruitées', 'Signal vrai');
title('Signal vrai et mesures bruitées');
xlabel('Temps (s)');
ylabel('Amplitude');
% Paramètres du modèle Kalman
Q = 1e-3;
R = sigma_n^2;
x_kalman = zeros(size(t));
P = 1;
x_k_prev = 0;
for k = 1:length(t)
x_pred = x_k_prev;
P_pred = P + Q;
K = P_pred / (P_pred + R);
x_kalman(k) = x_pred + K * (y(k) - x_pred);
P = (1 - K) * P_pred;
x_k_prev = x_kalman(k);
end


subplot(312)
plot(t, s, 'b', t, x_kalman, 'k');
legend('Signal vrai', 'Estimation du filtre de Kalman');
title('Filtre de Kalman');
xlabel('Temps (s)');
ylabel('Amplitude');


x = wgn(length(y), 1, 0);
x_wiener = filtrageWiener(x, y.', n);

subplot(312)
plot(t, s, 'b', t, x_wiener, 'k');
legend('Signal vrai', 'Estimation du filtre de wiener');
title('Filtre de Wiener');
xlabel('Temps (s)');
ylabel('Amplitude');

function x_filtre = filtrageWiener(x, y, n)
    N = length(x);

    [Rxx, ~] = xcorr(x, 'biased');
    Rxx = Rxx(N:N+n);
    Rxx = toeplitz(Rxx);

    Ryx = xcorr(y, x,'biased');
    Ryx = Ryx(N:N+n);

    theta = Rxx\Ryx;

    x_filtre = filter(theta, 1, x);
end