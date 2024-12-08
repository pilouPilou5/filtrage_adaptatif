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
title("electro_mere")

[Ryx,lags]=xcorr(electro,electro_mere,'biased');
figure(2)
plot(lags, Ryx)

n = 30;

Rxx = xcorr(electro_mere, 'biased');
Rxx = Rxx(N:N+n);
Rxx = toeplitz(Rxx);

Ryx = Ryx(N:N+n);

theta = Rxx\Ryx;

electro_mere_filtre = filter(theta, 1, electro_mere);

[Ryx_filtre,lags]=xcorr(electro,electro_mere_filtre,'biased');

figure(3)
plot(lags, Ryx_filtre)

figure(4)
plot(t, electro)
hold on
plot(t, electro-electro_mere_filtre)

[Rf, f] = freqz(theta, 1, 1024, Fs);
figure(5)
plot(f, abs(Rf))

Ha = tf(theta', 1, Ts, 'variable', 'z^-1');
figure(6)
impulse(Ha)