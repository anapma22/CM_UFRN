dR = 5e3; %Raio do Hex�gono.
dIntersiteDistance = 2*sqrt(3/4)*dR; %Dist�ncia entre ERBs (somente para informa��o).
dDimX = 5*dR; %Dimens�o X do grid.
dDimY = 6*sqrt(3/4)*dR; %Dimens�o Y do grid.

%Vetor com posi��es das BSs (grid Hexagonal com 7 c�lulas, uma c�lula central e uma camada de c�lulas ao redor).
vtBs = [0];
dOffset = pi/6;
for iBs = 2 : 7
    vtBs = [vtBs dR*sqrt(3)*exp(j * ((iBs-2)*pi/3 + dOffset))];
end
vtBs = vtBs + (dDimX/2 + j*dDimY/2); %Ajuste de posi��o das bases (posi��o relativa ao canto inferior esquerdo).

% Desenha setores hexagonais
fDrawDeploy(dR,vtBs)
axis equal;

%Precisa do vtBs para ser passado como argumento do fDrawDeploy.