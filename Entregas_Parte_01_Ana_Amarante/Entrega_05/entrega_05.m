close all;clear all;clc;
addpath('.\fitmethis')

% Estima��o com o conhecimento do sombreamento e do fading
% Par�metros para gera��o do canal real
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
sPar.chFileName  = 'Prx_Real_2020_1';
% Dist�ncia entre pontos de medi��o
sPar.dMed = sPar.totalLength/sPar.nPoints;
%
% Chama fun��o que gera o canal real
[vtDist, vtPathLoss, vtShadCorr, vtFading, vtPrxdBm] = fGeraCanal(sPar);
%
% Mostra informa��es do canal real
disp('Canal real:')
disp(['   M�dia do sombreamento: ' num2str(mean(vtShadCorr)) ]);
disp(['   Std do sombreamento: ' num2str(std(vtShadCorr)) ]);
disp(['   Janela de correla��o do sombreamento: ' num2str(sPar.shadowingWindow) ' amostras' ]);
disp(['   Expoente de path loss: ' num2str(sPar.n) ]);
disp(['   m de Nakagami: ' num2str(sPar.m) ]);

% V�rias janelas de filtragem para testar a estima��o
vtW = [2 5 10]; % Defini��o dos valores de W
for iw = 1: length(vtW)
    % Configura valor da janela de filtragem
    sPar.dW = vtW(iw);
    % Chama fun��o que estima o canal real
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
    
    disp(['Estima��o dos par�metros de larga escala (W = ' num2str(sPar.dW) '):'])
    disp(['   Desvio padr�o do sombreamento estimado = ' num2str(dStdShadEst)]);
    disp(['   M�dia do sombreamento estimado = ' num2str(dStdMeanShadEst)]);
    disp(['   Expoente de perda de percurso estimado n = ' num2str(dNEst)]);
    disp('----');
    disp(' ');
    
    % Gr�fico de pot�ncias
    if (vtW(iw)) == 5 
        % Figuras do canal estimado
        figure;
        % Pot�ncia recebida com canal completo
        plot(vtDistLogEst,vtPrxEst); hold all;
        % Pot�ncia recebida com path loss
        plot(vtDistLogEst,sPar.txPower-vtPathLossEst,'linewidth', 2)
        % Pot�ncia recebida com path loss e shadowing
        plot(vtDistLogEst,sPar.txPower-vtPathLossEst+vtShadCorrEst,'linewidth', 2)
        %title('Canal estimado: Pot�ncia recebida no receptor vs. log da dist�ncia')
        xlabel('log_{10}(d)');
        ylabel('Pot�ncia [dBm]');
        legend('Prx canal completo', 'Prx (somente perda de percurso)', 'Prx (perda de percurso + sombreamento)');
        title(['Prx original vs estimada para W = ' num2str(vtW(iw))]);
    end
end



