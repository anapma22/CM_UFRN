% Funções geradas automaticamente pelo matlab

function varargout = calcTputLTE(varargin)
% CALCTPUTLTE MATLAB code for calcTputLTE.fig
%      CALCTPUTLTE, by itself, creates a new CALCTPUTLTE or raises the existing
%      singleton*.
%
%      H = CALCTPUTLTE returns the handle to a new CALCTPUTLTE or the handle to
%      the existing singleton*.
%
%      CALCTPUTLTE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCTPUTLTE.M with the given input arguments.
%
%      CALCTPUTLTE('Property','Value',...) creates a new CALCTPUTLTE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calcTputLTE_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calcTputLTE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calcTputLTE

% Last Modified by GUIDE v2.5 25-Jul-2020 19:58:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calcTputLTE_OpeningFcn, ...
                   'gui_OutputFcn',  @calcTputLTE_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before calcTputLTE is made visible.
function calcTputLTE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calcTputLTE (see VARARGIN)

% Choose default command line output for calcTputLTE
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes calcTputLTE wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calcTputLTE_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% Funções modificadas 

%________________________________________________________________________________________________________________________________
% Botão que faz os cálculos
% --- Executes on button press in Button_Calcular.
function Button_Calcular_Callback(hObject, eventdata, handles)
% hObject    handle to Button_Calcular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Todo o cálculo da função calcTputLTE está nesse botão
% Carregando as tabelas em .csv
MCS_TBS = csvread('MCS_TBS.csv'); % Tabela padronizada do Release 10
TBS_PRB = csvread('TBS_PRB.csv'); % Tabela padronizada do Release 10
MCS_Mod_CodRate = csvread('MCS_Mod_CodRate.csv'); % Tabela não padronizada pelo 3GPP, construida a partir das tabelas 1 e 2 que estão na pasta deste arquivo

% Definição dos valores de PRBs de acordo com a BW 
SelectBW = get(handles.Select_BW,'Value'); % Pega os valores do listbox da BW
if SelectBW == 1     % BW == 1.4
    PRBs = 6;
elseif SelectBW == 2 % BW == 3
    PRBs = 15;
elseif SelectBW == 3 % BW == 5
    PRBs = 25;
elseif SelectBW == 4 % BW == 10
    PRBs = 50;
elseif SelectBW == 4 % BW == 15
    PRBs = 75;
elseif SelectBW == 6 % BW == 20
    PRBs = 100;
end
handles.PRBs = PRBs;         
guidata(hObject,handles);  

% Definição do valor de CP e RE
SelectCP = get(handles.Select_CP,'Value'); % Pega os valores do listbox do CP
if SelectCP == 1;      % CP normal Número de RE a ser exibido
   RE=7*12;            % Número de RE
   CP=7;               % 7 simbolos do Cycle Prefix
elseif SelectCP == 2;  % CP estendido
    RE=6*12;                
    CP=6;                       
end
handles.CP = CP;
handles.RE = RE;
guidata(hObject,handles);

% Definição do valor da MCS pelo listbox
SelectMCS = get(handles.Select_MCS,'Value');
MCS = SelectMCS;
handles.MCS = MCS;
guidata(hObject,handles);

% Definição do valor das antenas MIMO
SelectMIMO = get(handles.Select_MIMO,'Value');
if SelectMIMO == 1
    MIMO = 1;
elseif SelectMIMO == 2
    MIMO = 2;
elseif SelectMIMO == 3
    MIMO = 4;
else
    MIMO = 8;
end
handles.MIMO = MIMO;
guidata(hObject,handles);

% Definição do valor da Carrier Aggregation pelo listbox
SelectCA = get(handles.Select_CA,'Value');
CA = SelectCA;
handles.CA = CA;
guidata(hObject,handles);

