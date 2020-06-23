% file fCorrShadowing.m
function mtShadowingCorr = fCorrShadowing(mtPoints,dShad,dAlphaCorr,dSigmaShad,dDimXOri,dDimYOri)
% ceil arredonda o seu argumento para um inteiro maior ou igual ao argumento.
dDimYS = ceil(dDimYOri+mod(dDimYOri,dShad));  % Ajuste de dimensão para medir toda a dimensão do grid
dDimXS = ceil(dDimXOri+mod(dDimXOri,dShad));
[mtPosxShad,mtPosyShad] = meshgrid(0:dShad:dDimXS, 0:dShad:dDimYS); % meshgrid: 2-D and 3-D grids
mtPosShad = mtPosxShad+j*mtPosyShad;

% Amostras de sombreamento para os pontos de grade, matrizes com amostras de shadowing independentes
% 7 matrizes para cada ERB e 1 matriz para o ambiente
for iMap = 1:8 % samples - amostras
    mtShadowingSamples(:,:,iMap) = dSigmaShad*randn(size(mtPosyShad)); %QUEM É CHAMADO AQUI???
end

[dSizel, dSizec] = size(mtPoints);
for il = 1: dSizel
    for ic = 1: dSizec
        dshadPoint = mtPoints(il,ic); % Ponto de medição alvo (vamos localiza-lo no novo grid e plotar os quatro pontos que o circundam) - escolhido ao acaso
        % Achar a posição do ponto de medição na matriz de shadowing correlacionado
        dXIndexP1 = real(dshadPoint)/dShad;
        dYIndexP1 = imag(dshadPoint)/dShad;
        
        % Cálculo dos demais pontos depende de:
        % (i) se o ponto de medição é um ponto de shadowing descorrelacionado;
        % (ii) se o ponto está na borda lateral direita do grid e no canto superior do grid;
        % (iii) se o ponto está na borda lateral direita do grid;
        % (iv) se o ponto está na borda superior do grid;
        % (v)  se o ponto está no meio do grid.
        if (mod(dXIndexP1,1) == 0 && mod(dYIndexP1,1) == 0) % (i) O ponto de medição é um ponto de grade
            dXIndexP1 = floor(dXIndexP1)+1;
            dYIndexP1 = floor(dYIndexP1)+1;
            % Amostra de sombreamento do ambiente
            dShadowingC = mtShadowingSamples(dYIndexP1,dXIndexP1,8);
            % Amostra do sombreamento de cada ERB
            for iMap = 1:7
                dShadowingERB = mtShadowingSamples(dYIndexP1,dXIndexP1,iMap);
                % Equação do modelo para o sombreamento correlacionado
                mtShadowingCorr(il,ic,iMap) = sqrt(dAlphaCorr)*dShadowingC + sqrt(1-dAlphaCorr)*dShadowingERB;
            end
        else % Matriz em 2D para pontos que não estão na grade
            % Índice na matriz do primeiro ponto próximo
            dXIndexP1 = floor(dXIndexP1)+1; % Y = floor(X) rounds each element of X to the nearest integer less than or equal to that element.
            dYIndexP1 = floor(dYIndexP1)+1;
            if (dXIndexP1 == size(mtPosyShad,2)  && dYIndexP1 == size(mtPosyShad,1) )
                % (ii) Ponto de medição está na borda da lateral direta superior do grid
                % P2 - P1
                % |    |
                % P4 - P3
                dXIndexP2 = dXIndexP1-1;
                dYIndexP2 = dYIndexP1;
                dXIndexP4 = dXIndexP1-1;
                dYIndexP4 = dYIndexP1-1;
                dXIndexP3 = dXIndexP1;
                dYIndexP3 = dYIndexP1-1;
            elseif (dXIndexP1 == size(mtPosyShad,2))
                % (iii) Ponto de medição está na borda da lateral direta inferior do grid
                % P4 - P3
                % |    |
                % P2 - P1
                dXIndexP2 = dXIndexP1-1;
                dYIndexP2 = dYIndexP1;
                dXIndexP4 = dXIndexP1-1;
                dYIndexP4 = dYIndexP1+1;
                dXIndexP3 = dXIndexP1;
                dYIndexP3 = dYIndexP1+1;
            elseif (dYIndexP1 == size(mtPosyShad,1))
                % (iv) Ponto de medição está na borda superior esquerda do grid
                % P1 - P2
                % |    |
                % P3 - P4
                dXIndexP2 = dXIndexP1+1;
                dYIndexP2 = dYIndexP1;
                dXIndexP4 = dXIndexP1+1;
                dYIndexP4 = dYIndexP1-1;
                dXIndexP3 = dXIndexP1;
                dYIndexP3 = dYIndexP1-1;
            else
                % (v) Ponto de medição está na borda inferior esquerda do grid 
                % P4 - P3
                % |    |
                % P1 - P2
                dXIndexP2 = dXIndexP1+1;
                dYIndexP2 = dYIndexP1;
                dXIndexP4 = dXIndexP1+1;
                dYIndexP4 = dYIndexP1+1;
                dXIndexP3 = dXIndexP1;
                dYIndexP3 = dYIndexP1+1;
            end
            % Distâncias para regressão linear, X e Y são as distâncias horizontal e vertical entre o usuário (ponto de medição)
            dDistX = (mod(real(dshadPoint),dShad))/dShad; % dShad = distância de descorrelação = ddec 
            dDistY = (mod(imag(dshadPoint),dShad))/dShad;
            dStdNormFactor = sqrt((1 - 2 * dDistY + 2 * (dDistY^2))*(1 - 2 * dDistX + 2 * (dDistX^2)));
            % dSamplexn =  XA , XB, XC e XD as amostras de sombreamento dos quatro pontos mais próximos do usuário (ponto de medição)
            dSample1 = mtShadowingSamples(dYIndexP1,dXIndexP1,8);
            dSample2 = mtShadowingSamples(dYIndexP2,dXIndexP2,8);
            dSample3 = mtShadowingSamples(dYIndexP3,dXIndexP3,8);
            dSample4 = mtShadowingSamples(dYIndexP4,dXIndexP4,8);
            % X'u = Xu (ambiente) /dStdNormFactor
            dShadowingC = ((1-dDistY)*[dSample1*(1-dDistX) + dSample2*(dDistX)] +...
                (dDistY)*[dSample3*(1-dDistX) + dSample4*(dDistX)])/dStdNormFactor;
            for iMap = 1:7 % Amostra do sombreamento de cada ERB
                dSample1 = mtShadowingSamples(dYIndexP1,dXIndexP1,iMap);
                dSample2 = mtShadowingSamples(dYIndexP2,dXIndexP2,iMap);
                dSample3 = mtShadowingSamples(dYIndexP3,dXIndexP3,iMap);
                dSample4 = mtShadowingSamples(dYIndexP4,dXIndexP4,iMap);
                %X'u = Xu (ERB e ponto de medição) /dStdNormFactor
                dShadowingERB = ((1-dDistY)*[dSample1*(1-dDistX) + dSample2*(dDistX)] +...
                    (dDistY)*[dSample3*(1-dDistX) + dSample4*(dDistX)])/dStdNormFactor; 
                % Equação do modelo para o sombreamento correlacionado
                mtShadowingCorr(il,ic,iMap) = sqrt(dAlphaCorr)*dShadowingC + sqrt(1-dAlphaCorr)*dShadowingERB;
            end
        end
    end
end
end
