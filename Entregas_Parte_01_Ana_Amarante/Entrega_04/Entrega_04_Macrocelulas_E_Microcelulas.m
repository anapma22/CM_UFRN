%Entrega 04 - Gr�ficos de microc�lulas e Outage final
clear; close all;
dR = 500;  % Raio do Hex�gono
% dRMicro altera a fun��o fDrawDeploy, mas n�o altera a �rea de outage da microc�lula (nosso principal objetivo aqui)
dRMicro = 100; % Ele foi alterado para 150, pra ficar mais agravel visualmente a posi��o das microc�luas
dFc = [800 1800 2100];  % Frequ�ncias da portadora
dSensitivity = -90; % Sensibilidade
dPasso = 10; % Resolu��o do grid: dist�ncia entre pontos de medi��o
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

% Vetor com posi��es das microc�lulas
vtBsMicro = [0];
dOffsetMicro = pi;
for iBs = 2 : 7 
    vtBsMicro = [vtBsMicro dR*exp(j * ((iBs-2)*pi/3+ dOffsetMicro))];
end
vtBsMicro = vtBsMicro + (dDimXOri/2 + j*dDimYOri/2);  %Ajuste de posi��o das bases (posi��o relativa ao canto inferior esquerdo)
vtBsMicro(1)=[]; % Excluindo o primeiro elemento do vetor, para que n�o tenha nenhuma microc�lula central

% Matriz de refer�ncia com posi��o de cada ponto do grid (posi��o relativa ao canto inferior esquerdo)
dDimY = ceil(dDimYOri+mod(dDimYOri,dPasso));  %Ajuste de dimens�o para medir toda a dimens�o do grid
dDimX = ceil(dDimXOri+mod(dDimXOri,dPasso));  %Ajuste de dimens�o para medir toda a dimens�o do grid
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
mtPontosMedicao = mtPosx + j*mtPosy;


for idFc = 1: length(dFc)
    % Zerando os valores de outage 
    vtdOutRate = [0];
    mtOutRate = 0;
    % Inicia��o da Matriz de com a m�xima pot�ncia recebida  em cada ponto medido. 
    mtPowerFinaldBm = 0;
    mtPowerFinaldBm = -inf*ones(size(mtPosy));
    
    % Macroc�lulas
    for iBsD = 1 : length(vtBs) % Teve adi��o de 6 microc�lulas, 6+7 = 13 c�lulas no total  
        mtPosEachBS = mtPontosMedicao -(vtBs(iBsD));
        mtDistEachBs = abs(mtPosEachBS);  % Dist�ncia entre cada ponto de medi��o e a sua ERB
        mtDistEachBs(mtDistEachBs < dRMin) = dRMin; % Implementa��o do raio de seguran�a 
        % Okumura-Hata (cidade urbana) - dB
        mtPldB = 69.55 + 26.16*log10(dFc(idFc)) + (44.9 - 6.55*log10(dHBs))*log10(mtDistEachBs/1e3) - 13.82*log10(dHBs) - dAhm;
        % Pot�ncias recebidas em cada ponto de medi��o
        mtPowerEachBSdBm = dPtdBm - mtPldB;
        % C�lculo da maior pot�ncia em cada ponto para macroc�lulas
        mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBm);      
    end
    
    % Microc�lulas
    for iBsD = 1 : length(vtBsMicro)
        mtPosEachBSMicro = mtPontosMedicao - (vtBsMicro(iBsD));
        mtDistEachBsMicro = abs(mtPosEachBSMicro);  % Dist�ncia entre cada ponto de medi��o e a sua ERB
        mtDistEachBsMicro(mtDistEachBsMicro < dRMin) = dRMin; % Implementa��o do raio de seguran�a 
        % Perda de percurso para microc�lulas
        mtPldBMicro = 55.5 + 38 * log10(mtDistEachBsMicro / 1e3) + (24.5 + 1.5 * dFc(idFc) / 925) * log10(dFc(idFc));
        % Pot�ncias recebidas em cada ponto de medi��o para microc�lulas
        mtPowerEachBSdBmMicro = dPtdBmMicro - mtPldBMicro;
        % C�lculo da maior pot�ncia em cada ponto para microc�lulas
        mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBmMicro);
     end
        
    % C�lculo de porcentagem de Outage
    vtdOutRate(idFc) = 100*length(find(mtPowerFinaldBm < dSensitivity))/numel(mtPowerFinaldBm);
    disp(['Frequ�ncia da portadora = ' num2str(dFc(idFc))]);
    disp(['Taxa de outage = ' num2str(vtdOutRate(idFc)) ' %']); 
  
   % C�lculo da matriz de Outage
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

    % Plot da �rea de outage para macroc�lulas e microc�lulas com outage
    
        % Plot da �rea de outage para macroc�lulas
    figure;
    pcolor(mtPosx,mtPosy,mtOutRate);
%     c = gray; % Como inverter as cores do colormap: https://www.mathworks.com/help/matlab/ref/gray.html
%     c = flipud(c);    
    colormap (gray); % Caso nenhum dos casos acima, a maior �rea ser� de pot�ncia maior que a m�nima
    colorbar;
    fDrawDeploy(dR,vtBs);
    axis equal;
    title(['Macroc�lulas + Microc�lulas com Outage - Frequ�ncia  = ' num2str(dFc(idFc)) ' MHz']);
    
    % Plot da mtPowerFinaldBm final
    figure;
    pcolor(mtPosx,mtPosy,mtPowerFinaldBm);
    colormap hsv;
    colorbar;
    fDrawDeploy(dR,vtBs);
    fDrawDeploy(dRMicro,vtBsMicro);
    axis equal;
    title(['Pot�ncia final em dBm - Frequ�ncia  = ' num2str(dFc(idFc)) ' MHz']);
end
