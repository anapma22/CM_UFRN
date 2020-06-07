% Entrada de par�metros
dR = 5e3;  % Raio do Hex�gono
dFc = 800; % Frequ�ncia da portadora MHz

% C�lculos de outras vari�veis que dependem dos par�metros de entrada
dPasso = ceil(dR/10);  % Resolu��o do grid: dist�ncia entre pontos de medi��o
dRMin = dPasso; % Raio de seguran�a
dIntersiteDistance = 2*sqrt(3/4)*dR;  % Dist�ncia entre ERBs (somente para informa��o)
dDimX = 5*dR;  % Dimens�o X do grid
dDimY = 6*sqrt(3/4)*dR;  % Dimens�o Y do grid
dPtdBm = 57; % EIRP (incluindo ganho e perdas) (https://pt.slideshare.net/naveenjakhar12/gsm-link-budget)
dPtLinear = 10^(dPtdBm/10)*1e-3;  % EIRP em escala linear
dHMob = 5;  % Altura do receptor
dHBs = 30;  % Altura do transmissor
dAhm = 3.2*(log10(11.75*dHMob)).^2 - 4.97;  % Modelo Okumura-Hata: Cidade grande e fc  >= 400MHz


% Vetor com posi��es das BSs (grid Hexagonal com 7 c�lulas, uma c�lula central e uma camada de c�lulas ao redor)
vtBs = [ 0 ];
dOffset = pi/6;

for iBs = 2 : 7
    vtBs = [ vtBs dR*sqrt(3)*exp( j * ( (iBs-2)*pi/3 + dOffset ) ) ];
end
vtBs = vtBs + (dDimX/2 + j*dDimY/2);    % Ajuste de posi��o das bases (posi��o relativa ao canto inferior esquerdo)
%
% Matriz de refer�ncia com posi��o de cada ponto do grid (posi��o relativa ao canto inferior esquerdo)
dDimY = dDimY+mod(dDimY,dPasso);                           % Ajuste de dimens�o para medir toda a dimens�o do grid
dDimX = dDimX+mod(dDimX,dPasso);                           % Ajuste de dimens�o para medir toda a dimens�o do grid
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
%
% Inicia��o da Matriz de  pont�ncia recebida m�xima em cada ponto
% medido. Essa pot�ncia � a maior entre as 7 ERBs.
mtPowerFinaldBm = -inf*ones(size(mtPosy));
% Calcular O REM de cada ERB e aculumar a maior pot�ncia em cada ponto de medi��o
for iBsD = 1 : length(vtBs)                                 % Loop nas 7 ERBs
    % Matriz 3D com os pontos de medi��o de cada ERB. Os pontos s�o
    % modelados como n�meros complexos X +jY, sendo X a posi��o na abcissa e Y, a posi��o no eixo das ordenadas
    mtPosEachBS(:,:,iBsD)=(mtPosx + j*mtPosy)-(vtBs(iBsD));
    mtDistEachBs = abs(mtPosEachBS(:,:,iBsD));              % Dist�ncia entre cada ponto de medi��o e a sua ERB
    mtDistEachBs(mtDistEachBs < dRMin) = dRMin;             % Implementa��o do raio de seguran�a
    % Okumura-Hata (cidade urbana) - dB
    mtPldB = 69.55 + 26.16*log10(dFc) + (44.9 - 6.55*log10(dHBs))*log10(mtDistEachBs/1e3) - 13.82*log10(dHBs) - dAhm;
    mtPowerEachBSdBm(:,:,iBsD) = dPtdBm - mtPldB;           % Pot�ncias recebidas em cada ponto de medi��o
    % Plot da REM de cada ERB individualmente
    figure;
    pcolor(mtPosx,mtPosy,mtPowerEachBSdBm(:,:,iBsD));
    colorbar;
    % Desenha setores hexagonais
    fDrawDeploy(dR,vtBs)
    axis equal;
    title(['ERB ' num2str(iBsD)]);
    % C�lulo da maior pot�ncia em cada ponto de medi��o
    mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBm(:,:,iBsD));
end
% Plot da REM de todo o grid (composi��o das 7 ERBs)
figure;
pcolor(mtPosx,mtPosy,mtPowerFinaldBm);
colorbar;
fDrawDeploy(dR,vtBs);
axis equal;
title(['Todas as 7 ERB']);