% Cálculo do TBS, com base na tabela MCS_TBS.csv, a partir do valor de MCS
for i=1:(MCS)
    if i == (MCS) % Achou a linha da MCS selecionada
        TBS = MCS_TBS(MCS,2); % TBS recebe a posição de linha da MCS selecionada, na coluna 2
    end
end
handles.TBS = TBS;
guidata(hObject,handles);

% Cálculo do Nbits, com base na tabela TBS_PRB.csv, a partir do valor de TBS
TBS = TBS + 2; % Necessário para que o matlab interprete como o valor de linhas com os dados equivalentes
PRBs = PRBs +1; % Necessário para que o matlab interprete como o valor de colunas com os dados equivalentes
for i=1:TBS 
    if TBS == i % Achou a linha com o valor do TBS
        for j=1:PRBs % Percorre as colunas para achar o valor do PRB
            if PRBs == j;
                Nbits = TBS_PRB(TBS,PRBs); % Nbits recebe o valor da posição na linha correspondente do TBS e na coluna do PRB
            end
        end
    end
end
% Voltando aos valores originais de TBS e PRBs
TBS = TBS - 2;
PRBs = PRBs - 1;
handles.Nbits = Nbits;
guidata(hObject,handles);

% Cálculo da taxa de transmissão do LTE (Release 10)  - pela tabela
Tput_tab = Nbits * CP/7 * MIMO * CA * 0.001;
handles.Tput_tab = Tput_tab;
guidata(hObject,handles);

% Definição o valor da modulação e da taxa de codificação, com base na tabela MCS_Mod_CodRate.csv que foi construída
for i=1:(MCS)
    if i == (MCS)
        Modulation = MCS_Mod_CodRate(MCS,2); % Modulação recebe o valor da posição da linha da MCS, na coluna 2
        CodRate = MCS_Mod_CodRate(MCS,3); % Taxa de codificação recebe o valor da posição da linha da MCS, na coluna 3
    end
end
handles.Modulation = Modulation;
handles.CodRate = CodRate;
guidata(hObject,handles);

% Definação do tipo de modulação a ser exibido      
if Modulation == 2
    ModType = 'QPSK';
elseif Modulation == 4
    ModType = '16 QAM';
else
    ModType = '64 QAM';
end
handles.ModType = ModType;
guidata(hObject,handles);

% Cálculo da taxa de transmissão do LTE (Release 10)  - pela fórmula
Tput_form = CP * PRBs * MIMO * CA * 0.75 * 12 * Modulation * CodRate/0.5*0.001;
handles.Tput_form = Tput_form;
guidata(hObject,handles);

% Exibição dos valores já calculados
set(handles.Show_PRB, 'String', handles.PRBs);  
set(handles.Show_TBSIndex, 'String', handles.TBS);
set(handles.Show_Nbits, 'String', handles.Nbits);
set(handles.Show_Modulation, 'String', handles.ModType);
set(handles.Show_RE, 'String', handles.RE);
set(handles.Show_CP, 'String', handles.CP);
set(handles.Show_EQUA, 'String', handles.Tput_form );                  
set(handles.Show_TAB, 'String',handles.Tput_tab);

% Fim do botão e das funções alteradas nesse código, o resto foi gerado automaticamente pelo MATLAB
%________________________________________________________________________________________________________________________________
% Mostra o número de PRBs
function Show_PRB_Callback(hObject, eventdata, handles)
% hObject    handle to Show_PRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Show_PRB as text
%        str2double(get(hObject,'String')) returns contents of Show_PRB as a double


% --- Executes during object creation, after setting all properties.
function Show_PRB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Show_PRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%________________________________________________________________________________________________________________________________
% Mostra o índice do TBS
function Show_TBSIndex_Callback(hObject, eventdata, handles)
% hObject    handle to Show_TBSIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Show_TBSIndex as text
%        str2double(get(hObject,'String')) returns contents of Show_TBSIndex as a double


