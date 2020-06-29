%Entrega 04 - Gráficos de microcélulas e Outage final
clear; close all;
dR = 500;  % Raio do Hexágono
% dRMicro altera a função fDrawDeploy, mas não altera a área de outage da microcélula (nosso principal objetivo aqui)
dRMicro = 100; % Ele foi alterado para 150, pra ficar mais agravel visualmente a posição das microcéluas
dFc = [800 1800 2100];  % Frequências da portadora
dSensitivity = -90; % Sensibilidade
dPasso = 10; % Resolução do grid: distância entre pontos de medição
dRMin = dPasso; % Raio de segurança
dIntersiteDistance = 2*sqrt(3/4)*dR;  % Distância entre ERBs (somente para informação)
dDimXOri = 5*dR;  % Dimensão X do grid
dDimYOri = 6*sqrt(3/4)*dR;  % Dimensão Y do grid
dPtdBm = 21; % EIRP (incluindo ganho e perdas)
dPtLinear = 10^(dPtdBm/10)*1e-3; % EIRP em escala linear
dPtLinearMicro = 0.1; % Potência em W das microcélulas
dPtdBmMicro = 10*log10(dPtLinearMicro*1000);
dHMob = 1.5; % Altura do receptor
dHBs = 32; % Altura do transmissor
dAhm = 3.2*(log10(11.75*dHMob)).^2 - 4.97; % Modelo Okumura-Hata: Cidade grande e fc  >= 400MHz

% Vetor com posições das macrocélulas
vtBs = [0];
dOffset = pi/6;
for iBs = 2 : 7
    vtBs = [vtBs dR*sqrt(3)*exp(j * ((iBs-2)*pi/3 + dOffset))];
end
vtBs = vtBs + (dDimXOri/2 + j*dDimYOri/2);  %Ajuste de posição das bases (posição relativa ao canto inferior esquerdo)

% Vetor com posições das microcélulas
vtBsMicro = [0];
dOffsetMicro = pi;
for iBs = 2 : 7 
    vtBsMicro = [vtBsMicro dR*exp(j * ((iBs-2)*pi/3+ dOffsetMicro))];
end
vtBsMicro = vtBsMicro + (dDimXOri/2 + j*dDimYOri/2);  %Ajuste de posição das bases (posição relativa ao canto inferior esquerdo)
vtBsMicro(1)=[]; % Excluindo o primeiro elemento do vetor, para que não tenha nenhuma microcélula central

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
    mtPowerFinaldBm = 0;
    mtPowerFinaldBm = -inf*ones(size(mtPosy));
    
    % Macrocélulas
    for iBsD = 1 : length(vtBs) % Teve adição de 6 microcélulas, 6+7 = 13 células no total  
        mtPosEachBS = mtPontosMedicao -(vtBs(iBsD));
        mtDistEachBs = abs(mtPosEachBS);  % Distância entre cada ponto de medição e a sua ERB
        mtDistEachBs(mtDistEachBs < dRMin) = dRMin; % Implementação do raio de segurança 
        % Okumura-Hata (cidade urbana) - dB
        mtPldB = 69.55 + 26.16*log10(dFc(idFc)) + (44.9 - 6.55*log10(dHBs))*log10(mtDistEachBs/1e3) - 13.82*log10(dHBs) - dAhm;
        % Potências recebidas em cada ponto de medição
        mtPowerEachBSdBm = dPtdBm - mtPldB;
        % Cálculo da maior potência em cada ponto para macrocélulas
        mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBm);      
    end
    
    % Microcélulas
    for iBsD = 1 : length(vtBsMicro)
        mtPosEachBSMicro = mtPontosMedicao - (vtBsMicro(iBsD));
        mtDistEachBsMicro = abs(mtPosEachBSMicro);  % Distância entre cada ponto de medição e a sua ERB
        mtDistEachBsMicro(mtDistEachBsMicro < dRMin) = dRMin; % Implementação do raio de segurança 
        % Perda de percurso para microcélulas
        mtPldBMicro = 55.5 + 38 * log10(mtDistEachBsMicro / 1e3) + (24.5 + 1.5 * dFc(idFc) / 925) * log10(dFc(idFc));
        % Potências recebidas em cada ponto de medição para microcélulas
        mtPowerEachBSdBmMicro = dPtdBmMicro - mtPldBMicro;
        % Cálculo da maior potência em cada ponto para microcélulas
        mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBmMicro);
     end
        
    % Cálculo de porcentagem de Outage
    vtdOutRate(idFc) = 100*length(find(mtPowerFinaldBm < dSensitivity))/numel(mtPowerFinaldBm);
    disp(['Frequência da portadora = ' num2str(dFc(idFc))]);
    disp(['Taxa de outage = ' num2str(vtdOutRate(idFc)) ' %']); 
  
   % Cálculo da matriz de Outage
   [dSizel, dSizec] = size(mtPowerFinaldBm);
   for il=1: dSizel 
       for ic = 1:dSizec
           if mtPowerFinaldBm(il,ic) > dSensitivity
               mtOutRate(il,ic) = 0;
           else
               mtOutRate(il,ic) = 1;
           end
       end
   end

    % Plot da área de outage para macrocélulas e microcélulas com outage
    
        % Plot da área de outage para macrocélulas
    figure;
    pcolor(mtPosx,mtPosy,mtOutRate);
%     c = gray; % Como inverter as cores do colormap: https://www.mathworks.com/help/matlab/ref/gray.html
%     c = flipud(c);    
    colormap (gray); % Caso nenhum dos casos acima, a maior área será de potência maior que a mínima
    colorbar;
    fDrawDeploy(dR,vtBs);
    axis equal;
    title(['Macrocélulas + Microcélulas com Outage - Frequência  = ' num2str(dFc(idFc)) ' MHz']);
    
    % Plot da mtPowerFinaldBm final
    figure;
    pcolor(mtPosx,mtPosy,mtPowerFinaldBm);
    colormap hsv;
    colorbar;
    fDrawDeploy(dR,vtBs);
    fDrawDeploy(dRMicro,vtBsMicro);
    axis equal;
    title(['Potência final em dBm - Frequência  = ' num2str(dFc(idFc)) ' MHz']);
end
