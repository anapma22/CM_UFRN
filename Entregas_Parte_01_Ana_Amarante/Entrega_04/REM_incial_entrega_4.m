% Para isso, ainda sem as microcélulas, monte um REM somente de duas cores, identificando: 
% (i) a área de Outage do mapa (cor 1); e (ii) área com potência maior que a mínima (cor 2). 
clear; close all;
dR = 500;  %Raio do Hexágono
dFc = [800 1800 2100];  %Frequência da portadora
dSensitivity = -90; % Sensibilidade
dPasso = 50; %Resolução do grid: distância entre pontos de medição
dRMin = dPasso; %Raio de segurança
dIntersiteDistance = 2*sqrt(3/4)*dR;  %Distância entre ERBs (somente para informação)

dDimXOri = 5*dR;  %Dimensão X do grid
dDimYOri = 6*sqrt(3/4)*dR;  %Dimensão Y do grid
dPtdBm = 21; % EIRP (incluindo ganho e perdas)
dPtLinear = 10^(dPtdBm/10)*1e-3; % EIRP em escala linear
dHMob = 1.5; %A ltura do receptor
dHBs = 32; % Altura do transmissor
dAhm = 3.2*(log10(11.75*dHMob)).^2 - 4.97; % Modelo Okumura-Hata: Cidade grande e fc  >= 400MHz

% Vetor com posições das BSs (grid Hexagonal com 7 células, uma célula central e uma camada de células ao redor)
vtBs = [0];
dOffset = pi/6;
for iBs = 2 : 7
    vtBs = [vtBs dR*sqrt(3)*exp(j * ((iBs-2)*pi/3 + dOffset))];
end
vtBs = vtBs + (dDimXOri/2 + j*dDimYOri/2);  %Ajuste de posição das bases (posição relativa ao canto inferior esquerdo)

% Matriz de referência com posição de cada ponto do grid (posição relativa ao canto inferior esquerdo)
dDimY = ceil(dDimYOri+mod(dDimYOri,dPasso));  %Ajuste de dimensão para medir toda a dimensão do grid
dDimX = ceil(dDimXOri+mod(dDimXOri,dPasso));  %Ajuste de dimensão para medir toda a dimensão do grid
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
mtPontosMedicao = mtPosx + j*mtPosy;


for idFc = 1: length(dFc)
    % Zerando os valores de outage 
    vtdOutRate = [0]; 
    mtOutRate = 0;
    % Iniciação da Matriz de com a máxima potência recebida  em cada ponto medido. 
    mtPowerFinaldBm = -inf*ones(size(mtPosy));
    %Calcular O REM de cada ERB e acumular a maior potência em cada ponto de medição
    for iBsD = 1 : length(vtBs) %Loop nas 7 ERBs
        mtPosEachBS = mtPontosMedicao-(vtBs(iBsD));
        mtDistEachBs = abs(mtPosEachBS);  % Distância entre cada ponto de medição e a sua ERB
        mtDistEachBs(mtDistEachBs < dRMin) = dRMin; % Implementação do raio de segurança
        % Okumura-Hata (cidade urbana) - dB
        mtPldB = 69.55 + 26.16*log10(dFc(idFc)) + (44.9 - 6.55*log10(dHBs))*log10(mtDistEachBs/1e3) - 13.82*log10(dHBs) - dAhm;
        % Potências recebidas em cada ponto de medição sem shadowing
        mtPowerEachBSdBm = dPtdBm - mtPldB;
        % Cálculo da maior potência em cada ponto de medição sem shadowing
        mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBm);
    end
    % Cálculo de porcentagem de Outage
    vtdOutRate(idFc) = 100*length(find(mtPowerFinaldBm < dSensitivity))/numel(mtPowerFinaldBm);
    disp(['Frequência da portadora = ' num2str(dFc(idFc))]);
    disp(['Taxa de outage = ' num2str(vtdOutRate(idFc)) ' %']);
        
    % Cálculo da matriz de Outage para o plot, ela terá os valores de
    % mtPowerFinaldBm para os casos menores que a dSensitivity (potência )
    [dSizel, dSizec] = size(mtPowerFinaldBm);
    linha = 1;
    for il=1: dSizel 
        coluna = 1;
        for ic = 1:dSizec
            if mtPowerFinaldBm(il,ic) > dSensitivity
                mtOutRate(linha,coluna) = 0;
            else
                mtOutRate(linha,coluna) = 1;
            end
        coluna = coluna +1;
        end
        linha = linha + 1;
    end
    
    % Plot da área de outage
    figure;
    pcolor(mtPosx,mtPosy,mtOutRate);
    c = gray; % Como inverter as cores do colormap: https://www.mathworks.com/help/matlab/ref/gray.html
    c = flipud(c);    
    colormap (c); % Caso nenhum dos casos acima, a maior área será de potência maior que a mínima
    colorbar;
    fDrawDeploy(dR,vtBs);
    axis equal;
    title(['Frequência  = ' num2str(dFc(idFc)) ' MHz com Outage']);
end


