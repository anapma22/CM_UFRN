close all;clear all;clc;
%Entrada de par�metros
dR = 150;  %Raio do Hex�gono
dShad = 50;  %Dist�ncia de descorrela��o do shadowing
dPasso = 7;  %Dist�ncia entre pontos de medi��o
dSigmaShad = 8; %Desvio padr�o do sombreamento lognormal
%C�lculos de outras vari�veis que dependem dos par�metros de entrada
dDimXOri = 5*dR; %Dimens�o X do grid
dDimYOri = 6*sqrt(3/4)*dR; %Dimens�o Y do grid

%Matriz de refer�ncia com posi��o de cada ponto do grid (posi��o relativa ao canto inferior esquerdo)
dDimY = ceil(dDimYOri+mod(dDimYOri,dPasso));  %Ajuste de dimens�o para medir toda a dimens�o do grid
dDimX = ceil(dDimXOri+mod(dDimXOri,dPasso));  %Ajuste de dimens�o para medir toda a dimens�o do grid
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
%[mtPosx,mtPosy] = meshgrid(0:7:751, 0:7:782);
mtPontosMedicao = mtPosx + j*mtPosy;

%Matriz de pontos equidistantes de dShad em dShad
dDimYS = ceil(dDimYOri+mod(dDimYOri,dShad)); %Ajuste de dimens�o para medir toda a dimens�o do grid
dDimXS = ceil(dDimXOri+mod(dDimXOri,dShad));
[mtPosxShad,mtPosyShad] = meshgrid(0:dShad:dDimXS, 0:dShad:dDimYS);
%[mtPosxShad,mtPosyShad] = meshgrid(0:50:750, 0:50:809);
mtPosShad = mtPosxShad+j*mtPosyShad;
%Amostras de sombremento para os pontos de grade
mtShadowingSamples = dSigmaShad*randn(size(mtPosyShad));

[dSizel, dSizec] = size(mtPontosMedicao);

for il = 1: dSizel
    for ic = 1: dSizec
        %Ponto de medi��o alvo (vamos localiza-lo no novo grid e plotar os quatro pontos que o circundam) - escolhido ao acaso
        dshadPoint = mtPontosMedicao(il,ic);
        
        %Achar a posi��o do ponto de medi��o na matriz de shadowing correlacionado
        dXIndexP1 = real(dshadPoint)/dShad;
        dYIndexP1 = imag(dshadPoint)/dShad;
        
        %C�lculo dos demais pontos depende de:
        % (i) se o ponto de medi��o � um ponto de shadowing descorrelacionado
        % (i) se o ponto est� na borda lateral direita do grid e no canto superior do grid;
        % (ii) se o ponto est� na borda lateral direita do grid;
        % (iii) se o ponto est� na borda superior do grid;
        % (iv)  se o ponto est� no meio do grid.
        if (mod(dXIndexP1,1) == 0 && mod(dYIndexP1,1) == 0)
            %O ponto de medi��o � um ponto de grade
            dXIndexP1 = floor(dXIndexP1)+1;
            dYIndexP1 = floor(dYIndexP1)+1;
            plot(complex(mtPosShad(dYIndexP1,dXIndexP1)),'g*');
            %Amostra de sombreamento
            mtShadowingCorr(il,ic) = mtShadowingSamples(dYIndexP1,dXIndexP1);
        else
            %�ndice na matriz do primeiro ponto pr�ximo
            dXIndexP1 = floor(dXIndexP1)+1;
            dYIndexP1 = floor(dYIndexP1)+1;
            if (dXIndexP1 == size(mtPosyShad,2)  && dYIndexP1 == size(mtPosyShad,1) )
                %Ponto de medi��o est� na borda da lateral direta do grid e no canto superior
                % P2 - P1
                % |    |
                % P4 - P3
                %
                dXIndexP2 = dXIndexP1-1;
                dYIndexP2 = dYIndexP1;
                dXIndexP4 = dXIndexP1-1;
                dYIndexP4 = dYIndexP1-1;
                dXIndexP3 = dXIndexP1;
                dYIndexP3 = dYIndexP1-1;
                %
            elseif (dXIndexP1 == size(mtPosyShad,2))
                %Ponto de medi��o est� na borda da lateral direta do grid
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
                %Ponto de medi��o est� na borda superior do grid
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
            else
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
            %
            %Dist�ncias para regress�o linear
            dDistX = (mod(real(dshadPoint),dShad))/dShad;
            dDistY = (mod(imag(dshadPoint),dShad))/dShad;
            
            %Desvio padr�o da amostra Xu.
            %Ajuste do desvio padr�o devido a regress�o linear
            dStdNormFactor = sqrt( (1 - 2 * dDistY + 2 * (dDistY^2) )*(1 - 2 * dDistX + 2 * (dDistX^2) ) );
            
            %Calculo do sombreamento via regress�o linear. ISSO � AQUI MESMO? SIM
            %Amostras do sombreamento para os quatro pontos de grade
            dSample1 = mtShadowingSamples(dYIndexP1,dXIndexP1);
            dSample2 = mtShadowingSamples(dYIndexP2,dXIndexP2);
            dSample3 = mtShadowingSamples(dYIndexP3,dXIndexP3);
            dSample4 = mtShadowingSamples(dYIndexP4,dXIndexP4);
            mtShadowingCorr(il,ic) = ( (1-dDistY)*[dSample1*(1-dDistX) + dSample2*(dDistX)] +...
                (dDistY)*[dSample3*(1-dDistX) + dSample4*(dDistX)])/dStdNormFactor;
        end
    end
end
%Plot da superf�cie de atenua��o devido ao sombreamento
%surf( X , Y , Z ) creates a three-dimensional surface plot, which is a three-dimensional surface that has solid edge colors and solid face colors.
surf(mtPosx,mtPosy,mtShadowingCorr)