% --- Executes during object creation, after setting all properties.
function Show_TBSIndex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Show_TBSIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%________________________________________________________________________________________________________________________________
% Mostra o valor do TBS
function Show_Nbits_Callback(hObject, eventdata, handles)
% hObject    handle to Show_Nbits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Show_Nbits as text
%        str2double(get(hObject,'String')) returns contents of Show_Nbits as a double


% --- Executes during object creation, after setting all properties.
function Show_Nbits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Show_Nbits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%________________________________________________________________________________________________________________________________
% Mostra a modulação utilizada
function Show_Modulation_Callback(hObject, eventdata, handles)
% hObject    handle to Show_Modulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Show_Modulation as text
%        str2double(get(hObject,'String')) returns contents of Show_Modulation as a double


% --- Executes during object creation, after setting all properties.
function Show_Modulation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Show_Modulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%________________________________________________________________________________________________________________________________
% Mostra o número de RE
function Show_RE_Callback(hObject, eventdata, handles)
% hObject    handle to Show_RE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Show_RE as text
%        str2double(get(hObject,'String')) returns contents of Show_RE as a double


% --- Executes during object creation, after setting all properties.
function Show_RE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Show_RE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%________________________________________________________________________________________________________________________________
% Mostra o número de simbolos
function Show_CP_Callback(hObject, eventdata, handles)
% hObject    handle to Show_CP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Show_CP as text
%        str2double(get(hObject,'String')) returns contents of Show_CP as a double


% --- Executes during object creation, after setting all properties.
function Show_CP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Show_CP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%________________________________________________________________________________________________________________________________
% Mostra o resultado da equação pela formula
function Show_EQUA_Callback(hObject, eventdata, handles)
% hObject    handle to Show_EQUA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Show_EQUA as text
%        str2double(get(hObject,'String')) returns contents of Show_EQUA as a double


% --- Executes during object creation, after setting all properties.
function Show_EQUA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Show_EQUA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%________________________________________________________________________________________________________________________________
% Mostra o resultado da equação pela tabela
function Show_TAB_Callback(hObject, eventdata, handles)
% hObject    handle to Show_TAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Show_TAB as text
%        str2double(get(hObject,'String')) returns contents of Show_TAB as a double


% --- Executes during object creation, after setting all properties.
function Show_TAB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Show_TAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%________________________________________________________________________________________________________________________________
% Seleção da BW
% --- Executes on selection change in Select_BW.
function Select_BW_Callback(hObject, eventdata, handles)
% hObject    handle to Select_BW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Select_BW contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_BW


% --- Executes during object creation, after setting all properties.
function Select_BW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_BW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%________________________________________________________________________________________________________________________________
% Seleção do Cycle Prefix
% --- Executes on selection change in Select_CP.
function Select_CP_Callback(hObject, eventdata, handles)
% hObject    handle to Select_CP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Select_CP contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_CP


% --- Executes during object creation, after setting all properties.
function Select_CP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_CP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%________________________________________________________________________________________________________________________________
% Seleção do número de MCS
% --- Executes on selection change in Select_MCS.
function Select_MCS_Callback(hObject, eventdata, handles)
% hObject    handle to Select_MCS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Select_MCS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_MCS


% --- Executes during object creation, after setting all properties.
function Select_MCS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_MCS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%________________________________________________________________________________________________________________________________
% Seleção do número de antenas MIMO
% --- Executes on selection change in Select_MIMO.
function Select_MIMO_Callback(hObject, eventdata, handles)
% hObject    handle to Select_MIMO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Select_MIMO contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_MIMO


% --- Executes during object creation, after setting all properties.
function Select_MIMO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_MIMO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%______________________________________________________________________________________________________________________________
% Seleção da Carrier Aggregation
% --- Executes on selection change in Select_CA.
function Select_CA_Callback(hObject, eventdata, handles)
% hObject    handle to Select_CA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Select_CA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_CA


% --- Executes during object creation, after setting all properties.
function Select_CA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_CA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
