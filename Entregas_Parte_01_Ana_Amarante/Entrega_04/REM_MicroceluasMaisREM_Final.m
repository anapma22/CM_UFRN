% Entrega 04 - Gr�ficos de microc�lulas e Outage final
clear; close all;
dR = 500;  % Raio do Hex�gono
dFc = [800 1800 2100];  % Frequ�ncias da portadora
dSensitivity = -90; % Sensibilidade
dPasso = 50; % Resolu��o do grid: dist�ncia entre pontos de medi��o
dRMin = dPasso; % Raio de seguran�a
dIntersiteDistance = 2*sqrt(3/4)*dR;  % Dist�ncia entre ERBs (somente para informa��o)
dDimXOri = 5*dR;  % Dimens�o X do grid
dDimYOri = 6*sqrt(3/4)*dR;  % Dimens�o Y do grid
dPtdBm = 21; % EIRP (incluindo ganho e perdas)
dPtLinear = 10^(dPtdBm/10)*1e-3; % EIRP em escala linear
dPtLinearMicro = 0.1; % Pot�ncia em W das microc�lulas
dPtdBmMicro = 10*log10(dPtLinearMicro*1000);
dHMob = 1.5; % Altura do receptor
dHBs = 32; % Altura do transmissor
dAhm = 3.2*(log10(11.75*dHMob)).^2 - 4.97; % Modelo Okumura-Hata: Cidade grande e fc  >= 400MHz

% Vetor com posi��es das macroc�lulas
vtBs = [0];
dOffset = pi/6;
for iBs = 2 : 7
    vtBs = [vtBs dR*sqrt(3)*exp(j * ((iBs-2)*pi/3 + dOffset))];
end
vtBs = vtBs + (dDimXOri/2 + j*dDimYOri/2);  %Ajuste de posi��o das bases (posi��o relativa ao canto inferior esquerdo)


dRMicro = 100;
% Vetor com posi��es das BSs (grid Hexagonal com 6 c�lulas, SEM uma c�lula central e uma camada de c�lulas ao redor)
vtBsMicro = [0];
for iBs = 7 :-1:2 % for j=180:-1:1
    % vtBs = [vtBs dR*sqrt(3)*exp(j * ((iBs-2)*pi/3 + dOffset))];
    vtBsMicro = [vtBsMicro dR*exp(j * ((iBs-2)*pi/3+ dOffset))];
end
vtBsMicro = vtBsMicro + (dDimXOri/2 + j*dDimYOri/2);  %Ajuste de posi��o das bases (posi��o relativa ao canto inferior esquerdo)


% Matriz de refer�ncia com posi��o de cada ponto do grid (posi��o relativa ao canto inferior esquerdo)
dDimY = ceil(dDimYOri+mod(dDimYOri,dPasso));  %Ajuste de dimens�o para medir toda a dimens�o do grid
dDimX = ceil(dDimXOri+mod(dDimXOri,dPasso));  %Ajuste de dimens�o para medir toda a dimens�o do grid
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
mtPontosMedicao = mtPosx + j*mtPosy;


for idFc = 1: length(dFc)
    % Zerando os valores de outage 
    vtdOutRate = [0]; 
    % Inicia��o da Matriz de com a m�xima pot�ncia recebida  em cada ponto medido. 
    mtPowerFinaldBm = -inf*ones(size(mtPosy));
    
    %Calcular O REM de cada ERB e acumular a maior pot�ncia em cada ponto de medi��o
    % Okumura-Hata
      for iBsD = 1 : length(vtBs) % Teve adi��o de 6 microc�lulas, 6+7 = 13 c�lulas no total    
          %if iBsD <= 7 % C�lculo de macroc�lulas
              mtPosEachBS = mtPontosMedicao -(vtBs(iBsD));
              mtDistEachBs = abs(mtPosEachBS);  % Dist�ncia entre cada ponto de medi��o e a sua ERB
              mtDistEachBs(mtDistEachBs < dRMin) = dRMin; % Implementa��o do raio de seguran�a 
              % Okumura-Hata (cidade urbana) - dB
              mtPldB = 69.55 + 26.16*log10(dFc(idFc)) + (44.9 - 6.55*log10(dHBs))*log10(mtDistEachBs/1e3) - 13.82*log10(dHBs) - dAhm;
              % Pot�ncias recebidas em cada ponto de medi��o
              mtPowerEachBSdBm = dPtdBm - mtPldB;
              % C�lculo da maior pot�ncia em cada ponto para macroc�lulas
              mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBm);          
%         else % C�lculo de microc�lulas 
%             % Modelo COST 231 Walfisch-Ikegami NLOS 
%             mtPldBMicro = - 65.5 + 38*log10(mtDistEachBs/1e3) + (24.5 + (1.5 * dFc(idFc)/925))*log10(dFc(idFc));
%             % Pot�ncias recebidas em cada ponto de medi��o para microc�lulas
%             mtPowerEachBSdBmMicro = dPtdBmMicro - mtPldBMicro;
%             % C�lculo da maior pot�ncia em cada ponto para microc�lulas
%             mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBmMicro);
%         end
     end
    % Microc�lulas
    for iBsD = 2 : length(vtBsMicro)
        if iBsD == 1
            mtPowerFinaldBm = 0;
        else
            mtPosEachBSMicro = mtPontosMedicao - (vtBsMicro(iBsD));
            mtDistEachBsMicro = abs(mtPosEachBSMicro);  % Dist�ncia entre cada ponto de medi��o e a sua ERB
            mtDistEachBsMicro(mtDistEachBsMicro < dRMin) = dRMin; % Implementa��o do raio de seguran�a 
            % Perda de percurso para microc�lulas
            mtPldBMicro = 55 + 38 * log10(mtDistEachBsMicro/1e3) + (24.5 + (1.5*(dFc(idFc))/925)*log10(dFc(idFc)));
            % Pot�ncias recebidas em cada ponto de medi��o para microc�lulas
            mtPowerEachBSdBmMicro = dPtdBmMicro - mtPldBMicro;
            % C�lculo da maior pot�ncia em cada ponto para microc�lulas
            mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBmMicro);
        end
    end
       
    % C�lculo de porcentagem de Outage
     vtdOutRate(idFc) = 100*length(find(mtPowerFinaldBm < dSensitivity))/numel(mtPowerFinaldBm);
     disp(['Frequ�ncia da portadora = ' num2str(dFc(idFc))]);
     disp(['Taxa de outage = ' num2str(vtdOutRate(idFc)) ' %']);
         
    % C�lculo da matriz de Outage para o plot do Okumura Hata
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
    % Plot da �rea de outage para macroc�lulas
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
    title(['Macroc�lulas com outage - Frequ�ncia  = ' num2str(dFc(idFc)) ' MHz com Outage']);
    %%%%%%%%%%%%%
    
    figure;
    %pcolor(mtPosx,mtPosy,mtOutRate);
    pcolor(mtPosx,mtPosy,mtPowerFinaldBm);
    axis equal;
    fDrawDeploy(dR,vtBs);
    title(['Microc�lulas com outage - Frequ�ncia  = ' num2str(dFc(idFc)) ' MHz com Outage']);
    if mtOutRate == 0
          colormap gray(2);
     else
         c = gray; % Como inverter as cores do colormap: https://www.mathworks.com/help/matlab/ref/gray.html
         c = flipud(c);    
         colorbar;
         fDrawDeploy(dRMicro,vtBsMicro);
    end
end
