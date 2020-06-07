clear all;clc;close all;  % Limpa vari�veis, limpa tela e fecha todas as figuras
%#Tudo � limpo aqui.

% Entrada de par�metros
dR = 5e3; % 	  
%#Ap�s essa linha dr recebe o valor de 5000.

% C�lculos de outras vari�veis que dependem dos par�metros de entrada
dPasso = ceil(dR/10);   % Resolu��o do grid: dist�ncia entre pontos de medi��o
%#Ap�s essa linha dPasso recebe o valor de 500.

dIntersiteDistance = 2*sqrt(3/4)*dR; % Dist�ncia entre ERBs (somente para informa��o)
%#dIntersiteDistance recebe 8.6603e+03.

dDimX = 5*dR;   % Dimens�o X do grid
%dDimX recebe o valor de 2500.
dDimY = 6*sqrt(3/4)*dR;  % Dimens�o Y do grid
%dDimY recebe o valor de 2.59801e+04.

% Vetor com posi��es das BSs (grid Hexagonal com 7 c�lulas, uma c�lula central e uma camada de c�lulas ao redor)
vtBs = [ 0 ];
%vtBs recebe 0.

dOffset = pi/6;
%dOffset recebe 0.5236.

%Pra que serve esse primeiro for??? Para implementar o vtBs
for iBs = 2 : 7
    %iBs � iterado aqui
    vtBs = [ vtBs dR*sqrt(3)*exp( j * ( (iBs-2)*pi/3 + dOffset ) ) ]; %vtBs � iterado aqui
end
vtBs = vtBs + (dDimX/2 + j*dDimY/2); % Ajuste de posi��o das bases 
%                                    (posi��o relativa ao canto inferior esquerdo)
%

%
% Matriz de refer�ncia com posi��o de cada ponto do grid (posi��o relativa ao canto inferior esquerdo)
dDimY = dDimY+mod(dDimY,dPasso); % Ajuste de dimens�o para medir toda a dimens�o do grid
dDimX = dDimX+mod(dDimX,dPasso); % Ajuste de dimens�o para medir toda a dimens�o do grid
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
%


% Calcular os pontos de medi��o relativos de cada ERB
for iBsD = 1 : length(vtBs)                                 % Loop nas 7 ERBs
    % Matriz 3D com os pontos de medi��o de cada ERB. Os pontos s�o
    % modelados como n�meros complexos X +jY, sendo X a posi��o na abcissa e Y, a posi��o no eixo das ordenadas
    mtPosEachBS(:,:,iBsD)=(mtPosx + j*mtPosy)-(vtBs(iBsD));
    % Plot da posi��o relativa dos pontos de medi��o de cada ERB individualmente
    figure; %depois da execu��o desta linha --> imagem em branco 
    plot(mtPosEachBS(:,:,iBsD),'bo'); %depois da execu��o desta linha --> criado as grades
    hold on;
    fDrawDeploy(dR,vtBs-vtBs(iBsD)) %depois da execu��o desta linha --> as c�lulas s�o desenhadas %o eixo y foi modificado
    axis equal; %depois da execu��o desta linha --> img � centralizada
    title(['ERB ' num2str(iBsD)]);%depois da execu��o desta linha --> titulo
end

%DESENHA AS 7 ERBS, COM 7 C�LULAS EM CADA, COM DIFERENTES CENTRALIZA��ES