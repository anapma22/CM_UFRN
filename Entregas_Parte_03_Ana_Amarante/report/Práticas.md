## Objetivos
* Ter contato com as especificações de padrões de sistemas 3GPP para o 4G e o 5G;
* Entender e protoipar especificidades das camadas MAC/PHY de sistemas modernos de  Zomunicação móvel;
* Avaliar a capacidade de pico de sistemas de comunicações móveis;
* Comparar diferentes releases do 3GPP quanto a capacidade de pico.

De forma simplista, uma simulação sistêmica pode ser usada para avaliar a capacidade de um sistema existente, comparar sistemas distintos ou testar funcionalidades na fase de concepção (prova de conceito). Este projeto tem como objetivo a avaliação de um sistema de comunicações sem fio quando especificidades das camadas MAC/PHY são modeladas.

## Referências
1. Throughput Calculation for LTE TDD and FDD System [lida]
https://www.slideshare.net/veermalik121/throughput-calculation-for-lte-tdd-and-fdd-system
2. ETSI TS 136 213 V10.1.0 (2011-04) [lida]  [p34_e_p35]
https://www.etsi.org/deliver/etsi_ts/136200_136299/136213/10.01.00_60/ts_136213v100100p.pdf
3. Carrier Aggregation explained [lida]
https://www.3gpp.org/technologies/keywords-acronyms/101-carrier-aggregation-explained
4. LTE-Advanced [lida]
https://www.3gpp.org/technologies/keywords-acronyms/97-lte-advanced 
5. LTE Throughput Calculator [lida]
http://www.simpletechpost.com/p/throughput-calculator.html
6. Transport Block Size, Throughput and Code rate [lida] [importante]
http://www.simpletechpost.com/2012/12/transport-block-size-code-rate-protocol.html
7. Understanding LTE-Advanced: Carrier Aggregation [mt_grande_nao_li]
https://www.aglmediagroup.com/wp-content/uploads/2015/03/Understanding-Carrier-Aggregation-150303.pdf
8. LTE FDD System Capacity and Throughput Calculation [Daniel_mandou_esse_artigo_em_outro_link]
http://www.techplayon.com/lte-fdd-system-capacity-and-throughput-calculation/
9. LTE throughput calculator [calculadora_serve_para_comparar]
http://anisimoff.org/eng/lte_throughput_calculator.html
10. How to calculate LTE throughput 
http://anisimoff.org/eng/lte_throughput.html
11. Are you still frustrated in calculating DL Throughput (Theoretical) in LTE Advanced TDD ? [achei_inutil]
http://www.techtrained.com/what-downlink-throughput-theoretical-can-you-achieve-in-lte-advanced-tdd/
12. Análise de Desempenho Experimental de Redes LTEAdvanced Baseadas em MIMO e Agregação de Portadoras [achei_inutil]
http://tede.inatel.br:8080/jspui/bitstream/tede/164/5/0.Disserta%C3%A7%C3%A3o%20T%C3%A9rcio_v20%20-%20OK.pdf

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

## Exemplo de como foi feita uma calculadora do LTE
If we only consider "Uplink direction" and we assume that the UE is already attached to the network, then data is first received by PDCP (Packet data compression protocol) layer. This layer performs compression and ciphering / integrity if applicable. This layer will pass on the data to the next layer i.e. RLC Layer which will concatenate it to one RLC PDU.

RLC layer will concatenate or segment the data coming from PDCP layer into correct block size and forward it to the MAC layer with its own header. Now MAC layer selects the modulation and coding scheme configures the physical layer. The data is now in the shape of transport block size and needed to be transmitted in 1ms subframe.

Now how much bits are transferred in this 1ms transport block size? 
1. It depends on the MCS (modulation and coding scheme) and the number of resource blocks assigned to the UE. We have to refer to the Table 7.1.7.1-1 and Table 7.1.7.2.1-1 from 3GPP 136.213
Table 7.1.7.1-1: Modulation and TBS index table for PDSCH 
Table 7.1.7.2.1-1: Transport block size table (dimension 27×110) 
Lets assume that eNB assigns MCS index 20 and 2 resource blocks (RBs) on the basis of CQI and other information for downlink transmission on PDSCH. Now the value of TBS index is 18 as seen in Table 7.1.7.1-1

2. After knowing the value of TBS index we need to refer to the Table 7.1.7.2.1-1 to find the accurate size of transport block.

3. Now from the Table 7.1.7.2.1-1 the value of Transport block size is 776 bits for ITBS = 18 and NPRB=2.

4. Throughput is simply = Transport block size*(1000) = 776 *1000 = 776000 bits / seconds = 0.77 mbps (Assuming MIMO not used).

5. In simple words, code rate can be defined as how effectively data can be transmitted in 1ms transport block or in other words, it is the ratio of actual amount of bits transmitted to the maximum amount of bits that could be transmitted in one transport block

code rate = (TBS + CRC) / (RE x Bits per RE)
where
TBS = Transport block size as we calculated from Table 7.1.7.2.1-1
CRC = Cyclic redundancy check i.e. Number of bits appended for error detection
RE = Resource elements assigned to PDSCH or PUSCH
Bits per RE = Modulation scheme used

6. While we know the values of TBS, CRC and bits per RE (modulation order), it is not easy to calculate the exact amount of RE used for PDSCH or PUSCH since some of the REs are also used by control channels like PDCCH, PHICH etc
In our case, lets assume that 10% of RE's are assigned for control channels then
TBS = 776
CRC = 24
RE = 2 (RB) x 12 (subcarriers) x 7 (assuming 7 ofdm symbols) x 2 (slots per subframe) x 0.9 (10% assumption as above) = 302 REs
Bits per RE = 6 (Modulation order from table 7.1.7.1-1)
So

code rate = (776 + 24) / (302 * 6 ) = 0.4



## Passo que o prof passou para o trabalho
1. Mapear SINR em CQI index
    - Norma não define, mas define CQI modulation.
2. CQI index em MCS indez
    - MCS index em TBS index
3. TBS index pega a capacidade dos PRBs
4. TBS index e NPRBs no tamanho dos transport block
    - Coloca a banda na calculadora e a banda que define o número de PRBs.
    - Pega esse valor e calcula a taxa.