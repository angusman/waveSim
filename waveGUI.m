function varargout = waveGUI(varargin)
% WAVEGUI MATLAB code for waveGUI.fig
%      WAVEGUI, by itself, creates a new WAVEGUI or raises the existing
%      singleton*.
%
%      H = WAVEGUI returns the handle to a new WAVEGUI or the handle to
%      the existing singleton*.
%
%      WAVEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WAVEGUI.M with the given input arguments.
%
%      WAVEGUI('Property','Value',...) creates a new WAVEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before waveGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to waveGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help waveGUI

% Last Modified by GUIDE v2.5 21-Nov-2015 16:10:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @waveGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @waveGUI_OutputFcn, ...
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

% --- Executes just before waveGUI is made visible.
function waveGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to waveGUI (see VARARGIN)

I = imread('wavesplashbox.png');
imagesc(I)
axis off

% Choose default command line output for waveGUI
handles.output = hObject;

% Update handles structure
handles.f0 = @(x) max(1-abs(x-2),0);
handles.g0 = @(x) 0*x;
handles.x = [0,10];
handles.t = [0,10];
handles.v = 1;
handles.N = 100;
handles.dt = 0.01;

handles.camera = 'Dynamic';
handles.boundary = 'd';

handles.updates = 0;
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using waveGUI.
set(handles.slider_time,'Min',handles.t(1))
set(handles.slider_time,'Max',handles.t(2))

% UIWAIT makes waveGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = waveGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in push_update.
function push_update_Callback(hObject, eventdata, handles)
% hObject    handle to push_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.updates = handles.updates + 1;

[x,y] = wave(handles.f0,handles.g0,handles.x,handles.t,handles.v,handles.N,handles.dt,handles.boundary);
handles.waveX = x;
handles.waveY = y;

[m,n] = size(y);
whitebg('k')
colormap('winter')
step = 10;
dx = (x(end) - x(1))/handles.N;

handles.dx = dx;

cameraType = handles.camera;

colors = [min(-2*min(min(y)),2*min(min(y))) max(-1.5*max(max(y)),1.5*max(max(y)))];
    
switch cameraType
    case 'Dynamic'
        for time = 2:step:m
            handles.s1 = subplot(1,1,1,'Parent',handles.fig_panel);
            M = meshz([x x+dx],[x x+dx],[ones(length(x),1); 1]*[y(time,:) min(min(y))]);
            set(M,'FaceColor','interp')
            axis equal
            axis([x(1) x(end) x(1) x(end) min(min(y)) max(max(y))])
            caxis(colors)
            if time < 2*m/5
                view(0,0)
            elseif time < 3*m/5
                view(-(time-2*m/5)*(5/m)*30, (time-2*m/5)*(5/m)*15)
            else
                view(-30,15)
            end
            
            title(['t = ' num2str(floor(handles.dt*time))])
            set(handles.slider_time,'Value',min(handles.dt*time,get(handles.slider_time,'Max')))
            set(handles.edit_time,'String',num2str(min(handles.dt*time,get(handles.slider_time,'Max'))))
            
            pause(0.001)
        end
        
    case 'Side'
        for time = 2:step:m
            handles.s1 = subplot(1,1,1,'Parent',handles.fig_panel);
            M = meshz([x x+dx],[x x+dx],[ones(length(x),1); 1]*[y(time,:) min(min(y))]);
            set(M,'FaceColor','interp')
            axis([x(1) x(end) x(1) x(end) min(min(y)) max(max(y))])
            title(['t = ' num2str(floor(handles.dt*time))])
            set(handles.slider_time,'Value',min(handles.dt*time,get(handles.slider_time,'Max')))
            set(handles.edit_time,'String',num2str(min(handles.dt*time,get(handles.slider_time,'Max'))))
            
            caxis(colors)
            view(0,0)
            
            
            pause(0.001)
        end
        
    case 'Top'
        for time = 2:step:m
            handles.s1 = subplot(1,1,1,'Parent',handles.fig_panel);
            M = meshz([x x+dx],[x x+dx],[ones(length(x),1); 1]*[y(time,:) min(min(y))]);
            set(M,'FaceColor','interp')
            axis([x(1) x(end) x(1) x(end)])
            title(['t = ' num2str(floor(handles.dt*time))])
            set(handles.slider_time,'Value',min(handles.dt*time,get(handles.slider_time,'Max')))
            set(handles.edit_time,'String',num2str(min(handles.dt*time,get(handles.slider_time,'Max'))))
            
            caxis(colors)
            view(0,90)
            
            pause(0.001)
        end
        
        
    case 'Multi'
        for time = 2:step:m
            handles.s1 = subplot(2,1,1,'Parent',handles.fig_panel);
            M = meshz([x x+dx],[x x+dx],[ones(length(x),1); 1]*[y(time,:) min(min(y))]);
            set(M,'FaceColor','interp')
            axis equal
            axis([x(1) x(end) x(1) x(end) min(min(y)) max(max(y))])
            caxis(colors)
            if time < 2*m/5
                view(0,0)
            elseif time < 3*m/5
                view(-(time-2*m/5)*(5/m)*30, (time-2*m/5)*(5/m)*15)
            else
                view(-30,15)
            end
            title(['t = ' num2str(floor(handles.dt*time))])
            set(handles.slider_time,'Value',min(handles.dt*time,get(handles.slider_time,'Max')))
            set(handles.edit_time,'String',num2str(min(handles.dt*time,get(handles.slider_time,'Max'))))
            
            
            handles.s2 = subplot(2,1,2,'Parent',handles.fig_panel);
            M = meshz([x x+dx],[x x+dx],[ones(length(x),1); 1]*[y(time,:) min(min(y))]);
            set(M,'FaceColor','interp')
            axis([x(1) x(end) x(1) 1])
            caxis(colors)
            view(0,90)
            
            pause(0.001)
        end
        
