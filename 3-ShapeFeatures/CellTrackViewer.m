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

% Last Modified by GUIDE v2.5 30-Apr-2015 15:11:10

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
figObj=handles.figure1;
addlistener(handles.slider1,'ContinuousValueChange',@(figObj, handles)slider1_ValueChanged(figObj, handles));
resetGUI(hObject, eventdata, handles);
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

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider1.
function slider1_ValueChanged(hObject, eventdata, ~)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hObj=guihandles(hObject);
stordInfo =getappdata(hObj.figure1);
obj=stordInfo.UsedByGUIData_m;
num = floor(get(obj.slider1,'Value'));
if ~(num==1) && obj.frmId==num, return; end % for num==1 we have a strange exception. I could not figure out why.
obj.frmId=num;
plotFig(obj, [], obj);



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%contents{get(hObject,'Value')} returns selected item from popupmenu1
%update slider.
labels=get(handles.popupmenu1,'String');
val=get(handles.popupmenu1,'Value');
str=labels{val};
lbs=regexp(str, ' ', 'split');
handles.CurrentCellId=round(str2double(lbs(end)));
handles.track =getHandlesStruc(handles.CurrentStack, handles.CurrentCellId, handles.bigCellDataStruc);
frames=length(handles.track.Contours);
updateSliderSteps(handles.slider1, frames);
handles.com = calculateGravityTrackFrom(handles);
handles.frmId=1;
guidata(handles.figure1,handles); % we store this data in the gui
plotFig(hObject, eventdata, handles);


function struc =getHandlesStruc(currentStackId, currentCellId, bigStructure)
s =size(bigStructure);
struc={};
for i=1:s(2)
    tmp = bigStructure(i);
    if ~(isempty(tmp.Stack_number) || isempty(tmp.Cell_number))
        if tmp.Stack_number==currentStackId && any(tmp.Cell_number==currentCellId)
            tmp.AbsIdx=i;
            struc = tmp;
            break
        end
    end
end
% calculate center of mass
function com = calculateGravityTrackFrom(handles)
track = handles.track;
com = zeros(length(track.Contours),2);
h=waitbar(0, 'prepare shape track');
N=length(track.Contours);
% get dimensions
xmax=0; ymax=0;
for i=1:N
    curve = track.Contours{i};
    xmax = max(xmax, max(curve(:,1)));
    ymax = max(ymax, max(curve(:,2)));
    bw=poly2mask(curve(:,1), curve(:,2), ymax,xmax);
    [y, x] = find( bw );
    com(i,1)=mean(x);
    com(i,2)=mean(y);
    msg =['prepare shape track' num2str(i) '/' num2str(N)];
    waitbar(i/N, h, msg);
end
close(h);



function updateSliderSteps(slider, numSteps)
if numSteps>1
set(slider, 'Min', 1.0);
set(slider, 'Max', numSteps);
set(slider, 'Value', 1);
set(slider, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1) ]);
return;
end
set(slider, 'Max', 1.1);
set(slider, 'Value', 1);
set(slider, 'SliderStep', [0.5 , 0.5 ]);

function plotFig(hObject, eventdata, handles)

plotShapeSpace(hObject, eventdata, handles); %axes4;
plotShapeTrack(handles.axes2, handles); %axes 3

function plotShapeSpace(hObject, eventdata, handles)

set(handles.axes4, 'Position' , [60 7.5 102 51]);
tlen=plotShapeSpaceOnAxes(handles.axes4, handles);
msg=[num2str(handles.frmId) '/' num2str(tlen) ' '];
set(handles.text1, 'String', msg);





function trackLength=plotShapeSpaceOnAxes(axes, handles)
cla(axes); trackLength=0;
axis(axes, 'auto');
plot(axes, handles.score(:,1), handles.score(:,2), '.', 'color',[0.5,.5,.5], 'MarkerSize', 10);
track=handles.track;
idxes = find(handles.indices==track.AbsIdx);
x = handles.score(idxes,1);
y = handles.score(idxes,2);
if isempty(x), return; end
trackLength=length(x);
hold on
orangeCol=[237/255 94/255 48/255];
blueCol=[156/255,187/255,229/255];
plot(axes, x,y, '-', 'color', blueCol,'MarkerSize', 20);
plot(axes, x,y, '.', 'color', blueCol,'MarkerSize', 20);
plot(axes, x(handles.frmId),y(handles.frmId), '.', 'color', orangeCol, 'MarkerSize', 20);
plot(axes, x(handles.frmId),y(handles.frmId), 'O', 'color', orangeCol, 'MarkerSize', 10);

axis(axes, 'equal'); 
axis(axes, 'tight');


function plotShapeTrack(ax, handles) % axes 3 plot the shapes. 
cla(ax);
orangeCol=[237/255 94/255 48/255];
blueCol=[156/255,187/255,229/255];

