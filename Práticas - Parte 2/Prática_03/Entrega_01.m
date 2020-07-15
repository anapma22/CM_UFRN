% Variar a Eb/No de 0 a 14 dB e calcular a vari�ncia do ru�do, considerando modula��o BPSK e 16-QAM;

clear all; clc; close all
% Par�metros
n_bits = 1000;                % N�mero de bits
T = 500;                      % Tempo de s�mbolo OFDM
Ts = 2;                       % Tempo de s�mbolo em portadora �nica
K = T/Ts;                     % N�mero de subportadoras independentes
N = 2*K;                      % DFT de N pontos
EbN0dB = 0:1:14;              % Vetor de EbN0  (energy per bit to noise power spectral density ratio) is a normalized signal-to-noise ratio (SNR) measure
Eb = 1;                       % Energia de bit para o BPSK
N0 = Eb * 10.^(-EbN0dB/10);   % Pot�ncia de ru�do (Proakis)
variance = 0;

% Gerar bits aleat�rios para 16-QAM
dataIn=rand(1,n_bits);   % Sequ�ncia de n�meros entre 0 e 1 uniformemente distribu�dos
dataIn=sign(dataIn-.5);  % Sequ�ncia de -1 e 1
% Conversor serial paralelo
dataInMatrix = reshape(dataIn,n_bits/4,4); % Convers�o serial para paralelo

% % Gerar bits aleat�rios para BPSK
% dataIn_bpsk=rand(1,n_bits);   % Sequ�ncia de n�meros entre 0 e 1 uniformemente distribu�dos
% dataIn_bpsk=sign(dataIn-.5);  % Sequ�ncia de -1 e 1
% % Conversor serial paralelo
% dataInMatrix_bpsk = reshape(dataIn,n_bits/4,4); % Convers�o serial para paralelo

% Gerar constela�ao 16-QAM
seq16qam = 2*dataInMatrix(:,1)+dataInMatrix(:,2)+1i*(2*dataInMatrix(:,3)+dataInMatrix(:,4)); 
seq16=seq16qam';
% Garantir propriedadade da simetria
X = [seq16 conj(seq16(end:-1:1))]; % Concatena��o da seq16 com seu conjugado na ordem inversa

% Construindo xn
xn = zeros(1,N);
for n=0:N-1
    for k=0:N-1
        xn(n+1) = xn(n+1) + 1/sqrt(N)*X(k+1)*exp(1i*2*pi*n*k/N); % Vers�o amostrada de xt
    end
end
%  Fim da geracao de bits aleatorios

% Loop de vari�ncias
for ik = 1:length(EbN0dB)
    % Adi��o de ru�do
    noise = sqrt(N0(ik))*randn(1,N)+1i*sqrt(N0(ik))*randn(1,N); % Influ�ncia no eixo imagin�rio e real, isto �, influencia na amplitude e na fase do sinal
%     noise_bpsk = sqrt(N0(ik))*randn(1,N)+1i*sqrt(N0)*randn(1,N); % Influ�ncia no eixo imagin�rio e real, isto �, influencia na amplitude e na fase do sinal
    %
    rn = xn + noise; % sinal recebido amostrado 
    % Fim da geracao do ru�do AWGN complexo
    
    % DFT de rn
    Y = zeros(1,K);
    for k=0:K-1
        for n=0:N-1
            Y(1,k+1) = Y(1,k+1) + 1/sqrt(N)*rn(n+1)*exp(-1i*2*pi*k*n/N); % Discrete Fourier transform de rn
        end
    end
    
    % Plots
    scatterplot(Y) % C�rculos azuis, � a constela��o de Yk
    hold on
    scatter(real(seq16),imag(seq16), 'r', '+') % Cruzes vermelhas, � a constela��o 16-QAM 
    hold off
    title(['Sinal com Eb/N0 de ', num2str(EbN0dB(ik)), 'dB']);
    
    % Demodula��o, isolando a parte real e imagin�rio de Y e comparando com os valores das regi�es da constela��o do 16-QAM
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
    
    % C�lculo de vari�ncia
    %O c�lculo da vari�ncia populacional � obtido atrav�s da soma dos quadrados da diferen�a entre cada
    %valor e a m�dia aritm�tica, dividida pela quantidade de elementos observados.
    % AWGN tem m�dia zero, ent�o a vari�ncia � igual a soma dos quadrados de cada valor, dividida pela quantidade de elementos observados.
    variance = sum(find(Z(1,2:K)-X(1,2:K)))/n_bits;
    
    % Contagem de erro
    % find(X) returns a vector containing the linear indices of each nonzero element in array X.
    error = length(find(Z(1,2:K)-X(1,2:K)));
    disp(['Para EbN0 de ', num2str(EbN0dB(ik)),'dB, a vari�ncia � ', num2str(variance)]);
    %disp(['Para Eb/no de 'num2str(EbN0dB), ' temos a vari�ncia de ', num2str(variance), ' houve ', num2str(error), ' s�mbolos errados.']);
end