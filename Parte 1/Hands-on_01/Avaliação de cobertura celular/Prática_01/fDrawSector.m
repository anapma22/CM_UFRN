%%file fDrawSector.m

%ERBs macrocelulares com altura de 30 m;
%Estações móveis com altura média de 1,8 m;
%As dimensões do grid celular com as 7 ERBs é 5dR x 6 x ?3/4 dR;
%Para definir a Outage (falha da conexão por falta de potência),
    %a sensibilidade do receptor é considerada igual a -104 dBm;
%EIRP (Effective Isotropic Radiated Power) é 57 dBm;
%Potência recebida será calculada com o modelo de Okumura-Hata para cidades urbanas grandes;
%A frequência da portadora é um parâmetro ajustável denominado dFc;
%Para a potência recebida, todos os pontos menores que uma distância dRMin, 
    %terão potência recebida igual aquela calculada usando dRMin como distância.
%A ideia é calcular a potência recebida em dBm para pontos equidistantes em toda a ára de cobertura. 
    %A distância entre os pontos de medição foi definida como o próximo valor inteiro maior que dR/10. 
    %Esse valor pode ser ajustado para melhor visualizar os Radio Environment Maps (REMs).    

function fDrawSector(dR,dCenter)%dr = raio de cada hexágono; dCenter = 
vtHex=zeros(1,0);
for ie=1:6
    vtHex=[vtHex dR*(cos((ie-1)*pi/3)+j*sin((ie-1)*pi/3))];
end
vtHex=vtHex+dCenter;
vtHexp=[vtHex vtHex(1)];
plot(vtHexp,'k');

%fDrawSector(100,100+50*i)
%DESENHA UM HEXAGONO