function varargout = CellTrackViewer(varargin)
% CELLTRACKVIEWER MATLAB code for CellTrackViewer.fig
%      CELLTRACKVIEWER, by itself, creates a new CELLTRACKVIEWER or raises the existing
%      singleton*.
%
%      H = CELLTRACKVIEWER returns the handle to a new CELLTRACKVIEWER or the handle to
%      the existing singleton*.
%
%      CELLTRACKVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELLTRACKVIEWER.M with the given input arguments.
%
%      CELLTRACKVIEWER('Property','Value',...) creates a new CELLTRACKVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CellTrackViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CellTrackViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CellTrackViewer

% Last Modified by GUIDE v2.5 26-Mar-2015 11:22:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CellTrackViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @CellTrackViewer_OutputFcn, ...
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


% --- Executes just before CellTrackViewer is made visible.
function CellTrackViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CellTrackViewer (see VARARGIN)

% Choose default command line output for CellTrackViewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CellTrackViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CellTrackViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%contents{get(hObject,'Value')} returns selected item from popupmenu1
idx=get(hObject,'Value');
set(handles.text1, 'String',idx);
display('changed');

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


% --------------------------------------------------------------------
% open a stack.
function open_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,pathName] = uigetfile('*.mat','Select a processed Matlab file');
if fileName==0, return; end
[handles.stack, handles.stackNumber] = loadStackFromFile(pathName, fileName);
set(handles.text1, 'String', handles.stackNumber);
[tracks, lbls]= loadTrackInfo(pathName,handles.stackNumber);
if isempty(tracks), resetGUI(hObject, eventdata, handles); return; end
set(handles.popupmenu1, 'string', lbls);
set(handles.popupmenu1, 'Value', 1);



function resetGUI(hObject, eventdata, handles)
set(handles.popupmenu1, 'string', {'No Cell Tracks found.  '});
cla(handles.axes2);
cla(handles.axes3);
cla(handles.axes4);


%extract the relevant tracks and abs id from big structure.
function [tracks, labels]= loadTrackInfo(pathName,stackNumber)
tracks={}; labels={};
bPath = fullfile(pathName, 'BigCellDataStruct.mat');
if ~exist(bPath, 'file'),filleDoesNotexist(bPath); return; end
try data = load(bPath);
bigStructure=data.BigCellDataStruct;
catch
    fileHasWrongStructure(cellShapePath);
    return;
end
s =size(bigStructure);
for i=1:s(2)
    tmp = bigStructure(i);
    if tmp.Stack_number==stackNumber
       tmp.AbsIdx=i;
       tracks{end+1}=tmp;
       labels{end+1}=sprintf('Image Stack %03d : Cell Id %02d',stackNumber, tmp.Cell_number);
    end
end



    
function filleDoesNotexist(filename)
display('-------');
display(['The file "' filename '" does not exist in your Analysis folder.']);
display('Please check whether previous steps have been succesfully completed.');
display('-------');


function fileHasWrongStructure(filename)
display('-------');
display(['The file "' filename '" does not have the expected structure in your Analysis folder.']);
display('Please check whether previous steps have been succesfully completed.');
display('-------');
   


function [stack, stackNum] = loadStackFromFile(pathName, fileName)
path = fullfile(pathName, fileName);
tmp = load(path);
stack=[];
try 
    stack=tmp.stack;
catch % means we have some old data from first implementation.
    try 
    [~,fName,~] = fileparts(fileName);
    str =['tmp.' fName];
    stack = eval(['tmp.' fName]);
    end
end
[~,fName,~] = fileparts(fileName); 
if length(fName)>3
   num = fName(end-2:end);
   try stackNum= str2num(num); end
end
