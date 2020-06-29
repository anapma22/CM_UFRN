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
    sOut(iw) = fEstimaCanal(sPar);
    % Parser de vari�veis
    vtDistEst = sOut(iw).vtDistEst;
    vtPathLossEst = sOut(iw).vtPathLossEst;
    dNEst = sOut(iw).dNEst;
    vtShadCorrEst = sOut(iw).vtShadCorrEst;
    dStdShadEst = sOut(iw).dStdShadEst;
    dStdMeanShadEst = sOut(iw).dStdMeanShadEst;
    vtDesPequeEst = sOut(iw).vtDesPequeEst;
    vtPrxEst = sOut(iw).vtPrxEst;
    vtXCcdfEst = sOut(iw).vtXCcdfEst;
    vtYCcdfEst = sOut(iw).vtYCcdfEst;
    vtDistLogEst = log10(vtDistEst);
    vtDistLog = log10(vtDist);
end
% Estima��o cega via MLE
disp(' ')
disp('Estima��o do Fading para v�rias janelas (estudo n�merico sem conhecimento a priori do canal)');
disp('Resultados com fitdist do Matlab')
for iw = 1:length(vtW)%
    disp(['Janela W = ' num2str(vtW(iw))]);
    %
    sNaka(iw) = fitdist([sOut(iw).vtEnvNorm]','Nakagami');
    disp(['  Nakagami: m = ' num2str(sNaka(iw).mu) ', omega = ' num2str(sNaka(iw).omega)]);
    %
    sRice(iw) = fitdist([sOut(iw).vtEnvNorm]','Rician');
    K_rice = (sRice(iw).s)^2/(2*sRice(iw).sigma^2);
    disp(['  Rice: K = ' num2str(K_rice)]);
    %
    sRay(iw) = fitdist([sOut(iw).vtEnvNorm]','Rayleigh');
    disp(['  Rayleigh: sigma = ' num2str(sRay(iw).B)]);
    %
    sWei(iw) = fitdist([sOut(iw).vtEnvNorm]','Weibull');
    disp(['  Weibull: k = ' num2str(sWei(iw).B) ', lambda = ' num2str(sWei(iw).A)]);
    disp(' ')
end