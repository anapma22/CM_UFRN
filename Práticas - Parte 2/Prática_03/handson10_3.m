clear all; clc; close all
% Parâmetros
n_bits = 1000;                % Número de bits
T = 500;                      % Tempo de símbolo OFDM
Ts = 2;                       % Tempo de símbolo em portadora única
K = T/Ts;                     % Número de subportadoras independentes
N = 2*K;                      % DFT de N pontos
sigmas=[0 0.1 1];             % Vetor de variâncias do ruído
%
% Gerar bits aleatórios da mesma forma que foi feito na prática 2
dataIn=rand(1,n_bits);   % Sequência de números entre 0 e 1 uniformemente distribuídos
dataIn=sign(dataIn-.5);  % Sequência de -1 e 1
% Conversor serial paralelo
dataInMatrix = reshape(dataIn,n_bits/4,4);
%
% Gerar constelaçao 16-QAM
seq16qam = 2*dataInMatrix(:,1)+dataInMatrix(:,2)+1i*(2*dataInMatrix(:,3)+dataInMatrix(:,4)); 
seq16=seq16qam';
% Garantir propriedadade da simetria
X = [seq16 conj(seq16(end:-1:1))]; 
%
% Construindo xn
xn = zeros(1,N);
for n=0:N-1
    for k=0:N-1
        xn(n+1) = xn(n+1) + 1/sqrt(N)*X(k+1)*exp(1i*2*pi*n*k/N);
    end
end
%  Fim da geracao de bits aleatorios

% Loop de variâncias
for ik = 1:length(sigmas)
    %
    % Adição de ruído
    variance = sigmas(ik);
    noise = sqrt(variance)*randn(1,N)+1i*sqrt(variance)*randn(1,N);
    %
    % sinal recebido = xn + ruído 
    rn = xn+noise;
    % Fim da geracao do ruído AWGN complexo
    
    % DFT de rn
    Y = zeros(1,K);
    for k=0:K-1
        for n=0:N-1
            Y(1,k+1) = Y(1,k+1) + 1/sqrt(N)*rn(n+1)*exp(-1i*2*pi*k*n/N);
        end
    end
    % Fim da DFT
    
    % Plots
    scatterplot(Y) % Círculos azuis
    hold on
    scatter(real(seq16),imag(seq16), 'r', '+') % Cruzes vermelhas 
    hold off
    title(['Sinal com ruído de variância ', num2str(variance)]);
    
    % Demodulação  
    for k= 1:length(Y) % Para percorrer todo o vetor Yk 
        if real(Y(1,k)) > 0 % Para parte real de Yk positiva
            if real(Y(1,k)) > 2
                Z(1,k) = 3;
            else
                Z(1,k) = 1;
            end
        else % Para parte real de Yk negativa ou igual a zero
            if real(Y(1,k)) < -2
                 Z(1,k) = -3;
            else
                 Z(1,k) = -1;
            end
        end

        if imag(Y(1,k)) > 0 % Para parte imaginaria de Yk positiva
            if imag(Y(1,k)) > 2
                Z(1,k) = Z(1,k) + 1i*3;
            else
                Z(1,k) = Z(1,k) + 1i;
            end
        else % Para parte imaginaria de Yk negativa ou igual a zero
            if imag(Y(1,k)) < -2
                 Z(1,k) = Z(1,k) - 1i*3;
            else
                 Z(1,k) = Z(1,k) - 1i;
            end
        end
    end 
    
    % Contagem de erro
    error = length(find(Z(1,2:K)-X(1,2:K)));
    disp(['Para variância de ', num2str(variance), ' houve ', num2str(error), ' símbolos errados.']);
end