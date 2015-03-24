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

% Last Modified by GUIDE v2.5 23-Mar-2015 10:00:47

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
updateSliderSteps(10, handles);
 %addlistener(handles.slider1, 'Value','PostSet', @SliderValueChanged);
addlistener(handles.slider1,'ContinuousValueChange',@(hObject, event) SliderValueChanged(handles, eventdata));


% UIWAIT makes Inspect_Shapes wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% h=figure; % so we don't have figure popping up.
% set(h,'visible','off');

function updateSliderSteps(numSteps, handles)
set(handles.slider1, 'Min', 1);
set(handles.slider1, 'Max', numSteps);
set(handles.slider1, 'Value', 1);
set(handles.slider1, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1) ]);

% --- Outputs from this function are returned to the command line.
function varargout = Inspect_Shapes_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function checkForSavingCurrentMovie(hObject, eventdata, handles)
global stack;
if ~isempty(stack)
    choice = questdlg('Would you like to save current modifiation?', ...
	'Save Segementation','No','Yes', 'Yes');
    if strcmp('Yes', choice),
        uipushsaveBtn_ClickedCallback(hObject, eventdata, handles); end   
end

function resetGUIVariables(handles)
clearvars -global % clears all global variables
cla(handles.axes1);
set(handles.frames, 'String','');
set(handles.currFileName, 'string', '' );


% --------------------------------------------------------------------
% Tooltip: Open Folder Button
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
checkForSavingCurrentMovie(hObject, eventdata, handles);
resetGUIVariables(handles);
global stack;
global pathName;
[fileName,pathName] = uigetfile('*.mat','Select a processed Matlab file');
if fileName==0, return; end
global stackNumber;
[stack, stackNumber] = loadStackFromFile(pathName, fileName);
if isempty(stack)
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(6);
    errordlg(msg, 'Error', mode);
    clearvars -global
    return
end
global frameCurves;
global cellNumbers;
global orgFrameCurves;
global orgCellNumbers;
global mergeInfo;
[frameCurves,cellNumbers, mergeInfo]=loadSavedCurveDataFrom(pathName, fileName, stackNumber);
[orgFrameCurves,orgCellNumbers]=loadCurveDataFrom(pathName, fileName);
set(handles.currFileName, 'string', fileName );
handles.currPathName=pathName;
[~,~,frames]=size(stack);
updateSliderSteps(frames, handles);
%set up color
global allCellIds;
allCellIds=getAllCellIds(cellNumbers);
loadCurrFrame(1, 1, handles);
setUpGUI(handles, frames);

               
function setUpGUI(handles, frames)
set(handles.uipushsaveBtn, 'Enable', 'on');
try zoom(handles.figure1, 'out'); end
set(handles.filterSize, 'Enable', 'on');
set(handles.reset, 'Enable', 'on');
set(handles.liveSpan, 'Enable', 'on');
set(handles.slider1, 'Enable', 'on');
msg =['1/' num2str(frames)];
set(handles.frames, 'String',msg);




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
global currFrame;
if num==currFrame, return; end
loadCurrFrame(num,0, hObject);
global stack;
[~,~, frames]=size(stack);
msg =[num2str(num) '/' num2str(frames)];
set(hObject.frames, 'String',msg);






% this code can deal with legacy code from first 
% implementation. I store each stack in var.stack
% while the first version has given it the variable
% name with this structure: var.fileName%ID
% which can be lilke var.ImageStack001
% if file is not quite correct, then 
% it returns gracefully an empty variable.
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


% try to load the structure of cell curves in the data
% which hopefully have the expected structure 
% if expected structure is not found, the variables
% are returned empty.
function [frameCurves,cellNumbers] =loadCurveDataFrom(pathName, fileName)
frameCurves=[];cellNumbers={};
[~,fName,ext] = fileparts(fileName);

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


function [frameCurves,cellNumbers,mergeInfo] = loadSavedCurveDataFrom(pathName, fileName, stackNumber)
name=sprintf('ManCorrtdCrves%03d.mat',stackNumber); 
path =fullfile(pathName, name);
if ~exist(path, 'file'), 
    [frameCurves,cellNumbers] =loadCurveDataFrom(pathName, fileName);
    mergeInfo=setUpMergeInfo(length(frameCurves));
    return; 
