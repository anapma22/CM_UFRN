%Entrada de par�metros
dR = 200;  %Raio do Hex�gono
dFc = 800;  %Frequ�ncia da portadora
dShad = 50; %Dist�ncia de descorrela��o do shadowing
dSigmaShad = 8; %Desvio padr�o do sombreamento lognormal

%p (rho) --> Correla��o moderada
dAlphaCorr = 0.5; %Coeficiente de correla��o do sombreamento entre ERBs (sombreamento correlacionado)
%Quando rho = 1, n�o existe correla��o do sombreamento entre diferentes ERBs (o sombreamento de cada ERB � 
%independente). 
%Por outro lado, quando rho = 0, o sombreamento � igual para um ponto do esp�ao e qualquer ERB do sistema.


%C�lculos de outras vari�veis que dependem dos par�metros de entrada
%dPasso = ceil(dR/10);   %Resolu��o do grid: dist�ncia entre pontos de medi��o
dPasso = 10; 
dRMin = dPasso; %Raio de seguran�a
dIntersiteDistance = 2*sqrt(3/4)*dR;  %Dist�ncia entre ERBs (somente para informa��o)

%C�lculos de outras vari�veis que dependem dos par�metros de entrada
dDimXOri = 5*dR;  %Dimens�o X do grid
dDimYOri = 6*sqrt(3/4)*dR;  %Dimens�o Y do grid
dPtdBm = 57; %EIRP (incluindo ganho e perdas)
dPtLinear = 10^(dPtdBm/10)*1e-3; %EIRP em escala linear
dHMob = 5; %Altura do receptor
dHBs = 30; %Altura do transmissor
dAhm = 3.2*(log10(11.75*dHMob)).^2 - 4.97; %Modelo Okumura-Hata: Cidade grande e fc  >= 400MHz

%Vetor com posi��es das BSs (grid Hexagonal com 7 c�lulas, uma c�lula central e uma camada de c�lulas ao redor)
vtBs = [0];
dOffset = pi/6;
for iBs = 2 : 7
    vtBs = [vtBs dR*sqrt(3)*exp(j * ((iBs-2)*pi/3 + dOffset))];
end
vtBs = vtBs + (dDimXOri/2 + j*dDimYOri/2);  %Ajuste de posi��o das bases (posi��o relativa ao canto inferior esquerdo)

%Matriz de refer�ncia com posi��o de cada ponto do grid (posi��o relativa ao canto inferior esquerdo)
dDimY = ceil(dDimYOri+mod(dDimYOri,dPasso));  %Ajuste de dimens�o para medir toda a dimens�o do grid
dDimX = ceil(dDimXOri+mod(dDimXOri,dPasso));  %Ajuste de dimens�o para medir toda a dimens�o do grid
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
mtPontosMedicao = mtPosx + j*mtPosy;

%Inicia��o da Matriz de com a m�xima pot�ncia recebida  em cada ponto medido. 
%Essa pot�ncia � a maior entre as 7 ERBs.
%-inf*ones(size(mtPosy)) == matriz 105x101 de valores -inf
mtPowerFinaldBm = -inf*ones(size(mtPosy));
mtPowerFinalShaddBm = -inf*ones(size(mtPosy));
mtPowerFinalShadCorrdBm = -inf*ones(size(mtPosy));

%C�lculo do sombreamento correlacionado
mtShadowingCorr = fCorrShadowing(mtPontosMedicao,dShad,dAlphaCorr,dSigmaShad,dDimXOri,dDimYOri);

%Calcular O REM de cada ERB e acumular a maior pot�ncia em cada ponto de medi��o
for iBsD = 1 : length(vtBs) %Loop nas 7 ERBs
    %Matriz 3D com os pontos de medi��o de cada ERB. Os pontos s�o
    % modelados como n�meros complexos X +jY, sendo X a posi��o na abcissa e Y, a posi��o no eixo das ordenadas
    mtPosEachBS = mtPontosMedicao-(vtBs(iBsD));
    mtDistEachBs = abs(mtPosEachBS);  %Dist�ncia entre cada ponto de medi��o e a sua ERB
    mtDistEachBs(mtDistEachBs < dRMin) = dRMin; %Implementa��o do raio de seguran�a
    
    %Okumura-Hata (cidade urbana) - dB
    mtPldB = 69.55 + 26.16*log10(dFc) + (44.9 - 6.55*log10(dHBs))*log10(mtDistEachBs/1e3) - 13.82*log10(dHBs) - dAhm;
    
    %Shadowing independente em cada ponto
    mtShadowing = dSigmaShad*randn(size(mtPosy));
    %Pot�ncias recebidas em cada ponto de medi��o sem shadowing
    mtPowerEachBSdBm = dPtdBm - mtPldB;
    %Pot�ncias recebidas em cada ponto de medi��o com shadowing
    mtPowerEachBSShaddBm = dPtdBm - mtPldB + mtShadowing;
    %Pot�ncias recebidas em cada ponto de medi��o com shadowing correlacionado
    mtPowerEachBSShadCorrdBm = dPtdBm - mtPldB + mtShadowingCorr(:,:,iBsD);
    %C�lculo da maior pot�ncia em cada ponto de medi��o sem shadowing
    mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBm);
    %C�lculo da maior pot�ncia em cada ponto de medi��o com shadowing
    mtPowerFinalShaddBm = max(mtPowerFinalShaddBm,mtPowerEachBSShaddBm);
    %C�lculo da maior pot�ncia em cada ponto de medi��o com shadowing correlacionado
    mtPowerFinalShadCorrdBm = max(mtPowerFinalShadCorrdBm,mtPowerEachBSShadCorrdBm);
end
%Plot da REM de todo o grid (composi��o das 7 ERBs) sem shadowing
figure;
pcolor(mtPosx,mtPosy,mtPowerFinaldBm);
colormap(hsv);
colorbar;
fDrawDeploy(dR,vtBs);
axis equal;
title(['Todas as 7 ERB sem shadowing']);

%Plot da REM de todo o grid (composi��o das 7 ERBs) sem shadowing
figure;
pcolor(mtPosx,mtPosy,mtPowerFinalShaddBm);
colormap(hsv);
colorbar;
fDrawDeploy(dR,vtBs);
axis equal;
title(['Todas as 7 ERB com shadowing']);

%Cada execu��o de codigo, gera um gr�fico diferente, isso porque as
%matrizes de sombreamento tem o shadowing independente em cada ponto e que
%s�o gerados pela fun��o radn: mtShadowing = dSigmaShad*randn(size(mtPosy));
%Plot da REM de todo o grid (composi��o das 7 ERBs) com shadowing correlacionado
figure;
pcolor(mtPosx,mtPosy,mtPowerFinalShadCorrdBm);
colormap(hsv);
colorbar;
fDrawDeploy(dR,vtBs);
axis equal;
title(['Todas as 7 ERB com shadowing correlacionado']);

%Entrega 3: Comprova��o do fator de ajuste do desvio padr�o do sombreamento descorrelacionado
%Escreva um c�digo para comprovar que o desvio padr�o das amostras do sombreamento correlacionado 
%tem o mesmo desvio padr�o de entrada dSigmaShad. Comprovar que isso � verdade independente do valor
%de dAlphaCorr.