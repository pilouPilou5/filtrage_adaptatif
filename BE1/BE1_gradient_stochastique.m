close all

[chants,Fs] = audioread("Chants.wav");
rieurs = audioread("Rieurs.wav");

N=length(rieurs);

n = 15;

u_max = 2/((n+1)*std(rieurs)^2);

phi = [zeros(14,1); rieurs];


K=length(rieurs);
figure(1)
for j=1:10
    theta = wgn(n+1, 1, 1);
    u = 1;
    thetas = zeros([n+1 K-n]);
    for i=1:K-n
        theta = theta+u.*phi(i+n:-1:i)*(chants(i)-phi(i+n:-1:i)'*theta);
        thetas(:,i) = theta;
        u = 0.9999*u;
    end
    plot(thetas(1,:))
    hold on
end
hold off

rieurs_filtre = zeros([N 1]);

u = 1;
thetas = zeros([n+1 K-n]);
theta = zeros([n+1 1]);
for i=1:K-n
    theta = theta+u.*phi(i+n:-1:i)*(chants(i)-phi(i+n:-1:i)'*theta);
    thetas(:,i) = theta;
    u = 0.9999*u;
    rieurs_filtre(i) = theta'*phi(i+n:-1:i);
end

sound(chants-rieurs_filtre)