end

tmp =load(path);
try 
frameCurves=tmp.frameCurves;
cellNumbers=tmp.cellNumbers;
mergeInfo=tmp.mergeInfo;
end
if isempty(mergeInfo)
    mergeInfo=setUpMergeInfo(length(frameCurves));
end



function mergeInfo=setUpMergeInfo(tlen)
mergeInfo={};
for i=1:tlen
     mergeInfo{end+1}=[];
end

function loadCurrFrame(number, activeChange, handles)
global stack;
global currFrame;
global allCellIds
if (~isempty(currFrame) && currFrame==number) 
    if ~activeChange, return; end
end
        
currFrame=number;
if isempty(stack), return; end
cla(handles.axes1);
img=stack(:,:,number);
img = mat2gray(img);
imagesc(img, 'Parent', handles.axes1);
axis off; colormap(gray);
hold on
global frameCurves; global cellNumbers;
if isempty(frameCurves) || isempty(cellNumbers), return; end
fCurves=frameCurves{number};
cNumber=cellNumbers{number,1};
cellActive=cellNumbers{number,2};
nCells=length(cNumber);
colour=prism(length(allCellIds));
lgd={};
lines=[];

for i=1:nCells
    curve =fCurves{i};
    active=cellActive(i);
    idx = find(allCellIds==cNumber(i), 1);
    if active==0
        lines(end+1)= plot(handles.axes1, curve(:,2), curve(:,1), 'color', [0.7 0.7 0.7], 'LineWidth', 2.0);
        lgd{end+1}= [ 'cell id: ' num2str(cNumber(i))];
    elseif active==1
        lgd{end+1}=[ 'cell id: ' num2str(cNumber(i))];
        lines(end+1)=plot(handles.axes1, curve(:,2), curve(:,1), 'color', colour(idx,:), 'LineWidth', 2.0);
    elseif active==3
        plot(handles.axes1, curve(:,2), curve(:,1), 'color', [0.7 0.7 0.7], 'LineWidth', 2.0);
    end
end

global mergeInfo;
l= mergeInfo{currFrame};
for i=1:length(l)
    str=l{i}; 
    try
        curve=str.MergedCurve;
        idx = find(allCellIds==str.id, 1);
        lines(end+1)=plot(handles.axes1, curve(:,2), curve(:,1), 'color', colour(idx,:), 'LineWidth', 2.0);
        s=[ 'cell id: ' num2str(str.id)];
        lgd{end+1}=s;
    end
    h=imline(handles.axes1, [str.posA(1), str.posB(1)], [str.posA(2), str.posB(2)]);
    h.setColor('m');
    h.addNewPositionCallback(@(pos)updatePosition(pos, handles, h));
    upateContextMenu(h, [], handles);
end


% adding legend
state=get(handles.uitoggletool9, 'State');
legend(handles.axes1,lines, lgd);
if strcmp('off', state),legend(handles.axes1,'off'); end



% legend(handles.axes1,state);
% load merge info if state is pressed.

%uitoggletool9
%SelectionHighlight
% --------------------------------------------------------------------
% this is the saveBTN function
function uipushsaveBtn_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushsaveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipushsaveBtn, 'Enable', 'off');
[idsOk, fid] = areCellIdsCorrectForAllFrames();
if ~idsOk, 
     msg =['There is an issue with cell ids from frame ' num2str(fid) ' onwards.\n Current Modification cannot be chagned.'];
     warndlg(msg,'!! Warning !!'); 
    set(handles.uipushsaveBtn, 'Enable', 'on');
    return;
end

global pathName;
global stackNumber;
if isempty(pathName)
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(8);
    errordlg(msg, 'Error', mode);
    set(handles.uipushsaveBtn, 'Enable', 'on');
    return
end
   
global cellNumbers; 
global frameCurves;
global mergeInfo;
if isempty(cellNumbers) || isempty(frameCurves)
    msg = DialogMessages(11);
    helpdlg(msg, 'Info');
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

fileName=sprintf('ManCorrtdCrves%03d.mat',stackNumber); 
mPath =fullfile(pathName, fileName);
save(mPath,'frameCurves', 'cellNumbers', 'mergeInfo', '-v7.3');



