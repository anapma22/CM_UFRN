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
>> handson3_P2_1
Estimação dos parâmetros de larga escala (W = 100):
   Expoente de perda de percurso estimado n = 4.3807
   Desvio padrão do sombreamento estimado = 6.0559
   Média do sombreamento estimado = 0.78599

   

### Prática 03: Influência da janela de filtragem para separação dos desvanecimentos de larga e pequena escalas e estimação da distribuição do fading
handson3_P3_1.m

Canal sintético:
   Média do sombreamento: -0.77808
   Std do sombreamento: 5.8146
   Janela de correlação do sombreamento: 200 amostras
   Expoente de path loss: 4
   m de Nakagami: 4
Estimação dos parâmetros de larga escala (W = 10):
   Expoente de perda de percurso estimado n = 4.1888
   Desvio padrão do sombreamento estimado = 5.8222
   Média do sombreamento estimado = 0.51863
   MSE Shadowing = 2.4616
----
 
Estimação dos parâmetros de larga escala (W = 50):
   Expoente de perda de percurso estimado n = 4.195
   Desvio padrão do sombreamento estimado = 5.7474
   Média do sombreamento estimado = 0.61297
   MSE Shadowing = 2.4057
----
 
Estimação dos parâmetros de larga escala (W = 150):
   Expoente de perda de percurso estimado n = 4.2115
   Desvio padrão do sombreamento estimado = 5.4677
   Média do sombreamento estimado = 0.95587
   MSE Shadowing = 4.1951
----
 
Estimação dos parâmetros de larga escala (W = 200):
   Expoente de perda de percurso estimado n = 4.2199
   Desvio padrão do sombreamento estimado = 5.2705
   Média do sombreamento estimado = 1.1806
   MSE Shadowing = 6.0319
----
 
Estudo na melhor janela de filtragem
   Janelas utilizadas = 10   50  150  200
   Melhor MSE relativo aos valores reais do Shadowing (melhor janela):
      Melhor janela W = 50: MSE Shadowing = 2.4057
   Melhor MSE relativo aos valores reais do Fading:
      Melhor janela W = 50: MSE Shadowing = 0.12747
----------------------------------------------------------------------------------


handson3_P3_2.m

Canal sintético:
   Média do sombreamento: 0.36406
   Std do sombreamento: 5.7802
   Janela de correlação do sombreamento: 200 amostras
   Expoente de path loss: 4
   m de Nakagami: 4
Estimação dos parâmetros de larga escala (W = 10):
   Expoente de perda de percurso estimado n = 4.008
   Desvio padrão do sombreamento estimado = 5.8121
   Média do sombreamento estimado = 0.51989
   MSE Shadowing = 0.48409
----
 
Estimação dos parâmetros de larga escala (W = 50):
   Expoente de perda de percurso estimado n = 4.0058
   Desvio padrão do sombreamento estimado = 5.7512
   Média do sombreamento estimado = 0.61645
   MSE Shadowing = 0.19028
----
 
Estimação dos parâmetros de larga escala (W = 150):
   Expoente de perda de percurso estimado n = 3.9999
   Desvio padrão do sombreamento estimado = 5.5339
   Média do sombreamento estimado = 0.97684
   MSE Shadowing = 1.1248
----
 
Estimação dos parâmetros de larga escala (W = 200):
   Expoente de perda de percurso estimado n = 3.9977
   Desvio padrão do sombreamento estimado = 5.3803
   Média do sombreamento estimado = 1.2106
   MSE Shadowing = 2.4408
----
 
Estudo na melhor janela de filtragem
   Janelas utilizadas = 10   50  150  200
   Melhor MSE relativo aos valores reais do Shadowing (melhor janela):
      Melhor janela W = 50: MSE Shadowing = 0.19028
   Melhor MSE relativo aos valores reais do Fading:
      Melhor janela W = 50: MSE Shadowing = 0.12699
----------------------------------------------------------------------------------
 
MSE da CDF com várias janelas de filtragem com o conhecimento do Fading:
   m = 2, W = 10: MSE Fading = 0.0014162
   m = 2, W = 50: MSE Fading = 0.0010935
   m = 2, W = 150: MSE Fading = 0.00065904
   m = 2, W = 200: MSE Fading = 0.00047872