track=handles.track;
if isempty(handles.com), 
    return; end
plot(ax, handles.com(:,1), handles.com(:,2), '.', 'color', blueCol, 'MarkerSize',20);
hold(ax, 'on');
plot(ax, handles.com(:,1), handles.com(:,2), '-', 'color', blueCol, 'LineWidth',3);
plot(ax, handles.com(handles.frmId,1), handles.com(handles.frmId,2), '.', 'color', orangeCol, 'MarkerSize',20)
plot(ax, handles.com(handles.frmId,1), handles.com(handles.frmId,2), 'O', 'color', orangeCol, 'MarkerSize',15)
for i=1:length(track.Contours)
    curve = track.Contours{i};
    plot(ax, curve(:,1), curve(:,2), '-', 'color', [0.5,.5,.5]);
end
curve = track.Contours{handles.frmId};
plot(ax, curve(:,1), curve(:,2), '-', 'color', orangeCol, 'LineWidth', 3);
axis(ax, 'equal');



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

folderpath = uigetdir();
if folderpath==0, return; end
handles.csd =loadCellShapeData(folderpath);
if isempty(handles.csd), return; end
bigCellDataStruc=loadbigCellDataStruct(folderpath);
if isempty(bigCellDataStruc), return; end
if  isempty(bigCellDataStruc), resetGUI(hObject, eventdata, handles); return; end
[handles.indices, handles.contours]=loadBigcellarrayandindex(folderpath);
handles.bigCellDataStruc=bigCellDataStruc;
stackLabels= getStackNumbers(folderpath, handles);
if isempty(stackLabels), resetGUI(hObject, eventdata, handles); return; end
idLabels =getLabelsForStack(1, handles.bigCellDataStruc);
if isempty(idLabels), 
    set(handles.popupmenu1, 'string', 'No Tracks');
    set(handles.popupmenu1, 'Enable', 'off');
    return; 
end
set(handles.stackpopup, 'string', stackLabels);
set(handles.stackpopup, 'Enable', 'on');
set(handles.popupmenu1, 'string', idLabels);
set(handles.popupmenu1, 'Enable', 'on');
handles.score = getScoreFrom(handles.csd);
handles.CurrentStack=1;
handles.CurrentCellId=1;
handles.frmId=1;
guidata(handles.figure1,handles); % we store this data in the gui.
set(handles.popupmenu1, 'Value', 1); % set first as default value.
set(handles.stackpopup, 'Value', 1); % set first as default value.
popupmenu1_Callback(hObject, eventdata, handles);



function labels = getStackNumbers(folder, handles)
maxStack = getMaxStackNumber(folder);
if maxStack <0, resetPopups(handles); return; end 
labels ={};
for i =1: maxStack
    labels{end+1}=sprintf('Image Stack %03d ',i);
end





function counter = getMaxStackNumber(folder)
counter=-1;
file = fullfile(folder,'BigCellDataStruct.mat');
if ~exist(file, 'file')
    display(['The file "BigCellDataStruct"  is not present in your Analysis folder"\n' ...
             'Please check whether you followed all steps as described in the tutorial.'] );
    return
end
data = load(file);
s = size(data.BigCellDataStruct);
for i = 1:s(2)
    tmp = data.BigCellDataStruct(i);
    if tmp.Stack_number>counter
        counter=tmp.Stack_number;
    end
end



function [indices, contours]=loadBigcellarrayandindex(folderPath)
indices=[]; contours=[];
bPath = fullfile(folderPath, 'Bigcellarrayandindex.mat');
if ~exist(bPath, 'file'),filleDoesNotexist(bPath); return; end
try data = load(bPath);
indices=data.cell_indices;
contours=data.BigCellArray;
catch
    fileHasWrongStructure(cellShapePath);
    return;
end



function SCORE = getScoreFrom(CellShapeData)
if isfield(CellShapeData.set,'SCORE')
    SCORE=CellShapeData.set.SCORE;
else
    for i=1:N
       SCORE(i,:)= CellShapeData.point(i).SCORE;
    end
end


function csd = loadCellShapeData(folderPath)
csd=[];
bPath = fullfile(folderPath, 'CellShapeData_slim.mat');
if ~exist(bPath, 'file'),filleDoesNotexist(bPath); return; end
try data = load(bPath);
csd=data.CellShapeData;
catch
    fileHasWrongStructure(cellShapePath);
    return;
end

function resetGUI(hObject, eventdata, handles)
set(handles.stackpopup, 'Enable', 'off');
set(handles.stackpopup, 'string', {'No Cell Tracks found.  '});
cla(handles.axes2);
cla(handles.axes4);
set(handles.text1, 'String', ' ');
set(handles.popupmenu1, 'Enable', 'off');
set(handles.popupmenu1, 'String', 'No cell ids found');






