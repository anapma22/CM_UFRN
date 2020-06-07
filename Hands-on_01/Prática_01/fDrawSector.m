%%file fDrawSector.m

%ERBs macrocelulares com altura de 30 m;
%Esta��es m�veis com altura m�dia de 1,8 m;
%As dimens�es do grid celular com as 7 ERBs � 5dR x 6 x ?3/4 dR;
%Para definir a Outage (falha da conex�o por falta de pot�ncia),
    %a sensibilidade do receptor � considerada igual a -104 dBm;
%EIRP (Effective Isotropic Radiated Power) � 57 dBm;
%Pot�ncia recebida ser� calculada com o modelo de Okumura-Hata para cidades urbanas grandes;
%A frequ�ncia da portadora � um par�metro ajust�vel denominado dFc;
%Para a pot�ncia recebida, todos os pontos menores que uma dist�ncia dRMin, 
    %ter�o pot�ncia recebida igual aquela calculada usando dRMin como dist�ncia.
%A ideia � calcular a pot�ncia recebida em dBm para pontos equidistantes em toda a �ra de cobertura. 
    %A dist�ncia entre os pontos de medi��o foi definida como o pr�ximo valor inteiro maior que dR/10. 
    %Esse valor pode ser ajustado para melhor visualizar os Radio Environment Maps (REMs).    

function fDrawSector(dR,dCenter)%dr = raio de cada hex�gono; dCenter = 
vtHex=zeros(1,0);
for ie=1:6
    vtHex=[vtHex dR*(cos((ie-1)*pi/3)+j*sin((ie-1)*pi/3))];
end
vtHex=vtHex+dCenter;
vtHexp=[vtHex vtHex(1)];
plot(vtHexp,'k');

%fDrawSector(100,100+50*i)
%DESENHA UM HEXAGONO