% this function creates the structure as it was defined
% in Sam's thesis for the next steps in processing.
function cellFrameData = getCellFrameData(stackNumber)
global cellNumbers;
global frameCurves;
global mergeInfo;
cellFrameData={};
cellIds=getAllCellIds(cellNumbers);
j=1; % we index only the non_empty contours. 
for i=1:length(cellIds)
    id = cellIds(i);
    [contours, badFrmes]=getContourInfo(cellNumbers, frameCurves, id, mergeInfo);
    if length(contours)<1, 
        continue; end
    cellFrameData(j).Stack_number=stackNumber;
    cellFrameData(j).Cell_number=id;
    cellFrameData(j).Contours=contours;
    cellFrameData(j).BadFrames=badFrmes;
    j=j+1;
end



function[contours, badFrmes]=getContourInfo(cellNumbers, frameCurves, id, mergeInfo)
contours={};
badFrmes={};
faultyFrmes=[];
goodFrames=[];
for i=1:length(cellNumbers)
    num=cellNumbers{i,1};
    cellAc=cellNumbers{i,2};
    curves=frameCurves{i};
    idx=find(num==id,1);
    if cellAc(idx)==1 % it is a good frame
        contours{end+1}=curves{idx};
        goodFrames(end+1)=i;
    elseif cellAc(idx)==0   
        faultyFrmes(end+1)=i;
    elseif ~isempty(idx) %check merged.
        curve=getMergedContour(mergeInfo{i},id);
        if ~isempty(curve), contours{end+1}=curve; goodFrames(end+1)=i; end
    end
        
end
% missing frames which can also be for jump of id, are added.
[minFrmIdx , maxFrmIdx] = getMinMaxFrame(faultyFrmes, goodFrames);

faulty = zeros(maxFrmIdx-minFrmIdx+1,1);
if isempty(faulty), return; end
gIdx=goodFrames-minFrmIdx+1;
faulty(gIdx)=1;
fIdx=find(faulty==0);
if isempty(fIdx), return; end
faultyFrmes = fIdx+minFrmIdx-1;
badFrmes{1}=faultyFrmes; % this was the original structure.
 



function [minFrmIdx , maxFrmIdx] = getMinMaxFrame(faultyFrmes, goodFrames)
if isempty(faultyFrmes) && ~isempty(goodFrames)
   minFrmIdx = min(goodFrames);
   maxFrmIdx=  max(goodFrames);
   return;
end

if ~isempty(faultyFrmes) && isempty(goodFrames)
    minFrmIdx = min(faultyFrmes);
    maxFrmIdx=  max(faultyFrmes); 
   return;
end
minFrmIdx = min(min(goodFrames), min(faultyFrmes));
maxFrmIdx=  max(max(goodFrames), max(faultyFrmes));
    

function curve=getMergedContour(mrgInfo,id)
curve={};
for i=1:length(mrgInfo)
    m=mrgInfo{i};
    if id==m.id
        curve=m.MergedCurve;
    end
end

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
global mergeInfo;
cellArray={};
for i = 1:length(cellNumbers)
    cellId=cellNumbers{i,1};
    cellAc=cellNumbers{i,2};
    curves=frameCurves{i};
    for j=1:length(cellId);
        if cellAc(j)==1 % if it is active cell, add it
            cellArray{end+1}=curves{j};
        end
    end
    mrgInf=mergeInfo{i};
    for j=1:length(mrgInf)
        m=mrgInf{j};
        cellArray{end+1}=m.MergedCurve;
    end
end




% --------------------------------------------------------------------
% Toolbar: Data Cursor
function uitoggletool6_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitoggletool6, 'State', 'on');
set(handles.setId, 'State', 'off');
setptr(handles.figure1, 'arrow');
zoom off
pan off

% --------------------------------------------------------------------
% Toolbar: Pan
function uitoggletool5_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitoggletool6, 'State', 'off');
set(handles.setId, 'State', 'off');
zoom off
pan off

% --------------------------------------------------------------------
% Toolbar: Pan on
function uitoggletool2_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitoggletool6, 'State', 'off');
set(handles.setId, 'State', 'off');
zoom off
pan off

% --------------------------------------------------------------------
% Toolbar: zoom on
function uitoggletool1_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitoggletool6, 'State', 'off');
set(handles.setId, 'State', 'off');
zoom off
pan off


