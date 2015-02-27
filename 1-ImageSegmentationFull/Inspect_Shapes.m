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

% Last Modified by GUIDE v2.5 26-Feb-2015 16:48:42

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
cla(handles.axes1);
set(handles.axes1, 'color', 'w');
clearvars -global % clears all global variables
numSteps = 10;
 set(handles.slider1, 'Min', 1);
 set(handles.slider1, 'Max', numSteps);
 set(handles.slider1, 'Value', 1);
 set(handles.slider1, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1) ]);
 %addlistener(handles.slider1, 'Value','PostSet', @SliderValueChanged);
addlistener(handles.slider1,'ContinuousValueChange',@(hObject, event) SliderValueChanged(handles, eventdata));
% UIWAIT makes Inspect_Shapes wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% h=figure; % so we don't have figure popping up.
% set(h,'visible','off');

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
clearvars -global % clears all global variables
set(handles.uipushsaveBtn, 'Enable', 'on');
global pathName;
[fileName,pathName] = uigetfile('*.mat','Select a processed Matlab file');
if fileName==0, return; end
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
global stackNumber;
[frameCurves,cellNumbers,stackNumber]=loadCurveDataFrom(pathName, fileName);
if isempty(frameCurves) || isempty(cellNumbers)
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(7);
    errordlg(msg, 'Error', mode);
    clearvars -global
    return
end
set(handles.currFileName, 'string', fileName );
handles.currPathName=pathName;
loadCurrFrame(1, 1, handles);
try zoom(handles.figure1, 'out'); end


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

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider1.
function SliderValueChanged(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num = floor(get(hObject.slider1,'Value'));
loadCurrFrame(num,0, hObject);







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
function [frameCurves,cellNumbers, stackNum] =loadCurveDataFrom(pathName, fileName)
frameCurves=[];cellNumbers={}; stackNum=-1;
[~,fName,ext] = fileparts(fileName);
if length(fName)>3
   num = fName(end-2:end);
   try stackNum= str2num(num); end
end
name = [fName 'CurveData' ext];
path =fullfile(pathName, name);
if ~exist(path, 'file'), return; end
tmp =load(path);
try 
    frameCurves=tmp.Frame_curves;
    cellNum=tmp.Cell_numbers;
end
frameNum=length(cellNum);
for i=1:frameNum % for initial state;
    cellInfo = cellNum{i};
    cellActive =ones(length(cellInfo),1);
    cellNumbers{i,1}=cellInfo;
    cellNumbers{i,2}=cellActive;
end
cellNumbers =loadSavedCorrections(stackNum, pathName, frameNum, cellNumbers);


% here we read out the information saved from a previous analysis
function cellNumbers =loadSavedCorrections(stackNum, pathName, frameNum, cellNumbers)
name=sprintf('CellFrameData%03d.mat',stackNum); % if we have saved something before;
try
    path =fullfile(pathName, name); 
    if ~exist(path, 'file'), return; end
    tmp =load(path);
    CellFrameData=tmp.CellFrameData;
    noCellId=length(CellFrameData);
    for i=1:noCellId
        cellInfo=CellFrameData(i);
        badFrames =cellInfo.BadFrames{3};
        if isempty(badFrames), continue; end;
        for j =1:frameNum
            if any(badFrames(:)==j)
               cllActive=cellNumbers{j,2};
               cllActive(i)=0;
               cellNumbers{j,2}=cllActive; 
            end
        end
    end     
end






function loadCurrFrame(number, activeChange, handles)
global stack;
global currFrame;

if (~isempty(currFrame) && currFrame==number) 
    if ~activeChange, return; end
end
        
currFrame=number;
if isempty(stack), return; end
cla(handles.axes1);
img=stack(:,:,number);
imagesc(img, 'Parent', handles.axes1);
axis off; colormap(gray);
hold on
global frameCurves; global cellNumbers;
if isempty(frameCurves) || isempty(cellNumbers), return; end
fCurves=frameCurves{number};
cNumber=cellNumbers{number,1};
cellActive=cellNumbers{number,2};
nCells=length(cNumber);
colour=cool(nCells);
for i=1:nCells
    curve =fCurves{i};
    active=cellActive(i);
    if active==0
        plot(handles.axes1, curve(:,2), curve(:,1), 'color', 'r', 'LineWidth', 2.0);
    else
        plot(handles.axes1, curve(:,2), curve(:,1), 'color', colour(i,:), 'LineWidth', 2.0);
    end
end



% --------------------------------------------------------------------
% this is the saveBTN function
function uipushsaveBtn_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushsaveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipushsaveBtn, 'Enable', 'off');
global pathName;
global stackNumber;
if isempty(pathName)
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(8);
    errordlg(msg, 'Error', mode);
    set(handles.uipushsaveBtn, 'Enable', 'on');
    return
