close all

[chants,Fs] = audioread("Chants.wav");
rieurs = audioread("Rieurs.wav");

N=length(rieurs);

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
title("visualisation convergence theta")

%rieurs_filtre = gradientDeterministe(rieurs, chants, 15, 10, 100);

rieurs_filtre = gradientDeterministeTempReel(rieurs, chants, 15, 10);

sound(chants-rieurs_filtre)

function x_filtre = gradientDeterministe(x, y, n, u, K)
    N=length(x);

    [Rxx, ~] = xcorr(x, 'biased');
    Rxx = Rxx(N:N+n);
    Rxx = toeplitz(Rxx);

    Ryx = xcorr(y, x,'biased');
    Ryx = Ryx(N:N+n);
    theta = zeros(n+1,1);
    for i=1:K
        theta = theta+u.*(Ryx-Rxx*theta);
    end

    x_filtre = filter(theta, 1, x);
end