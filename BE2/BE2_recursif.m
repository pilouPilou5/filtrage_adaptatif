close all

load sig_electro.mat

electro = electro';
electro_mere = electro_mere(1:length(electro))';

electro_mere_filtre = gradientDeterministe(electro_mere, electro, 30, 1, 100);

figure(1)
plot(electro)
hold on
plot(electro-electro_mere_filtre);

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