% --------------------------------------------------------------------
% Toolbar: Change ID
function setId_OnCallback(hObject, eventdata, handles)

% hObject    handle to setId (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitoggletool6, 'State', 'off');
set(handles.setId, 'State', 'on');
setptr(handles.figure1, 'crosshair');
zoom off
pan off


% --------------------------------------------------------------------
function setId_OffCallback(hObject, eventdata, handles)
% hObject    handle to setId (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.setId, 'State', 'off');
setptr(handles.figure1, 'arrow');


% Toolbar: Free IM ROI
% --------------------------------------------------------------------
function mergeShape_OnCallback(hObject, eventdata, handles)
% hObject    handle to mergeShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitoggletool6, 'State', 'off');
set(handles.setId, 'State', 'off');
zoom off
pan off


% --------------------------------------------------------------------
function mergeShape_OffCallback(hObject, eventdata, handles)
% hObject    handle to mergeShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.mergeShape, 'State', 'off');


% % --------------------------------------------------------------------
% function merge_OffCallback(hObject, eventdata, handles)
% % hObject    handle to merge (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% % guiHandle.Merge=0;
% % guidata(handles.figure1,guiHandle);
% setptr(handles.figure1, 'arrow');
% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ptrState=get(handles.uitoggletool6, 'State');
idState=get(handles.setId, 'State');
%modifiers = get(handles.figure1,'CurrentCharacter');
pos=get(handles.axes1,'CurrentPoint');
if strcmp('on' , ptrState)==1    
    key=get(hObject,'SelectionType');
    modifier= strcmp(key, 'alt');
    selectTogglePressed(pos, modifier, handles); 
    return; 
end

global currFrame;
if strcmp('on', idState)==1
   changeIdOfCell(pos);
   loadCurrFrame(currFrame,1,handles);
   [idsOk, fid]=areCellIdsCorrectForAllFrames;
   if ~idsOk, warndlg(['There is an issue with cell ids from frame ' num2str(fid) ' onwards.'],'!! Warning !!'); end
end


function changeIdOfCell(pos)
[cellId, state] =isClickInShape(pos);
if cellId<1, return; end
msg = ['The current cell id = ' num2str(cellId) ', which will changed into the New Id.'];
warning('off');
newId=FilterDialog(msg, 'new Id ', num2str(cellId));
if newId<0, return; end % user clicked cancel.
if newId==cellId, return; end
changeIds(cellId, newId, state);


function changeIds(cellId, newId, state)
global cellNumbers;
global stack;
global mergeInfo;
[~,~,N]=size(stack);
for i=1:N
    if state==3
        mergeInfo{i} = changeMergedId(mergeInfo{i},cellId, newId);
    else %change cell id.
        cellIds=cellNumbers{i,1};
        idx = find(cellIds==cellId);
        if isempty(idx), continue; end
        cellIds(idx)=newId;
        cellNumbers{i,1}=cellIds;
    end
end
global allCellIds;
allCellIds=getAllCellIds(cellNumbers);


function mrgInf = changeMergedId(mrgInf,cellId, newId)
for i=1:length(mrgInf)
    item = mrgInf{i};
    if item.id==cellId,
       item.id=newId;
       mrgInf{i}=item;
       break;
    end
end


function selectTogglePressed(pos, modifier, handles)
global currFrame;
global stack;
[~,~,N]=size(stack);
[cellId, state] =isClickInShape(pos);
if cellId<1 || state==3, return; end
eIdx=currFrame; 
if modifier, eIdx=N; end
removesCellsFromStack(currFrame, eIdx, cellId, state);

loadCurrFrame(currFrame, 1, handles);% repaint figure;
[cellId, ~] =isClickInShape(pos);
if cellId<1, return; end
 



function [cellId, state, mergedId] =isClickInShape(pos)
cellId=-1;
mergedId=-1;
state=0;
global frameCurves;
global currFrame;
global cellNumbers;
global mergeInfo;
if isempty(frameCurves) || isempty(currFrame), return; end;
cellAc=cellNumbers{currFrame,2};
cellIds=cellNumbers{currFrame,1};
curves =frameCurves{currFrame};

for i=1:length(curves)
    curve=curves{i};
    id = cellIds(i);
    [in,on]=inpolygon(pos(1,1), pos(1,2), curve(:,2), curve(:,1));
    if (in+on)>0
        cellId=id;
        mergedId=id;
        if cellAc(i)==3, state=3; break; end
        cellAc(i)=mod(cellAc(i)+1,2);
        state=cellAc(i);
        break;
    end
end
if state ==3 % if we operate on a merged item, we need to check there.
   mrgInf=mergeInfo{currFrame};
   for i =1:length(mrgInf)
       item = mrgInf{i};
       if sum(find(item.ids==cellId))>0
          cellId=item.id;
          break
       end
   end
end



% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%try pos=get(handles.axes1,'CurrentPoint');catch return; end



% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global currFrame;
try 
    if handles.MergedPosChanged==1
       handles.MergedPosChanged=0;
        guidata(handles.figure1,handles); 
       
       exectueMerge(currFrame);
       loadCurrFrame(currFrame, 1,handles);
    end
end


% remove the cell with cellId from all future frames.
% frame str = sIdx
% frame end = eIdx
function removesCellsFromStack(sIdx, eIdx, cellId, state)
global cellNumbers;
if sIdx<1 || eIdx<1 || cellId<1, return; end
if isempty(cellNumbers), return; end
for i=sIdx:eIdx
    cellAc=cellNumbers{i,2};
    cellIds=cellNumbers{i,1};
    idx =find(cellIds==cellId,1);
    if isempty(idx), continue; end
    cellAc(idx)=state;
    cellNumbers{i,2}=cellAc;
end



% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

function figure1_WindowKeyReleaseFcn(hObject, eventdata, handles)
function slider1_ButtonDownFcn(hObject, eventdata, handles)


% --------------------------------------------------------------------
function filterSize_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to filterSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning('off','all')
num=FilterDialog('Filter removes shapes with area smaler than minimal area.', 'Min Area [px]', 100);
if num<1, return; end % user clicked cancel.
filterForArea(num);
global currFrame;
loadCurrFrame(currFrame, 1, handles);% repaint figure;


function filterForArea(area)
global frameCurves;
global cellNumbers;
global stack;
if isempty(stack), return; end;
[~, ~, frames]=size(stack);
for i =1:frames
    curves=frameCurves{i};
    cellAc=cellNumbers{i,2};
    cellId=cellNumbers{i,1};
    for j=1:length(cellId)
        curve=curves{j};
        polyArea=polyarea( curve(:,2), curve(:,1));
        if cellAc(j)==1&&polyArea<=area 
            cellAc(j)=0; % all smaller areas filterd out.
        end
    end
    cellNumbers{i,2}=cellAc;
end





% --------------------------------------------------------------------
function reset_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global currFrame;
resetSegementation(currFrame, 0);
loadCurrFrame(currFrame, 1, handles);% repaint figure;

% --------------------------------------------------------------------
function resetAll_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to resetAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('Are you sure you want to reset the complete movie?', ...
	'Reset Movie','No','Yes', 'Yes');
if strcmp(choice, 'No')==1, return; end
resetSegementation(1,1);
global currFrame;
loadCurrFrame(currFrame, 1, handles);

function resetSegementation(currFrame, allFutFrames)
global cellNumbers;
global frameCurves;
global orgFrameCurves;
global orgCellNumbers;
global mergeInfo;
eIdx=currFrame;
if allFutFrames 
   global stack;
   [~, ~, eIdx]=size(stack);
end
if (isempty(cellNumbers) || isempty(frameCurves) ||...
   isempty(orgFrameCurves) || isempty(orgCellNumbers)), return; end
for i=currFrame:eIdx
    curves=orgFrameCurves{i};
    cellAc=orgCellNumbers{i,2};
    cellIds=orgCellNumbers{i,1};
    cellNumbers{i,2}=cellAc;
    cellNumbers{i,1}=cellIds;
    frameCurves{i}=curves;
    mergeInfo{i}=[];
end
global allCellIds;
allCellIds=getAllCellIds(cellNumbers);

function filterOutLifeSpanShorterThan(framNum)
global cellNumbers;
global stack;
if isempty(stack), return; end
[~,~, frames]=size(stack);
cellIds=getAllCellIds(cellNumbers);
cellLife=zeros(length(cellIds),1);
for i=1:frames
    cellAc=cellNumbers{i,2};
    cellId=cellNumbers{i,1};
    for j=1:length(cellId)
        if cellAc(j)>0, % we only count active frames
            cellLife(cellId(j))=cellLife(cellId(j))+1;
        end
    end
end
cellsToRemove=cellLife<framNum;
if sum(cellsToRemove)<1, return; end % no cell lives shorter.

for i=1:frames
    cellAc=cellNumbers{i,2};
    cIds=cellNumbers{i,1};
    for j=1:length(cIds)
        cellId=cIds(j);
        idx=find(cellIds==cellId,1);
        if cellsToRemove(idx)==1
            cellAc(j)=0;
        end
    end
    cellNumbers{i,2}=cellAc;
end
%is any shorter than life span?


% --------------------------------------------------------------------
function liveSpan_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to liveSpan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num=FilterDialog('Filter removes shapes present less than in in Min Frames Number', 'Min Frame No:', 5);
filterOutLifeSpanShorterThan(num);
global currFrame;
loadCurrFrame(currFrame, 1, handles);% repaint figure;


% --------------------------------------------------------------------
% this is the free shape drawing tool
function pMerge_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pMerge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uitoggletool2_OnCallback(hObject, eventdata, handles) %set other commands of
global currFrame; 

[~, xi, yi] =roipoly(handles.axes1);
if isempty(xi)|| isempty(yi), return; end
markeMergedShapes(xi,yi, currFrame);
addManualShapeToFrame(xi, yi, currFrame);
loadCurrFrame(currFrame, 1,handles);



function markeMergedShapes(xi,yi, currFrame)
global frameCurves;
global cellNumbers;
curves=frameCurves{currFrame};
cellAc=cellNumbers{currFrame,2};
for i =1:length(curves)
    curve = curves{i};
    [in,on] = inpolygon(curve(:,2), curve(:,1),xi,yi);
    if sum(in(:))+sum(on(:))>0
        cellAc(i)=0; %merge
    end
end
cellNumbers{currFrame,2}=cellAc;

function addManualShapeToFrame(xi, yi, currFrame)
if isempty(xi)|| isempty (yi), return; end;
global frameCurves;
global cellNumbers;
global allCellIds;
curves=frameCurves{currFrame};
cellAc=cellNumbers{currFrame,2};
cellIds=cellNumbers{currFrame,1};


curves{end+1}=[yi,xi];
frameCurves{currFrame}=curves;
maxId=max(allCellIds);
cellIds(end+1)=maxId+1;
allCellIds(end+1)=cellIds(end);
cellNumbers{currFrame,1}=cellIds;
cellAc(end+1)=1;
cellNumbers{currFrame,2}=cellAc;


% --------------------------------------------------------------------
function merge_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to merge (see GCBO)
% eventdata  reserved - to be defined in a futureposition = wait(h); version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitoggletool6, 'State', 'off');
set(handles.setId, 'State', 'off');
zoom off
pan off
g=helpdlg(DialogMessages( 14 ),'How to Merge');
fp=getpixelposition(handles.figure1,true);
movegui(g,[fp(1)+fp(3),fp(2)+fp(4)-60]);
h=imline(handles.axes1);


