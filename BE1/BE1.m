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

Ryx = xcorr(chants, rieurs,'biased');

figure(2)
plot(lags, Ryx)
title("intercorrélation avant filtrage")

rieurs_filtre = filtrageWiener(rieurs, chants, 15);

[Ryx_filtre,lags]=xcorr(chants,rieurs_filtre,'biased');

figure(3)
plot(lags, Ryx_filtre)
title("intercorrélation après filtrage")

%sound(chants-rieurs_filtre)

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