end
guidata(hObject,handles)


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

% --- Executes on slider movement.
function slider_time_Callback(hObject, eventdata, handles)
% hObject    handle to slider_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
real = get(hObject,'Value');
adjust = round(real/handles.dt)*handles.dt;
set(hObject,'Value', adjust)
set(handles.edit_time,'String',num2str(adjust))

if handles.updates > 0 && (strcmp(handles.camera,'Side') || strcmp(handles.camera,'Dynamic') || strcmp(handles.camera,'Top'))
    x = handles.waveX;
    y = handles.waveY;
    dx = handles.dx;
    [AZ,EL] = view;
    
    time = 1+round(get(hObject,'Value')/handles.dt);
    handles.s1 = subplot(1,1,1,'Parent',handles.fig_panel);
    M = meshz([x x+dx],[x x+dx],[ones(length(x),1); 1]*[y(time,:) min(min(y))]);
    set(M,'FaceColor','interp')
    axis([x(1) x(end) x(1) x(end) min(min(y)) max(max(y))])
    title(['t = ' num2str(floor(handles.dt*time))])
    
    colors = [min(-2*min(min(y)),2*min(min(y))) max(-1.5*max(max(y)),1.5*max(max(y)))];
    caxis(colors)
    switch handles.camera
        case 'Dynamic'          
            view(AZ,EL)
            axis equal
            axis([x(1) x(end) x(1) x(end) min(min(y)) max(max(y))])            
        case 'Side'
            view(0,0)
        case 'Top'
            view(0,90)
    end
    
    
    pause(0.001)
