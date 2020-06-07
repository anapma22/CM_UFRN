clear all;clc;close all;  % Limpa variáveis, limpa tela e fecha todas as figuras
%#Tudo é limpo aqui.

% Entrada de parâmetros
dR = 5e3; % 	  
%#Após essa linha dr recebe o valor de 5000.

% Cálculos de outras variáveis que dependem dos parâmetros de entrada
dPasso = ceil(dR/10);   % Resolução do grid: distância entre pontos de medição
%#Após essa linha dPasso recebe o valor de 500.

dIntersiteDistance = 2*sqrt(3/4)*dR; % Distância entre ERBs (somente para informação)
%#dIntersiteDistance recebe 8.6603e+03.

dDimX = 5*dR;   % Dimensão X do grid
%dDimX recebe o valor de 2500.
dDimY = 6*sqrt(3/4)*dR;  % Dimensão Y do grid
%dDimY recebe o valor de 2.59801e+04.

% Vetor com posições das BSs (grid Hexagonal com 7 células, uma célula central e uma camada de células ao redor)
vtBs = [ 0 ];
%vtBs recebe 0.

dOffset = pi/6;
%dOffset recebe 0.5236.

%Pra que serve esse primeiro for??? Para implementar o vtBs
for iBs = 2 : 7
    %iBs é iterado aqui
    vtBs = [ vtBs dR*sqrt(3)*exp( j * ( (iBs-2)*pi/3 + dOffset ) ) ]; %vtBs é iterado aqui
end
vtBs = vtBs + (dDimX/2 + j*dDimY/2); % Ajuste de posição das bases 
%                                    (posição relativa ao canto inferior esquerdo)
%

%
% Matriz de referência com posição de cada ponto do grid (posição relativa ao canto inferior esquerdo)
dDimY = dDimY+mod(dDimY,dPasso); % Ajuste de dimensão para medir toda a dimensão do grid
dDimX = dDimX+mod(dDimX,dPasso); % Ajuste de dimensão para medir toda a dimensão do grid
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
%


% Calcular os pontos de medição relativos de cada ERB
for iBsD = 1 : length(vtBs)                                 % Loop nas 7 ERBs
    % Matriz 3D com os pontos de medição de cada ERB. Os pontos são
    % modelados como números complexos X +jY, sendo X a posição na abcissa e Y, a posição no eixo das ordenadas
    mtPosEachBS(:,:,iBsD)=(mtPosx + j*mtPosy)-(vtBs(iBsD));
    % Plot da posição relativa dos pontos de medição de cada ERB individualmente
    figure; %depois da execução desta linha --> imagem em branco 
    plot(mtPosEachBS(:,:,iBsD),'bo'); %depois da execução desta linha --> criado as grades
    hold on;
    fDrawDeploy(dR,vtBs-vtBs(iBsD)) %depois da execução desta linha --> as células são desenhadas %o eixo y foi modificado
    axis equal; %depois da execução desta linha --> img é centralizada
    title(['ERB ' num2str(iBsD)]);%depois da execução desta linha --> titulo
end

%DESENHA AS 7 ERBS, COM 7 CÉLULAS EM CADA, COM DIFERENTES CENTRALIZAÇÕES