function [labels] =getLabelsForStack(stackNumber, bigStructure)
s =size(bigStructure);
labels={};
for i=1:s(2)
    tmp = bigStructure(i);
    if isempty(tmp.Contours), continue; end
    if tmp.Stack_number==stackNumber
       labels{end+1}=sprintf('Cell Id %d', tmp.Cell_number);
    end
end

function bigCellDataStruct = loadbigCellDataStruct(folder)
bigCellDataStruct={};
bPath = fullfile(folder, 'BigCellDataStruct.mat');
if ~exist(bPath, 'file'),filleDoesNotexist(bPath); return; end
try data = load(bPath);
bigCellDataStruct=data.BigCellDataStruct;
catch
    fileHasWrongStructure(cellShapePath);
    return;
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
   





% --------------------------------------------------------------------
function save_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname]=uiputfile({'*.tiff';},'Save Average Shape Files');
if filename ==0, return; end
[folderSpace, folderShapes]= setUpFolderStructure(pathname, filename);


currentFrameId = handles.frmId;
tlen=plotShapeSpaceOnAxes(handles.axes4, handles);
f=figure('Visible','Off'); %does not keep if invisible. though
set(f, 'Position', [0, 0, 1024, 1024]);
set(0, 'currentfigure', f);

writeShapeSpaceToFile(f, folderSpace, tlen, handles)
writeShapesToFile(f, folderShapes, tlen, handles)

handles.frmId=currentFrameId;
guidata(handles.figure1,handles);

ax1=subplot(5,3,[4,7,10]);
ax2=subplot(5,3,[2,3,5,6,8,9,11,12,14,15]);
movieFileName=fullfile(pathname, filename);
tmpFile=fullfile(pathname, 'tmp4211.eps'); % without saving the frame before, getFrame works not correcltly. 
for i =1:tlen
    handles.frmId=i;
    guidata(handles.figure1,handles);
    plotShapeTrack(ax1, handles);
    plotShapeSpaceOnAxes(ax2, handles);
    saveas(f, tmpFile, 'epsc');
    A = getframe(f);
    imwrite(A.cdata, movieFileName, 'WriteMode', 'append',  'Compression','none');
end
delete(tmpFile);

set(0, 'currentfigure', handles.figure1);
close(f);



function [folderSpace, folderShapes]= setUpFolderStructure(pathname, filename)
[~,name,~] = fileparts(filename);
folder = fullfile(pathname, [name '_Movies']);

if exist(folder, 'dir')==7 
   rmdir(folder,'s'); end
folderSpace= fullfile(folder, 'ShapeSpace_Only');
folderShapes= fullfile(folder, 'Shapes_Only');
mkdir(folder);
mkdir(folderSpace);
mkdir(folderShapes);

function writeShapeSpaceToFile(f, folderSpace, tlen, handles)
set(f,'color','white');
movieFileName=fullfile(folderSpace, '_movie.tiff');
for i =1:tlen
    handles.frmId=i;
    guidata(handles.figure1,handles);
    axes=subplot(1,1,1);
    plotShapeSpaceOnAxes(axes, handles);
    frName=sprintf('frame%03d.eps',i); 
    saveas(f, fullfile(folderSpace, frName), 'epsc'); 
    A = getframe(f);
    imwrite(A.cdata, movieFileName, 'WriteMode', 'append',  'Compression','none');
end


function writeShapesToFile(f, folder, tlen, handles)
set(f,'color','white');
clf;
movieFileName=fullfile(folder, '_movie.tiff');
for i =1:tlen
    handles.frmId=i;
    guidata(handles.figure1,handles);
    axes=subplot(1,1,1);
    plotShapeTrack(axes, handles);
    frName=sprintf('frame%03d.eps',i); 
    saveas(f, fullfile(folder, frName), 'epsc'); 
    A = getframe(f);
    imwrite(A.cdata, movieFileName, 'WriteMode', 'append',  'Compression','none');
end


% --- Executes on selection change in stackpopup.
function stackpopup_Callback(hObject, eventdata, handles)
% hObject    handle to stackpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stackid=get(handles.stackpopup,'Value');
idLabels =getLabelsForStack(stackid, handles.bigCellDataStruc);
if isempty(idLabels), 
    set(handles.popupmenu1, 'string', 'No Tracks');
    set(handles.popupmenu1, 'Enable', 'off');
    return; 
end
set(handles.popupmenu1, 'string', idLabels);
set(handles.popupmenu1, 'Enable', 'on');
handles.CurrentStack=stackid;
handles.CurrentCellId=1;
set(handles.popupmenu1, 'Value', 1); % set first as default value.
guidata(handles.figure1,handles); % we store this data in the gui.
popupmenu1_Callback(hObject, eventdata, handles);





% --- Executes during object creation, after setting all properties.
function stackpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stackpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

