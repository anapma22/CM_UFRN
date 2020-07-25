% function calcTputLTE_ = calcTputLTE(MCS, BW, MIMO, eqtab, prefic)

clear all; clc; close all;
% Carregando as tabelas em .csv
% MCS_TBS = readtable('MCS_TBS.csv', 'HeaderLines',1);  % Pula a primeira linha do csv
% TBS_PRB = readtable('TBS_PRB.csv');  % Pula a primeira linha do csv
MCS_TBS = csvread('MCS_TBS.csv');%, 'HeaderLines',1);  % Pula a primeira linha do csv
TBS_PRB = csvread('TBS_PRB.csv');  % Pula a primeira linha do csv

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
if MCS == 0 % Por quest�es me adapta��o ao c�digo a primeira linha do MCS_TBS.csv foi removida e est� representada neste if
    TBS = 0;
else
    for i=1:MCS 
        if MCS == i;
            TBS = MCS_TBS(i,2);
        end
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
PRBs = PRBs -1;

% C�lculo da taxa de transmiss�o do LTE (Release 10)  - pela tabela
Tput_tab = Nbits * (CP/7*10^3) * MIMO * CA;

if(MCS==0)
    Modulation = 2;
    CodRate = 0.1171875;
elseif(MCS==1)
    Modulation = 2;
    CodRate = 0.15332031;
elseif(MCS==2)
    Modulation = 2;
    CodRate = 0.18847656;
elseif(MCS==3)
    Modulation = 2;
    CodRate = 0.24511719;
elseif(MCS==4)
    Modulation = 2;
    CodRate = 0.3007125;
elseif(MCS==5)
    Modulation = 2;
    CodRate = 0.37011719;
elseif(MCS==6)
    Modulation = 2;
    CodRate = 0.43847656;
elseif(MCS==7)
    Modulation = 2;
    CodRate = 0.51367188;
elseif(MCS==8)
    Modulation = 2;
    CodRate=0.58789063;
elseif(MCS==9)
    Modulation = 2;
    CodRate = 0.66308594;
elseif(MCS==10)
    Modulation = 4;
    CodRate = 0.33203125;
elseif(MCS==11)
    Modulation = 4;
    CodRate = 0.36914063;
elseif(MCS==12)
    Modulation = 4;
    CodRate = 0.42382813;
elseif(MCS==13)
    Modulation = 4;
    CodRate = 0.47851563;
elseif(MCS==14)
    Modulation = 4;
    CodRate = 0.54003906;
elseif(MCS==15)
    Modulation = 4;
    CodRate = 0.6015625;
elseif(MCS==16)
    Modulation = 4;
    CodRate = 0.64257813;
elseif(MCS==17)
    Modulation = 6;
    CodRate = 0.42773438;
elseif(MCS==18)
    Modulation = 6;
    CodRate = 0.45507813;
elseif(MCS==19)
    Modulation = 6;
    CodRate = 0.50488281;
elseif(MCS==20)
    Modulation = 6;
    CodRate = 0.55371094;
elseif(MCS==21)
    Modulation = 6;
    CodRate = 0.6015625;
elseif(MCS==22)
    Modulation = 6;
    CodRate = 0.65039063;
elseif(MCS==23)
    Modulation = 6;
    CodRate = 0.70214844;
elseif(MCS==24)
    Modulation = 6;
    CodRate = 0.75390625;
elseif(MCS==25)
    Modulation = 6;
    CodRate = 0.80273438;
elseif(MCS==26)
    Modulation = 6;
    CodRate = 0.85253906;
elseif(MCS==27)
    Modulation = 6;
    CodRate = 0.88867188;
elseif(MCS==28)
    Modulation = 6;
    CodRate = 0.92578125;
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
