close all

[son, Fs] = audioread("fichier_son.wav");
Ts = 1/Fs;
figure(1)
son = son(200:end);
t = 0:Ts:(length(son)-1)*Ts;
plot(t, son)
title("signal avant filtrage")

son_filtre = kalmanStationnaire(son, 10, 1000, 20);

figure(2)
plot(t(1:length(son_filtre)), son_filtre);
title("signal après filtrage")

sound(son)
pause(3)
sound(son_filtre)

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