## Objetivos
* Ter contato com as especificações de padrões de sistemas 3GPP para o 4G e o 5G;
* Entender e protoipar especificidades das camadas MAC/PHY de sistemas modernos de  Zomunicação móvel;
* Avaliar a capacidade de pico de sistemas de comunicações móveis;
* Comparar diferentes releases do 3GPP quanto a capacidade de pico.

De forma simplista, uma simulação sistêmica pode ser usada para avaliar a capacidade de um sistema existente, comparar sistemas distintos ou testar funcionalidades na fase de concepção (prova de conceito). Este projeto tem como objetivo a avaliação de um sistema de comunicações sem fio quando especificidades das camadas MAC/PHY são modeladas.

## Referências
1. Throughput Calculation for LTE TDD and FDD System [lida]
https://www.slideshare.net/veermalik121/throughput-calculation-for-lte-tdd-and-fdd-system
2. ETSI TS 136 213 V10.1.0 (2011-04) [lida]  p34 e p35
https://www.etsi.org/deliver/etsi_ts/136200_136299/136213/10.01.00_60/ts_136213v100100p.pdf
3. Carrier Aggregation explained
https://www.3gpp.org/technologies/keywords-acronyms/101-carrier-aggregation-explained
4. LTE-Advanced
https://www.3gpp.org/technologies/keywords-acronyms/97-lte-advanced 
5. LTE Throughput Calculator 
http://www.simpletechpost.com/p/throughput-calculator.html
6. Transport Block Size, Throughput and Code rate
http://www.simpletechpost.com/2012/12/transport-block-size-code-rate-protocol.html
7. Understanding LTE-Advanced: Carrier Aggregation
https://www.aglmediagroup.com/wp-content/uploads/2015/03/Understanding-Carrier-Aggregation-150303.pdf
8. LTE FDD System Capacity and Throughput Calculation
http://www.techplayon.com/lte-fdd-system-capacity-and-throughput-calculation/
9. LTE throughput calculator
http://anisimoff.org/eng/lte_throughput_calculator.html
10. How to calculate LTE throughput
http://anisimoff.org/eng/lte_throughput.html
11. Are you still frustrated in calculating DL Throughput (Theoretical) in LTE Advanced TDD ?
http://www.techtrained.com/what-downlink-throughput-theoretical-can-you-achieve-in-lte-advanced-tdd/

report, com um mini-relatório de no máximo 2 páginas com as formulações e explicações de como o cálculo da taxa de pico foi realizado.

## Release 8, as seguintes características se destacam no LTE:
* Largura de banda flexível: 1.4 MHz, 3 MHz, 5 MHz, 10 MHz, 15 MHz e 20 MHz;
* Pico de taxa de transmissão: 300 Mbps no downlink ao usar o MIMO 4x4 e 20 MHz de largura de banda e 64-QAM;
* Rede all-IP com baixo RTT (round trip time): 5 ms de latência de pacotes IP (em condições ideais de rádio).

## Release 10 (LTE-Advanced), as seguintes funcionalidades foram adicionadas:
* Densification (uso de small cells, resultando em um deployment denso em termos de eNBs);
* Relaying;
* MIMO (Downlink 8 x 8 MIMO e Uplink 4 x 4 MIMO);
* Carrier Aggregation (até 100 MHz de banda - 5 portadoras de 20 MHz).

Essas melhorias, principalmente o Carrier Aggregation, possibilitam taxas de transmissão teóricas de 1,5 Gbps (em 100 MHz no Uplink) e 3 Gbps (em 100 MHz no Downlink).

## Carrier Aggregation
Cada CA tem uma Componente Carrier, que é formada pela soma de portadoras com bandas diferentes, podendo ser contíguas ou não (frequências diferentes). O throughput não leva a portadora em consideração e sim a banda.
É pra vê o números de PRBs para 10 e 20 MHz, depois somar o número de PRBs (como soma é o parte do trabalho).

Calcular as diversas taxas de transmissão do LTE (Release 10) é o objetivo desse experimento, incluindo funcionalidades importantes como o Carrier Aggregation. Uma das grandes metas desse projeto é identificar quais os parâmetros de camada PHY influenciam no cálculo da taxa de transmissão de pico dos sistemas LTE-Advanced (releaseR10).

Esse cálculo está muito bem mapeado para o Release 8, ficando como desafio o mapeamento para o Release 10.

Para release 8, o Downlink throughput é calculado baseado na especificação 3GPP 36.213, principalmente pelas tabelas 7.1.7.1-1 e 7.1.7.2.1-1. Outro desafio importante é mapear a norma que tem as tabelas do LTE-Advanced Release 10, e usá-las para a sua calculadora. Será a mesma norma, em sua versão mais atualizada?

Faça uma função chamada **calcTputLTE**, que receba os parâmetros de entrada do LTE e devolva o valor da taxa de transmissão de pico do DL. Existem duas maneiras de calcular a taxa de pico: 
1. Pelas tabelas da norma (que incluem valores mais precisos em relação ao overhead); 
2. Via equações que relacionam a capacidade do PRB e a disponibilidade de PRBs dependendo da banda escolhida. É requisito que o aluno faça das duas formas, tanto pelas normas quanto pelos cálculos.

Para o LTE, construa a calcTputLTE com os seguintes parâmetros de entrada:
1. Número de Component Carriers
2. MIMO (layers)
3. Largura de banda
4. Prefixo cíclico
5. MCS

Downlink Throughput is calculated based on 3GPP specs 36.213, table 7.1.7.1-1 and table 7.1.7.2.1-1. You can use sliders to change the value of MCS or Resource blocks. Please visit 'Transport Block Size, Throughput and code rate' for detailed description
