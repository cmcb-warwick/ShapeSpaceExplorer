function varargout = ConstrainedClusteringNEW(varargin)
% CONSTRAINEDCLUSTERING MATLAB code for ConstrainedClustering.fig
%      CONSTRAINEDCLUSTERING, by itself, creates a new CONSTRAINEDCLUSTERING or raises the existing
%      singleton*.
%
%      H = CONSTRAINEDCLUSTERING returns the handle to a new CONSTRAINEDCLUSTERING or the handle to
%      the existing singleton*.
%
%      CONSTRAINEDCLUSTERING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONSTRAINEDCLUSTERING.M with the given input arguments.
%
%      CONSTRAINEDCLUSTERING('Property','Value',...) creates a new CONSTRAINEDCLUSTERING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConstrainedClustering_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConstrainedClustering_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConstrainedClustering

% Last Modified by GUIDE v2.5 11-Dec-2017 17:05:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ConstrainedClusteringNEW_OpeningFcn, ...
                   'gui_OutputFcn',  @ConstrainedClusteringNEW_OutputFcn, ...
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


% --- Executes just before ConstrainedClustering is made visible.
function ConstrainedClusteringNEW_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ConstrainedClustering (see VARARGIN)

% Choose default command line output for ConstrainedClustering
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
cPath=mfilename('fullpath');
[folder,~,~] = fileparts(cPath);
imFile = fullfile(folder, 'img/', 'header.png');
img=imread(imFile);
imshow(img,'Parent',handles.axes1)
imFile = fullfile(folder, 'img/', 'cluster.png');
img=imread(imFile);
imshow(img,'Parent',handles.axes2)

% show path from last time.
global PATH
if length(PATH>2)
set(handles.edit1, 'String', PATH);
end

% UIWAIT makes ConstrainedClustering wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ConstrainedClusteringNEW_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
struc.fpath= get(handles.edit1, 'String');
struc.classes1=get(handles.popupmenu1,'Value');
struc.classes2=get(handles.popupmenu2,'Value');
struc.handle=handles.figure1;
varargout{1} = struc;
h= handles.figure1;
delete(h);

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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fPath =uigetdir(matlabroot,'Select Analysis Directory');
set(handles.edit1, 'String','...')
if exist(fPath, 'dir')
  set(handles.edit1, 'String',fPath);  
end



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fpath= get(handles.edit1, 'String');
% if ~exist(fpath, 'dir')
%     mode = struct('WindowStyle','non-modal','Interpreter','tex');
%     msg = DialogMessages(5);
%     errordlg(msg, 'Error', mode);
% else
figure1_CloseRequestFcn(hObject, eventdata, handles);




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
