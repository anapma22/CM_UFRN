% Par�metros para gera��o do canal sint�tico
sPar.d0 = 5;                     % dist�ncia de refer�ncia d0
sPar.P0 = 0;                     % Pot�ncia medida na dist�ncia de refer�ncia d0
sPar.nPoints = 50000;            % N�mero de amostras da rota de medi��o
sPar.totalLength = 100;          % Dist�ncia final da rota de medi��o
sPar.n = 4;                      % Expoente de perda de percurso
sPar.sigma = 6;                  % Desvio padr�o do shadowing em dB
sPar.shadowingWindow = 200;      % Tamanho da janela de correla��o do shadowing (colocar em fun��o da dist�ncia de correla��o)
sPar.m = 4;                      % Par�metro de Nakagami
sPar.txPower = 0;                % Pot�ncia de transmiss�o em dBm
sPar.nCDF = 40;                  % N�mero de pontos da CDF normalizada
sPar.chFileName  = 'Prx_sintetico';
% Dist�ncia entre pontos de medi��o
sPar.dMed = sPar.totalLength/sPar.nPoints;
% Vetor de dist�ncias do transmissor (al�m da dist�ncia de refer�ncia)
vtDist = sPar.d0:sPar.dMed:sPar.totalLength;
% N�mero de amostras geradas
nSamples = length(vtDist);
% Gera��o da Perda de percurso (determin�stica)
vtPathLoss = sPar.P0 + 10*sPar.n*log10(vtDist./sPar.d0);
% Gera��o do Sombreamento (V.A. Gaussiana com m�dia zero e desvio padr�o sigma)
nShadowSamples = floor(nSamples/sPar.shadowingWindow);
vtShadowing = sPar.sigma*randn(1,nShadowSamples);
% Amostras para a �ltima janela
restShadowing = sPar.sigma*randn(1,1)*ones(1,mod(nSamples,sPar.shadowingWindow));
% Repeti��o do mesmo valor de sombreamento durante a janela de correla��o
vtShadowing = ones(sPar.shadowingWindow,1)*vtShadowing;
% Amostras organizadas em um vetor
vtShadowing = [reshape(vtShadowing,1,nShadowSamples*sPar.shadowingWindow),restShadowing];
% Filtragem para evitar varia��o abrupta do sombreamento (filtro m�dia m�vel)
% O sombreamento tem menos "2*jan" amostras devido a filtragem
jan = sPar.shadowingWindow/2;
iCont = 1;
for i = jan+1:nSamples-jan,
    vtShadCorr(iCont) = mean(vtShadowing(i-jan:i+jan));
    iCont = iCont+1;
end
% Ajuste do desvio padr�o depois do filtro de correla��o do sombreamento
vtShadCorr = vtShadCorr*std(vtShadowing)/std(vtShadCorr);
vtShadCorr = vtShadCorr - mean(vtShadCorr)+ mean(vtShadowing);
%
% Gera��o do desvanecimento de pequena escala: Nakagami fading
% PDF da envolvt�ria normalizada
fpNakaPdf = @(x)((2.*sPar.m.^sPar.m)./(gamma(sPar.m))).*x.^(2.*sPar.m-1).*exp(-(sPar.m.*x.^2));
% Gerador de n�meros aleat�rios com distribui��o Nakagami
vtNakagamiNormEnvelope = slicesample(1,nSamples,'pdf',fpNakaPdf);
% Fading em dB (Pot�ncia)
vtNakagamiSampdB = 20.*log10(vtNakagamiNormEnvelope');
%
% C�lculo da Pot�ncia recebida
vtTxPower = sPar.txPower*ones(1,nSamples);
% Ajuste do n�mero de amostras devido ao filtro de correla��o do
% sombreamento (tira 2*"Jan" amostras)
vtTxPower = vtTxPower(jan+1:nSamples-jan);
vtPathLoss = vtPathLoss(jan+1:nSamples-jan);
vtFading = vtNakagamiSampdB(jan+1:nSamples-jan);
vtDist = vtDist(jan+1:nSamples-jan);
% Pot�ncia recebida
vtPrx = vtTxPower-vtPathLoss+vtShadCorr+vtFading;
%
% Salvamento dos dados
%    Para excel:
dlmwrite([sPar.chFileName '.txt'], [vtDist',vtPrx'], 'delimiter', '\t');
%    Matlab
save([sPar.chFileName '.mat'],'vtDist', 'vtPathLoss', 'vtShadCorr', 'vtFading', 'vtPrx');
%
% Mostra informa��es do canal sint�tico
disp('Canal sint�tico:')
disp(['   M�dia do sombreamento: ' num2str(mean(vtShadCorr)) ]);
disp(['   Std do sombreamento: ' num2str(std(vtShadCorr)) ]);
disp(['   Janela de correla��o do sombreamento: ' num2str(sPar.shadowingWindow) ' amostras' ]);
disp(['   Expoente de path loss: ' num2str(sPar.n) ]);
disp(['   m de Nakagami: ' num2str(sPar.m) ]);
%
% Plot do desvanecimento de larga escala (gr�fico linear)
figure;
% Log da dist�ncia
log_distancia = log10(vtDist);
% Pot�ncia recebida com canal completo
plot(log_distancia,vtPrx); hold all;
% Pot�ncia recebida com path loss
plot(log_distancia,sPar.txPower-vtPathLoss,'linewidth', 2)
% Pot�ncia recebida com path loss e shadowing
plot(log_distancia,sPar.txPower-vtPathLoss+vtShadCorr,'linewidth', 2)
%title('Canal sint�tico: Pot�ncia recebida no receptor vs. log da dist�ncia')
xlabel('log_{10}(d)');
ylabel('Pot�ncia [dBm]');
legend('Prx canal completo', 'Prx (somente perda de percurso)', 'Prx (perda de percurso + sombreamento)');
xlim([0.7 1.6])
%
% Plot da gera��o do desvanecimento Nakagami
figure;
[f,x] = hist(vtNakagamiNormEnvelope,100);
bar(x,f/trapz(x,f)); % Histograma normalizado = PDF (das amostras)
hold all;
plot(x,fpNakaPdf(x),'r'); % PDF da distribui��o
title('Canal sint�tico - desvanecimento de pequena escala');
legend('Histograma normalizado das amostras','PDF');