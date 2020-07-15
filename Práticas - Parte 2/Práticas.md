Objetivos
    Entender a modelagem da multiplexação OFDM;
    Entender o processo de ortogalização entre subportadoras OFDM;
    Entender a modelagem da demultiplexação OFDM;
    Demonstrar o processo de demultiplexação OFDM em canais AWGN.

A entrega devem compor um único arquivo zip com os códigos, o mini-relatório e um arquivo chamado README.txt, indicando como rodar o código produzido por você (produza um código autocontido, no qual o usuário deva rodar um único script para chegar nos resultados desejados). O mini-relatório deve ser técnico (análise dos resultados), mas pode ser administrativo (voltado a comentários sobre a execução do projeto). O arquivo zip deve ser entregue via SIGAA.

Faz parte da entrega a produção de um vídeo no youtube, de no máximo 5 minutos, contendo uma descrição do relatório e do código implementado (explicar brevemente o que foi feito, mostrar as formulações, mostrar como rodar o código e os gráficos gerados). O link do vídeo deve ser informado no mini-relatório. O vídeo é parte bem importante da avaliação.

# Hands-on 1: Multiplexação OFDM (ortogonalidade, transmissão e recepção, desempenho em canal AWGN)

## Transmissão digital por multiplexação de multiportadoras

## Prática 1: Divisão na frequência e ortogonalidade
Passo 01: Abra um script no Matlab, salve-o como handson10_1.m.
Aqui é feito a comprovação da ortogonalidade.


## Prática 2: Transmissão de um sinal OFDM
O experimento dessa prática consiste em gerar um sinal OFDM x com 100 bits pseudoaleatórios, modulação 16-QAM, T=50 segundos e Ts=2 segundos. Desejamos mostrar a forma de onda de x(t) e, em seguida, computar os valores de xn.

## Prática 3: Recepção OFDM
Considere o mesmo sinal gerado na Prática 2, mas supondo que o sinal enviado foi corrompido por um ruído aditivo gaussiano branco (AWGN) de média zero e variância σ2=2.

Quanto maior a variância do ruído, mais espalhados se encontram os sinais recebidos, e maiores são as chances de obtermos erros no bloco de decisão.

# Entrega 01: loopback OFDM em canais AWGN
Faça um loopback de tranmissão e recepção OFDM similar a Prática 3 em Python (ou Matlab) com as seguintes mudanças:

1. Eb/No como variável de entrada. Variar a Eb/No de 0 a 14 dB e calcular a variância do ruído, considerando modulação BPSK e 16-QAM;

 Na minha pesquisa, encontrei esse link (https://www.researchgate.net/post/Noise_power_of_AWGN_is_same_as_noise_variance), que afirma que a variância é igual a potência de ruído.

2. Usar as funções ifft e fft para multiplexar (Tx) e demultiplexar (Rx);
3. Fazer o gráfico da BER vs Eb/No para com OFDM e, no mesmo gráfico, o gráfico da Pe vs Eb/No (fórmula teórica) da modulação BPSK e 16-QAM sem OFDM.


Se você tem Eb/N0 e precisa achar N0, basta então calcular Eb.
Eb pode ser interpretado como a potência do sinal, porém deve ser normalizado para cada símbolo para que seja encontrado a potência de um único símbolo, ao invés do sinal todo. 
Note que é importante que a potência total do sinal também esteja normalizada. Caso contrário, o ruído inserido pode ser bem maior do que o correto.

https://en.wikipedia.org/wiki/Eb/N0
http://www.eletrica.ufpr.br/evelio/TE111/Eb_N0.pdf
https://paginas.fe.up.pt/~sam/Tele2/apontamentos/Modul_7.pdf p7
https://pt.wikipedia.org/wiki/Rela%C3%A7%C3%A3o_sinal-ru%C3%ADdo
http://www.decom.fee.unicamp.br/~baldini/EE881/Cap6.pdf



A variancia da pra calcular pela fórmula, mas pra isso precisa calcular o ruído e pra calcular o ruído precisa saber como calcula o N0, mas não tem N0, então precisa achar N0 a partir de Eb.
Como calcular o Eb? Temos o Eb/N0