position = wait(h);
try close(g);end
global currFrame;
if isempty(position), return; end
[inside, ids]=bothPosInSideCell(position(1,:), position(2,:));
if ~inside || isempty(ids),h.delete(); return; end
upateContextMenu(h, hObject, handles);

m.posA=position(1,:);
m.posB=position(2,:);
m.ids=ids;
m.id=min(m.ids);
updateMergeInfo(m, h);
exectueMerge(currFrame);
loadCurrFrame(currFrame, 1,handles);


function upateContextMenu(h, hObject, handles)
h.setColor('m');
h.addNewPositionCallback(@(pos)updatePosition(pos, handles, h));
hMyMenu = uicontextmenu('Parent',handles.figure1);
uimenu(hMyMenu, 'Label', 'Remove', 'Callback', @(hObject,handles)removeInLine(h, hObject, handles));
set(findobj(h, 'Type', 'line'), 'UIContextMenu', hMyMenu);



function removeInLine(h, hObject, handles)
if isempty(h), return; end
pos = h.getPosition();
global currFrame;
global stack;
[~,~,tlen]=size(stack);
mId = getMergedIds(currFrame, pos);
if mId <1, return; end 
for i=currFrame:tlen
    removeMergedItemFor(mId, i);
end
h.delete(); 
loadCurrFrame(currFrame, 1, guihandles(hObject));


