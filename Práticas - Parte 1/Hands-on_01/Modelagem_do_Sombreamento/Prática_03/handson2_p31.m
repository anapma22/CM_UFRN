close all;clear all;clc;
% Entrada de par�metros
dR = 200; % Raio do Hex�gono.
dShad = 50; % Dist�ncia de descorrela��o do shadowing, dist entre os pontos na grade.
dPasso = 7; % Dist�ncia entre pontos de medi��o. 
% C�lculos de outras vari�veis que dependem dos par�metros de entrada.
dDimXOri = 5*dR; % Dimens�o X do grid.
dDimYOri = 6*sqrt(3/4)*dR; % Dimens�o Y do grid.

% Matriz de refer�ncia com posi��o de cada ponto do grid (posi��o relativa ao canto inferior esquerdo).
dDimY = ceil(dDimYOri+mod(dDimYOri,dPasso));  % Ajuste de dimens�o para medir toda a dimens�o do grid.
dDimX = ceil(dDimXOri+mod(dDimXOri,dPasso));  % Ajuste de dimens�o para medir toda a dimens�o do grid.
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
mtPontosMedicao = mtPosx + j*mtPosy;

% Defini��o do ponto de medi�ao (quadrado vermelho) nos pontos da grade.
% Ponto de medi��o alvo (vamos localiza-lo no novo grid e plotar os quatro pontos que o circundam) - escolhido ao acaso
dshadPoint = mtPontosMedicao(12,12);

% Matriz de pontos equidistantes de dShad em dShad = ddec.
dDimYS = ceil(dDimYOri+mod(dDimYOri,dShad));  % Ajuste de dimens�o para medir toda a dimens�o do grid.
dDimXS = ceil(dDimXOri+mod(dDimXOri,dShad)); 
[mtPosxShad,mtPosyShad] = meshgrid(0:dShad:dDimXS, 0:dShad:dDimYS);
mtPosShad = mtPosxShad+j*mtPosyShad;

% Achar a posi��o do ponto de medi��o na matriz de shadowing correlacionado.
dXIndexP1 = real(dshadPoint)/dShad;
dYIndexP1 = imag(dshadPoint)/dShad;

% C�lculo dos demais pontos depende de:
% (i) se o ponto de medi��o � um ponto de shadowing descorrelacionado;
% (i) se o ponto est� na borda lateral direita do grid e no canto superior do grid;
% (ii) se o ponto est� na borda lateral direita do grid;
% (iii) se o ponto est� na borda superior do grid;
% (iv)  se o ponto est� no meio do grid.
%Cria uma regra para achar os quatro pontos de grade mais pr�ximos de um dado ponto de medi��o;
if (mod(dXIndexP1,1) == 0 && mod(dYIndexP1,1) == 0)
    %O ponto de medi��o � um ponto de grade.
    dXIndexP1 = floor(dXIndexP1)+1;
    dYIndexP1 = floor(dYIndexP1)+1;
    plot(complex(mtPosShad(dYIndexP1,dXIndexP1)),'g*');
    disp('O ponto de medi��o � um ponto de grade');
else
    % �ndice na matriz do primeiro ponto pr�ximo.
    dXIndexP1 = floor(dXIndexP1)+1;
    dYIndexP1 = floor(dYIndexP1)+1;
    if (dXIndexP1 == size(mtPosyShad,2)  && dYIndexP1 == size(mtPosyShad,1) )
        % Ponto de medi��o est� na borda da lateral direta do grid e no canto superior.
        % P2 - P1
        % |    |
        % P4 - P3
        dXIndexP2 = dXIndexP1-1;
        dYIndexP2 = dYIndexP1;
        dXIndexP4 = dXIndexP1-1;
        dYIndexP4 = dYIndexP1-1;
        dXIndexP3 = dXIndexP1;
        dYIndexP3 = dYIndexP1-1;
        %
    elseif (dXIndexP1 == size(mtPosyShad,2))
        % Ponto de medi��o est� na borda da lateral direta inferior do grid.
        % P4 - P3
        % |    |
        % P2 - P1
        %
        dXIndexP2 = dXIndexP1-1;
        dYIndexP2 = dYIndexP1;
        dXIndexP4 = dXIndexP1-1;
        dYIndexP4 = dYIndexP1+1;
        dXIndexP3 = dXIndexP1;
        dYIndexP3 = dYIndexP1+1;
    elseif (dYIndexP1 == size(mtPosyShad,1))
        % Ponto de medi��o est� na borda superior esquerda do grid.
        % P1 - P2
        % |    |
        % P3 - P4
        %
        dXIndexP2 = dXIndexP1+1;
        dYIndexP2 = dYIndexP1;
        %
        dXIndexP4 = dXIndexP1+1;
        dYIndexP4 = dYIndexP1-1;
        %
        dXIndexP3 = dXIndexP1;
        dYIndexP3 = dYIndexP1-1;
        %
    else % Pulou os outros e veio direto pra esse
        % Ponto de medi��o est� na borda inferior esquerda do grid.
        % P4 - P3
        % |    |
        % P1 - P2
        %
        %
        dXIndexP2 = dXIndexP1+1;
        dYIndexP2 = dYIndexP1;
        %
        dXIndexP4 = dXIndexP1+1;
        dYIndexP4 = dYIndexP1+1;
        %
        dXIndexP3 = dXIndexP1;
        dYIndexP3 = dYIndexP1+1;
    end
    
    % Plot dos pontos de grade.
    plot(complex(mtPosShad),'ko') % Plota v�rias bolinhas pretas de 0 a 1000 nos dois eixos.
    hold on;
    
    %Plot do ponto de medi��o (quadrado vermelho).
    plot(complex(dshadPoint),'sr')
    
    %Plot dos quatro pontos de grade que circundam o ponto de medi��o.
    mt4Poitns = complex([mtPosShad(dYIndexP1,dXIndexP1)...
        mtPosShad(dYIndexP2,dXIndexP2)...
        mtPosShad(dYIndexP3,dXIndexP3) ...
        mtPosShad(dYIndexP4,dXIndexP4)]);
    plot(mt4Poitns,'b*');
    axis equal;
    
    %Zoom nos pontos pr�ximos ao ponto investigado.
    %axis define os limites dos eixos.
    axis([-2*dShad+real(mtPosShad(dYIndexP3,dXIndexP3))...
        2*dShad+real(mtPosShad(dYIndexP4,dXIndexP4))...
        -2*dShad+imag(mtPosShad(dYIndexP3,dXIndexP3))...
        2*dShad+imag(mtPosShad(dYIndexP1,dXIndexP1))]);
    
end
%vem a dist�ncia do quadrado vermelho - dshadPoint, ele � definido la em cima.
%Dist�ncias para regress�o linear.
dDistX = (mod(real(dshadPoint),dShad))/dShad;
dDistY = (mod(imag(dshadPoint),dShad))/dShad;

disp(['X = ' num2str(dDistX) ' e Y = ' num2str(dDistY)])