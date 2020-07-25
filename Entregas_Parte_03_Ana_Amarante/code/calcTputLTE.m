clear all; clc; close all;

% Carregando as tabelas em .csv
MCS_TBS = csvread('MCS_TBS.csv'); % Tabela padronizada do Release 10
TBS_PRB = csvread('TBS_PRB.csv'); % Tabela padronizada do Release 10
MCS_Mod_CodRate = csvread('MCS_Mod_CodRate.csv'); % Tabela não padronizada pelo 3GPP

% Parâmetros de entrada do LTE
BW = input('Digite a frequência em MHz: ');
CP = input('CP normal(7) ou estendido(6): ');
MCS = input('Digite o número de MCS: ');
MIMO = input('Digite o MIMO da sequinte forma: Para um MIMO nxn, digite apenas o número n: ');
CA= input('Digite o número de CA: '); 

% Definição do valor de CP
if CP == 7  % Número de RE 
   RE=7*12; 
else
   RE=6*12; % Número de simbolos
end
% Definição dos valores de PRBs de acordo com a BW 
if BW == 1.4
    PRBs = 6;
elseif BW == 3
    PRBs = 15;
elseif BW == 5
    PRBs = 25;
elseif BW == 10
    PRBs = 50;
elseif BW == 15
    PRBs = 75;
elseif BW == 20
    PRBs = 100;
end

% Cálculo do TBS
for i=1:(MCS+1)
    if i == (MCS+1)
        TBS = MCS_TBS(MCS+1,2);
    end
end

% Cálculo do Nbits
TBS = TBS + 2; % Necessário para que o matlab interprete como o valor de linhas com os dados equivalentes
PRBs = PRBs +1; % Necessário para que o matlab interprete como o valor de colunas com os dados equivalentes
for i=1:TBS 
    if TBS == i % Achou a linha com o valor do TBS
        for j=1:PRBs % Percorre as colunas do valor do TBS
            if PRBs == j;
                Nbits = TBS_PRB(TBS,PRBs);
            end
        end
    end
end

% Voltando aos valores originais
TBS = TBS - 2;
PRBs = PRBs - 1;

% Cálculo da taxa de transmissão do LTE (Release 10)  - pela tabela
Tput_tab = Nbits * (CP/7*10^3) * MIMO * CA;

% Definir o valor da modulação e do CodRate
for i=1:(MCS+1)
    if i == (MCS+1)
        Modulation = MCS_Mod_CodRate(MCS+1,2);
        CodRate = MCS_Mod_CodRate(MCS+1,3);
    end
end
     
if Modulation == 2
    QAM = 8;
elseif Modulation == 4
    QAm = 16;
else
    QAM = 64;
end

% Cálculo da taxa de transmissão do LTE (Release 10)  - pela fórmula
Tput_form = CP * PRBs * MIMO * CA * 0.75 * 12 * Modulation * CodRate/(0.5*0.001);