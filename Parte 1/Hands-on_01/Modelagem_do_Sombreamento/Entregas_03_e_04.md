# Entrega 03: Comprovação do fator de ajuste do desvio padrão do sombreamento correlacionado
#### Escreva um código para comprovar que o desvio padrão das amostras do sombreamento correlacionado tem o mesmo desvio padrão de entrada dSigmaShad. Comprovar que isso é verdade independente do valor de dAlphaCorr.

#### Verificar se as amostras mtPowerFinalShadCorrdBm tem sombreamento com desvio padrão dSigmaShad para alguns valores de dAlphaCorr.

#### Atenção: Caso o valor não bate, tente modificar o código para corrigir o problema (a priori, ele não existe).

Foi verificado que ```dSigmaShad``` tem o valor 8, logo, o desvio padrão de ```mtShadowingCorr``` também deve ser 8 para atender a entrega.   
Não foi necessário fazer alterações no código para tal, isso pode ser verificado abaixo:
* Para dAlphaCorr = 0:
```
>> std(mtShadowingCorr(:))
ans = 8.0014 
```

* Para dAlphaCorr = 0.5:
```
>> std(mtShadowingCorr(:))
ans = 8.3031  
```

* Para dAlphaCorr = 1:
```
>> std(mtShadowingCorr(:))
ans = 8.0014
```
A diferença entre os valores é no máximo de 3 cadas decimais.

Outro ponto nesta entrega foi verificar se as amostras da matriz ```mtPowerFinalShadCorrdBm``` tem sombreamento com desvio padrão ```dSigmaShad``` para alguns valores de ```dAlphaCorr```. A verificação está abaixo:
* Para dAlphaCorr = 0:
```
>> std(mtPowerFinalShadCorrdBm(:))
ans = 10.2670
```

* Para dAlphaCorr = 0.5:
```
>> std(mtPowerFinalShadCorrdBm(:))
ans = 10.8823  
```

* Para dAlphaCorr = 1:
```
>> std(mtPowerFinalShadCorrdBm(:))
ans = 10.2670  
```
Como é sugerido na prórpia entrega, não foi necessário fazer alterações no código, apenas a variação do ```dAlphaCorr```.  
Lembrando que, não foi feito nenhuma alteração para esta entrega, porém foram feitas alterações na função ```fCorrShadowing.m```, para que a mesma pudesse ser executada.


# Entrega 04: Modelagem e avaliação da inclusão de microcélulas
#### Uma solução tecnológica para tratar problemas de cobertura é o uso de repetidores (microcélulas, picocélulas) com intuito de estender o alcance de uma estrutura macrocelular (torres altas e com alta potência). Considere o uso de microcélulas com as seguintes características:
#### Potência de transmissão: 5W
#### Perda de percurso: COST 231 Walfish-Ikegami NLOS
#### Altura da antena da estação base: 12,5m
#### Altura da antena da estação móvel: 1,5m

#### Posicione seis (somente seis) microcélulas em pontos estratégicos escolhidos por você. Deve ficar claro no seu relatório a razão do posicionamento escolhido por você.    
#### Para isso, ainda sem as microcélulas, monte um REM somente de duas cores, identificando:  
#### (i) a área de Outage do mapa (cor 1); 
#### (ii) área com potência maior que a mínima (cor 2). 
#### Analise esse gráfico e decida qual o melhor posicionamento da suas seis microcélulas. Inclua esse REM no seu relatório. Faça o mesmo REM com a inclusão das microcélulas. Inclua também esse REM no seu relatório.

#### A figura a seguir mostra um exemplo de posicionamento de seis microcélulas. Será que algumas dessas posições são realmente as mais aconselhadas para resolver o problema da Outage?

Este modelo considera explicitamente importantes mecanismos de propagação presentes em ambiente urbano, tendo como vantagem a precisão que ele ofere. Porém, para obter essa precisão é necessário ter várias características geométricas do ambiente, como desvantagem temos que essas características nem sempre estão presentes na base de
dados.
A propagação é no plano vertical, incluindo a ERB e a estação móvel. São desconsideradas reflexões laterais no ambiente.

São consideradas múltiplas difrações em topo de edificações (rooftop to street diffraction e multi-screen diffraction), importante mecanismo em ambiente urbano. Esse modelo de propagação é interessante para microcélulas baixas (nível de postes de
iluminação), cada vez mais utilizados.

O primeiro termo representa a atenuação de espaço livre, o segundo termo a atenuação por difração e dispersão no topo dos edifícios (rooftop to street diffraction and scatter loss) e o terceiro a atenuação já ao nível das ruas devido às múltiplas difrações e reflexões que ocorrem (multi-screen diffraction loss).

O método semi-empírico de Walfisch-Ikegami, é para os casos com visibilidade (LOS) e sem
visibilidade. O segundo é o que foi trabalhado no projeto, o Non Line of Sigh (NLOS) between base and mobile. 

https://repositorio.ufrn.br/jspui/bitstream/123456789/15379/1/CarlosGM_DISSERT.pdf#page=62&zoom=100,109,652

__
Parâmetros usados neste modelo de propagação:
* d = mtDistEachBs/1e3 = Distância ERB-EM, de 0, 02 a 5 km;
* fc = dFc = Frequência de operação na faixa de 800 a 2000 MHz;
* hb = dHBs = Altura da estação rádio base sobre o nível da rua, entre 4 e 50 metros; 
* hm = dHMob = Altura da antena da estação móvel, entre 1 e 3 metros;
* hr = Altura média das edificações, em metros;
* H = (hb – hr) =  altura da antena da ERB, acima das edificações; 
* (hr – hm) = altura da antena da EM, abaixo das edificações;
* D = Separação entre edificações, na faixa de 20 a 50 metros, se não houver informações;
* w = Largura da rua (Utiliza-se d/2, não havendo informações = (mtDistEachBs/1e3)/2);
* Φ = Ângulo de incidência da onda em direção ao nível da rua.


# Dúvida


Na entrega 03, é para fazer uma verificação, sem implementar nada novo no código?
3. A fCorrShadowing.m cria 8 gráficos?

Criar 8 mapas de atenuação de sombreamento (7 para as ERBs e 1 comum) e devolver um mapa do sombreameto de cada ponto de medição, considerando o valor do dAlphaCorr para controlar a correlação do sombreamento entre ERBs;

Na entrega 04, deve ter um REM que identifique a área de Outage e a área com potência maior que a mínima.
 - A potência mínima é a sensibilidade de -104 dBm?
 - A área de Outgate é com p


Mapa gera um gráfico? Na fCorrShadowing.m diz que vai gerar 8 mapas, mas são 8 matrizes.
QUEM É ESSE IMAP??????
Já na entrega 3 também se refere a um mapa, mas fala que é um gráfico.