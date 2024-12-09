close all

[son, Fs] = audioread("fichier_son.wav");
Ts = 1/Fs;
figure(1)
son = son(200:end);
t = 0:Ts:(length(son)-1)*Ts;
subplot(311)
plot(t, son)
title("signal avant filtrage")

n=10;

L = length(son);
nbr_L = floor(length(son)/L);
lg_ini = 1;
xx = son;
Xl = zeros(n, 1);


for k=1:nbr_L
xx_u=xx(lg_ini+(k-1)*L+1:lg_ini+k*L);
% calcul des paramètres du modèle
theta=aryule(xx_u,n);
theta=-rot90(theta(2:n+1));

%construction du modèle
A=[zeros(n-1,1) eye(n-1);theta'];
B=[zeros(n-1,1);1];
C=B';
D=0;


R=10;
Q=eye(n);

% solution stationnaire
Au=A';
Bu=C';
S=zeros(n,1);
E=eye(n);
[P,LL,G,RR] = dare(Au,Bu,Q,R,S,E);
K=P*C'*(inv(C*P*C'+R));
Kmat(:,k)=K;

[num,den]=ss2tf(A-K*C*A,K,C,0);

xx_n_u=filter(num,den,xx_u);

xx_ns(lg_ini+(k-1)*L+1-1:lg_ini+k*L-1)=xx_n_u;

% solution non stationnaire
Pp=0.001*eye(n);
xx_n_u=zeros(L,1);
for kk=1:L
Xp=A*Xl;
err=xx_u(kk)-C*A*Xl;
K=Pp*C'*inv(C*Pp*C'+R);
Pp=A*Pp*A'-A*K*C*Pp*A'+Q*eye(n);
Xl=Xp+K*err;
xx_n_u(kk)=C*Xl;
end
Kmatns(:,k)=K;
xx_nns(lg_ini+(k-1)*L+1:lg_ini+k*L)=xx_n_u;
end

subplot(312)
plot(t, Kmat)

subplot(313)
plot(t, Kmatns)