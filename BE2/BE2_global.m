close all

load sig_electro.mat
Fs=1/Ts;
N = length(electro);
electro = electro';
electro_mere = electro_mere(1:N)';
t=0:Ts:N*Ts-Ts;

figure(1)
subplot(211)
plot(t,electro)
title("electro")
subplot(212)
plot(t,electro_mere)
title("electro\_mere")

[Ryx,lags]=xcorr(electro,electro_mere,'biased');
figure(2)
plot(lags, Ryx)
title("intercorrélation avant filtrage");

electro_mere_filtre = filtrageWiener(electro_mere, electro, 30);

[Ryx_filtre,lags]=xcorr(electro,electro_mere_filtre,'biased');

figure(3)
plot(lags, Ryx_filtre)
title("intercorrélation après filtrage");

figure(4)
plot(t, electro)
hold on
plot(t, electro-electro_mere_filtre)

[Rf, f] = freqz(theta, 1, 1024, Fs);
figure(5)
plot(f, abs(Rf))
title("réponse fréquentielle filtre")

Ha = tf(theta', 1, Ts, 'variable', 'z^-1');
figure(6)
impulse(Ha)
title("réponse impulsionnelle filtre")

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