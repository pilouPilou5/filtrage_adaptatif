



%% impossible sujet incompréhensible



close all

load("data_BE5.mat")

T0 = 100;
f0 = 1/T0;

t = 0:1:length(absc)-1;

A1 = 70;
phi1 = -pi/2;
B1 = 0;

A2 = 70;
phi2 = 0;
B2 = 0;

figure(1)
plot(absc, ordo)

z = [absc ordo];

N = length(absc);
n = 20;
phi = [zeros(n,2); z];
K=N;

z_filtre = zeros(size(z));
theta = zeros([n 2]);
Pt = 100000*eye(n);
lambda = 0.99;
for i=1:K-2
    r = [sin(2*pi*f0*t(i)); cos(2*pi*f0*t(i)); 1];
    H = [A1*cos(r(1)) -A1*sin(r(1)) B1; A2*cos(r(2)) -A2*sin(r(2)) B2]
    %z_filtre(i,1) = phi(i+n-1:-1:i,1)'*theta(:,1);
    %z_filtre(i,2) = phi(i+n:-1:i+1,2)'*theta(:,2);
    z_filtre(i,:) = r'*H;
    
end

figure(2)
plot(t, z(:,1))
hold on
plot(t, z_filtre(:,1))
plot(t, A1*cos(2*pi*f0*t+phi1))

figure(3)
plot(t, z(:,2))
hold on
plot(t, z_filtre(:,2))
plot(t, A2*cos(2*pi*f0*t+phi2))

figure(4)
plot(z(:,1), z(:,2))
hold on
plot(z_filtre(:,1), z_filtre(:,2))