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

% Last Modified by GUIDE v2.5 25-Mar-2015 16:41:08

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

% Update handles structure
guidata(hObject, handles);
cla
figure1_ResizeFcn(hObject, eventdata, handles);
% UIWAIT makes InteractiveShapeSlicer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


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
path = uigetdir();
if path==0, return; end
cellShapePath = fullfile(path, 'CellShapeData.mat');
if exist(cellShapePath, 'file')
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
plotScore(SCORE, handles.axes1);
handles.score=SCORE;
guidata(handles.figure1,handles); 


function plotScore(SCORE, axes)
if isempty(SCORE), return; end
orangeCol=[237/255 94/255 48/255];
plot(axes,SCORE(:,1),SCORE(:,2),'*', 'color', orangeCol)
axis equal; axis tight;
hold on

    
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
if isfield(CellShapeData.set,'SCORE')
    SCORE=CellShapeData.set.SCORE;
else
    for i=1:N
       SCORE(i,:)= CellShapeData.point(i).SCORE;
    end
end


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
%set(gca,'xlim',[-10 10],'ylim',[-10 10]);
pos =get(handles.figure1, 'Position'); %[0 0 xwidth ywidth]
pos(1)=10;
pos(2)=0;
pos(3)=pos(3)-20;
set(gca, 'Position', pos);
try 
    plotScore(handles.score, handles.axes1); 
end





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
brush on
zoom off
pan off
set(handles.brush, 'State', 'on');

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