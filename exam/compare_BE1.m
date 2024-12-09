close all
[chants,Fs] = audioread("Chants.wav");
rieurs = audioread("Rieurs.wav");
N=length(rieurs);
n = 15;
tic
rieurs_filtre = gradientDeterministe(rieurs, chants, 15, 10, 100);
toc
% gradient stochastique
tic
phi = [zeros(14,1); rieurs];


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
toc

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

