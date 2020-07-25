clear all; clc; close all;

% Carregando as tabelas em .csv
MCS_TBS = csvread('MCS_TBS.csv'); % Tabela padronizada do Release 10
TBS_PRB = csvread('TBS_PRB.csv'); % Tabela padronizada do Release 10
MCS_Mod_CodRate = csvread('MCS_Mod_CodRate.csv'); % Tabela n�o padronizada pelo 3GPP

% Par�metros de entrada do LTE
BW = input('Digite a frequ�ncia em MHz: ');
CP = input('CP normal(7) ou estendido(6): ');
MCS = input('Digite o n�mero de MCS: ');
MIMO = input('Digite o MIMO da sequinte forma: Para um MIMO nxn, digite apenas o n�mero n: ');
CA= input('Digite o n�mero de CA: '); 

% Defini��o do valor de CP
if CP == 7  % N�mero de RE 
   RE=7*12; 
else
   RE=6*12; % N�mero de simbolos
end
% Defini��o dos valores de PRBs de acordo com a BW 
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

% C�lculo do TBS
for i=1:(MCS+1)
    if i == (MCS+1)
        TBS = MCS_TBS(MCS+1,2);
    end
end

% C�lculo do Nbits
TBS = TBS + 2; % Necess�rio para que o matlab interprete como o valor de linhas com os dados equivalentes
PRBs = PRBs +1; % Necess�rio para que o matlab interprete como o valor de colunas com os dados equivalentes
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

% C�lculo da taxa de transmiss�o do LTE (Release 10)  - pela tabela
Tput_tab = Nbits * (CP/7*10^3) * MIMO * CA;

% Definir o valor da modula��o e do CodRate
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

% C�lculo da taxa de transmiss�o do LTE (Release 10)  - pela f�rmula
Tput_form = CP * PRBs * MIMO * CA * 0.75 * 12 * Modulation * CodRate/(0.5*0.001);