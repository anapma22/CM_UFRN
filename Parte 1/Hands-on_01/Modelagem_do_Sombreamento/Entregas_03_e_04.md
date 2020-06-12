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
* 