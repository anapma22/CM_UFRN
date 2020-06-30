close all;clear all;clc;
% Entrada de parâmetros
dR = 200;  % Raio do Hexágono
dSigmaShad = 8; % Desvio padrão do sombreamento lognormal
dAlphaCorr = [0:0.2:1];
dShad = 50;
dPasso = 10; 
% Cálculos de outras variáveis que dependem dos parâmetros de entrada
dDimXOri = 5*dR;  % Dimensão X do grid
dDimYOri = 6*sqrt(3/4)*dR;  % Dimensão Y do grid

% Vetor com posições das BSs (grid Hexagonal com 7 células, uma célula central e uma camada de células ao redor)
vtBs = [0];
dOffset = pi/6;
for iBs = 2 : 7
    vtBs = [vtBs dR*sqrt(3)*exp(j * ((iBs-2)*pi/3 + dOffset))];
end
vtBs = vtBs + (dDimXOri/2 + j*dDimYOri/2);  % Ajuste de posição das bases (posição relativa ao canto inferior esquerdo)
% Cálculo de mtPontosMedicao
dDimY = ceil(dDimYOri+mod(dDimYOri,dPasso));  % Ajuste de dimensão para medir toda a dimensão do grid
dDimX = ceil(dDimXOri+mod(dDimXOri,dPasso));  % Ajuste de dimensão para medir toda a dimensão do grid
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
mtPontosMedicao = mtPosx + j*mtPosy;

disp(['O valor de dSgmaShad é: ' num2str(dSigmaShad)]);
% Verificação do desvio padrão 
for idAC = 1 : length(dAlphaCorr)
    % Cálculo do sombreamento correlacionado, aqui tem o desvio padrão igual ao 8
    mtShadowingCorr = fCorrShadowing(mtPontosMedicao,dShad,dAlphaCorr(idAC),dSigmaShad,dDimXOri,dDimYOri);
    disp('******************************************');
    disp(['Para dAlphaCorr = ' num2str(dAlphaCorr(idAC)) ', o sombreamento correlacionado de mtShadowingCorr é = ' num2str(std(mtShadowingCorr(:))) ]);
end

