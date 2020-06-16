% Entrada de par�metros.-
dR = 1e3; %Raio do Hex�gono.
dFc = 800; %Frequ�ncia da portadora.
dSigmaShad = 8; %Desvio padr�o do sombreamento lognormal.

%C�lculos de outras vari�veis que dependem dos par�metros de entrada.
%ceil arredonda o seu argumento para um inteiro maior ou igual ao argumento.
dPasso = ceil(dR/20); %Resolu��o do grid: dist�ncia entre pontos de medi��o.
dRMin = dPasso; %Raio de seguran�a.
dIntersiteDistance = 2*sqrt(3/4)*dR; %Dist�ncia entre ERBs (somente para informa��o).
dDimX = 5*dR; %Dimens�o X do grid.
dDimY = 6*sqrt(3/4)*dR; %Dimens�o Y do grid.
dPtdBm = 57; %EIRP (incluindo ganho e perdas).
dPtLinear = 10^(dPtdBm/10)*1e-3; %EIRP em escala linear.
dHMob = 1.8; %Altura do receptor.
dHBs = 30; %Altura do transmissor.
dAhm = 3.2*(log10(11.75*dHMob)).^2 - 4.97; % Modelo Okumura-Hata: Cidade grande e fc >= 400MHz.

%Vetor com posi��es das BSs (grid Hexagonal com 7 c�lulas, uma c�lula central e uma camada de c�lulas ao redor).
vtBs = [0];
dOffset = pi/6;
for iBs = 2 : 7
    vtBs = [vtBs dR*sqrt(3)*exp(j * ((iBs-2)*pi/3 + dOffset))];
end
vtBs = vtBs + (dDimX/2 + j*dDimY/2); %Ajuste de posi��o das bases (posi��o relativa ao canto inferior esquerdo).

%Matriz de refer�ncia com posi��o de cada ponto do grid (posi��o relativa ao canto inferior esquerdo)
dDimY = ceil(dDimY+mod(dDimY,dPasso));  %Ajuste de dimens�o para medir toda a dimens�o do grid.
dDimX = ceil(dDimX+mod(dDimX,dPasso));  %Ajuste de dimens�o para medir toda a dimens�o do grid.
%[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY) returns 2-D grid coordinates based on the coordinates contained in vectors 0:dPasso:dDimX and 0:dPasso:dDimY.
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
%Inicia��o da Matriz com a m�xima pot�ncia recebida em cada ponto medido. Essa pot�ncia � a maior entre as 7 ERBs.
mtPowerFinaldBm = -inf*ones(size(mtPosy));
mtPowerFinalShaddBm = -inf*ones(size(mtPosy));

%Cria��o de sete matrizes de dist�ncias relativas de cada ponto de medi��o e para cada ERB (matrizes mtDistEachBs).
%Calcular O REM de cada ERB e acumular a maior pot�ncia em cada ponto de medi��o.
for iBsD = 1 : length(vtBs) %Loop nas 7 ERBs.
    %Matriz 3D com os pontos de medi��o de cada ERB. Os pontos s�o modelados como n�meros complexos X +jY, sendo X a posi��o na abcissa e Y, a posi��o no eixo das ordenadas.
    
    %Matrizes de perda de EIRP.
    mtPosEachBS = (mtPosx + j*mtPosy)-(vtBs(iBsD));
    mtDistEachBs = abs(mtPosEachBS); %Dist�ncia entre cada ponto de medi��o e a sua ERB.
    mtDistEachBs(mtDistEachBs < dRMin) = dRMin;  %Implementa��o do raio de seguran�a.
    
    %Matrizes de perda de percurso.
    %Okumura-Hata (cidade urbana) - dB. C�lculo da perda de percurso.
    mtPldB = 69.55 + 26.16*log10(dFc) + (44.9 - 6.55*log10(dHBs))*log10(mtDistEachBs/1e3) - 13.82*log10(dHBs) - dAhm;
    
    %Matrizes de sombreamento.
    %Shadowing independente em cada ponto.
    %dSigmaShad = 8 %Desvio padr�o do sombreamento lognormal.
    %randn(sz) returns an array of random numbers where size vector sz defines size(X). For example, randn([3 4]) returns a 3-by-4 matrix.
    %mtShadowing = 8*randn([105   101]);
    mtShadowing = dSigmaShad*randn(size(mtPosy));
    
    %Pot�ncias recebidas em cada ponto de medi��o sem shadowing.
    mtPowerEachBSdBm = dPtdBm - mtPldB;   %(EIRP)57 - Okumura Hata        
    %Pot�ncias recebidas em cada ponto de medi��o com shadowing.
    mtPowerEachBSShaddBm = dPtdBm - mtPldB + mtShadowing;  
    
    %C�lulo da maior pot�ncia em cada ponto de medi��o sem shadowing.
    %C = max(A,B) returns an array with the largest elements taken from A or B.
    %mtPowerFinaldBm com a maior pot�ncia recebida em cada ponto de medi��o.
    mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBm);
    
    %C�lulo da maior pot�ncia em cada ponto de medi��o com shadowing
    mtPowerFinalShaddBm = max(mtPowerFinalShaddBm,mtPowerEachBSShaddBm);
end

%Plot da REM de todo o grid (composi��o das 7 ERBs) sem shadowing.
figure;
pcolor(mtPosx,mtPosy,mtPowerFinaldBm);
colormap(hsv);
colorbar;
fDrawDeploy(dR,vtBs);
axis equal;
title(['Todas as 7 ERB sem shadowing']);

%Plot da REM de todo o grid (composi��o das 7 ERBs) sem shadowing.
figure;
pcolor(mtPosx,mtPosy,mtPowerFinalShaddBm);
colormap(hsv);
colorbar;
fDrawDeploy(dR,vtBs);
axis equal;
title(['Todas as 7 ERB com shadowing']);