end
   
fileName=sprintf('CellArray%03d.mat',stackNumber);
cPath =fullfile(pathName, fileName);
CellArray = getCellArray();


fileName=sprintf('CellFrameData%03d.mat',stackNumber); 
fPath =fullfile(pathName, fileName);
CellFrameData=getCellFrameData(stackNumber);

if isempty(CellFrameData) || isempty(CellArray), return; end
save(cPath,'CellArray', '-v7.3');
save(fPath,'CellFrameData', '-v7.3');

set(handles.uipushsaveBtn, 'Enable', 'on');
msg = DialogMessages(9);
helpdlg(msg, 'Info');


% this function creates the structure as it was defined
% in Sam's thesis for the next steps in processing.
function cellFrameData = getCellFrameData(stackNumber)
global cellNumbers;
global frameCurves;
cellFrameData={};
cellIds=getAllCellIds(cellNumbers);
for i=1:length(cellIds)
    id = cellIds(i);
    [contours, badFrmes]=getContourInfo(cellNumbers, frameCurves, id);
    cellFrameData(i).Stack_number=stackNumber;
    cellFrameData(i).Cell_number=id;
    cellFrameData(i).Contours=contours;
    cellFrameData(i).BadFrames=badFrmes;
end



function[contours, badFrmes]=getContourInfo(cellNumbers, frameCurves, id)
contours={};
badFrmes={};
faultyFrmes=[];
for i=1:length(cellNumbers)
    num=cellNumbers{i,1};
    cellAc=cellNumbers{i,2};
    curves=frameCurves{i};
    idx=find(num==id,1);
    if cellAc(idx) % it is a good frame
        contours{end+1}=curves{idx};
    else
        faultyFrmes(end+1)=i;
    end  
end
badFrmes{3}=faultyFrmes; % this was the original structure.





% looks at all cell ids and returns those
% as a number array back.
function cellIds=getAllCellIds(cellNumbers)
cellIds=[];
for i=1:length(cellNumbers)
    ids = cellNumbers{i};
    cellIds=[cellIds, ids];
    cellIds=unique(cellIds);
end




% this method looks which curves have been marked as ative
% and saves only the actives curves to the file
function cellArray = getCellArray()
global cellNumbers;
global frameCurves;
cellArray={};
for i = 1:length(cellNumbers)
    cellId=cellNumbers{i,1};
    cellAc=cellNumbers{i,2};
    curves=frameCurves{i};
    for j=1:length(cellId);
        if cellAc(j) % if it is active cell, add it
            cellArray{end+1}=curves{j};
        end
    end
end




% --------------------------------------------------------------------
function uitoggletool6_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitoggletool6, 'State', 'on');
zoom off
pan off

% --------------------------------------------------------------------
function uitoggletool5_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitoggletool6, 'State', 'off');

% --------------------------------------------------------------------
function uitoggletool2_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitoggletool6, 'State', 'off');


% --------------------------------------------------------------------
function uitoggletool1_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitoggletool6, 'State', 'off');



% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ptrState=get(handles.uitoggletool6, 'State');
if strcmp('on' , ptrState)==0, return; end; % if it is not pointer forget it. 
pos=get(handles.axes1,'CurrentPoint');
global frameCurves;
global currFrame;
global cellNumbers;
if isempty(frameCurves) || isempty(currFrame), return; end;
cellAc=cellNumbers{currFrame,2};
curves =frameCurves{currFrame};
for i=1:length(curves)
    curve=curves{i};
    [in,on]=inpolygon(pos(1,1), pos(1,2), curve(:,2), curve(:,1));
    if (in+on)>0
        cellAc(i)=mod(cellAc(i)+1,2);
        cellNumbers{currFrame,2}=cellAc;
        loadCurrFrame(currFrame, 1, handles);
        return;
    end
end
