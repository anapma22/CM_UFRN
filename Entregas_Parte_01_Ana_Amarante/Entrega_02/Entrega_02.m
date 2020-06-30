close all;clear all;clc;
% vetor de frequências da portadora MHz.
vtFc = [800 900 1800 1900 2100];
% vetor dos raios, começa em 1000, é incrementado a cada 10 e termina em 12000.
vtdR = [1000:10:12000]; 

for iFc = 1:length(vtFc) % for para percorrer o vetor das frequência, vai ser feito 5x.
    % dFc recebe a posição atual do vtFc.
    dFc = vtFc(iFc);   
    vtdOutRate = [0]; % vetor dos dOutRate, deve ser zerado a cada nova frequência.
    vtdRdOutRate = [0]; % vetor dos raios que acompanham diferentes valores de dOutRates, tb devem ser zerados a cada nova frequência.
    for idR = 1:length(vtdR) % for para percorrer o vetor dos raios (vtdR).
        dR = vtdR(idR); 
        % Cálculos de outras variáveis que dependem dos parâmetros de entrada.
        dPasso = ceil(dR/50);  % Resolução do grid: distância entre pontos de medição.
        dRMin = dPasso;  % Raio de segurança.
        dIntersiteDistance = 2*sqrt(3/4)*dR;  % Distância entre ERBs (somente para informação).
        dDimX = 5*dR;  % Dimensão X do grid.
        dDimY = 6*sqrt(3/4)*dR; % Dimensão Y do grid.
        dPtdBm = 57; % EIRP (incluindo ganho e perdas).
        dPtLinear = 10^(dPtdBm/10)*1e-3;  % EIRP em escala linear.
        dSensitivity = -104; % Sensibilidade do receptor em dBm.
        dHMob = 1.8;   % Altura do receptor.
        dHBs = 30;  % Altura do transmissor.
        dAhm = 3.2*(log10(11.75*dHMob)).^2 - 4.97; % Modelo Okumura-Hata: Cidade grande e fc >= 300MHz.
                                                   % Modelo COST Hata: Cidade grande e fc >= 300MHz.
        % Vetor com posições das BSs (grid Hexagonal com 7 células, uma célula central e uma camada de células ao redor)
        vtBs = [0];
        dOffset = pi/6;
        for iBs = 2:7
            vtBs = [vtBs dR*sqrt(3)*exp(j*((iBs-2)*pi/3 + dOffset))];
        end
        vtBs = vtBs + (dDimX/2 + j*dDimY/2); % Ajuste de posição das bases (posição relativa ao canto inferior esquerdo).
    
        % Matriz de referência com posição de cada ponto do grid (posição relativa ao canto inferior esquerdo).
        dDimY = ceil(dDimY+mod(dDimY,dPasso));  % Ajuste de dimensão para medir toda a dimensão do grid.
        dDimX = ceil(dDimX+mod(dDimX,dPasso));  % Ajuste de dimensão para medir toda a dimensão do grid.
        [mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
    
        % Iniciação da Matriz com a potência máxima recebida em cada ponto medido. Essa potência é a maior entre as 7 ERBs.
        % Ones(size(mtPosy) cria uma matriz de 1 do tamanho de mtPosy: 261x251.
        % -Inf(n) returns an n-by-n matrix of -Inf values: -inf*ones(size(mtPosy)) retorna uma matriz de 261x251 com -inf valores.
        mtPowerFinaldBm = -inf*ones(size(mtPosy));
        
        % Calcular O REM (Radio Environment Maps) de cada ERB e aculumar a maior potência em cada ponto de medição.
        for iBsD = 1:length(vtBs)  % Loop nas 7 ERBs.
            % Matriz 3D com os pontos de medição de cada ERB. Os pontos são modelados como números complexos X +jY, sendo X a posição na abcissa e Y, a posição no eixo das ordenadas.
            mtPosEachBS =(mtPosx + j*mtPosy)-(vtBs(iBsD));
            % Y = abs(X) returns the absolute value of each element in array X. If X is complex, abs(X) returns the complex magnitude.
            mtDistEachBs = abs(mtPosEachBS);   % Distância entre cada ponto de medição e a sua ERB.
            mtDistEachBs(mtDistEachBs < dRMin) = dRMin; % Implementação do raio de segurança.
            % COST Hata (cidade urbana) - dB.
            mtPldB = 46.3 + 33.9*log10(dFc) + 3 + (44.9 - 6.55*log10(dHBs))*log10(mtDistEachBs/1e3) - 13.82*log10(dHBs) - dAhm;      
            mtPowerEachBSdBm = dPtdBm - mtPldB;  %Potências recebidas em cada ponto de medição.
            %Cálculo da maior potência em cada ponto de medição.
            mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBm); 
        end

        % (mtPowerFinaldBm < dSensitivity) retorna uma matriz 261x251 de 1s e 0s.
        % find(mtPowerFinaldBm < dSensitivity) retorna um vetor com 37755. k = find(X) returns a vector containing the linear indices of each nonzero element in array X.
        % numel: Number of array elements.
        % If X is a multidimensional array, then find returns a column vector of the linear indices of the result.
    
        % Outage (limite 10%).
        dOutRate = 100*length(find(mtPowerFinaldBm < dSensitivity))/numel(mtPowerFinaldBm);
        % vtdOutRate(idR) vetor para o OutRate.
        % vtdRdOutRate(idR) vetor para o Raio -- foi necessário criar esse vetor, pois assim os valores de OutRate tem a mesma posição do raio.        
        if (dOutRate <= 10)
            vtdOutRate(idR) = dOutRate;
            vtdRdOutRate(idR) = dR;
        elseif (dOutRate > 10) % caso não seja menor que 10, deve ser preenchido por zero para a posição em questão.
            vtdOutRate(idR) = 0;
            vtdRdOutRate(idR) = 0;
        end  
        % Após esse if, os dois vetores tem as mesmas posições
        % vtdOutRate possui valores menores que 10 e zeros.
        % vtdRdOutRate possui os raios dos respectivos OutRate menores que 10 e zeros.
    end 
    % vtdOutRate e vtdRdOutRate já foram completamente preenchidos para dFc em questão.
          
    % Foram impressos os valores máximos de vtdOutRate e vtdRdOutRate.
    % Precisa ser aqui dentro para mostrar as diferentes frequências.
    disp('**********************************');
    disp(['Frequência da portadora = ' num2str(dFc)]);     
    disp(['Raio = ' num2str(max(vtdRdOutRate))]);
    disp(['Taxa de outage = ' num2str(max(vtdOutRate)) ' %']);
    
end
