%1.1 Variar a Eb/No de 0 a 14 dB e calcular a vari�ncia do ru�do, considerando modula��o BPSK e 16-QAM;
clear all; clc; close all

% Par�metros com valores fixos
n_bits = 1000;                % N�mero de bits
T = 500;                      % Tempo de s�mbolo OFDM
Ts = 2;                       % Tempo de s�mbolo em portadora �nica
K = T/Ts;                     % N�mero de subportadoras independentes
N = 2*K;                      % DFT de N pontos
EbNodB = 0:1:14;              % Vetor de EbNo2  (energy per bit to noise power spectral density ratio) is a normalized signal-to-noise ratio (SNR) measure
Eb_bpsk = 1;                  % Energia de bit para o BPSK
No2_bpsk = Eb_bpsk *10.^(-EbNodB/10);   % Pot�ncia de ru�do (Proakis)

% Gerar bits aleat�rios para 16-QAM
dataIn=rand(1,n_bits);   % Sequ�ncia de n�meros entre 0 e 1 uniformemente distribu�dos
dataIn=sign(dataIn-.5);  % Sequ�ncia de -1 e 1
% Gerar bits aleat�rios para BPSK
dataIn_bpsk=rand(1,n_bits);   % Sequ�ncia de n�meros entre 0 e 1 uniformemente distribu�dos
dataIn_bpsk=sign(dataIn_bpsk-.5);  % Sequ�ncia de -1 e 1

% Conversor serial paralelo para BPSK
dataInMatrix_bpsk = reshape(dataIn_bpsk,n_bits/1,1);
% Gerar constela�ao BPSK
seqbpsk = dataInMatrix_bpsk(:,1); 
seqbpsk_t=seqbpsk';
% Garantir propriedadade da simetria par BPSK
X_bpsk = [seqbpsk_t conj(seqbpsk_t(end:-1:1))]; 
% Construindo xn para BPSK
xn_bpsk = zeros(1,N);
for n=0:N-1
    for k_bpsk=0:N-1
        xn_bpsk(n+1) = xn_bpsk(n+1) + 1/sqrt(N)*X_bpsk(k_bpsk+1)*exp(1i*2*pi*n*k_bpsk/N);
    end
end

% Conversor serial paralelo para 16-QAM
dataInMatrix = reshape(dataIn,n_bits/4,4); 
% Gerar constela�ao 16-QAM
seq16qam = 2*dataInMatrix(:,1)+dataInMatrix(:,2)+1i*(2*dataInMatrix(:,3)+dataInMatrix(:,4)); 
seq16=seq16qam';
% Garantir propriedadade da simetria para 16-QAM
X = [seq16 conj(seq16(end:-1:1))]; % Concatena��o da seq16 com seu conjugado na ordem inversa
% Construindo xn para 16-QAM
xn = zeros(1,N);
for n=0:N-1
    for k=0:N-1
        xn(n+1) = xn(n+1) + 1/sqrt(N)*X(k+1)*exp(1i*2*pi*n*k/N); % Vers�o amostrada de xt
    end
end

% Loop para calcular as vari�ncias e Eb, No2 do 16-QAM com diferentes
% valores de EbNo
for ik = 1:length(EbNodB) 
    Eb = (1/sqrt(10))*dataIn; % normalization of energy to 1 (https://www.mathworks.com/matlabcentral/fileexchange/19403-symbol-error-rate-for-16qam-in-awgn-channel)
    No2 = Eb *10.^(-EbNodB(ik)/10);   % Pot�ncia de ru�do (Proakis)
    
    % Adi��o de ru�do
    noise = sqrt(No2(ik))*randn(1,N)+1i*sqrt(No2(ik))*randn(1,N); % Influ�ncia no eixo imagin�rio e real, isto �, influencia na amplitude e na fase do sinal
    noise_bpsk = sqrt(No2(ik))*randn(1,N)+1i*sqrt(No2(ik))*randn(1,N); % Influ�ncia no eixo imagin�rio e real, isto �, influencia na amplitude e na fase do sinal
    
    % Sinal recebido amostrado para 16-QAM
    rn = xn + noise;   
    % DFT de rn para 16-QAM
    Y = zeros(1,K);
    for k=0:K-1
        for n=0:N-1
            Y(1,k+1) = Y(1,k+1) + 1/sqrt(N)*rn(n+1)*exp(-1i*2*pi*k*n/N); % Discrete Fourier transform de rn
        end
    end
    
    % Sinal recebido amostrado para BPSK
    rn_bpsk = xn_bpsk + noise_bpsk; % sinal recebido amostrado  para bpsk
    % DFT de rn para BKPS
    Y_bpsk = zeros(1,K);
    for k_bpsk=1:K-1
            Y_bpsk = fft(rn_bpsk/22);
    end
    
    % Plots para 16-QAM
    scatterplot(Y) % C�rculos azuis, � a constela��o de Yk
    hold on
    scatter(real(seq16),imag(seq16), 'r', '+') % Cruzes vermelhas, � a constela��o 16-QAM 
    hold off
    title(['Modula��o 16-QAM: Sinal com Eb/No de ', num2str(EbNodB(ik)), 'dB']);
    
    % Plots BPSK
    scatterplot(Y_bpsk)
    hold on
    scatter(real(seqbpsk_t),imag(seqbpsk_t), 'r', '+')
    axis ([-2,2,-2,2])
    hold off
    title(['Modula��o BPSK: Sinal com Eb/No de ', num2str(EbNodB(ik)), 'dB']);
    % Demodula��o   para BPSK
    for k_bpsk= 1:length(Y_bpsk) % Para percorrer todo o vetor Yk 
        if real(Y_bpsk(1,k_bpsk)) > 0 % Para parte real de Yk 
            Z_bpsk(1,k_bpsk) = 1;
        else
            Z_bpsk(1,k_bpsk) = -1;
        end
    end
        
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
    variance = sum(find(Z(1,2:K)-X(1,2:K)))/n_bits;
    variance_bpsk = sum(find(Z_bpsk(1,2:K)-X_bpsk(1,2:K)))/n_bits;    
    
    disp(['Modula��o 16-QAM: Para Eb/No de ', num2str(EbNodB(ik)),'dB, a vari�ncia � ', num2str(variance)]);
    disp(['Modula��o BPSK:   Para Eb/No de ', num2str(EbNodB(ik)),'dB, a vari�ncia � ', num2str(variance_bpsk)]);   
end