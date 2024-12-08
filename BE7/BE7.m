close all

M=4;
SNR = 6;

msg = randi([0, M-1], 1000, 1);
msg_m = qammod(msg, M);

scatterplot(msg_m)

num = 1 %[1 0.9 0.81 0.1];
den = 1;

msg_canal = filter(num, den, msg_m);
msg_bruit = awgn(msg_canal, SNR, 'measured');
scatterplot(msg_bruit)

msg_d = qamdemod(msg_bruit, M);

figure(3)
stairs(msg)
hold on
stairs(msg_d)

[~, BER] = biterr(msg, msg_d)
[~, SER] = symerr(msg, msg_d)