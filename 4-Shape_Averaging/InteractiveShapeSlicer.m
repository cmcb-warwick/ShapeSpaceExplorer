function varargout = InteractiveShapeSlicer(varargin)
% INTERACTIVESHAPESLICER MATLAB code for InteractiveShapeSlicer.fig
%      INTERACTIVESHAPESLICER, by itself, creates a new INTERACTIVESHAPESLICER or raises the existing
%      singleton*.
%
%      H = INTERACTIVESHAPESLICER returns the handle to a new INTERACTIVESHAPESLICER or the handle to
%      the existing singleton*.
%
%      INTERACTIVESHAPESLICER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERACTIVESHAPESLICER.M with the given input arguments.
%
%      INTERACTIVESHAPESLICER('Property','Value',...) creates a new INTERACTIVESHAPESLICER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before InteractiveShapeSlicer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to InteractiveShapeSlicer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help InteractiveShapeSlicer

% Last Modified by GUIDE v2.5 13-Dec-2017 15:35:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InteractiveShapeSlicer_OpeningFcn, ...
                   'gui_OutputFcn',  @InteractiveShapeSlicer_OutputFcn, ...
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


% --- Executes just before InteractiveShapeSlicer is made visible.
function InteractiveShapeSlicer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to InteractiveShapeSlicer (see VARARGIN)

% Choose default command line output for InteractiveShapeSlicer
handles.output = hObject;
 resetAxes(handles);
% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);

%figure1_ResizeFcn(hObject, eventdata, handles);
% UIWAIT makes InteractiveShapeSlicer wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function resetAxes(handles)
set(handles.brush, 'State', 'off');
cla(handles.axes2,'reset');
set(gca,'xtick',[],'ytick',[],'Xcolor','w','Ycolor','w')


% --- Outputs from this function are returned to the command line.
function varargout = InteractiveShapeSlicer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function open_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cellShapeData
resetAxes(handles);
path = uigetdir();
if path==0, return; end
cellShapePath = fullfile(path, 'CellShapeData.mat');
if exist(cellShapePath, 'file')
    display('File is loading ... ');
    try data = load(cellShapePath);
        cellShapeData=data.CellShapeData;
    catch
        fileHasWrongStructure(cellShapePath);
        return;
    end
else
    filleDoesNotexist(cellShapePath);
    return;
end
% now we are ready to plot

SCORE = getScoreFrom(cellShapeData);
plotScore(SCORE, handles.axes2);
%%

%%
handles.score=SCORE;
handles.path=path;
handles.CSD=cellShapeData;
guidata(handles.figure1,handles); 



function plotScore(SCORE, axes1)
global cellShapeData
csd= cellShapeData;
%set(0, 'currentfigure', fig);  %# for figures
%set(f, 'currentaxes', axs);  %# for axes with handle axs on figure f
if isempty(SCORE), return; end
N = length(SCORE);
mk = getMarkerSize(N);
hLine=plot(axes1,SCORE(:,1),SCORE(:,2),'.', 'color',[0.5,.5,.5], 'MarkerSize', mk);
%%
brush on
%f = figure;
h = uicontrol('Position',[20 20 200 40],'String','Continue',...
              'Callback','uiresume(gcbf)');
disp('This will print immediately');
uiwait(gcf); 
disp('This will print after you click Continue');
%close(f);

brushedIdx = logical(hLine.BrushData);  % logical array
 x = hLine.XData(brushedIdx);
 y = hLine.YData(brushedIdx);
 
% csd =[];
%try csd = handles.CSD;end
%if isempty(csd), return; end
[cx, cy] =getCenterCoordinate(x,y);
size(csd)
[selectedIdx, mIdx] = findSelectedIdx(csd, x,y, cx, cy);
if isempty(mIdx) || ~isempty(find(selectedIdx==0, 1)), return; end
avshape=shapemean(csd,selectedIdx,mIdx,0);

%figure(10)
%clf;
hold on
axes('Position',[.7 .7 .2 .2])
box on
orangeCol=[237/255 94/255 48/255];
plot(avshape, 'color', orangeCol,'LineWidth',3)
%axis equal
plotScore(SCORE, axes1);
% h=figure(11);
% clf;
% set(0, 'currentfigure', h);  %# for figures
% N = length(SCORE);
% mk = getMarkerSize(N);
% plotScore(SCORE, gca);
% plot(x,y,'.', 'color',orangeCol, 'MarkerSize', mk);
% %%
% axis equal; axis tight; box on
% hold on

    
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


function SCORE = getScoreFrom(CellShapeData)
%if isfield(CellShapeData.point,'SCORE')
    SCORE=CellShapeData.point.SCORE;
    N=length(CellShapeData.point);
%else
    for i=1:N
       SCORE(i,:)= CellShapeData.point(i).SCORE;
    end
%end


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --------------------------------------------------------------------
function brush_OffCallback(hObject, eventdata, handles)
% hObject    handle to brush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
brush off
set(handles.brush, 'State', 'off');




% --------------------------------------------------------------------
function brush_OnCallback(hObject, eventdata, handles)
% hObject    handle to brush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom off
pan off
h = brush(handles.figure1);
orangeCol=[237/255 94/255 48/255];
set(h,'Color',orangeCol,'Enable','on');
%b = get(orangeCol,'BrushData')


