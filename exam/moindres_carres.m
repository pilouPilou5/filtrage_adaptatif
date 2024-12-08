close all

M = 16;
N = 1000;
% génération de données aléatoires
x = randi([0 M-1], [N, 1]);

%modulation QAM 16
x_mod = pammod(x, 16);

%simulation d'un canal de transmission
x_canal = filter(1, [1 -0.8], x_mod);

x_bruit = awgn(x_canal, 1000, 'measured');

N = length(x_bruit);
n = 50;
phi = [zeros(n,1); x];
K=N;

x_filtre = zeros(size(x));
theta = zeros([n 1]);
Pt = 10000*eye(n);
lambda = 0.9;
for i=1:K-2
    x_filtre(i) = phi(i+n-1:-1:i).'*theta;
    Kt = Pt*phi(i+n-1:-1:i)/(phi(i+n-1:-1:i).'*Pt*phi(i+n-1:-1:i)+lambda);
    Pt = (1/lambda)*(Pt-Kt*phi(i+n-1:-1:i).'*Pt);
    theta = theta+Kt*(x(i+1)-x_filtre(i)).';
end

scatterplot(x_mod)
scatterplot(x_bruit)
scatterplot(x_filtre)