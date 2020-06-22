% Para isso, ainda sem as microc�lulas, monte um REM somente de duas cores, identificando: 
% (i) a �rea de Outage do mapa (cor 1); e (ii) �rea com pot�ncia maior que a m�nima (cor 2). 
clear; close all;
dR = 500;  %Raio do Hex�gono
dFc = 800;  %Frequ�ncia da portadora
dSensitivity = -90; % Sensibilidade
dPasso = 50; %Resolu��o do grid: dist�ncia entre pontos de medi��o
dRMin = dPasso; %Raio de seguran�a
dIntersiteDistance = 2*sqrt(3/4)*dR;  %Dist�ncia entre ERBs (somente para informa��o)

dDimXOri = 5*dR;  %Dimens�o X do grid
dDimYOri = 6*sqrt(3/4)*dR;  %Dimens�o Y do grid
dPtdBm = 57; % EIRP (incluindo ganho e perdas)
dPtLinear = 10^(dPtdBm/10)*1e-3; % EIRP em escala linear
dHMob = 1.8; %A ltura do receptor
dHBs = 30; % Altura do transmissor
dAhm = 3.2*(log10(11.75*dHMob)).^2 - 4.97; % Modelo Okumura-Hata: Cidade grande e fc  >= 400MHz

% Vetor com posi��es das BSs (grid Hexagonal com 7 c�lulas, uma c�lula central e uma camada de c�lulas ao redor)
vtBs = [0];
dOffset = pi/6;
for iBs = 2 : 7
    vtBs = [vtBs dR*sqrt(3)*exp(j * ((iBs-2)*pi/3 + dOffset))];
end
vtBs = vtBs + (dDimXOri/2 + j*dDimYOri/2);  %Ajuste de posi��o das bases (posi��o relativa ao canto inferior esquerdo)

% Matriz de refer�ncia com posi��o de cada ponto do grid (posi��o relativa ao canto inferior esquerdo)
dDimY = ceil(dDimYOri+mod(dDimYOri,dPasso));  %Ajuste de dimens�o para medir toda a dimens�o do grid
dDimX = ceil(dDimXOri+mod(dDimXOri,dPasso));  %Ajuste de dimens�o para medir toda a dimens�o do grid
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
mtPontosMedicao = mtPosx + j*mtPosy;
% Inicia��o da Matriz de com a m�xima pot�ncia recebida  em cada ponto medido. 
mtPowerFinaldBm = -inf*ones(size(mtPosy));

%Calcular O REM de cada ERB e acumular a maior pot�ncia em cada ponto de medi��o
for iBsD = 1 : length(vtBs) %Loop nas 7 ERBs
    mtPosEachBS = mtPontosMedicao-(vtBs(iBsD));
    mtDistEachBs = abs(mtPosEachBS);  % Dist�ncia entre cada ponto de medi��o e a sua ERB
    mtDistEachBs(mtDistEachBs < dRMin) = dRMin; % Implementa��o do raio de seguran�a
    % Okumura-Hata (cidade urbana) - dB
    mtPldB = 69.55 + 26.16*log10(dFc) + (44.9 - 6.55*log10(dHBs))*log10(mtDistEachBs/1e3) - 13.82*log10(dHBs) - dAhm;
    % Pot�ncias recebidas em cada ponto de medi��o sem shadowing
    mtPowerEachBSdBm = dPtdBm - mtPldB;
    % C�lculo da maior pot�ncia em cada ponto de medi��o sem shadowing
    mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBm);
end
% C�lculo de porcentagem de Outage
dOutRate = 100*length(find(mtPowerFinaldBm < dSensitivity))/numel(mtPowerFinaldBm);
disp(['Frequ�ncia da portadora = ' num2str(dFc)]);
disp(['Taxa de outage = ' num2str(dOutRate) ' %']);

% C�lculo da matriz de Outage para o plot
[dSizel, dSizec] = size(mtPowerFinaldBm);
linha = 1;
for il=1: dSizel 
    coluna = 1;
    for ic = 1:dSizec
        if mtPowerFinaldBm(il,ic) < dSensitivity
            mtOutRate(linha,coluna) = mtPowerFinaldBm(il,ic);
        else
            mtOutRate(linha,coluna) = 0;
        end
    coluna = coluna +1;
    end
    linha = linha + 1;
end

% Plot da porcentagem da outage
figure;
pcolor(mtPosx,mtPosy,mtOutRate);
if dOutRate >= 100 % Caso o dOutRate seja maior ou igual a 100%, apenas uma cor ser� exibida
    colormap hsv(1);
    legend({'Outage'},'Location','southoutside');
else
    colormap hsv(2);
    legend({'Pot�ncia maior que a m�nima'},'Location','southoutside');
end
fDrawDeploy(dR,vtBs);
axis equal;
title(['Todas as 7 ERB sem shadowing com Outage']);

