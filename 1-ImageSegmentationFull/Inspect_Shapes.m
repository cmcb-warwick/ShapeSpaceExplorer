function varargout = Inspect_Shapes(varargin)
% INSPECT_SHAPES MATLAB code for Inspect_Shapes.fig
%      INSPECT_SHAPES, by itself, creates a new INSPECT_SHAPES or raises the existing
%      singleton*.
%
%      H = INSPECT_SHAPES returns the handle to a new INSPECT_SHAPES or the handle to
%      the existing singleton*.
%
%      INSPECT_SHAPES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INSPECT_SHAPES.M with the given input arguments.
%
%      INSPECT_SHAPES('Property','Value',...) creates a new INSPECT_SHAPES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Inspect_Shapes_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Inspect_Shapes_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Inspect_Shapes

% Last Modified by GUIDE v2.5 19-Feb-2015 22:09:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Inspect_Shapes_OpeningFcn, ...
                   'gui_OutputFcn',  @Inspect_Shapes_OutputFcn, ...
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


% --- Executes just before Inspect_Shapes is made visible.
function Inspect_Shapes_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Inspect_Shapes (see VARARGIN)

% Choose default command line output for Inspect_Shapes
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
set(handles.currFileName, 'string', '...');
clearvars -global % clears all global variables
numSteps = 10;
 set(handles.slider1, 'Min', 1);
 set(handles.slider1, 'Max', numSteps);
 set(handles.slider1, 'Value', 1);
 set(handles.slider1, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1) ]);
 %addlistener(handles.slider1, 'Value','PostSet', @SliderValueChanged);
addlistener(handles.slider1,'ActionEvent',@(hObject, event) SliderValueChanged(handles, eventdata));
% UIWAIT makes Inspect_Shapes wait for user response (see UIRESUME)
% uiwait(handles.figure1);
h=figure; % so we don't have figure popping up..
set(h,'visible','off');

% --- Outputs from this function are returned to the command line.
function varargout = Inspect_Shapes_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,pathName] = uigetfile('*.mat','Select an processed Matlab file');
if fileName==0, return; end
clearvars -global % clears all global variables
global stack;
stack = loadStackFromFile(pathName, fileName);
if isempty(stack)
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(6);
    errordlg(msg, 'Error', mode);
    clearvars -global
    return
end
global frameCurves;
global cellNumbers;
[frameCurves,cellNumbers]=loadCurveDataFrom(pathName, fileName);
if isempty(frameCurves) || isempty(cellNumbers)
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(7);
    errordlg(msg, 'Error', mode);
    clearvars -global
    return
end
set(handles.currFileName, 'string', fileName );
handles.currPathName=pathName;
loadCurrFrame(1, handles);

%plot(handles.axes1, handles.Frame_curves{handles.Frame_no}{j}(:,2),
% handles.Frame_curves{handles.Frame_no}{j}(:,1),'Color',handles.cmap(handles.Cell_numbers{handles.Frame_no}(j),:));
                


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


% this code can deal with legacy code from first 
% implementation. I store each stack in var.stack
% while the first version has given it the variable
% name with this structure: var.fileName%ID
% which can be lilke var.ImageStack001
% if file is not quite correct, then 
% it returns gracefully an empty variable.
function stack = loadStackFromFile(pathName, fileName)
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


% try to load the structure of cell curves in the data
% which hopefully have the expected structure 
% if expected structure is not found, the variables
% are returned empty.
function [frameCurves,cellNumbers] =loadCurveDataFrom(pathName, fileName)
frameCurves=[];cellNumbers=[];
[~,fName,ext] = fileparts(fileName);
name = [fName 'CurveData' ext];
path =fullfile(pathName, name);
if ~exist(path, 'file'), return; end
tmp =load(path);
try 
    frameCurves=tmp.Frame_curves;
    cellNumbers=tmp.Cell_numbers;
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider1.
function SliderValueChanged(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num = floor(get(hObject.slider1,'Value'));
loadCurrFrame(num, hObject);


function loadCurrFrame(number, handles)
global stack;
if isempty(stack), return; end
img=stack(:,:,number);

imagesc(img, 'Parent', handles.axes1);
axis off; colormap(gray);
hold on
global frameCurves; global cellNumbers;
if isempty(frameCurves) || isempty(cellNumbers), return; end
fCurves=frameCurves{number};
cNumber=cellNumbers{number};
for i=1:length(cNumber)
    curve =fCurves{i};
    plot(handles.axes1, curve(:,2), curve(:,1), 'm'); 
end

