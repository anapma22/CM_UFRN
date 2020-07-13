clc;clear all;close all;
% Passo 1: Gera��o de fases aleat�rias
phi_k = 2*pi*rand;
phi_j = 2*pi*rand; 
%
% Passo 2: Gera��o de sinais amostrados 
M = 50;
m = 0:M-1;
x_k = sin(4*pi*m/5+phi_k);
n = 1;
x_j_1 = sin(4*pi*m/5+2*pi*m*n/M+phi_j);
n = 2;
x_j_2 = sin(4*pi*m/5+2*pi*m*n/M+phi_j);
n = 3;
x_j_3 = sin(4*pi*m/5+2*pi*m*n/M+phi_j);
%
% Passo 3: Verifica��o de ortogonalidade  
Sum1 = sum(x_k.*x_j_1);
disp(['O resultado para n=1 �: ' , num2str(Sum1)])
Sum2 = sum(x_k.*x_j_2);
disp(['O resultado para n=2 �: ' , num2str(Sum2)])
Sum3 = sum(x_k.*x_j_3);
disp(['O resultado para n=3 �: ' , num2str(Sum3)])

% Esses valores s�o praticamente zero, de modo que dessa forma comprovamos a
% ortogonalidade entre as subportadoras .