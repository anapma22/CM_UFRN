% Entrega 04 - Gráficos de microcélulas e Outage final
clear; close all;
dR = 500;  % Raio do Hexágono
dFc = [800 1800 2100];  % Frequências da portadora
dSensitivity = -90; % Sensibilidade
dPasso = 50; % Resolução do grid: distância entre pontos de medição
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


dRMicro = 100;
% Vetor com posições das BSs (grid Hexagonal com 6 células, SEM uma célula central e uma camada de células ao redor)
vtBsMicro = [0];
for iBs = 7 :-1:2 % for j=180:-1:1
    % vtBs = [vtBs dR*sqrt(3)*exp(j * ((iBs-2)*pi/3 + dOffset))];
    vtBsMicro = [vtBsMicro dR*exp(j * ((iBs-2)*pi/3+ dOffset))];
end
vtBsMicro = vtBsMicro + (dDimXOri/2 + j*dDimYOri/2);  %Ajuste de posição das bases (posição relativa ao canto inferior esquerdo)


% Matriz de referência com posição de cada ponto do grid (posição relativa ao canto inferior esquerdo)
dDimY = ceil(dDimYOri+mod(dDimYOri,dPasso));  %Ajuste de dimensão para medir toda a dimensão do grid
dDimX = ceil(dDimXOri+mod(dDimXOri,dPasso));  %Ajuste de dimensão para medir toda a dimensão do grid
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
mtPontosMedicao = mtPosx + j*mtPosy;


for idFc = 1: length(dFc)
    % Zerando os valores de outage 
    vtdOutRate = [0]; 
    % Iniciação da Matriz de com a máxima potência recebida  em cada ponto medido. 
    mtPowerFinaldBm = -inf*ones(size(mtPosy));
    
    %Calcular O REM de cada ERB e acumular a maior potência em cada ponto de medição
    % Okumura-Hata
      for iBsD = 1 : length(vtBs) % Teve adição de 6 microcélulas, 6+7 = 13 células no total    
          %if iBsD <= 7 % Cálculo de macrocélulas
              mtPosEachBS = mtPontosMedicao -(vtBs(iBsD));
              mtDistEachBs = abs(mtPosEachBS);  % Distância entre cada ponto de medição e a sua ERB
              mtDistEachBs(mtDistEachBs < dRMin) = dRMin; % Implementação do raio de segurança 
              % Okumura-Hata (cidade urbana) - dB
              mtPldB = 69.55 + 26.16*log10(dFc(idFc)) + (44.9 - 6.55*log10(dHBs))*log10(mtDistEachBs/1e3) - 13.82*log10(dHBs) - dAhm;
              % Potências recebidas em cada ponto de medição
              mtPowerEachBSdBm = dPtdBm - mtPldB;
              % Cálculo da maior potência em cada ponto para macrocélulas
              mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBm);          
%         else % Cálculo de microcélulas 
%             % Modelo COST 231 Walfisch-Ikegami NLOS 
%             mtPldBMicro = - 65.5 + 38*log10(mtDistEachBs/1e3) + (24.5 + (1.5 * dFc(idFc)/925))*log10(dFc(idFc));
%             % Potências recebidas em cada ponto de medição para microcélulas
%             mtPowerEachBSdBmMicro = dPtdBmMicro - mtPldBMicro;
%             % Cálculo da maior potência em cada ponto para microcélulas
%             mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBmMicro);
%         end
     end
    % Microcélulas
    for iBsD = 2 : length(vtBsMicro)
        if iBsD == 1
            mtPowerFinaldBm = 0;
        else
            mtPosEachBSMicro = mtPontosMedicao - (vtBsMicro(iBsD));
            mtDistEachBsMicro = abs(mtPosEachBSMicro);  % Distância entre cada ponto de medição e a sua ERB
            mtDistEachBsMicro(mtDistEachBsMicro < dRMin) = dRMin; % Implementação do raio de segurança 
            % Perda de percurso para microcélulas
            mtPldBMicro = 55 + 38 * log10(mtDistEachBsMicro/1e3) + (24.5 + (1.5*(dFc(idFc))/925)*log10(dFc(idFc)));
            % Potências recebidas em cada ponto de medição para microcélulas
            mtPowerEachBSdBmMicro = dPtdBmMicro - mtPldBMicro;
            % Cálculo da maior potência em cada ponto para microcélulas
            mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBmMicro);
        end
    end
       
    % Cálculo de porcentagem de Outage
     vtdOutRate(idFc) = 100*length(find(mtPowerFinaldBm < dSensitivity))/numel(mtPowerFinaldBm);
     disp(['Frequência da portadora = ' num2str(dFc(idFc))]);
     disp(['Taxa de outage = ' num2str(vtdOutRate(idFc)) ' %']);
         
    % Cálculo da matriz de Outage para o plot do Okumura Hata
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
    %%%%%%%%%%%%%
    % Plot da área de outage para macrocélulas
    figure;
    pcolor(mtPosx,mtPosy,mtOutRate);
         if mtOutRate == 0
         colormap gray(2);
    else
        c = gray; % Como inverter as cores do colormap: https://www.mathworks.com/help/matlab/ref/gray.html
        c = flipud(c);    
        colormap (c); 
        colorbar;
    end
    fDrawDeploy(dR,vtBs);
    axis equal;
    title(['Macrocélulas com outage - Frequência  = ' num2str(dFc(idFc)) ' MHz com Outage']);
    %%%%%%%%%%%%%
    
    figure;
    %pcolor(mtPosx,mtPosy,mtOutRate);
    pcolor(mtPosx,mtPosy,mtPowerFinaldBm);
    axis equal;
    fDrawDeploy(dR,vtBs);
    title(['Microcélulas com outage - Frequência  = ' num2str(dFc(idFc)) ' MHz com Outage']);
    if mtOutRate == 0
          colormap gray(2);
     else
         c = gray; % Como inverter as cores do colormap: https://www.mathworks.com/help/matlab/ref/gray.html
         c = flipud(c);    
         colorbar;
         fDrawDeploy(dRMicro,vtBsMicro);
    end
end
