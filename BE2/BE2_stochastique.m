close all

load sig_electro.mat

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

n = 14;

u_max = 2/((n+1)*std(electro_mere)^2);

phi = [zeros(n-1,1); electro_mere];


K=length(electro_mere);
figure(3)
for j=1:10
    theta = wgn(n+1, 1, 1);
    u = 0.1;
    thetas = zeros([n+1 K-n]);
    for i=1:K-n
        theta = theta+u.*phi(i+n:-1:i)*(electro(i)-phi(i+n:-1:i)'*theta);
        thetas(:,i) = theta;
        %u = 0.99*u;
    end
    plot(thetas(1,:))
    hold on
end
hold off

electro_mere_filtre = zeros([N 1]);

u = 1;
thetas = zeros([n+1 K-n]);
theta = zeros([n+1 1]);
for i=1:K-n
    theta = theta+u.*phi(i+n:-1:i)*(electro(i)-phi(i+n:-1:i)'*theta);
    thetas(:,i) = theta;
    u = 0.9999*u;
    electro_mere_filtre(i) = theta'*phi(i+n:-1:i);
end
figure(4)
plot(t, electro-electro_mere_filtre)