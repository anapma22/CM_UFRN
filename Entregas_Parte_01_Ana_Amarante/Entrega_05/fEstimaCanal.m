%%file fEstimaCanal.m
function [sOut] = fEstimaCanal(sPar)
% PURPOSE: Estima par�metros do canal: path loss, shadowing e desvanecimento plano
%
% ENTRADAS: na estrutura sPar
%    - P0: pot�ncia de refer�ncia medida na dist�ncia d0
%    - d0: dist�ncia d0 de refer�ncia
%    - shadWindowFilter: janela para m�dia m�vel do desvanecimento da larga
%    escala
%    - txPower: pot�ncia de transmiss�o em dBm
%    - nCDF: N�mero de pontos da CDF normalizada
%
% SA�DAS: Estrutura sOut com
%    - vtDist: pontos de medi��o [m]
%    - vtPathLossEst: amostras estimadas da perda de percurso
%    - vtShadCorr: amostras do somrbeamento
%    - vtDesPequeEst: amostras do desvanecimento de pequena escala
%    - vtPrxEst: pot�ncia recebida estimada (canal completo)
%    - dNEst: Expoente de perda de percurso estimado
%    - dStdShadEst: Desvio padr�o do shadwoing estimado
%    - dStdMeanShadEst: M�dia do shadwoing estimado
%    - vtXCcdfEst: Valores dos Bins da CCDF do desvanecimento de pequena escala 
%    - vtYCcdfEst: Quantidade de amostras em cada bin da CCDF do desvanecimento de pequena escala

% L� canal gerado
load(sPar.chFileName);
%
vtPtrxmW = 10.^(vtPrxdBm/10);
nSamples = length(vtPtrxmW);
% Vetores para canal estimado
vtDesLarga = [];
vtDesPequeEst = [];
%
% C�lculo do desvanecimenro lento e r�pido
dMeiaJanela = round((sPar.dW-1)/2);  % Meia janela
ij = 1;
for ik = dMeiaJanela + 1 : nSamples - dMeiaJanela
    % Desvanecimento de larga escala: perda de percurso + sombreamento [dB]
    vtDesLarga(ij) = 10*log10(mean(vtPtrxmW(ik-dMeiaJanela:ik+dMeiaJanela)));
    % Desvanecimento de pequena escala [dB]
    vtDesPequeEst(ij) = vtPrxdBm(ik)-vtDesLarga(ij);
    ij = ij + 1;
end
%
% C�lculo da envolt�ria normalizada (para efeitos de c�lculo do fading)
indexes = dMeiaJanela+1 : nSamples-dMeiaJanela;
%vtPrxW = ((10.^(vtPrxdBm(indexes)./10))/1000);
vtPtrxmWNew = 10.^(vtPrxdBm(indexes)/10);
desLarga_Lin = (10.^(vtDesLarga(1:length(indexes))./10));
vtEnvNorm = sqrt(vtPtrxmWNew)./sqrt(desLarga_Lin);
%
% Ajuste no tamanho dos vetores devido a filtragem
vtDistEst = vtDist( dMeiaJanela+1 : nSamples-dMeiaJanela );
vtPrxdBm = vtPrxdBm( dMeiaJanela+1 : nSamples-dMeiaJanela );
%
% C�lculo reta de perda de percurso
vtDistLog = log10(vtDist);
vtDistLogEst = log10(vtDistEst);
% C�lculo do coeficientes da reta que melhor se caracteriza a perda de percurso
dCoefReta = polyfit(vtDistLogEst,vtPrxdBm,1); 
% Expoente de perda de percurso estimado
dNEst = -dCoefReta(1)/10;
% Perda de percurso estimada para os pontos de medi��o
vtPathLossEst = polyval(dCoefReta,vtDistLogEst);  
%
% Sombreamento
vtShadCorrEst = vtDesLarga - vtPathLossEst;
% Calcula a vari�ncia do sombreamento estimado
dStdShadEst = std(vtShadCorrEst);
dStdMeanShadEst = mean(vtShadCorrEst);
vtPathLossEst = - vtPathLossEst;
vtPrxEst = sPar.txPower - vtPathLossEst + vtShadCorrEst + vtDesPequeEst;
%
% Estima��o da CDF do desvanecimento de pequena escala
% C�lculo dos pontos do eixo x da cdf (espacamento igual entre os pontos)
vtn = 1 : sPar.nCDF;
xCDF = 1.2.^(vtn-1) * 0.01;
%
% C�lculo da CDF
den = 0;
cdffn=zeros(1,sPar.nCDF);
for ik = 1:sPar.nCDF
    for ij = 1:length(vtEnvNorm)
        if vtEnvNorm(ij) <= xCDF(ik)
            den = den + 1;
        end
        cdffn(ik) = cdffn(ik) + den;
        den = 0;
    end
end
%
% Monta estrutura do histograma
vtXCcdfEst = 20.*log10(xCDF);
vtYCcdfEst = cdffn/(cdffn(end)); 
%
sOut.vtDistEst = vtDistEst;
sOut.vtPathLossEst = vtPathLossEst;
sOut.dNEst = dNEst;
sOut.vtShadCorrEst = vtShadCorrEst;
sOut.dStdShadEst = dStdShadEst;
sOut.dStdMeanShadEst = dStdMeanShadEst;
sOut.vtDesPequeEst = vtDesPequeEst;
sOut.vtPrxEst = vtPrxEst;
sOut.vtXCcdfEst = vtXCcdfEst;
sOut.vtYCcdfEst = vtYCcdfEst;
sOut.vtEnvNorm = vtEnvNorm;