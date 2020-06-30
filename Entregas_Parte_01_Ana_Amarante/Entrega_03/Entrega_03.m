close all;clear all;clc;
% Entrada de par�metros
dR = 200;  % Raio do Hex�gono
dSigmaShad = 8; % Desvio padr�o do sombreamento lognormal
dAlphaCorr = [0:0.2:1];
dShad = 50;
dPasso = 10; 
% C�lculos de outras vari�veis que dependem dos par�metros de entrada
dDimXOri = 5*dR;  % Dimens�o X do grid
dDimYOri = 6*sqrt(3/4)*dR;  % Dimens�o Y do grid

% Vetor com posi��es das BSs (grid Hexagonal com 7 c�lulas, uma c�lula central e uma camada de c�lulas ao redor)
vtBs = [0];
dOffset = pi/6;
for iBs = 2 : 7
    vtBs = [vtBs dR*sqrt(3)*exp(j * ((iBs-2)*pi/3 + dOffset))];
end
vtBs = vtBs + (dDimXOri/2 + j*dDimYOri/2);  % Ajuste de posi��o das bases (posi��o relativa ao canto inferior esquerdo)
% C�lculo de mtPontosMedicao
dDimY = ceil(dDimYOri+mod(dDimYOri,dPasso));  % Ajuste de dimens�o para medir toda a dimens�o do grid
dDimX = ceil(dDimXOri+mod(dDimXOri,dPasso));  % Ajuste de dimens�o para medir toda a dimens�o do grid
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
mtPontosMedicao = mtPosx + j*mtPosy;

disp(['O valor de dSgmaShad �: ' num2str(dSigmaShad)]);
% Verifica��o do desvio padr�o 
for idAC = 1 : length(dAlphaCorr)
    % C�lculo do sombreamento correlacionado, aqui tem o desvio padr�o igual ao 8
    mtShadowingCorr = fCorrShadowing(mtPontosMedicao,dShad,dAlphaCorr(idAC),dSigmaShad,dDimXOri,dDimYOri);
    disp('******************************************');
    disp(['Para dAlphaCorr = ' num2str(dAlphaCorr(idAC)) ', o sombreamento correlacionado de mtShadowingCorr � = ' num2str(std(mtShadowingCorr(:))) ]);
end

