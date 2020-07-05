close all;clear all;clc;
% Estima��o com o conhecimento do sombreamento e do fading
% Par�metros para gera��o do canal sint�tico
sPar.d0 = 5;                     % dist�ncia de refer�ncia d0
sPar.P0 = 0;                     % Pot�ncia medida na dist�ncia de refer�ncia d0 (em dBm)
sPar.nPoints = 50000;            % N�mero de amostras da rota de medi��o
sPar.totalLength = 100;          % Dist�ncia final da rota de medi��o
sPar.n = 4;                      % Expoente de perda de percurso
sPar.sigma = 6;                  % Desvio padr�o do shadowing em dB
sPar.shadowingWindow = 200;      % Tamanho da janela de correla��o do shadowing (colocar em fun��o da dist�ncia de correla��o)
sPar.m = 4;                      % Par�metro de Nakagami
sPar.txPower = 0;                % Pot�ncia de transmiss�o em dBm
sPar.nCDF = 40;                  % N�mero de pontos da CDF normalizada
sPar.dW = 100;                   % Janela de estima��o do sombreamento
sPar.chFileName  = 'Prx_sintetico';
% Dist�ncia entre pontos de medi��o
sPar.dMed = sPar.totalLength/sPar.nPoints;
%
% Chama fun��o que gera o canal sint�tico
[vtDist, vtPathLoss, vtShadCorr, vtFading, vtPrxdBm] = fGeraCanal(sPar);
%
% Mostra informa��es do canal sint�tico
disp('Canal sint�tico:')
disp(['   M�dia do sombreamento: ' num2str(mean(vtShadCorr)) ]);
disp(['   Std do sombreamento: ' num2str(std(vtShadCorr)) ]);
disp(['   Janela de correla��o do sombreamento: ' num2str(sPar.shadowingWindow) ' amostras' ]);
disp(['   Expoente de path loss: ' num2str(sPar.n) ]);
disp(['   m de Nakagami: ' num2str(sPar.m) ]);
%
% V�rias janelas de filtragem para testar a estima��o
vtW = [10 50 150 200];
for iw = 1: length(vtW)
    % Configura valor da janela de filtragem
    sPar.dW = vtW(iw);
    % Chama fun��o que estima o canal sint�tico
    [sOut] = fEstimaCanal(sPar);
    % Parser de vari�veis
    vtDistEst = sOut.vtDistEst;
    vtPathLossEst = sOut.vtPathLossEst;
    dNEst = sOut.dNEst;
    vtShadCorrEst = sOut.vtShadCorrEst;
    dStdShadEst = sOut.dStdShadEst;
    dStdMeanShadEst = sOut.dStdMeanShadEst;
    vtDesPequeEst = sOut.vtDesPequeEst;
    vtPrxEst = sOut.vtPrxEst;
    vtXCcdfEst = sOut.vtXCcdfEst;
    vtYCcdfEst = sOut.vtYCcdfEst;
    vtDistLogEst = log10(vtDistEst);
    vtDistLog = log10(vtDist);
    % MSE com Shadowing conhecido
    dMeiaJanela = round((sPar.dW-1)/2);
    vtMSEShad(iw) = immse(vtShadCorr(dMeiaJanela+1 : end-dMeiaJanela ), vtShadCorrEst);
    %
    % MSE com Fading conhecido
    vtMSEFad(iw) = immse(vtFading(dMeiaJanela+1 : end-dMeiaJanela ), vtDesPequeEst);
    %
    disp(['Estima��o dos par�metros de larga escala (W = ' num2str(sPar.dW) '):'])
    disp(['   Expoente de perda de percurso estimado n = ' num2str(dNEst)]);
    disp(['   Desvio padr�o do sombreamento estimado = ' num2str(dStdShadEst)]);
    disp(['   M�dia do sombreamento estimado = ' num2str(dStdMeanShadEst)]);
    disp(['   MSE Shadowing = ' num2str(vtMSEShad(iw))]);
    disp('----');
    disp(' ');
end
% Display informa��o sobre o estudo das janelas
disp(['Estudo na melhor janela de filtragem']);
disp(['   Janelas utilizadas = ' num2str(vtW)]);
% Melhor janela com Shadowing conhecido
[valBestShad, posBestShad] = min(vtMSEShad);
disp(['   Melhor MSE relativo aos valores reais do Shadowing (melhor janela):'])
disp(['      Melhor janela W = ' num2str(vtW(posBestShad)) ': MSE Shadowing = ' num2str(valBestShad)]);
% Melhor janela com Fading conhecido
[valBestFad, posBestFad] = min(vtMSEFad);
disp(['   Melhor MSE relativo aos valores reais do Fading:'])
disp(['      Melhor janela W = ' num2str(vtW(posBestFad)) ': MSE Shadowing = ' num2str(valBestFad)]);
disp('----------------------------------------------------------------------------------');
disp(' ');