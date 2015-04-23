function varargout = ConfigPane2(varargin)
% CONFIGPANE2 MATLAB code for ConfigPane2.fig
%      CONFIGPANE2, by itself, creates a new CONFIGPANE2 or raises the existing
%      singleton*.
%
%      H = CONFIGPANE2 returns the handle to a new CONFIGPANE2 or the handle to
%      the existing singleton*.
%
%      CONFIGPANE2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIGPANE2.M with the given input arguments.
%
%      CONFIGPANE2('Property','Value',...) creates a new CONFIGPANE2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConfigPane2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConfigPane2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConfigPane2

% Last Modified by GUIDE v2.5 18-Feb-2015 09:52:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ConfigPane2_OpeningFcn, ...
                   'gui_OutputFcn',  @ConfigPane2_OutputFcn, ...
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


% --- Executes just before ConfigPane2 is made visible.
function ConfigPane2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ConfigPane2 (see VARARGIN)

% Choose default command line output for ConfigPane2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
cPath=mfilename('fullpath');
[folder,~,~] = fileparts(cPath);
imFile = fullfile(folder, 'img/', 'header.png');
img=imread(imFile);
imshow(img,'Parent',handles.axes1)
set(handles.popupmenu1, 'enable', 'off');
set(handles.popupmenu2, 'enable', 'off');
list = {};
maxFrame=varargin{1};
for i=1:maxFrame
    list{i}=num2str(i);
end
set(handles.popupmenu1, 'string', list);
set(handles.popupmenu2, 'string', list);
set(handles.popupmenu1, 'value', 1);
set(handles.popupmenu2, 'value', maxFrame);

% UIWAIT makes ConfigPane2 wait for user response (see UIRESUME
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ConfigPane2_OutputFcn(hObject, eventdata, handles) 
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
struc.firstFrame=1;
struc.lastFrame=Inf;
struc.subSet =get(handles.radiobutton2, 'Value');
if struc.subSet
    struc.firstFrame= get(handles.popupmenu1, 'value');
    struc.lastFrame= get(handles.popupmenu2, 'value');
end
varargout{1}=struc;
delete(handles.figure1);

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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
frstFrame= get(handles.popupmenu1, 'value');
lastFrame= get(handles.popupmenu2, 'value');
if frstFrame>lastFrame
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(4);
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


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
value =get(handles.radiobutton2, 'Value');
status ='off';
if value, status='on'; end
set(handles.popupmenu1, 'enable', status);
set(handles.popupmenu2, 'enable', status);


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
