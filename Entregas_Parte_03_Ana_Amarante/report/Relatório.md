## Relatório

## Introdução
1. Mapear SINR em CQI index
    - Norma não define, mas define CQI modulation.  
2. CQI index em MCS index
    - MCS index em TBS index

LTE(Long Term Evolution), 4G. 
Para calcular a taxa de transmissão, é necessário saber o valor da MCS (Modulation and Coding Scheme), responsável pela modulação e taxa de codificação. 
A MCS, por sua vez, é mapeada por meio do CQI (Channel Quality Indicator) index, que tem um valor diferente para cada signal to interference-plus-noise ratio (SINR). O mapeamento do SINR em CQI index está mostrado na Tabela 1, esse mapeamento não é feito pelo 3GPP. **(mas define CQI modulation.)????**
Tabela 1: https://www.semanticscholar.org/paper/Ricean-K-factor-Estimation-based-on-Channel-Quality-Wang/a5ce89af1dd6c0fb52459abdfa8afff1b817e1f3/figure/0

A partir do mapeamento feito na Tabela 1, é possível mapear o CQI index em MCS index. Isto é feito por meio da Tabela 2, que é uma patente. **(tem haver com a padronização do RRM?? o 3GPP padroniza a sinalização, os algoritmos reais do RRM na rede não estão definidos no 3GPP - esses algoritmos podem depender do fornecedor e do operador)????**
Tabela 2: https://patents.patsnap.com/v/US10136451-user-terminal-radio-base-station-and-adaptive-modulation-and-coding-method.html

Com esses dois mapeamentos iniciais, é possível calcular a taxa de pico pelas tabelas da norma (que incluem valores mais precisos em relação ao overhead) e pelas equações que relacionam a capacidade do PRB e a disponibilidade de PRBs dependendo da banda escolhida. Neste experimento, a taxa de pico foi calculada das duas formas.

## Experimento
3. TBS index pega a capacidade dos PRBs
4. TBS index e NPRBs no tamanho dos transport block
    - Coloca a banda na calculadora e a banda que define o número de PRBs.
    - Pega esse valor e calcula a taxa.

O número de PRBs é calculado a partir do valor da banda, retirando 10% desse valor para guarda de banda e o valor de banda efetiva é divido por 180KHz. Logo, temos para 1.4MHz são 6 PRBs, 3MHz são 15 PRBs, 5Mhz são 25 PRBs, 10MHz são 50 PRBs e para 20MHz são 100 PRBs.
O cálculo da taxa pelas tabelas, é feito a partir da Tabela 3: MCS_TBS.csv, que faz o mapeamento entre as MCS index e o Transport Block Size (TBS) index. 
De posse dos números de PRBs e o TBS, se consegue o número de bitsque pode ser transmitido em 1 TTI (=1ms).
Logo, o cálculo pela tabela pode ser feito da seguinte forma:
Tput = Nbits * CP/7 * 10^3 * MIMO * CA

Para calcular a taxa de transmissão pela fórmula, temos as seguintes informações:
- Os parâmetros de entrada são: BW (MHz); Cycle Prefix (normal ou estendido); MCS (de 0 até 28); antenas MIMO e o número de Carrier Aggregation. 

Sabendo que o overhead ocupa 25% da transmissão; 12 é o número de subportadoras em frequência dentro de um RB; a modulação é representada por Modulation = log2(M), com M sendo os valores para distintas amplitudes e a taxa de codificação é calculada por meio da váriavel CodRate, sendo que esta taxa é divida pelo templo de um slot, que é (0.5∗10−3).
Temos que, a fórmula pode ser dada por:
Tput = BW * CP * PRBs * MIMO * CA * 0.75 * 12 * Modulation * CodRate/(0.5∗10−3);

## VALOR NÃO BATE COM O GIT PARA CP NORMAL!!!!!!!!!!
if MenuCP == 2;             %CP = NORMAL
   RE=7*12;                 %Calcula o numero de RE
   CP=7;                    %Salva o valor de simbolos do prefixo ciclico
   fator=1;                 %Fator = 1 para CP normal (sem alteração na tabela)
    
   
elseif MenuCP == 3;         %CP = EXTENDIDO
    RE=6*12;                %Calcula o numero de resource elements
    CP=6;                   %Salva o valor de simbolos do prefixo ciclico     
    fator=0.857;            %Fator = 0.857 para CP extendido (alteração na tabela)
Esse fator multiplica a tabela do Nbits


## Conclusão
Sei que poderia ter manipulado de forma mais eficiente os csv., acabei usando a maneira mais simples que pensei, com laço de repetição devido ao tempo. Mas sei que existem funções que trabalham melhor com esses arquivos. Outra sugestão de melhoria seria montar uma tabela com os valores respectivos de cada Modulação e CodRate para os diferentes valores de MCS e limpar mais o "código".


# Referências 
https://www.etsi.org/deliver/etsi_ts/136200_136299/136213/10.01.00_60/ts_136213v100100p.pdf
http://www.simpletechpost.com/2012/12/transport-block-size-code-rate-protocol.html
Throughput Calculation for LTE TDD and FDD System 
https://www.slideshare.net/veermalik121/throughput-calculation-for-lte-tdd-and-fdd-system
https://www.semanticscholar.org/paper/Ricean-K-factor-Estimation-based-on-Channel-Quality-Wang/a5ce89af1dd6c0fb52459abdfa8afff1b817e1f3/figure/0
https://patents.patsnap.com/v/US10136451-user-terminal-radio-base-station-and-adaptive-modulation-and-coding-method.html
https://www.mathworks.com/help/matlab/ref/csvread.html
http://mtm.ufsc.br/~melissa/arquivos/matlabpet/aula_01.pdf