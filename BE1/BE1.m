close all

%% 1.3.1
[chants,Fs] = audioread("Chants.wav");
rieurs = audioread("Rieurs.wav");

N=length(rieurs);

Ts = 1/Fs;
Ta = N*Ts;

f = -Fs/2:1/Ta:Fs/2-1/Ta;

figure(1)
subplot(211)
plot(f, fftshift(abs(fft(chants))))
title("fft chants")

subplot(212)
plot(f, fftshift(abs(fft(rieurs))))
title("fft rieurs")

%% 1.3.2
n = 15;

[Rxx, lags] = xcorr(rieurs, 'biased');
Rxx = Rxx(N:N+n);
Rxx = toeplitz(Rxx);

Ryx = xcorr(chants, rieurs,'biased');

figure(2)
plot(lags, Ryx)

Ryx = Ryx(N:N+n);

theta = Rxx\Ryx;

rieurs_filtre = filter(theta, 1, rieurs);

[Ryx_filtre,lags]=xcorr(chants,rieurs_filtre,'biased');

figure(3)
plot(lags, Ryx_filtre)

sound(chants-rieurs_filtre)

%% 1.3.3