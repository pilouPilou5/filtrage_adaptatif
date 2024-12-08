close all

load("data_BE5.mat")

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
    z_filtre(i,1) = phi(i+n-1:-1:i,1)'*theta(:,1);
    z_filtre(i,2) = phi(i+n:-1:i+1,2)'*theta(:,2);
    Kt = Pt*phi(i+n-1:-1:i,:)/(phi(i+n-1:-1:i,:)'*Pt*phi(i+n-1:-1:i,:)+lambda*eye(2));
    Pt = (1/lambda)*(Pt-Kt*phi(i+n-1:-1:i,:)'*Pt);
    theta = theta+Kt*(z(i+1,:)-z_filtre(i,:))';
    
end

figure(2)
plot(z(:,1))
hold on
plot(z_filtre(:,1))

figure(3)
plot(z(:,2))
hold on
plot(z_filtre(:,2))

figure(4)
plot(z(:,1), z(:,2))
hold on
plot(z_filtre(:,1), z_filtre(:,2))