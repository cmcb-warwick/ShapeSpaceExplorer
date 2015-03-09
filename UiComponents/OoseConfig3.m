function varargout = OoseConfig3(varargin)
% OOSECONFIG3 MATLAB code for OoseConfig3.fig
%      OOSECONFIG3, by itself, creates a new OOSECONFIG3 or raises the existing
%      singleton*.
%
%      H = OOSECONFIG3 returns the handle to a new OOSECONFIG3 or the handle to
%      the existing singleton*.
%
%      OOSECONFIG3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OOSECONFIG3.M with the given input arguments.
%
%      OOSECONFIG3('Property','Value',...) creates a new OOSECONFIG3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OoseConfig3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OoseConfig3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OoseConfig3

% Last Modified by GUIDE v2.5 09-Mar-2015 14:26:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OoseConfig3_OpeningFcn, ...
                   'gui_OutputFcn',  @OoseConfig3_OutputFcn, ...
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


% --- Executes just before OoseConfig3 is made visible.
function OoseConfig3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OoseConfig3 (see VARARGIN)

% Choose default command line output for OoseConfig3
handles.output = hObject;
guidata(hObject, handles);
cPath=mfilename('fullpath');
[folder,~,~] = fileparts(cPath);
imFile = fullfile(folder, 'img/', 'header.png');
img=imread(imFile);
imshow(img,'Parent',handles.axes1)
set(handles.edit1, 'String','...') 
set(handles.edit2, 'String','...')

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OoseConfig3 wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OoseConfig3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
struc.anaFolder = get(handles.edit1, 'String');
struc.OosFolder = get(handles.edit2, 'String');
struc.classes =get(handles.popupmenu3,'Value');
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
folderAna =get(handles.edit1, 'String');
folderOos =get(handles.edit2, 'String');

if strcmp(folderAna,'...')==1 || strcmp(folderOos,'...')
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(12);
    errordlg(msg, 'Error', mode);
    return;
end
if  ~exist(folderAna, 'dir')
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(5);
    errordlg(msg, 'Error', mode);
    return;
end

if  ~exist(folderOos, 'dir')
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(5);
    errordlg(msg, 'Error', mode);
    return;
end
if strcmp(folderAna,folderOos)
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(13);
    errordlg(msg, 'Error', mode);
    return;
end

    
figure1_CloseRequestFcn(hObject, eventdata, handles)








% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
h= handles.figure1;
if isequal(get(h, 'waitstatus'), 'waiting')
    uiresume(h)
else
    h= handles.figure1;
    delete(h);
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder =uigetdir(matlabroot,'Select OOSE Directory');
set(handles.edit2, 'String',folder)  
set(handles.pushbutton2, 'enable', 'on'); 


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