end
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function slider_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function edit_time_Callback(hObject, eventdata, handles)
% hObject    handle to edit_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_time as text
%        str2double(get(hObject,'String')) returns contents of edit_time as a double
handles.time = str2num(get(hObject,'String'));
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_n_Callback(hObject, eventdata, handles)
% hObject    handle to edit_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_n as text
%        str2double(get(hObject,'String')) returns contents of edit_n as a double
handles.N = str2num(get(hObject,'String'));
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dt as text
%        str2double(get(hObject,'String')) returns contents of edit_dt as a double
handles.dt = str2num(get(hObject,'String'));
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_v_Callback(hObject, eventdata, handles)
% hObject    handle to edit_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_v as text
%        str2double(get(hObject,'String')) returns contents of edit_v as a double
handles.v = str2num(get(hObject,'String'));
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_interval_Callback(hObject, eventdata, handles)
% hObject    handle to edit_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_interval as text
%        str2double(get(hObject,'String')) returns contents of edit_interval as a double
handles.x = str2num(get(hObject,'String'));
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_interval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_timeinterval_Callback(hObject, eventdata, handles)
% hObject    handle to edit_timeinterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_timeinterval as text
%        str2double(get(hObject,'String')) returns contents of edit_timeinterval as a double
handles.t = str2num(get(hObject,'String'));
set(handles.slider_time,'Min',handles.t(1))
set(handles.slider_time,'Max',handles.t(2))

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_timeinterval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_timeinterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
cla;
choice = get(hObject,'Value');
switch choice
    case 1 %max(1 - |x-2|)
        set(handles.edit_k,'Visible','off')
        set(handles.text_k,'Visible','off')
        set(handles.edit_f,'Visible','off')
        set(handles.text_f,'Visible','off')
        set(handles.edit_g,'Visible','off')
        set(handles.text_g,'Visible','off')
        handles.f0 = @(x) max(1-abs(x-2),0);
        handles.g0 = @(x) 0*x;
        
    case 2 %sin(k*pi)
        set(handles.edit_k,'Visible','on')
        set(handles.text_k,'Visible','on')
        set(handles.edit_f,'Visible','off')
        set(handles.text_f,'Visible','off')
        set(handles.edit_g,'Visible','off')
        set(handles.text_g,'Visible','off')
        handles.k = str2num(get(handles.edit_k,'String'));
        handles.f0 = @(x) sin( (handles.k*pi*(x-0))/(10-0));
        handles.g0 = @(x) 0*x;      
        
    case 3 %custom g(x) = 0
        set(handles.edit_f,'Visible','on')
        set(handles.text_f,'Visible','on')
        set(handles.edit_g,'Visible','off')
        set(handles.text_g,'Visible','off')
        handles.f0 = str2func(['@(x)' get(handles.edit_f,'String')]);
        handles.g0 = @(x) 0*x;
        
    case 4 %fully custom
        set(handles.edit_f,'Visible','on')
        set(handles.text_f,'Visible','on')
        set(handles.edit_g,'Visible','on')
        set(handles.text_g,'Visible','on')
        handles.f0 = str2func(['@(x)' get(handles.edit_f,'String')]);
        handles.g0 = str2func(['@(x)' get(handles.edit_g,'String')]);
        
        
end
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_k_Callback(hObject, eventdata, handles)
% hObject    handle to edit_k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_k as text
%        str2double(get(hObject,'String')) returns contents of edit_k as a double
handles.k = str2num(get(hObject,'String'));
handles.f0 = @(x) sin( (handles.k*pi*(x-0))/(10-0));
handles.g0 = @(x) 0*x;

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit_k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in panel_camera.
function panel_camera_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_camera 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.camera = get(eventdata.NewValue,'String');

guidata(hObject,handles)
  
   


% --- Executes when selected object is changed in panel_boundary.
function panel_boundary_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_boundary 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.boundary = get(eventdata.NewValue,'String');

guidata(hObject,handles)



function edit_f_Callback(hObject, eventdata, handles)
% hObject    handle to edit_f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_f as text
%        str2double(get(hObject,'String')) returns contents of edit_f as a double
handles.f0 = str2func(['@(x)' get(handles.edit_f,'String')]);

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_f_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.updates > 0
    printFig = figure();
    colormap('winter')
    
    switch handles.camera
        case {'Dynamic', 'Side', 'Top'}
            copyobj(handles.s1,printFig)
            whitebg('w')
        case 'Multi'
            copyobj(handles.s1,printFig)
            copyobj(handles.s2,printFig)
            whitebg('w')
    end
end



function edit_g_Callback(hObject, eventdata, handles)
% hObject    handle to edit_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_g as text
%        str2double(get(hObject,'String')) returns contents of edit_g as a double
handles.g0 = str2func(['@(x)' get(handles.edit_g,'String')]);

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_g_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

