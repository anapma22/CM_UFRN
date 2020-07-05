%%file fGeraCanal.m
function [vtDist, vtPathLoss, vtShadCorr, vtFading, vtPrxdBm] = fGeraCanal(sPar)
% Prop�sito: Gerar canal composta de path loss, shadowing e desvanecimento plano
%
% ENTRADAS: na estrutura sParams
%    - nPoints: N�mero de amostras
%    - totalLength: dist�ncia m�xima da rota
%    - P0: pot�ncia de refer�ncia medida na dist�ncia d0
%    - d0: dist�ncia d0 de refer�ncia
%    - n: expoente de perda de percurso
%    - sigma: desvio padr�o do sombreamento lognormal [dB]
%    - Tamanho da janela de correla��o do sombreamento [amostras]
%    - m: par�metro de Nakagami
%    - dMed: dist�ncia entre pontos de medi��o (totalLength/nPoints)
%    - txPower: pot�ncia de transmiss�o em dBm
%
% SA�DAS:
%    - vtDist: pontos de medi��o [m]
%    - vtPathLoss: amostras da perda de percurso
%    - vtShadCorr: amostras do somrbeamento
%    - fading: amostras do desvanecimento de pequena escala
%    - vtPrx: pot�ncia recebida com o canal completo
%
% Parser dos par�metros de entrada
nPoints = sPar.nPoints;
totalLength = sPar.totalLength;
P0 = sPar.P0;
d0 = sPar.d0;
n = sPar.n;
sigma = sPar.sigma;
shadowingWindow = sPar.shadowingWindow;
m = sPar.m;
dMed = sPar.dMed;
txPower = sPar.txPower;
%
% Dist�ncia do transmissor (al�m da dist�ncia de refer�ncia)
d = d0:dMed:totalLength;
nSamples = length(d);
%
% Gera��o da Perda de percurso (determin�stica)
vtPathLoss = P0 + 10*n*log10(d./d0);
%
% Gera��o do Sombreamento
nShadowSamples = floor(nSamples/shadowingWindow);
shadowing = sigma*randn(1,nShadowSamples);
% Amostras para a �ltima janela
restShadowing = sigma*randn(1,1)*ones(1,mod(nSamples,shadowingWindow));
% Repeti��o do mesmo valor de sombreamento durante a janela de correla��o
shadowing = ones(shadowingWindow,1)*shadowing;
% Amostras organizadas em um vetor
shadowing = [reshape(shadowing,1,nShadowSamples*shadowingWindow),restShadowing];
% Filtragem para evitar varia��o abrupta do sombreamento
jan = shadowingWindow/2;
iCont = 1;
for i = jan+1:nSamples-jan,
    vtShadCorr(iCont) = mean(shadowing(i-jan:i+jan)); %diminuir a varia��o brusca do sombreamento
    iCont = iCont+1;
end
% Ajuste do desvio padr�o depois do filtro de correla��o do sombreamento
vtShadCorr = vtShadCorr*std(shadowing)/std(vtShadCorr);
vtShadCorr = vtShadCorr - mean(vtShadCorr)+ mean(shadowing);
%
% Gera��o do desvanecimento de pequena escala
% Nakagami fading
nakagamiPdf = @(x)((2.*m.^m)./(gamma(m))).*x.^(2.*m-1).*exp(-(m.*x.^2));
nakagamiNormEnvelope = slicesample(1,nSamples,'pdf',nakagamiPdf);
nakagamiSamp=20.*log10(nakagamiNormEnvelope');
%
% C�lculo da Pot�ncia recebida
txPower = txPower*ones(1,nSamples);
% Ajuste do n�mero de amostras devido a filtragem
txPower = txPower(jan+1:nSamples-jan);
vtPathLoss = vtPathLoss(jan+1:nSamples-jan);
vtFading = nakagamiSamp(jan+1:nSamples-jan);
vtDist = d(jan+1:nSamples-jan);
% Pot�ncia recebida
vtPrxdBm = txPower-vtPathLoss+vtShadCorr+vtFading;
% Salva vari�veis do canal no Matlab
save([sPar.chFileName '.mat'],'vtDist', 'vtPathLoss', 'vtShadCorr', 'vtFading', 'vtPrxdBm');