close all

[son, Fs] = audioread("fichier_son.wav");
Ts = 1/Fs;
son = son(200:end);

son_filtre_stationnaire = kalmanStationnaire(son, 10, 1000, 20);
son_filtre_non_stationnaire = kalmanNonStationnaire(son, 10, 1000, 20);

erreur_stationnaire = sum(abs(son_filtre_stationnaire-son(1:length(son_filtre_stationnaire))))

erreur_non_stationnaire = sum(abs(son_filtre_non_stationnaire.'-son(1:length(son_filtre_non_stationnaire))))

function x_filtre = kalmanStationnaire(x, n, L, R)
    B = [zeros(n-1,1); 1];
    C = B';
    D = 0;
    Q = eye(n);
    S = zeros(n,1);
    E = eye(n);
    x_filtre = zeros(L, 1);
    for k=1:length(x)/L-1
        segment = x(k*L+1:(k+1)*L);
        AR = aryule(segment, n);
        theta =  -rot90(AR(2:n+1));
        A = [zeros(n-1,1) eye(n-1); theta'];
        [P, LL, G, RR] = dare(A', B, Q, R, S, E);
        K = P*C'/(C*P*C'+R);
        [num, den] = ss2tf(A-K*C*A, K, C, D);
        segment_filtre = filter(num, den, segment);
        x_filtre = [x_filtre;segment_filtre];
    end
end

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