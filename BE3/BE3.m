close all

[son, Fs] = audioread("fichier_son.wav");
Ts = 1/Fs;
t = 0:Ts:(length(son)-1)*Ts;
figure(1)
son = son(200:end);
plot(son)

n = 10;

N = 1000;
bruit = son(1:N);
[Rvv, lags] = xcorr(bruit, 'biased');
Rvv = Rvv(N:N+n);
Rvv_mat = toeplitz(Rvv);

son_filtre = zeros([N,1]);
for i=1:length(son)/N-1
    voix = son(i*N+1:(i+1)*N);
    
    [Rxx, lags] = xcorr(voix, 'biased');
    Rxx = Rxx(N:N+n);
    
    Ryx = Rxx-Rvv;
    Rxx = toeplitz(Rxx);
    
    theta = Rxx\Ryx;
    
    son_filtre = [son_filtre; filter(theta, 1, voix)];
end
figure(2)
plot(t(1:length(son_filtre)), son_filtre)
% sound(son)
% pause(3)
sound(son_filtre)

%% 3
Pb = mean(son(end-5000:end).^2);
Ps = mean(son.^2);
Pb_filtre = mean(son_filtre(end-5000:end).^2);
Ps_filtre = mean(son_filtre.^2);
SNR = 10*log10(Ps/Pb)
SNR_filtre = 10*log10(Ps_filtre/Pb_filtre)