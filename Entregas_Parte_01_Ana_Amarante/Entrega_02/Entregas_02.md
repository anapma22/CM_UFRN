# Entrega 02: Ajuste do modelo de propagação
* Esta entrega, é a entrega 01, sendo que o modelo de propagação adotado é o COST Hata model (COST 231), que é mais fiel para frequências acima de 900 MHz.
* Como as duas entregas são totalmente relacionados, o mesmo código foi trabalhado para atender os dois modelos de propagação.
* O modelo COST 231 foi calculado conforme aprendemos em [Antenas e Propagação (DCO1006).](https://drive.google.com/file/d/0ByJm8i8ph9tlYzE1ZDhLOG10cnc/view) 

```
**********************************
Frequência da portadora = 800
Raio = 6940
Taxa de outage = 9.9219 %
**********************************
Frequência da portadora = 900
Raio = 6210
Taxa de outage = 9.9983 %
**********************************
Frequência da portadora = 1800
Raio = 3180
Taxa de outage = 9.9006 %
**********************************
Frequência da portadora = 1900
Raio = 3020
Taxa de outage = 9.9826 %
**********************************
Frequência da portadora = 2100
Raio = 2740
Taxa de outage = 9.9615 %
```



Para melhor visualização ente os resultados dos dois modelos, a tabela abaixo foi criada. 
|  Frequência (MHz) | Modelo de Propagação  | Raio obtido  | Taxa de outage (%)  |
|:-:|:-:|:-:|:-:|
|  800  | Okumura-Hata |  8040 |  9.9709 |
|  800  |    COST 231  |  6940 |  9.9219 |
|  900  | Okumura-Hata |  7360 |  9.9922 |
|  900  |     COST 231 |  6210 |  9.9983 |
| 1800  | Okumura-Hata |  4390 |  9.9308 |
| 1800  |    COST 231  |  3180 |  9.9006 |
| 1900  | Okumura-Hata |  4220 |  9.9409 |
| 1900  |     COST 231 |  3020 |  9.9826 |
| 2100  | Okumura-Hata |  3910 |  9.8243 |
| 2100  |    COST 231  |  2740 |  9.9615 |