function removeMergedItemFor(mId, frameIdx)
global mergeInfo;
global cellNumbers;
cellAc=cellNumbers{frameIdx,2};
cellIds=cellNumbers{frameIdx,1};

mrgInfo = mergeInfo{frameIdx};
for i=1:length(mrgInfo)
    item = mrgInfo{i};
    if item.id==mId
        mrgInfo{i}=[];
        emptyCells = cellfun('isempty', mrgInfo);
        mrgInfo(emptyCells) = [];
        mrgInfo = reshape(mrgInfo, [], 1);   
        for j=1:length(item.ids) %unmerge shapes.
            idx = find(cellIds==item.ids(j), 1);
            cellAc(idx)=1;
        end
    end
 
end
mergeInfo{frameIdx}=mrgInfo;
cellNumbers{frameIdx,2}=cellAc;


function [mId] = getMergedIds(frameIdx, pos)
global mergeInfo;
mId=-1; 
mrgInfo = mergeInfo{frameIdx};
for i=1:length(mrgInfo)
    item = mrgInfo{i};
    if xor(isequal(pos(2,:), item.posA), isequal(pos(2,:), item.posB)) && ...
        xor(isequal(pos(1,:), item.posA), isequal(pos(1,:), item.posB))
        mId=item.id;
        return;
    end
 
