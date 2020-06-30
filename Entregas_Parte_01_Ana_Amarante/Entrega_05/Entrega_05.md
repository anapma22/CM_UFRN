# Entrega 5: Análise de uma medição real (caracterização de canais banda estreita)

Tudo até agora foi feito com base em um sinal sintético gerado via simulação. Modifique o código disponibilizado para manipular o arquivo Prx_Real_2020_1.mat e estimar o expoente de perda de percurso e o desvio padrão do sombreamento.

Prx_sintetico.mat foi trocado para Prx_Real_2020_1.mat, ficando da seguinte forma:
sPar.chFileName  = 'Prx_Real_2020_1';

1. Plotar no mesmo gráfico as curvas: 
- potência recebida completa (sujeita ao desvanecimento de larga e pequena escalas) vs distância; *linha azul*
- potência recebida somente sujeita ao path loss estimado vs distância; *linha vermelha*
- potência recebida somente sujeita ao path loss e ao sombreamento estimados vs distância. *linha amarela*
Identificar as linhas por legendas e cores diferentes. *ok*
A curvas devem ser feitas em função da distância percorrida na medição. Use W = 5. *ok, alterei o vtW = [5]; % Definição dos valores de W*

2. Fazer a estimativa para os seguintes valores da janela W = 2, 5, 10. Fazer uma tabela com o seguinte formato:
|  Janela | Desvio padrão do sombreamento estimado  | Média do sombreamento estimado  | Expoente de perda de percurso estimado  |
|:-:|:-:|:-:|:-:|
|  W = 2   | 6.3304 |  0.37393 |  3.4528 |
|  W = 5   | 6.2749 |  0.44941 |  3.4529 |
|  W = 10  | 6.2275 |  0.51562 |  3.4531 |

Canal real:
   Média do sombreamento: 0.15697
   Std do sombreamento: 6.3808
   Janela de correlação do sombreamento: 200 amostras
   Expoente de path loss: 4
   m de Nakagami: 4
Estimação dos parâmetros de larga escala (W = 2):
   Desvio padrão do sombreamento estimado = 6.3304
   Média do sombreamento estimado = 0.37393
   Expoente de perda de percurso estimado n = 3.4528
----
 
Estimação dos parâmetros de larga escala (W = 5):
   Desvio padrão do sombreamento estimado = 6.2749
   Média do sombreamento estimado = 0.44941
   Expoente de perda de percurso estimado n = 3.4529
----
 
Estimação dos parâmetros de larga escala (W = 10):
   Desvio padrão do sombreamento estimado = 6.2275
   Média do sombreamento estimado = 0.51562
   Expoente de perda de percurso estimado n = 3.4531
----