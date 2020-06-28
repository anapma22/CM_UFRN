# Hands-on 02:Caracterização de canal banda estreita (modelagem e caracterização do desvanecimento de pequena escala)

## Parte 01:Separação dos desvanecimentos de Larga e Pequena escalas
Este projeto tem o objetivo de 
Gerar uma série temporal sintética com Perda de Percurso, Sombreamento e Desvanecimento m-Nakagami;
Estimar cada desvanecimento por meio de regressão linear, filtragem e tratamento estatístico;
Fazer gráficos e comparar as partes geradas sinteticamente e as partes estimadas.

### Prática 01: Criação do sinal sintético

#### Passo 01
Erro gerado pelo Matlab:
>> handson3_P1_1
Error using dlmwrite (line 124)
Cannot open file Prx_sintetico.txt.

Error in handson3_P1_1 (line 63)
dlmwrite([sPar.chFileName '.txt'], [vtDist',vtPrx'], 'delimiter', '\t');

### Prática 02: Estimação do parâmetros do canal
fGeraCanal.m e outro

handson3_P2_1.m

Prática 03: Influência da janela de filtragem para separação dos desvanecimentos de larga e pequena escalas e estimação da distribuição do fading