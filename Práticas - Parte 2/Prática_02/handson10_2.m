clear all; close all;clc;
% Par�metros
n_bits = 100;            % N�mero de bits
T = 50;                  % Tempo de s�mbolo
Ts = 2;                  % Tempo de s�mbolo em portadora �nica
K = T/Ts;                % N�mero de subportadoras independentes
N = 2*K;                 % N pontos da IDFT
%
% Gerar bits aleat�rios
dataIn=rand(1,n_bits);   % Sequ�ncia de n�meros entre 0 e 1 uniformemente distribu�dos
dataIn=sign(dataIn-.5);  % Sequ�ncia de -1 e 1
% Conversor serial paralelo
dataInMatrix = reshape(dataIn,n_bits/4,4);
% Finalizacao de organizacao dos bits

% Gerar constela�ao 16-QAM
seq16qam = 2*dataInMatrix(:,1)+dataInMatrix(:,2)+1i*(2*dataInMatrix(:,3)+dataInMatrix(:,4)); 
seq16=seq16qam';
% Garantir propriedadade da simetria
X = [seq16 conj(seq16(end:-1:1))]; 
% Finalizacao da geracao da constelacao QAM16

% Construindo xn
xn = zeros(1,N);
for n=0:N-1
    for k=0:N-1
        xn(n+1) = xn(n+1) + 1/sqrt(N)*X(k+1)*exp(1i*2*pi*n*k/N);
    end
end
% Finalizacao do sinal discreto xn

% Construindo xt
xt=zeros(1, T+1);
for t=0:T
    for k=0:N-1
        xt(1,t+1)=xt(1,t+1)+1/sqrt(N)*X(k+1)*exp(1i*2*pi*k*t/T); 
    end 
end 
% Finalizacao do sinal discreto xn

% Plots
plot(abs(xt)); % Magnitude (envolt�ria)
hold on
stem(abs(xn), 'r')
hold off
title('Sinais OFDM')
legend('x(t)','x_n')
xlabel('Tempo')