----
   m = 3, W = 10: MSE Fading = 0.00028936
   m = 3, W = 50: MSE Fading = 0.00014872
   m = 3, W = 150: MSE Fading = 0.00017917
   m = 3, W = 200: MSE Fading = 0.00040264
----
   m = 4, W = 10: MSE Fading = 2.3932e-05
   m = 4, W = 50: MSE Fading = 4.4269e-06
   m = 4, W = 150: MSE Fading = 0.0003256
   m = 4, W = 200: MSE Fading = 0.00079851
----
   m = 5, W = 10: MSE Fading = 2.9383e-05
   m = 5, W = 50: MSE Fading = 9.7767e-05
   m = 5, W = 150: MSE Fading = 0.00062026
   m = 5, W = 200: MSE Fading = 0.0012639
----
   Melhor MSE relativo aos valores reais do fading:
   W = 50 e m = 4: MSE Fading = 4.4269e-06
----------------------------------------------------------------------------------
 

handson3_P3_3.m

Canal sintético:
   Média do sombreamento: -0.1083
   Std do sombreamento: 5.5141
   Janela de correlação do sombreamento: 200 amostras
   Expoente de path loss: 4
   m de Nakagami: 4
 
Estimação do Fading para várias janelas (estudo númerico sem conhecimento a priori do canal)
Resultados com fitdist do Matlab
Janela W = 10
  Nakagami: m = 4.403, omega = 0.99894
  Rice: K = 7.9142
  Rayleigh: sigma = 0.70673
  Weibull: k = 4.5837, lambda = 1.0626
 
Janela W = 50
  Nakagami: m = 4.0459, omega = 0.98836
  Rice: K = 7.0736
  Rayleigh: sigma = 0.70298
  Weibull: k = 4.2908, lambda = 1.0576
 
Janela W = 150
  Nakagami: m = 3.5633, omega = 0.93172
  Rice: K = 6.0199
  Rayleigh: sigma = 0.68254
  Weibull: k = 3.9507, lambda = 1.0269
 
Janela W = 200
  Nakagami: m = 3.1244, omega = 0.90508
  Rice: K = 5.0974
  Rayleigh: sigma = 0.67271
  Weibull: k = 3.6633, lambda = 1.0112
 
>> 


handson3_P3_4.m


sPar = 

         d0: 5
         P0: 0
    nPoints: 10000

Canal sintético:
   Média do sombreamento: 0.13636
   Std do sombreamento: 6.2796
   Janela de correlação do sombreamento: 200 amostras
   Expoente de path loss: 4
   m de Nakagami: 4
 
Estimação do Fading para várias janelas (estudo númerico sem conhecimento a priori do canal)
Resultados com FITMETHIS
Janela W = 10

				Name		Par1		Par2		Par3		LogL		AIC
              Kernel 	 4.088e-02 							 2.573e+02 	 1.808e+05
              rician 	 9.405e-01 	 2.402e-01 				 2.379e+02 	-4.718e+02
              normal 	 9.718e-01 	 2.360e-01 				 2.337e+02 	-4.635e+02
      tlocationscale 	 9.718e-01 	 2.360e-01 	 1.501e+06 	 2.337e+02 	-4.615e+02
            nakagami 	 4.295e+00 	 1.000e+00 				 2.300e+02 	-4.561e+02
                 gev 	-2.180e-01 	 2.302e-01 	 8.811e-01 	 2.226e+02 	-4.391e+02
             weibull 	 1.063e+00 	 4.504e+00 				 1.516e+02 	-2.993e+02
               gamma 	 1.589e+01 	 6.117e-02 				 1.275e+02 	-2.510e+02
            logistic 	 9.701e-01 	 1.355e-01 				 1.209e+02 	-2.378e+02
         loglogistic 	-4.476e-02 	 1.453e-01 				-4.287e+01 	 8.975e+01
           lognormal 	-6.046e-02 	 2.593e-01 				-8.225e+01 	 1.685e+02
    birnbaumsaunders 	 9.394e-01 	 2.621e-01 				-1.039e+02 	 2.118e+02
     inversegaussian 	 9.718e-01 	 1.391e+01 				-1.126e+02 	 2.292e+02
                  ev 	 1.091e+00 	 2.413e-01 				-6.614e+02 	 1.327e+03
            rayleigh 	 7.071e-01 							-3.413e+03 	 6.827e+03
             uniform 	 2.140e-01 	 1.892e+00 				-4.810e+03 	 9.625e+03
                  gp 	-7.596e-01 	 1.437e+00 				-5.605e+03 	 1.121e+04
         exponential 	 9.718e-01 							-9.025e+03 	 1.805e+04
 
