close all;clear all;clc;
addpath('./fitmethis')
%addpath('./CODES/HD_03_MATLAB/fitmethis')
% Estima��o com o conhecimento do sombreamento e do fading
% Par�metros para gera��o do canal sint�tico
sPar.d0 = 5;                     % dist�ncia de refer�ncia d0
sPar.P0 = 0;                     % Pot�ncia medida na dist�ncia de refer�ncia d0 (em dBm)
sPar.nPoints = 10000;            % N�mero de amostras da rota de medi��o
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
% Teste KS
sDistNames = [{'Weibull'};{'Rician'};{'Rayleigh'};{'Nakagami'}];
% Test KS (h = 0, n�o rejeita H0 e os dados podem ser da distribui��o especificada;
% k � o maior diferen�a engre a CDF dos dados e da distribui��o especificada. Quanto menor k, melhor o fit)
for iw = 1:length(vtW)
    disp(' ')
    disp(['Janela W = ' num2str(vtW(iw)) ]);
    for ik = 1:length(sDistNames)
        data = [sOut(iw).vtEnvNorm]';
        pd = fitdist(data,sDistNames{ik});
        x = linspace(min(data),max(data),length(data));
        tCDF = [x' cdf(pd,x)'];
        [h,p,k,c] = kstest(data,'CDF',tCDF);
        sKtest(ik,iw).h = h;
        sKtest(ik,iw).p = p;
        sKtest(ik,iw).k = k;
        sKtest(ik,iw).c = c;
        disp(['   Distribui��o ' sDistNames{ik} ': k = ' num2str(k) ', p-value = ' num2str(p)]);
        % Resultado do teste KS
        if (h == 0)
            disp('     h = 0 => N�o rejeita a hip�tese H0 com n�vel de signific�ncia $\alpha$ = 5% (p > 0.05).');
        elseif (h == 1)
            disp('     h = 1 => Rejeita a hip�tese H0 com n�vel de signific�ncia $\alpha$ = 5% (p < 0.05).');
        end
    end
end