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
% Chama fun��o que gera o canal sint�tico
[vtDist, vtPathLoss, vtShadCorr, vtFading, vtPrxdBm] = fGeraCanal(sPar);
% Transforma pot�ncia em mWatts
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
envNormal = sqrt(vtPtrxmWNew)./sqrt(desLarga_Lin);
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
disp(['Estima��o dos par�metros de larga escala (W = ' num2str(sPar.dW) '):'])
disp(['   Expoente de perda de percurso estimado n = ' num2str(dNEst)]);
% Perda de percurso estimada para os pontos de medi��o
vtPathLossEst = polyval(dCoefReta,vtDistLogEst);  
%
% Sombreamento
vtShadCorrEst = vtDesLarga - vtPathLossEst;
% Calcula a vari�ncia do sombreamento estimado
stdShad = std(vtShadCorrEst);
meanShad = mean(vtShadCorrEst);
disp(['   Desvio padr�o do sombreamento estimado = ' num2str(stdShad)]);
disp(['   M�dia do sombreamento estimado = ' num2str(meanShad)]);
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
    for ij = 1:length(envNormal)
        if envNormal(ij) <= xCDF(ik)
            den = den + 1;
        end
        cdffn(ik) = cdffn(ik) + den;
        den = 0;
    end
end
%
% Monta estrutura do histograma
xccdfEst = 20.*log10(xCDF);
yccdfEst = cdffn/(cdffn(end)); 
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
title('Prx original vs estimada');
%
% Figura do Path loss (original vs estimado) 
figure;
plot(vtDistLog,-vtPathLoss);hold on;plot(vtDistLogEst,-vtPathLossEst);
legend('Path Loss original','Path Loss estimado');
title('Perda de percurso original vs estimada');
%
% Figura do Sombreamento (original vs estimado) 
figure;
plot(vtDistLog,vtShadCorr);hold on;plot(vtDistLogEst,vtShadCorrEst);
legend('Shadowing original','Shadowing estimado');
title('Sombreamento original vs estimada');
%
% Figura do Fading (original vs estimado) 
figure;
plot(vtDistLog,vtFading);hold on;plot(vtDistLogEst,vtDesPequeEst);
legend('Fading original','Fading estimado');
title('Fading original vs estimada');
%
% Plot das CDFs normalizadas Nakagami (assumindo que sabemos que o canal � m-Nakagami)- para v�rios valores de m
figure;
plot( xccdfEst, yccdfEst, '--' );
legendaNaka = [{'CDF das amostras'}];
hold all;
vtm = [1 2 4 6];
xCDF = 10.^(xccdfEst/20);
tam_dist = length(gammainc(1*xCDF.^2,1)); % Tamanho da distribui��o
for ik = 1:length(vtm)%
    im = vtm(ik);
    cdfnaka(ik,1:tam_dist) = gammainc(im*xCDF.^2,im);
    semilogy(20.*log10(xCDF),cdfnaka(ik,:));
    legendaNaka = [legendaNaka ; {['m = ' num2str(vtm(ik))]}];
end
legend(legendaNaka);
axis([-30 10 1e-5 1]);
title('Estudo do fading com o conhecimento da distribui��o');
xlabel('x');
ylabel('F(x)');