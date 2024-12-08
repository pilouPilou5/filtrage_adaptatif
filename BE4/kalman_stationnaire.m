close all

[son, Fs] = audioread("fichier_son.wav");
Ts = 1/Fs;
figure(1)
son = son(200:end);
t = 0:Ts:(length(son)-1)*Ts;
plot(t, son)

n = 10;
L = 1000;

segment = son(1:L);
B = [zeros(n-1,1); 1];
C = B';
D = 0;
R = 20;
Q = eye(n);
S = zeros(n,1);
E = eye(n);
son_filtre = zeros(L, 1);
for k=1:length(son)/L-1
    segment = son(k*L+1:(k+1)*L);
    AR = aryule(segment, n);
    theta =  -rot90(AR(2:n+1));
    A = [zeros(n-1,1) eye(n-1); theta'];
    [P, LL, G, RR] = dare(A', B, Q, R, S, E);
    K = P*C'/(C*P*C'+R);
    [num, den] = ss2tf(A-K*C*A, K, C, D);
    segment_filtre = filter(num, den, segment);
    son_filtre = [son_filtre;segment_filtre];
end

figure(2)
plot(t(1:length(son_filtre)), son_filtre);

sound(son)
pause(3)
sound(son_filtre)