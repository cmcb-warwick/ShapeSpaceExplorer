function varargout = ConfigPane3(varargin)
% CONFIGPANE3 MATLAB code for ConfigPane3.fig
%      CONFIGPANE3, by itself, creates a new CONFIGPANE3 or raises the existing
%      singleton*.
%
%      H = CONFIGPANE3 returns the handle to a new CONFIGPANE3 or the handle to
%      the existing singleton*.
%
%      CONFIGPANE3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIGPANE3.M with the given input arguments.
%
%      CONFIGPANE3('Property','Value',...) creates a new CONFIGPANE3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConfigPane3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConfigPane3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConfigPane3

% Last Modified by GUIDE v2.5 25-Jul-2015 18:40:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ConfigPane3_OpeningFcn, ...
                   'gui_OutputFcn',  @ConfigPane3_OutputFcn, ...
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


% --- Executes just before ConfigPane3 is made visible.
function ConfigPane3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ConfigPane3 (see VARARGIN)

% Choose default command line output for ConfigPane3
handles.output = hObject;
guidata(hObject, handles);
cPath=mfilename('fullpath');
[folder,~,~] = fileparts(cPath);
imFile = fullfile(folder, 'img/', 'header.png');
img=imread(imFile);
imshow(img,'Parent',handles.axes1)
set(handles.edit1, 'String','...') 
for i=1:1000
    list{i}=num2str(i);
end
set(handles.popupmenu1, 'string', list);
set(handles.popupmenu2, 'string', list);
set(handles.popupmenu1, 'value', 5); % spatial bandwith
set(handles.popupmenu2, 'value', 3); % range bandwith.
list2={};
for i=0:10:10000
    list2{end+1}=i;
end
set(handles.popupmenu3, 'string', list2);
set(handles.popupmenu2, 'value', 1); % min area size

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ConfigPane3 wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ConfigPane3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout={-1};
if handles.cancel==1,   % if cancel
    delete(handles.figure1);
    return;
end
struc.folder = get(handles.edit1, 'String');
struc.spatialBdw=get(handles.popupmenu1, 'value');
struc.rangeBdw=get(handles.popupmenu2, 'value');
struc.minArea=get(handles.popupmenu3, 'value');
varargout{1}=struc;
delete(handles.figure1);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder =uigetdir(matlabroot,'Select Analysis Directory');
set(handles.edit1, 'String',folder)  
set(handles.pushbutton2, 'enable', 'on'); 


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder =get(handles.edit1, 'String');
if  ~exist(folder, 'dir')
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(5);
    errordlg(msg, 'Error', mode);
else
    handles.cancel=0;
    guidata(handles.figure1,handles);
    if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
        uiresume(handles.figure1)
    else
        h= handles.figure1;
        delete(h);
    end
end








% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
handles.cancel=1;
guidata(handles.figure1,handles);
h= handles.figure1;
if isequal(get(h, 'waitstatus'), 'waiting')
    uiresume(h)
else
    h= handles.figure1;
    delete(h);
end




% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
