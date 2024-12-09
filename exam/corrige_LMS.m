clear all
close all
clc
% Paramètres du signal et du canal
N = 1000; % Nombre d'échantillons
x = randi([0 1], 1, N); % Signal binaire aléatoire (0 ou 1)
x = 2*x - 1; % BPSK (-1 ou 1)
% Réponse impulsionnelle du canal
h = [0.5, 1, 0.5]; % Canal linéaire
y = conv(x, h, 'same'); % Signal transmis à travers le canal
% Ajouter du bruit au signal reçu
sigma_bruit = 0.2; % Écart-type du bruit
noise = sigma_bruit * randn(1, length(y));
y_noisy = y + noise; % Signal reçu bruité
% Paramètres de l'égaliseur LMS
M = 5; % Longueur de l'égaliseur (FIR)
mu = 0.01; % Pas d'apprentissage
w = zeros(M, 1); % Initialisation des coefficients du filtre
x_hat = zeros(1, N); % Signal estimé
e = zeros(1, N); % Erreur
% Égalisation adaptative (algorithme LMS)
for n = M:N
    % Fenêtre de signal reçu
    y_seg = y_noisy(n:-1:n-M+1)'; % Signal reçu dans la fenêtre
    % Sortie de l'égaliseur
    x_hat(n) = w' * y_seg;
    % Calcul de l'erreur
    e(n) = x(n) - x_hat(n);
    % Mise à jour des coefficients (LMS)
    w = w +
    Mat_w(:,n)=w;
end
plot(Mat_w(1,:))