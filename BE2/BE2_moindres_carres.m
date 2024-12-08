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

n = 60;

phi = [zeros(n-1,1); electro_mere];


K=length(electro_mere);
figure(3)
for j=1:10
    theta = wgn(n+1, 1, 1);
    Pt = 10000*eye(n+1);
    lambda = 1;
    thetas = [theta zeros([n+1 K-n-1])];
    for i=1:K-1
        Kt = Pt*phi(i+n:-1:i)/(phi(i+n:-1:i)'*Pt*phi(i+n:-1:i)+lambda);
        Pt = (1/lambda)*(Pt-Kt*phi(i+n:-1:i)'*Pt);
        theta = theta+Kt*(electro_mere(i)-phi(i+n:-1:i)'*theta);
        thetas(:,i) = theta;
    end
    plot(thetas(1,:))
    hold on
end
hold off

electro_mere_filtre = zeros(size(electro_mere));
theta = zeros([n+1 1]);
Pt = 10000*eye(n+1);
for i=1:K-1
    Kt = Pt*phi(i+n:-1:i)/(phi(i+n:-1:i)'*Pt*phi(i+n:-1:i)+lambda);
    Pt = (1/lambda)*(Pt-Kt*phi(i+n:-1:i)'*Pt);
    theta = theta+Kt*(electro_mere(i)-phi(i+n:-1:i)'*theta);
    thetas(:,i) = theta;
    electro_mere_filtre(i) = theta'*phi(i+n:-1:i);
end

figure(4)
plot(electro)
hold on
plot(electro-electro_mere_filtre)
hold off
legend('electro','electro\_filtre')

function x_filtre = filtrageMoindresCarres(x, y, n, P0)
    phi = [zeros(n-1,1); x];

    x_filtre = zeros(size(x));
    theta = zeros([n+1 1]);
    Pt = P0*eye(n+1);
    for i=1:K-1
        Kt = Pt*phi(i+n:-1:i)/(phi(i+n:-1:i)'*Pt*phi(i+n:-1:i)+lambda);
        Pt = (1/lambda)*(Pt-Kt*phi(i+n:-1:i)'*Pt);
        theta = theta+Kt*(x(i)-phi(i+n:-1:i)'*theta);
        x_filtre(i) = theta'*phi(i+n:-1:i);
    end