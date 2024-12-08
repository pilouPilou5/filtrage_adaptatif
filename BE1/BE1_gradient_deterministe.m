close all

[chants,Fs] = audioread("Chants.wav");
rieurs = audioread("Rieurs.wav");

N=length(rieurs);

Ts = 1/Fs;
Ta = N*Ts;

n = 15;

[Rxx, lags] = xcorr(rieurs, 'biased');
Rxx = Rxx(N:N+n);
Rxx = toeplitz(Rxx);

Ryx = xcorr(chants, rieurs,'biased');
Ryx = Ryx(N:N+n);

u_max = 2/max(eig(Rxx));

K = 100;
theta = zeros(n+1,1);
thetas = theta;
u = 10;
for i=1:K
    theta = theta+u.*(Ryx-Rxx*theta);
    thetas = [thetas theta];
end

figure(1)
plot(thetas(1,:))

rieurs_filtre = filter(theta, 1, rieurs);

sound(chants-rieurs_filtre)