end

function updateMergeInfo(merge, h)
global mergeInfo;
global currFrame;
l=mergeInfo{currFrame};

if isempty(l), l={}; end
found =0;
cIds=sort(merge.ids);
for i=1:length(l)
    tmp = l{i};
    if isempty(tmp), continue; end
    ids = sort(tmp.ids);
    if isequal(ids, cIds);
       h.delete(); found=1;
       break;
    end
end
if ~found, l{end+1}=merge; end
mergeInfo{currFrame}=l;

function updatePosition(posts, handles, h)
global mergeInfo;
global currFrame;
l=mergeInfo{currFrame};
[inside, cIds]=bothPosInSideCell(posts(1,:), posts(2,:));
cIds=sort(cIds);
if isempty(cIds) 
    warning('off');
    h.delete();
    loadCurrFrame(currFrame, 1, handles);
    return;
end
for i=1:length(l)
    tmp=l{i};
    ids = sort(tmp.ids); 
    if isequal(ids, cIds);
        tmp.posA=posts(1,:);
        tmp.posB=posts(2,:);
        l{i}=tmp;
        if ~inside,l{i}=[];
            h.delete(); end
        break;
    end
end
mergeInfo{currFrame}=l;
handles.MergedPosChanged=1;
guidata(handles.figure1,handles); 

function [b, ids]= bothPosInSideCell(pos1, pos2)
b=1; ids=[];
[cellId1, state1, mId1] =isClickInShape(round(pos1));
[cellId2, state2, mId2]=isClickInShape(round(pos2));
if cellId1<1 || cellId2<1
    b=0; return; end
if (state1==3 && state2==3) && mId2>0 && mId1>0 && ~(mId1==mId2)
   ids=[mId1, mId2]; end
if ~(cellId1==cellId2) && ~(state1==3) &&~(state2==3)
    ids=[cellId1, cellId2]; end







function exectueMerge(currFrame)
global mergeInfo;
global frameCurves;
global cellNumbers;
global stack;
frame=stack(:,:,currFrame);
[~,~,tlen]=size(stack);
mrgInf=mergeInfo{currFrame};
if isempty(mrgInf), return; end
for i=1:length(mrgInf)
    h = waitbar(0,'Merging ... '); 
    item = mrgInf{i};
    for j=currFrame:tlen
        [cellAct, mrgInf]=updateMergeInforForFrame(frameCurves, cellNumbers, mergeInfo, j, item, frame);
        if isempty(cellAct) || isempty(mrgInf), continue;end
        mergeInfo{j}=mrgInf;
        cellNumbers{j,2}=cellAct;
         waitbar(j/tlen,h,['Merging at frame ' num2str(j) 'of' num2str(tlen)]);
    end
    close(h);
