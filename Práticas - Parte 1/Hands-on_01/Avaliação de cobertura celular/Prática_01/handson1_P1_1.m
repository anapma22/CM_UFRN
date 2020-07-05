dR = 5e3; % Raio do Hexágono
dIntersiteDistance = 2*sqrt(3/4)*dR; % Distância entre ERBs (somente para informação)
dDimX = 5*dR;  % Dimensão X do grid
dDimY = 6*sqrt(3/4)*dR; % Dimensão Y do grid
% Vetor com posições das BSs (grid Hexagonal com 7 células, uma célula central e uma camada de células ao redor)
vtBs = [ 0 ];
dOffset = pi/6;
for iBs = 2 : 7
    vtBs = [ vtBs dR*sqrt(3)*exp( j * ( (iBs-2)*pi/3 + dOffset ) ) ];
end
vtBs = vtBs + (dDimX/2 + j*dDimY/2); % Ajuste de posição das bases (posição relativa ao canto inferior esquerdo)

% Desenha setores hexagonais
fDrawDeploy(dR,vtBs) %grid já criado, com 7 ERBs
axis equal;

%DESENHA 7 HEXAGONOS --> fDrawSector(dR,dCenter); fDrawSector(100,100+50*i)
%DENTRO DE UM GRID --> fDrawDeploy(dR,vtBs); fDrawDeploy(5000,[1.250000000000000e+04 + 1.299038105676658e+04i 2.000000000000000e+04 + 1.732050807568877e+04i 1.250000000000000e+04 + 2.165063509461097e+04i 5.000000000000002e+03 + 1.732050807568878e+04i 4.999999999999998e+03 + 8.660254037844390e+03i 1.250000000000000e+04 + 4.330127018922194e+03i 2.000000000000000e+04 + 8.660254037844390e+03i])

