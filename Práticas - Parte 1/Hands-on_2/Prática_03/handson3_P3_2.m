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
%
% Estudo visual: Estima��o do Fading para v�rias janelas de filtragem e
% v�rios valores do m de Nakagami
%
% Plot das CCDFs do Fading para cada janela
figure;
chMarkers = ['o-';'x-';'s-';'d-';'>-';'^-';'-.'];
for iw = 1:length(vtW)
    plot( sOut(iw).vtXCcdfEst,  sOut(iw).vtYCcdfEst, chMarkers(iw,:) ); hold all;
end
chLegendaW = strcat('W = ',cellstr(num2str(vtW')));
legend(chLegendaW);
xlabel('x');
ylabel('F(x)');
%
% Plot das CDFs Nakagami te�rica o valor do m de entrada
vtm = sPar.m;
xCDF = 10.^(sOut(1).vtXCcdfEst/20);
tam_dist = length(gammainc(1*xCDF.^2,1)); % Tamanho da distribui��o
for ik = 1:length(vtm)
    im = vtm(ik);
    cdfnaka(ik,1:tam_dist) = gammainc(im*xCDF.^2,im);
    semilogy(20.*log10(xCDF),cdfnaka(ik,:),'--', 'linewidth', 2);
    chLegendaNaka = strcat('m = ',cellstr(num2str(vtm'))); %cria��o da legenda autom�tica
end
legend([chLegendaW; chLegendaNaka]);
axis([-10 10 1e-5 1]);
% C�lculo do erro m�dio baseado na compara��o de CDFs 
disp('MSE da CDF com v�rias janelas de filtragem com o conhecimento do Fading:')
% C�lculo do erro m�dio quadr�tico da CDF do Fading
vtm = [2:1:5];
for ik = 1:length(vtm)
    im = vtm(ik);
    cdfnaka(ik,1:tam_dist) = gammainc(im*xCDF.^2,im);
    for il = 1:length(vtW)
        mtMSEFad(ik,il) = immse(cdfnaka(ik,:), sOut(il).vtYCcdfEst);
        disp(['   m = ' num2str(vtm(ik)) ', W = ' num2str(vtW(il)) ': MSE Fading = ' num2str(mtMSEFad(ik,il))]);
    end
    disp('----');
end
[vLinha, posLinha] = min(mtMSEFad); % Melhor m para cada W
[valCol, posCol] = min(vLinha); % Melhor W de todos (entre os com menores m)
bestLin = posLinha(posCol);
bestCol = posCol;
disp(['   Melhor MSE relativo aos valores reais do fading:'])
disp(['   W = ' num2str(vtW(bestCol)) ' e m = ' num2str(vtm(bestLin)) ': MSE Fading = ' num2str(mtMSEFad(bestLin, bestCol))]);
disp('----------------------------------------------------------------------------------');
disp(' ');