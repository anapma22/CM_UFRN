%%file fDrawDeploy.m
function fDrawDeploy(dR,vtBs)
% Desenha setores hexagonais
hold on;
for iBsD = 1 : length(vtBs)
    fDrawSector(dR,vtBs(iBsD));
end
% Plot BSs
plot(vtBs,'sk'); axis equal;
end


%DESENHA UM GRID CELULAR

%grid � uma estrutura geom�trica constitu�da por eixos (comumente horizontais e verticais) 