Janela W = 50

				Name		Par1		Par2		Par3		LogL		AIC
              Kernel 	 4.233e-02 							-3.410e+01 	 1.744e+05
            nakagami 	 4.003e+00 	 9.920e-01 				-4.361e+01 	 9.122e+01
                 gev 	-1.860e-01 	 2.329e-01 	 8.685e-01 	-6.236e+01 	 1.307e+02
              rician 	 9.315e-01 	 2.493e-01 				-8.254e+01 	 1.691e+02
              normal 	 9.656e-01 	 2.444e-01 				-9.107e+01 	 1.861e+02
      tlocationscale 	 9.656e-01 	 2.444e-01 	 7.494e+05 	-9.107e+01 	 1.881e+02
               gamma 	 1.487e+01 	 6.493e-02 				-1.054e+02 	 2.149e+02
             weibull 	 1.060e+00 	 4.274e+00 				-1.944e+02 	 3.929e+02
            logistic 	 9.612e-01 	 1.403e-01 				-2.000e+02 	 4.039e+02
           lognormal 	-6.905e-02 	 2.670e-01 				-2.729e+02 	 5.497e+02
    birnbaumsaunders 	 9.316e-01 	 2.698e-01 				-2.870e+02 	 5.779e+02
         loglogistic 	-5.528e-02 	 1.510e-01 				-2.878e+02 	 5.796e+02
     inversegaussian 	 9.656e-01 	 1.303e+01 				-2.948e+02 	 5.935e+02
                  ev 	 1.090e+00 	 2.570e-01 				-1.156e+03 	 2.316e+03
            rayleigh 	 7.043e-01 							-3.403e+03 	 6.809e+03
             uniform 	 2.120e-01 	 2.073e+00 				-5.745e+03 	 1.149e+04
                  gp 	-6.553e-01 	 1.358e+00 				-6.023e+03 	 1.205e+04
         exponential 	 9.656e-01 							-8.927e+03 	 1.786e+04
 
Janela W = 150

				Name		Par1		Par2		Par3		LogL		AIC
              Kernel 	 4.282e-02 							-1.244e+02 	 1.708e+05
            nakagami 	 3.726e+00 	 9.466e-01 				-1.380e+02 	 2.801e+02
                 gev 	-1.522e-01 	 2.317e-01 	 8.388e-01 	-1.675e+02 	 3.410e+02
               gamma 	 1.385e+01 	 6.792e-02 				-1.762e+02 	 3.563e+02
              rician 	 9.045e-01 	 2.533e-01 				-2.061e+02 	 4.161e+02
      tlocationscale 	 9.399e-01 	 2.445e-01 	 7.492e+01 	-2.167e+02 	 4.394e+02
              normal 	 9.408e-01 	 2.478e-01 				-2.184e+02 	 4.409e+02
            logistic 	 9.348e-01 	 1.418e-01 				-3.024e+02 	 6.089e+02
           lognormal 	-9.753e-02 	 2.764e-01 				-3.256e+02 	 6.552e+02
             weibull 	 1.035e+00 	 4.069e+00 				-3.315e+02 	 6.670e+02
    birnbaumsaunders 	 9.054e-01 	 2.794e-01 				-3.387e+02 	 6.815e+02
     inversegaussian 	 9.408e-01 	 1.182e+01 				-3.465e+02 	 6.971e+02
         loglogistic 	-8.432e-02 	 1.564e-01 				-3.491e+02 	 7.022e+02
                  ev 	 1.067e+00 	 2.708e-01 				-1.470e+03 	 2.945e+03
            rayleigh 	 6.880e-01 							-3.198e+03 	 6.398e+03
                  gp 	-5.443e-01 	 1.253e+00 				-6.235e+03 	 1.247e+04
             uniform 	 1.868e-01 	 2.302e+00 				-6.855e+03 	 1.371e+04
         exponential 	 9.408e-01 							-8.593e+03 	 1.719e+04
 
