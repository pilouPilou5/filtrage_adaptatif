close all

[son, Fs] = audioread("fichier_son.wav");
Ts = 1/Fs;
figure(1)
son = son(200:end);
t = 0:Ts:(length(son)-1)*Ts;
plot(t, son)
title("signal avant filtrage")

son_filtre = kalmanNonStationnaire(son, 10, 1000, 20);

figure(2)
plot(t(1:length(son_filtre)), son_filtre);
title("signal après filtrage")

sound(son)
pause(3)
sound(son_filtre)

function x_filtre = kalmanNonStationnaire(x, n, L, R)
    nbr_L = floor(length(x)/L);
    lg_ini = 0;
    xx = x;
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
    x_filtre = xx_nns;
end