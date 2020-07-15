% Variar a Eb/No de 0 a 14 dB e calcular a variância do ruído, considerando modulação BPSK e 16-QAM;

clear all; clc; close all
% Parâmetros
n_bits = 1000;                % Número de bits
T = 500;                      % Tempo de símbolo OFDM
Ts = 2;                       % Tempo de símbolo em portadora única
K = T/Ts;                     % Número de subportadoras independentes
N = 2*K;                      % DFT de N pontos
EbN0dB = 0:1:14;              % Vetor de EbN0  (energy per bit to noise power spectral density ratio) is a normalized signal-to-noise ratio (SNR) measure
Eb = 1;                       % Energia de bit para o BPSK
N0 = Eb * 10.^(-EbN0dB/10);   % Potência de ruído (Proakis)
variance = 0;

% Gerar bits aleatórios para 16-QAM
dataIn=rand(1,n_bits);   % Sequência de números entre 0 e 1 uniformemente distribuídos
dataIn=sign(dataIn-.5);  % Sequência de -1 e 1
% Conversor serial paralelo
dataInMatrix = reshape(dataIn,n_bits/4,4); % Conversão serial para paralelo

% % Gerar bits aleatórios para BPSK
% dataIn_bpsk=rand(1,n_bits);   % Sequência de números entre 0 e 1 uniformemente distribuídos
% dataIn_bpsk=sign(dataIn-.5);  % Sequência de -1 e 1
% % Conversor serial paralelo
% dataInMatrix_bpsk = reshape(dataIn,n_bits/4,4); % Conversão serial para paralelo

% Gerar constelaçao 16-QAM
seq16qam = 2*dataInMatrix(:,1)+dataInMatrix(:,2)+1i*(2*dataInMatrix(:,3)+dataInMatrix(:,4)); 
seq16=seq16qam';
% Garantir propriedadade da simetria
X = [seq16 conj(seq16(end:-1:1))]; % Concatenação da seq16 com seu conjugado na ordem inversa

% Construindo xn
xn = zeros(1,N);
for n=0:N-1
    for k=0:N-1
        xn(n+1) = xn(n+1) + 1/sqrt(N)*X(k+1)*exp(1i*2*pi*n*k/N); % Versão amostrada de xt
    end
end
%  Fim da geracao de bits aleatorios

% Loop de variâncias
for ik = 1:length(EbN0dB)
    % Adição de ruído
    noise = sqrt(N0(ik))*randn(1,N)+1i*sqrt(N0(ik))*randn(1,N); % Influência no eixo imaginário e real, isto é, influencia na amplitude e na fase do sinal
%     noise_bpsk = sqrt(N0(ik))*randn(1,N)+1i*sqrt(N0)*randn(1,N); % Influência no eixo imaginário e real, isto é, influencia na amplitude e na fase do sinal
    %
    rn = xn + noise; % sinal recebido amostrado 
    % Fim da geracao do ruído AWGN complexo
    
    % DFT de rn
    Y = zeros(1,K);
    for k=0:K-1
        for n=0:N-1
            Y(1,k+1) = Y(1,k+1) + 1/sqrt(N)*rn(n+1)*exp(-1i*2*pi*k*n/N); % Discrete Fourier transform de rn
        end
    end
    
    % Plots
    scatterplot(Y) % Círculos azuis, é a constelação de Yk
    hold on
    scatter(real(seq16),imag(seq16), 'r', '+') % Cruzes vermelhas, é a constelação 16-QAM 
    hold off
    title(['Sinal com Eb/N0 de ', num2str(EbN0dB(ik)), 'dB']);
    
    % Demodulação, isolando a parte real e imaginário de Y e comparando com os valores das regiões da constelação do 16-QAM
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
    
    % Cálculo de variância
    %O cálculo da variância populacional é obtido através da soma dos quadrados da diferença entre cada
    %valor e a média aritmética, dividida pela quantidade de elementos observados.
    % AWGN tem média zero, então a variância é igual a soma dos quadrados de cada valor, dividida pela quantidade de elementos observados.
    variance = sum(find(Z(1,2:K)-X(1,2:K)))/n_bits;
    
    % Contagem de erro
    % find(X) returns a vector containing the linear indices of each nonzero element in array X.
    error = length(find(Z(1,2:K)-X(1,2:K)));
    disp(['Para EbN0 de ', num2str(EbN0dB(ik)),'dB, a variância é ', num2str(variance)]);
    %disp(['Para Eb/no de 'num2str(EbN0dB), ' temos a variância de ', num2str(variance), ' houve ', num2str(error), ' símbolos errados.']);
end