end




function [cellAct, mrgInf]=updateMergeInforForFrame(frameCurves, cellNumbers, mergeInfo, frmNum, item, frame)
cellAct=[]; mrgInf=[];
if isempty(frameCurves) || isempty(cellNumbers), return, end
curves=frameCurves{frmNum};
cellIds=cellNumbers{frmNum,1};
cellAct=cellNumbers{frmNum,2};
idx1=find(cellIds==item.ids(1),1);
idx2=find(cellIds==item.ids(2),1);
if isempty(idx1) ||isempty(idx2), return; end % do nothing.
mrgInf=mergeInfo{frmNum};
[item.id1, curve1, item.iterSec1]=findIntersection(curves, cellIds,item.ids(1), item.posA, item.posB);
[item.id2, curve2, item.iterSec2]=findIntersection(curves, cellIds,item.ids(2), item.posA, item.posB);
item.MergedCurve =connect2Shapes(item, frame, curve1, curve2);
item.posA=item.iterSec1;
item.posB=item.iterSec2;
idx1=find(cellIds==item.id1, 1); %mark as 3
cellAct(idx1)=3;
idx2=find(cellIds==item.id2, 1);
cellAct(idx2)=3;
mergeInfo{frmNum}=mrgInf;
found =0;
for i=1:length(mrgInf) % remove existing Info.
    tmp=mrgInf{i};
    if isequal(tmp.ids, item.ids)
        mrgInf{i}=item;
        found=1;
        break;
    end
end
if ~found, mrgInf{end+1}=item; end


function curve =connect2Shapes(item, frame, curve1, curve2)
if isequal(item.posA,item.iterSec2) && ...
   isequal(item.posB,item.iterSec2), return; end % we have already merged.
bwShape1=getBWCountour(curve1, frame);
bwShape2=getBWCountour(curve2, frame);
bwInter1=getBWCountour([item.iterSec1(2),item.iterSec1(1)], frame);
bwInter2=getBWCountour([item.iterSec2(2),item.iterSec2(1)], frame);

A = imdilate(bwInter1,strel('disk',3,0))&bwShape1;
B = imdilate(bwInter2,strel('disk',3,0))&bwShape2;
piece=bwconvhull(A|B);

BW=piece|bwShape1|bwShape2;
B=bwboundaries(BW,'noholes');
c=B{1}(:,[2 1]);
curve(:,1)=c(:,2); %for consistency with other curves.
curve(:,2)=c(:,1);



function mask = getBWCountour(curve, frame)
mask = zeros(size(frame));
[last,~]=size(curve);
for i =1:last
    mask(curve(i,1),curve(i,2))=1;
end

function [id, curve,interSect]=findIntersection(curves, cellIds, id, posA, posB)
idx1=find(id==cellIds,1); 
curve=curves{idx1};
dx=0;dy=0;d=Inf;
for i=1:length(curve(:,1))
    [dx,dy,d]=updateDistanceInfo(dx,dy, curve(i,2), curve(i,1), d, posA);
    [dx,dy,d]=updateDistanceInfo(dx,dy, curve(i,2), curve(i,1), d, posB);
end
interSect(1)=dx;
interSect(2)=dy;


function [dx,dy,d]=updateDistanceInfo(dx,dy, cX, cY, d, pos)
nwD=sqrt((pos(1)-cX)^2+(pos(2)-cY)^2);
if nwD<d
   dx=cX;
   dy=cY;
   d=nwD;
end

function [b, frmId] = areCellIdsCorrectForAllFrames()
b=1; frmId=-1;
global stack;
global mergeInfo;
global cellNumbers;
[~, ~, tlen]=size(stack);
for i=1:tlen
    allIds=[];
    cellIds=cellNumbers{i,1};
    cellAct=cellNumbers{i,2};
    ids = cellAct<2;
    allIds=[allIds, cellIds(ids)];
    mrgInfo = mergeInfo{i};
    for j=1:length(mrgInfo)
        m=mrgInfo{j};
        allIds(end+1)=m.id;
    end
    if ~(length(allIds)==length(unique(allIds))), b=0; frmId=i; break; end
end


