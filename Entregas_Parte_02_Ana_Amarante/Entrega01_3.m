%1.3 Fazer o gr�fico da BER vs Eb/No para com OFDM e, no mesmo gr�fico, o gr�fico da 
% Pe vs Eb/No (f�rmula te�rica)  da modula��o BPSK e 16-QAM sem OFDM.

clear all; clc; close all

% Par�metros com valores fixos
n_bits = 1000;                % N�mero de bits
T = 500;                      % Tempo de s�mbolo OFDM
Ts = 2;                       % Tempo de s�mbolo em portadora �nica
K = T/Ts;                     % N�mero de subportadoras independentes
N = 2*K;                      % DFT de N pontos
EbNodB = 0:1:14;              % Vetor de EbNo2  (energy per bit to noise power spectral density ratio) is a normalized signal-to-noise ratio (SNR) measure
EbNo = 10.^(EbNodB/10);      % Eb/No em escala linear
% Eb_bpsk = 1;                  % Energia de bit para o BPSK
% No2_bpsk = Eb_bpsk *10.^(-EbNodB/10);   % Pot�ncia de ru�do (Proakis)
M = [2 16];
k_qam = log2(16);
theoreticalBER = [];
theoreticalBER_bpsk = [];

for ik = 1:length(EbNo) 
    i = 2;
    for i=2:2:4
        if i == 4 % 16-QAM
            theoreticalBER(ik) = (4/k_qam)*(1-1/sqrt(16))*(qfunc(sqrt(3*k_qam*EbNo(ik)/(16-1)))); %(http://www.ene.unb.br/andre/teaching/files/ComDig/Apostila/Cap%2003%20Desempenho%20em%20Canal%20Ruidoso.pdf, eq 97)
        else % BPSK
            theoreticalBER_bpsk(ik) = qfunc(sqrt(2*EbNo(ik))); %(https://www.mathworks.com/help/comm/ref/qfunc.html)
        end
    end
end
figure (1)
plotBER = semilogy(EbNodB,theoreticalBER,'r--o');
hold on
figure (1)
plotBER = semilogy(EbNodB,theoreticalBER_bpsk,'b--o');
hold on


%------------- 16-QAM --------------------------------
 for ik = 1:length(EbNodB) 
    % Gerar bits aleat�rios para 16-QAM
    dataIn=rand(1,n_bits);   % Sequ�ncia de n�meros entre 0 e 1 uniformemente distribu�dos
    dataIn=sign(dataIn-.5);  % Sequ�ncia de -1 e 1
    % Conversor serial paralelo para 16-QAM
    dataInMatrix = reshape(dataIn,n_bits/4,4); 
    % Gerar constela�ao 16-QAM
    seq16qam = 2*dataInMatrix(:,1)+dataInMatrix(:,2)+1i*(2*dataInMatrix(:,3)+dataInMatrix(:,4)); 
    seq16=seq16qam';
    % Garantir propriedadade da simetria para 16-QAM
    X = [seq16 conj(seq16(end:-1:1))]; % Concatena��o da seq16 com seu conjugado na ordem inversa
    % Construindo xn para 16-QAM, vers�o amostrada de um s�mbolo OFDM x(t)
    xn = zeros(1,N);
    for n=0:N-1
        for k=0:N-1
            xn(n+1) = xn(n+1) + 1/sqrt(N)*X(k+1)*exp(1i*2*pi*n*k/N); % Vers�o amostrada de xt
        end
    end
    % Construindo xt para 16-QAM, para o TX
    xt=zeros(1, T+1);
    for t=0:T
        xt=ifft(xn,[],N); %(https://www.mathworks.com/help/matlab/ref/ifft.html)
        % returns the inverse Fourier transform along the dimension dim. For example, if Y is a matrix, then ifft(Y,n,2) returns the n-point inverse transform of each row.
    end
    Eb = ((sum(xn*xn'))/length(xn));%(1/sqrt(10))*dataIn; % normalization of energy to 1 (https://www.mathworks.com/matlabcentral/fileexchange/19403-symbol-error-rate-for-16qam-in-awgn-channel)
    No2(ik) = Eb *10.^(-EbNodB(ik)/10);   % Pot�ncia de ru�do (Proakis)
    noise = sqrt((No2(ik))/2)*randn(1,N)+1i*sqrt((No2(ik))/2)*randn(1,N); % Influ�ncia no eixo imagin�rio e real, isto �, influencia na amplitude e na fase do sinal
    %noise=1/sqrt(2)*(randn(1,length(ofdm_signal))+1i*randn(1,length(ofdm_signal)));
    % Sinal recebido amostrado para 16-QAM
    rn = xt + noise;   
    % Discrete Fourier Transform (DFT) de rn para 16-QAM - Demodula��o
    Y = zeros(1,K);
    for k=0:K-1 
        Y = fft(rn/22); % Fast Fourier transform, para o RX
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
    % C�lculo de vari�ncia para 16-QAM
    variance = var(noise(:));%sum(find(Z(1,2:K)-X(1,2:K)))/n_bits;

    disp(['16-QAM: Para Eb/No de ', num2str(EbNodB(ik)),'dB, a vari�ncia � ', num2str(variance)]);
    % Contagem de erro para 16-QAM
    error = length(find(Z(1,2:K)-X(1,2:K))); % find(X) returns a vector containing the linear indices of each nonzero element in array X.
    BER(ik)=error/n_bits; % Calculo da BER para 16 - QAM
    % nBitErr(ii) = size(find([ipBitRe- ipBinHatRe]),1) + size(find([ipBitIm - ipBinHatIm]),1) ;
    %     Plots para 16-QAM
%     scatterplot(Y) % C�rculos azuis, � a constela��o de Yk
%     hold on
%     scatter(real(seq16),imag(seq16), 'r', '+') % Cruzes vermelhas, � a constela��o 16-QAM 
%     hold off
%     title(['Modula��o 16-QAM: Sinal com Eb/No de ', num2str(EbNodB(ik)), 'dB']);
 end
figure(1)
plotBER = semilogy(EbNodB,BER,'m*'); 
hold on
%---------------------------------------------------
 
%------------------- BPSK --------------------------
for ik = 1:length(EbNodB) 
    % Gerar bits aleat�rios para BPSK
    dataIn_bpsk=rand(1,n_bits);   % Sequ�ncia de n�meros entre 0 e 1 uniformemente distribu�dos
    dataIn_bpsk=sign(dataIn_bpsk-.5);  % Sequ�ncia de -1 e 1
    % Conversor serial paralelo para BPSK
    dataInMatrix_bpsk = reshape(dataIn_bpsk,n_bits/1,1);
    % Gerar constela�ao BPSK
    seqbpsk = dataInMatrix_bpsk(:,1); 
    seqbpsk_t=seqbpsk';
    % Garantir propriedadade da simetria para BPSK
    X_bpsk = [seqbpsk_t conj(seqbpsk_t(end:-1:1))]; 
    % Construindo xn para BPSK, vers�o amostrada de um s�mbolo OFDM x(t)
    xn_bpsk = zeros(1,N);
    for n=0:N-1
        for k_bpsk=0:N-1
            xn_bpsk(n+1) = xn_bpsk(n+1) + 1/sqrt(N)*X_bpsk(k_bpsk+1)*exp(1i*2*pi*n*k_bpsk/N);
        end
    end
    % Construindo xt para 16-QAM, para o TX
    xt_bpsk=zeros(1, T+1);
    for t=0:T
        xt_bpsk=ifft(xn_bpsk,[],N); %(https://www.mathworks.com/help/matlab/ref/ifft.html)
        % returns the inverse Fourier transform along the dimension dim. For example, if Y is a matrix, then ifft(Y,n,2) returns the n-point inverse transform of each row.
    end
    Eb_bpsk = ((sum(xn_bpsk*xn_bpsk'))/length(xn_bpsk));%(1/sqrt(10))*dataIn; % normalization of energy to 1 (https://www.mathworks.com/matlabcentral/fileexchange/19403-symbol-error-rate-for-16qam-in-awgn-channel)
    No2_bpsk(ik) = Eb *10.^(-EbNodB(ik)/10);   % Pot�ncia de ru�do (Proakis)
    noise_bpsk = sqrt((No2_bpsk(ik))/2)*randn(1,N)+1i*sqrt((No2_bpsk(ik))/2)*randn(1,N); % Influ�ncia no eixo imagin�rio e real, isto �, influencia na amplitude e na fase do sinal   
    % Sinal recebido amostrado para BPSK
    rn_bpsk = xt_bpsk + noise_bpsk; % sinal recebido amostrado  para bpsk
    % Discrete Fourier Transform (DFT) de rn para BKPS - Demodula��o
    Y_bpsk = zeros(1,K);
    for k_bpsk=1:K-1
            Y_bpsk = fft(rn_bpsk/22); % Fast Fourier transform, para o RX
    end
    % Demodula��o   para BPSK
    for k_bpsk= 1:length(Y_bpsk) % Para percorrer todo o vetor Yk 
        if real(Y_bpsk(1,k_bpsk)) > 0 % Para parte real de Yk 
            Z_bpsk(1,k_bpsk) = 1;
        else
            Z_bpsk(1,k_bpsk) = -1;
        end
    end
    % C�lculo de vari�ncia para BPSK
    variance_bpsk = var(noise_bpsk(:)); %sum(find(Z_bpsk(1,2:K)-X_bpsk(1,2:K)))/n_bits;    
    disp(['BPSK:   Para Eb/No de ', num2str(EbNodB(ik)),'dB, a vari�ncia � ', num2str(variance_bpsk)]);   
    % Contagem de erro para BPSK
    error_bpsk = length(find(Z_bpsk(1,2:K)-X_bpsk(1,2:K)));
    BER_bpsk(ik)=error_bpsk/n_bits; % Calculo da BER
        
%     Plots BPSK
%     scatterplot(Y_bpsk)
%     hold on
%     scatter(real(seqbpsk_t),imag(seqbpsk_t), 'r', '+')
%     axis ([-2,2,-2,2])
%     hold off
%     title(['Modula��o BPSK: Sinal com Eb/No de ', num2str(EbNodB(ik)), 'dB']);
end

figure(1)
plotBER = semilogy(EbNodB,BER_bpsk,'c*');
hold on
grid on, hold on;
xlabel('Eb/No (dB)')
ylabel('BER')
legend({'BER te�rica - 16-QAM sem OFDM','BER te�rica - BPSK sem OFDM','BER simulada - 16-QAM com OFDM','BER simulada - BPSK com OFDM'},'Location','southwest');
%---------------------------------------------------
    