Janela W = 200

				Name		Par1		Par2		Par3		LogL		AIC
              Kernel 	 4.364e-02 							-3.262e+02 	 1.671e+05
            nakagami 	 3.449e+00 	 9.217e-01 				-3.468e+02 	 6.976e+02
               gamma 	 1.280e+01 	 7.232e-02 				-3.681e+02 	 7.401e+02
                 gev 	-1.429e-01 	 2.352e-01 	 8.203e-01 	-3.681e+02 	 7.422e+02
              rician 	 8.864e-01 	 2.607e-01 				-4.384e+02 	 8.808e+02
      tlocationscale 	 9.236e-01 	 2.476e-01 	 3.808e+01 	-4.480e+02 	 9.020e+02
              normal 	 9.257e-01 	 2.544e-01 				-4.552e+02 	 9.143e+02
           lognormal 	-1.168e-01 	 2.875e-01 				-5.079e+02 	 1.020e+03
            logistic 	 9.183e-01 	 1.451e-01 				-5.202e+02 	 1.044e+03
    birnbaumsaunders 	 8.881e-01 	 2.909e-01 				-5.203e+02 	 1.045e+03
     inversegaussian 	 9.257e-01 	 1.071e+01 				-5.285e+02 	 1.061e+03
         loglogistic 	-1.035e-01 	 1.629e-01 				-5.387e+02 	 1.081e+03
             weibull 	 1.021e+00 	 3.879e+00 				-5.614e+02 	 1.127e+03
                  ev 	 1.056e+00 	 2.853e-01 				-1.843e+03 	 3.690e+03
            rayleigh 	 6.788e-01 							-3.113e+03 	 6.228e+03
                  gp 	-5.149e-01 	 1.217e+00 				-6.205e+03 	 1.241e+04
             uniform 	 1.779e-01 	 2.364e+00 				-7.117e+03 	 1.424e+04
         exponential 	 9.257e-01 							-8.398e+03 	 1.680e+04




handson3_P3_5.m

Canal sintético:
   Média do sombreamento: -0.97451
   Std do sombreamento: 6.2627
   Janela de correlação do sombreamento: 200 amostras
   Expoente de path loss: 4
   m de Nakagami: 4
 
Janela W = 10
   Distribuição Weibull: k = 0.022853, p-value = 0.00011983
     h = 1 => Rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p < 0.05).
   Distribuição Rician: k = 0.010183, p-value = 0.28836
     h = 0 => Não rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p > 0.05).
   Distribuição Rayleigh: k = 0.26172, p-value = 0
     h = 1 => Rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p < 0.05).
   Distribuição Nakagami: k = 0.020543, p-value = 0.00077462
     h = 1 => Rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p < 0.05).
 
Janela W = 50
   Distribuição Weibull: k = 0.028822, p-value = 4.1105e-07
     h = 1 => Rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p < 0.05).
   Distribuição Rician: k = 0.015771, p-value = 0.019855
     h = 1 => Rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p < 0.05).
   Distribuição Rayleigh: k = 0.24961, p-value = 0
     h = 1 => Rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p < 0.05).
   Distribuição Nakagami: k = 0.0087737, p-value = 0.47203
     h = 0 => Não rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p > 0.05).
 
Janela W = 150
   Distribuição Weibull: k = 0.037834, p-value = 7.9847e-12
     h = 1 => Rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p < 0.05).
   Distribuição Rician: k = 0.028484, p-value = 6.9254e-07
     h = 1 => Rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p < 0.05).
   Distribuição Rayleigh: k = 0.22805, p-value = 0
     h = 1 => Rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p < 0.05).
   Distribuição Nakagami: k = 0.011225, p-value = 0.19766
     h = 0 => Não rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p > 0.05).
 
Janela W = 200
   Distribuição Weibull: k = 0.03943, p-value = 9.7304e-13
     h = 1 => Rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p < 0.05).
   Distribuição Rician: k = 0.034121, p-value = 1.2045e-09
     h = 1 => Rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p < 0.05).
   Distribuição Rayleigh: k = 0.20021, p-value = 7.2197e-318
     h = 1 => Rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p < 0.05).
   Distribuição Nakagami: k = 0.017071, p-value = 0.009823
     h = 1 => Rejeita a hipótese H0 com nível de significância $\alpha$ = 5% (p < 0.05).