% --------------------------------------------------------------------
function zoom_in_OnCallback(hObject, eventdata, handles)
% hObject    handle to zoom_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.brush, 'State', 'off');

% --------------------------------------------------------------------
function zoom_out_OnCallback(hObject, eventdata, handles)
% hObject    handle to zoom_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.brush, 'State', 'off');

% --------------------------------------------------------------------
function pan_OnCallback(hObject, eventdata, handles)
% hObject    handle to pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.brush, 'State', 'off');


    


% --------------------------------------------------------------------
function genFig_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to genFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(handles.brush, 'State', 'off');
hBrushLine = findall(handles.axes2,'tag','Brushing');
brushedData = get(hBrushLine, {'Xdata','Ydata'});
if isempty(brushedData), return; end
brushedIdx = ~isnan(brushedData{1});
x = brushedData{1}(brushedIdx);
y = brushedData{2}(brushedIdx);
csd =[];
try csd = handles.CSD;end
if isempty(csd), return; end
[cx, cy] =getCenterCoordinate(x,y);
[selectedIdx, mIdx] = findSelectedIdx(csd, x,y, cx, cy);
if isempty(mIdx) || ~isempty(find(selectedIdx==0, 1)), return; end
avshape=shapemean(csd,selectedIdx,mIdx,0);

figure(10)
clf;
orangeCol=[237/255 94/255 48/255];
plot(avshape, 'color', orangeCol,'LineWidth',3)
axis equal

h=figure(11);
clf;
set(0, 'currentfigure', h);  %# for figures
N = length(handles.score);
mk = getMarkerSize(N);
plotScore(handles.score, gca);
plot(x,y,'.', 'color',orangeCol, 'MarkerSize', mk);





function [selectedIdx, mIdx] = findSelectedIdx(csd, x,y, cx, cy)
mIdx=[];
selectedIdx=zeros(length(x),1);
allScores=csd.point.SCORE;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
length(csd.point)
for i=1:length(x)
    for j=1:length(csd.point)
        if x(i)==csd.point(j).SCORE(1) && y(i)==csd.point(j).SCORE(2)
           selectedIdx(i)=j;
        end 
    end
end
% find the center Coordinate.
for i=1:length(x) 
    if cx==x(i) && cy==y(i)
       mIdx=selectedIdx(i); break;
    end  
end



function [cx, cy] =getCenterCoordinate(x,y)
cDist = Inf;
for i=1:length(x)
    cd=0;
    for j=1:length(x)
         cd =cd+ sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
    end
    if cd<cDist,
        cx=x(i);
        cy=y(i);
        cDist=cd;
    end
end


% --------------------------------------------------------------------
function save_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex]=uiputfile({'*.eps'; '*.fig'},'Save Average Shape Files');
[~,name,ext] = fileparts(filename);
if ~(ishandle(11) && sum(ismember( findall(0,'type','figure'),10))>0), return; end
if filterindex==1
   saveas(11, fullfile(pathname, filename), 'epsc');   
elseif filterindex==2
    saveas(11, fullfile(pathname, filename), 'fig');  
end
% if avergage fig does not exist, we are done.
if ~(ishandle(10) && sum(ismember( findall(0,'type','figure'),10))>0), return; end
avgPath =[name '_Avg_Shape' ext];
if filterindex==1
   saveas(10, fullfile(pathname, avgPath), 'epsc');   
elseif filterindex==2
   saveas(handles.figure1, fullfile(pathname, filename), 'fig');  
end    


function mk = getMarkerSize(N)
mk = 10;
if N>10000, mk =7; end
if N>20000, mk =3; end

function  out=brushpanel(STR,fighandle)

g.fh = figure('units','pixels',...
    'position',[1169 324 380 100],...
    'menubar','none',...
    'Color','w',...
    'name','Select plot regions',...
    'numbertitle','off',...
    'resize','off');

g.sub=annotation('textbox',...
    'units','pixels',...
    'position',[0 0 380 100],...
    'Tag','box',...
    'Color',[58 51 153]/255,...
    'BackgroundColor','none',...
    'String',STR,...
    'Fontsize',14,...
    'FaceAlpha',0,...
    'EdgeColor', [112 112 112]/255);

g.bg = uibuttongroup('units','pix',...
    'pos',[0 0 380 50],...
    'BorderType','line',...
    'ForegroundColor','w');
g.rd = uicontrol(g.bg,...
    'style','push',...
    'unit','pix',...
    'position',[260 15 70 22],...
    'Fontsize',8,...
    'string','Close');

g.bO = brush(fighandle);
g.axhandle=get(fighandle,'CurrentAxes');
set(g.bO,'enable','on');
set(g.rd(:),'callback',{@select,g});
uiwait(g.fh)

hBrushLine = findall(g.axhandle,'tag','Brushing');
brushedData = get(hBrushLine, {'Xdata','Ydata'});
brushedIdx = ~isnan(brushedData{1});
brushedXData = brushedData{1}(brushedIdx);
brushedYData = brushedData{2}(brushedIdx);

out=[brushedXData' brushedYData'];
close(g.fh)

function select(varargin)
g = varargin{3};
str=get(g.rd(1),'val');

if str(1)==1    
    g.st=true;
    set(g.bO,'enable','off');
end
guidata(g.fh,g.bO);
uiresume
