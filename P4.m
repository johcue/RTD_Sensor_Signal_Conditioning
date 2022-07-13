function varargout = P4(varargin)

% Last Modified by GUIDE v2.5 17-Jun-2020 18:25:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @P4_OpeningFcn, ...
                   'gui_OutputFcn',  @P4_OutputFcn, ...
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


% --- Executes just before P4 is made visible.
function P4_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for P4
clc
handles.output = hObject;
handles.linea1=line('Parent',handles.grafica,'XData',[],'YData',[],'Color',[0 0 0]);
handles.linea2=line('Parent',handles.grafica,'XData',[],'YData',[],'Color',[1 0 0]);
handles.linea3=line('Parent',handles.grafica,'XData',[],'YData',[],'Color',[0 0 1]);
SimRTD();
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = P4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Tmin_Callback(hObject, eventdata, handles)
% hObject    handle to Tmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Tmin = str2double(get(hObject,'String'));
Tmax = str2double(get(handles.Tmax,'String'));
if Tmin > Tmax
    set(handles.Tmax, 'String', Tmin);
    set(handles.Tmin, 'String', Tmax);
end

% Hints: get(hObject,'String') returns contents of Tmin as text
%        str2double(get(hObject,'String')) returns contents of Tmin as a double


% --- Executes during object creation, after setting all properties.
function Tmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tmax_Callback(hObject, eventdata, handles)
% hObject    handle to Tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Tmin = str2double(get(hObject,'String'));
Tmax = str2double(get(handles.Tmax,'String'));
if Tmax < Tmin
    set(handles.Tmax, 'String', Tmin);
    set(handles.Tmin, 'String', Tmax);
end

% Hints: get(hObject,'String') returns contents of Tmax as text
%        str2double(get(hObject,'String')) returns contents of Tmax as a double


% --- Executes during object creation, after setting all properties.
function Tmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in btnAdquirir.
function btnAdquirir_Callback(hObject, eventdata, handles)
% hObject    handle to btnAdquirir (see GCBO)
est=get(handles.btnAdquirir,'Value');
if est==0
    set(handles.btnAdquirir,'String','ADQUIRIR');
else
    set(handles.btnAdquirir,'String','DETENER');
end

 %Valores de Muestreo
   N=400;
   Ts=0.1;
   a=0.00385; %coeficiente térmico
   

 %Adquiero el valor de resistencia para el Divisor de Tension
   R=str2num(get(handles.R,'String'));
  
 %Adquiero los valores deresistencias para el Puente de Wheatstone
   R1=str2num(get(handles.R1,'String'));
   R2=str2num(get(handles.R2,'String'));
   R3=str2num(get(handles.R3,'String'));
   
 %Adquiero los valores de temperatura min y max
  Tmax=str2num(get(handles.Tmax,'String'));
  Tmin=str2num(get(handles.Tmin,'String'));
  
  
   
while est==1   
    Treal=[];    
    Xmax=[];
    Xmin=[];
    %Obtiene el valor del listbox de Modo de Operacion
    op=get(handles.ModoOperacion,'value');
    switch op 
     case 1
         set(handles.pnlDivisor, 'Visible', 'On');
      for i=0:(N-1)
          
      %Vector de Tiempo
        t=(0:(i))*Ts; 
                
      %Activo Señal de Entrada y muestras
        datos=SimRTD('ai',0.1,[0 1]);        
        entrada=datos(:,1);
        muestras=datos(:,2);
         
       %Cambio del voltaje resivido a Temperatura
        gDiv=21;
        V2=muestras/gDiv;
        V1=entrada-V2;
        corriente=V1/R;
        Rv=V2/corriente;
        temperatura=(((Rv/100)-1)/a);
        Treal=[Treal;temperatura];
        
       
       %Ponemos el valor de la temperatura en una variable c:
        set(handles.edit4,'String',temperatura);       
       
        %Funcion de control
        if temperatura > Tmax
            SimRTD('dio', 0);
        elseif temperatura < Tmin && temperatura < Tmax
            SimRTD('dio', 1);
        end
        
       %Graficamos
        Xmax=[Xmax,Tmax];
        Xmin=[Xmin,Tmin];                
           pause(Ts);
        set(handles.linea1,'XData',t,'YData',Treal);
                hold on
        set(handles.linea2,'XData',t,'YData',Xmax);
                hold on 
        set(handles.linea3,'XData',t,'YData',Xmin);
      end
    case 2
        set(handles.pnlPW, 'Visible', 'On');
      for i=0:(N-1)
          %Vector de Tiempo
           t=(0:(i))*Ts; 
                
      %Activo Señal de Entrada y muestras
        datos=SimRTD('ai',0.1,[0 1]);        
        entrada=datos(:,1);
        muestras=datos(:,2);
    
      %De volt a temp 
        Rt=((36*muestras)/(70*entrada-6*muestras));
        temperatura=Rt/a;
        Treal=[Treal;temperatura];
      
        %Ponemos el valor de la temperatura en una variable c:
        set(handles.edit4,'String',temperatura);       
       
        %Funcion de control
        if temperatura > Tmax
            SimRTD('dio', 0);
        elseif temperatura < Tmin && temperatura < Tmax
            SimRTD('dio', 1);
        end
       
       
       %Graficamos
        Xmax=[Xmax,Tmax];
        Xmin=[Xmin,Tmin];                
           pause(Ts);
        set(handles.linea1,'XData',t,'YData',Treal);
                hold on
        set(handles.linea2,'XData',t,'YData',Xmax);
                hold on 
        set(handles.linea3,'XData',t,'YData',Xmin);
      end
    end
        
    est=get(handles.btnAdquirir,'Value');
end



function R_Callback(hObject, eventdata, handles)
% hObject    handle to R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R as text
%        str2double(get(hObject,'String')) returns contents of R as a double


% --- Executes during object creation, after setting all properties.
function R_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ModoOperacion.
function ModoOperacion_Callback(hObject, eventdata, handles)
% hObject    handle to ModoOperacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ModoOperacion contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ModoOperacion


% --- Executes during object creation, after setting all properties.
function ModoOperacion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModoOperacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R3_Callback(hObject, eventdata, handles)
% hObject    handle to R3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R3 as text
%        str2double(get(hObject,'String')) returns contents of R3 as a double


% --- Executes during object creation, after setting all properties.
function R3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R2_Callback(hObject, eventdata, handles)
% hObject    handle to R2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R2 as text
%        str2double(get(hObject,'String')) returns contents of R2 as a double


% --- Executes during object creation, after setting all properties.
function R2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R1_Callback(hObject, eventdata, handles)
% hObject    handle to R1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R1 as text
%        str2double(get(hObject,'String')) returns contents of R1 as a double


% --- Executes during object creation, after setting all properties.
function R1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rg_Callback(hObject, eventdata, handles)
% hObject    handle to Rg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rg as text
%        str2double(get(hObject,'String')) returns contents of Rg as a double


% --- Executes during object creation, after setting all properties.
function Rg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
